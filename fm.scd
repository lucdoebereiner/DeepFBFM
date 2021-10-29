(
SynthDef(\xmod, { arg out = 0, car1 = 311.0, car2 = 10.5, fbAmp1 = 0.0, fbAmp2 = 0.0, del = 0.0, index1 = 2.0, index2 = 2.0, amp = 0.3, dur = 1.0;
	var fb = LocalIn.ar(2);
	var synth1 = PMOsc.ar(car1, (fb[1].abs * fbAmp1), index1);
	var synth2 = PMOsc.ar(car2, (fb[0].abs * fbAmp2), index2);
	var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
	LocalOut.ar(DelayC.ar([synth1,synth2],del,del));
	Out.ar(out, (synth1 + synth2) * env * amp);
}).send(s)
)

Synth(\xmod, [\out, 0, \car1, 124.12, \car2, 1151, \fbAmp1, 111.5, \fbAmp2, 210.5, \index1, 21, \index2, 12.2]);

Synth(\xmod, [\out, 1, \car1, 2.12, \car2, 121, \fbAmp1, 11.5, \fbAmp2, 121.5, \index1, 13, \index2, 120.2]);


s.boot
(
SynthDef(\xmod2, { arg out = 0, fc = 311.0, carRatio = 1.4, i = 1, fm = 10.0, modRatio = 0.5, fmRatio = 1.2, fbAmp = 0.0, amp = 0.3, dur = 1.0;
	var fb = LPF.ar(LocalIn.ar(1),1000);
	var mod1 = SinOsc.ar(fm) * i*fm;
	var mod2 = SinOsc.ar(fm*fmRatio) * i*(fm*fmRatio);
	var mod = mod1 + mod2 + ((fb * i*fm)  * fbAmp);
	var car1 = SinOsc.ar(fc + mod);
	var car2 = SinOsc.ar( (fc*carRatio) + (mod * modRatio));
	var synth = LPF.ar((car1 + car2) * -6.dbamp, 10000);
	var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
	LocalOut.ar(synth);
	Out.ar(out, synth * env * amp);
}).send(s)
)

Synth(\xmod2)
Synth(\xmod2, [\fc1, 1000, \fc2, 120, \i, 10, \fm1, 121])
Synth(\xmod2, [\fc1, 1000, \fc2, 121, \i, 10, \fm1, 121, \ratio, 1.2])
Synth(\xmod2, [\fc1, 1000, \fc2, 121, \i, 10, \fm1, 121, \ratio, 3.20])

Synth(\xmod2, [\fc1, 100, \fc2, 191, \i, 4, \fm1, 201, \ratio, 2.2])

Synth(\xmod2, [\fc, 100, \carRatio, 1.91, \i, 4, \fm1, 201, \modRatio, 3, \fmRatio, 2.2])

Synth(\xmod2, [\fc, 100, \carRatio, 4.1, \i, 3.2, \fm, 122.3, \modRatio, 4.2, \fmRatio, 5.2, \fbAmp, 0.1, \lpf, 2000])

Synth(\xmod2, [\fc, 280, \carRatio, 1.8, \i, 2, \fm, 14.3, \modRatio, 1.2, \fmRatio, 4.1, \fbAmp, 0.2, \dur, 3.0])


Synth(\xmod2, [\fc, 180, \carRatio, 1.8, \i, 3, \fm, 14.3, \modRatio, 1.7, \fmRatio, 1.6, \fbAmp, 1.8, \dur, 3.0])


(
~recParameters = { arg car1, car2, fbAmp1, fbAmp2, index1, index2, i;
	
	var serverOptions = ServerOptions.new
	.numOutputBusChannels_(1)
	.numInputBusChannels_(1);

	var score = Score([
		[0.0, ['/d_recv',
			SynthDef(\xmod, { arg out = 0, car1 = 311.0, car2 = 10.5,
				fbAmp1 = 0.0, fbAmp2 = 0.0, del = 0.0, index1 = 2.0, index2 = 2.0, amp = 0.3, dur = 1.0;
				var fb = LocalIn.ar(2);
				var synth1 = PMOsc.ar(car1, (fb[1].abs * fbAmp1), index1);
				var synth2 = PMOsc.ar(car2, (fb[0].abs * fbAmp2), index2);
				var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
				LocalOut.ar(DelayC.ar([synth1,synth2],del,del));
				Out.ar(out, (synth1 + synth2) * env * amp);
			}).asBytes
		]],
		[0.0, (x = Synth.basicNew(\xmod)).newMsg(args: [car1: car1, car2: car2,
			fbAmp1: fbAmp1, fbAmp2: fbAmp2, index1: index1, index2: index2])],
	]);
	
	score.recordNRT(
		outputFilePath: ("~/src/python/fm_tensor/recs/" ++ "fm" ++ i ++ ".wav").standardizePath,
		headerFormat: "wav",
		sampleFormat: "int16",
		options: serverOptions,
		duration: 1,
		//		action: { "done".postln }
	);
	
}
)

// car1, car2, fbAmp1, fbAmp2, index1, index2, i;

((5*5*5*5*5*5)*0.25)/60

(5*5*5*5*5*5)


//Array.geom(10, 0.5, 2.5).last;

~specs = [];

(
var cars = Array.geom(5, 1, 5);
var fbs = Array.geom(5, 0.05, 10);
var indices = Array.geom(5, 0.5, 5);
var i = 0;
Task({
cars.do({ arg c1;
	cars.do({ arg c2;
		fbs.do({ arg fb1;
			fbs.do({ arg fb2;
				indices.do({ arg idx1;
					indices.do({arg idx2;
						i.postln;
						~specs = ~specs.add([i,c1,c2,fb1,fb2,idx1,idx2]);
						i = i+1;
						~recParameters.(c1, c2, fb1, fb2, idx1, idx2, i);
						0.01.wait;
					})
				})
				
			})
		})
	})
})
}).start;
)

(
var file = File.new("/home/luc/src/python/fm_tensor/recs/specs.csv".standardizePath, "w");
~specs.do({ arg s;
	file.write(format("%, %, %, %, %, %, %\n", s[0], s[1], s[2], s[3], s[4], s[5], s[6]));
});

file.close;

)

"" ++ 1 ++ ", " ++ 2 ++ "\n"



~specs

(
SynthDef(\fmsynth, { arg dur = 3.0, amp = 0.5, fb = 0.0, car = 200.0, mod = 100.0, del = 0.0, index = 2.0;
	var fbIn = LocalIn.ar(1);
	var synth = PMOsc.ar(car, mod + (fb.abs * fbIn), index);
	var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
	LocalOut.ar(DelayC.ar(synth,del,del));
	Out.ar(0, synth * env * amp);
}).send(s)
)

Synth(\fmsynth);
Synth(\fmsynth, [\fb, 102.5, \del, 0.1]);
Synth(\fmsynth, [\car, 1000, \fb, 920.5, \del, 0.05]);
Synth(\fmsynth, [\car, 1000, \mod, 10, \fb, 192.5, \del, 0.08]);
Synth(\fmsynth, [\car, 1000, \mod, 300, \fb, 192.5, \del, 0.03]);
Synth(\fmsynth, [\car, 1000, \mod, 900, \fb, 122.5, \del, 0.02]);



(
var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(1)
    .numInputBusChannels_(1)
);

a = Score([
    [0.0, ['/d_recv',
		SynthDef(\fmsynth, { arg dur = 3.0, amp = 0.5, fb = 0.0, car = 200.0, mod = 100.0, del = 0.0, index = 2.0;
			var fbIn = LocalIn.ar(1);
			var synth = PMOsc.ar(car, mod + (fb.abs * fbIn), index);
			var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
			LocalOut.ar(DelayC.ar(synth,del,del));
			Out.ar(0, synth * env * amp);
		}).asBytes
    ]],
    [0.0, (x = Synth.basicNew(\fmsynth, server, 1000)).newMsg(args: [car: 1000, mod: 900, fb: 22.5, del: 0.02])],
]);

a.recordNRT(
    outputFilePath: "~/src/python/fm_tensor/fm2.wav".standardizePath,
    headerFormat: "wav",
    sampleFormat: "int16",
    options: server.options,
    duration: 3,
    action: { "done".postln }
);

server.remove;
)




(
~recParameters = { arg fc, carRatio, fm, fmRatio, index, modRatio, fbAmp, i;
	
	var serverOptions = ServerOptions.new
	.numOutputBusChannels_(1)
	.numInputBusChannels_(1);

	var score = Score([
		[0.0, ['/d_recv',
			SynthDef(\xmod2, { arg out = 0, fc = 311.0, carRatio = 1.4,
				i = 1, fm = 10.0, modRatio = 0.5, fmRatio = 1.2, fbAmp = 0.0, amp = 0.3, dur = 1.0;
				var fb = LPF.ar(LocalIn.ar(1),1000);
				var mod1 = SinOsc.ar(fm) * i*fm;
				var mod2 = SinOsc.ar(fm*fmRatio) * i*(fm*fmRatio);
				var mod = mod1 + mod2 + ((fb * i*fm)  * fbAmp);
				var car1 = SinOsc.ar(fc + mod);
				var car2 = SinOsc.ar( (fc*carRatio) + (mod * modRatio));
				var synth = LPF.ar((car1 + car2) * -6.dbamp, 10000);
				var env = EnvGen.kr(Env.linen(0.01, dur-0.11, 0.1), doneAction: 2);
				LocalOut.ar(synth);
				Out.ar(out, synth * env * amp);
			}).asBytes
		]],
		[0.0, (x = Synth.basicNew(\xmod2)).newMsg(args: [fc: fc, carRatio: carRatio,
			fbAmp: fbAmp, fm: fm, fmRatio: fmRatio, i: index, modRatio: modRatio])],
	]);
	
	score.recordNRT(
		outputFilePath: ("~/src/python/fm_tensor/recs2/" ++ "fm" ++ i ++ ".wav").standardizePath,
		headerFormat: "wav",
		sampleFormat: "int16",
		options: serverOptions,
		duration: 1,
	);
	
}
)



~specs = [];



18*6*5*3*5*3*3

Array.geom(18, 40, 1.3).last;

Array.geom(6, 50, 1.8);

Array.geom(5, 0.25, 1.9);


~recParameters.(40, 0.5, 50, 0.5, 1.0, 0.5, 0.0, 0);

(
var freqs = Array.geom(18, 40, 1.3);
var modFreqs = Array.geom(6, 50, 1.8);
var ratios = [0.5, 1.0, 1.15, 2.5, 5.75];
var modRatios = [0.5, 1.0, 2];
var indices = [1.0, 4.0, 10.0];
var fbs = [0.0, 0.5, 1.2];
var i = 0;
Task({
freqs.do({ arg fc;
	modFreqs.do({ arg fm;
		ratios.do({ arg fmRatio;
			modRatios.do({ arg modRatio;
				ratios.do({ arg carRatio;
					indices.do({arg index;
						fbs.do({arg fbAmp;
							i.postln;
							~specs = ~specs.add([i,fc,fm,fmRatio,modRatio,carRatio,index,fbAmp]);
							i = i+1;
							//							~recParameters.(fc, carRatio, fm, fmRatio, index, modRatio, fbAmp, i);
							//							0.02.wait;
						})
					})
				})
			})
		})
	})
})
}).start;
)

(
var file = File.new("/home/luc/src/python/fm_tensor/recs2/specs.csv".standardizePath, "w");
~specs.do({ arg s;
	file.write(format("%, %, %, %, %, %, %, %\n", s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7]));
});

file.close;

)

// rec 3
s.boot
(
SynthDef(\fm3, { arg out = 0, fc = 311.0, i = 1, fmRatio = 1.4, fbAmp = 0.0, amp = 0.3, dur = 1.0;
	var fb = LPF.ar(LocalIn.ar(1).sin,700);
	var fm = fc * fmRatio;
	var mod1 = SinOsc.ar(fm) * i*fm;
	var mod = mod1 + ((fb * i*fm)  * fbAmp);
	var car = SinOsc.ar(fc + mod);
	var synth = car;
	var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
	LocalOut.ar(synth);
	Out.ar(out, synth * env * amp);
}).send(s)
)

s.recHeaderFormat = "wav";
s.recChannels = 1;
s.prepareForRecord("/home/luc/Dropbox/Bewerbungen/trossingen/presentations/singA.wav", 1);

Synth(\fm3, [\fc, 100, \i, 12, \fmRatio, 2.5, \fbAmp, 0.9])

// sine400

Synth(\fm3, [\fc, 878.46316601, \fmRatio, 1.83798103, \i,  2.02242504,   \fbAmp, 0.07209266])

// singA
s.record;
Synth(\fm3, [\fc, 478.09600522, \fmRatio, 2.83561382, \i,  7.90579525,   \fbAmp, 0.06258633, \dur, 4])
s.stopRecording;
// pink
Synth(\fm3, [\fc, -101.67331728, \fmRatio, 3.38843764, \i,  7.68757798,   \fbAmp, 0.81728205])

// voice complex
s.record;
Synth(\fm3, [\fc, 1537.63567464, \fmRatio, 5.09804292, \i,  2.73762584,   \fbAmp, 0.08052301])
s.stopRecording;

// saw2000
Synth(\fm3, [\fc, 1828.60949276, \fmRatio, 4.89282607, \i,   2.8931221,   \fbAmp,0.08686998])

// fm 100
s.record;
Synth(\fm3, [\fc, 610.94909075, \fmRatio, 1.73863754, \i, 12.3839326  ,   \fbAmp, 0.069364  ])
s.stopRecording;

// voice sh
s.record;
Synth(\fm3, [\fc, 4033.96907136, \fmRatio, 3.34816569, \i,  4.07271221,   \fbAmp,   0.13495806, \dur, 3])
s.stopRecording;

// voice boo
Synth(\fm3, [\fc, 288.03629215, \fmRatio, 1.65103198, \i,  23.5911505,   \fbAmp,   0.06152043])

// whistle
Synth(\fm3, [\fc, -209.72848826, \fmRatio, 1.31718638, \i, 1.31537357 ,   \fbAmp,   0.05041321])

s.record;
Synth(\fm3, [\fc, 549.72848826, \fmRatio, 1.31718638, \i, 1.31537357 ,   \fbAmp,   0.05041321])
s.stopRecording;


(
~recParameters = { arg fc, fmRatio, index, fbAmp, i;
	
	var serverOptions = ServerOptions.new
	.numOutputBusChannels_(1)
	.numInputBusChannels_(1);

	var score = Score([
		[0.0, ['/d_recv',
			SynthDef(\fm3, { arg out = 0, fc = 311.0, i = 1, fmRatio = 1.4, fbAmp = 0.0, amp = 0.3, dur = 1.0;
				var fb = LPF.ar(LocalIn.ar(1).sin,700);
				var fm = fc * fmRatio;
				var mod1 = SinOsc.ar(fm) * i*fm;
				var mod = mod1 + ((fb * i*fm)  * fbAmp);
				var car = SinOsc.ar(fc + mod);
				var synth = car;
				var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
				LocalOut.ar(synth);
				Out.ar(out, synth * env * amp);
			}).asBytes
		]],
		[0.0, (x = Synth.basicNew(\fm3)).newMsg(args: [fc: fc, i: index,
			fbAmp: fbAmp, fmRatio: fmRatio])],
	]);
	
	score.recordNRT(
		outputFilePath: ("~/src/python/fm_tensor/recs3/" ++ "fm" ++ i ++ ".wav").standardizePath,
		headerFormat: "wav",
		sampleFormat: "int16",
		options: serverOptions,
		duration: 1,
	);
	
}
)

30*20*10*10

~specs = [];

Array.geom(30, 40, 1.2).last;

(
var freqs = Array.geom(30, 40, 1.2);
var modRatios = Array.geom(20, 0.5, 1.18);
var indices = Array.geom(10, 1, 1.5);
var fbs = Array.geom(10, 0.01, 1.7);
var i = 0;
Task({
freqs.do({ arg fc;
	modRatios.do({ arg fmRatio;
		indices.do({arg index;
			fbs.do({arg fbAmp;
				var fcRnd = fc * rrand(0.9, 1.2);
				var fmRatioRnd = (fmRatio * rrand(0.9, 1.2)).round(0.1);
				var indexRnd = index * rrand(0.9, 1.2);
				var fbAmpRnd = fbAmp * rrand(0.9, 1.2);
				i.postln;
				//				fbAmpRnd.postln;
				~specs = ~specs.add([i,fcRnd,fmRatioRnd,indexRnd,fbAmpRnd]);
				~recParameters.(fcRnd, fmRatioRnd, indexRnd, fbAmpRnd, i);
				i = i+1;
				0.02.wait;
			})
		})
	})
})
}).start;
)


(
var file = File.new("/home/luc/src/python/fm_tensor/recs3/specs.csv".standardizePath, "w");
~specs.do({ arg s;
	file.write(format("%, %, %, %, %\n", s[0], s[1], s[2], s[3], s[4]));
});

file.close;

)


~recBuf = Buffer.alloc(s, 44100);

(
{
	//var input = SinOsc.ar(SinOsc.ar(100).range(100,600));
	var input = SoundIn.ar(0)*2;
	//	var input = PinkNoise.ar(0.6);
	var dur = 1.0;
	var env = EnvGen.kr(Env.linen(0.01, dur-0.21, 0.2), doneAction: 2);
	RecordBuf.ar(input, ~recBuf.bufnum, loop: 0, doneAction: 2);
}.play
)




~recBuf.write("/home/luc/src/python/fm_tensor/voice_sh.wav", "wav", "int16");