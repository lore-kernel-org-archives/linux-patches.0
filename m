Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021957;
	b=4uX7uDnGaKItgi9t3alDqATfTGcgRLMNltXXkrvmYEPM3lUvTKBiBCDz5ByspAtEyy5E
	 n6akNFz3TAILS5vy/JNk5fBSwj8te3VqKjMEsDVMFVkFyyaFEuAyccZ6rh6n/KulAWkkV
	 2oZvXphywq1XYOv7FcMcov+yzKsj1DgBm+EbCE4hyZXthYVBGx9FRoN9rM/2K0QIdUYYQ
	 lKAcPuKxewPr66p1wc2d4OWmX3UZslN8iOOZNiBjJmd1wLJXq/dm84/NRfaO6IYb/7j7S
	 FEsmzrYj5km0MI4YdiTGk8L2CoaUpGuvTNSDnmfG7GJzT6l+QGDzCTsGYJB2Iiwm8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021957;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=2LHhB3YdVOtFDH2OYkTj4jFKvnyNs9u2Zn5BtRaQPXw=;
	b=q7ynay0TDAfL7rrehYc1dDwWTuc3W3SCFcEzr72yvI2jXGtPyIpQ6/igTvjiPaHFmdLh
	 NJbhevv6s1VrAqVFc6m2wy3yCMorM/Fg03IDnitzi/rYSUZ3NXIsJ7seDPpZ2jDhSD1MS
	 in9Paj2he9oW1tMpYCf3oo297Z2bMfHq4a+s7Vp34njbCF1BIfPFYuOg7YMpfwoyNjPY9
	 1d/T3CNDj3ZFL7DHcj9Ama7wooqC/1pnCRXiQGUo6b7At1lS40vhxV+vug/PI1mwNt5fm
	 g66WzRb9BnOMOfXtNaqFoQ+cZCXq76F+t6Ym7o5g54MnEPnnfxO1ZWzPHCrR3gL5uuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=hbw+p5j8;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="0DTRnGK/";
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16874606A320
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:12:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16874606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=hbw+p5j8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0DTRnGK/
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 8C6661D00193
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 12:12:36 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Wed, 18 Nov 2026 12:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795021955;
	 x=1795108355; bh=2LHhB3YdVOtFDH2OYkTj4jFKvnyNs9u2Zn5BtRaQPXw=; b=
	hbw+p5j8uCniXzTwZBVwHLm2nI0Nx3j908hlxx7CgbBltSRyoXEVUvQs1r3e4xQY
	0Xh80JbvT0KN52ocCNz5ZFozGCvQ2ure3JvmFIDcHfXRqZ96M00txTC94N8UMjvJ
	dlBzkNQ0vc4vpPPUvcxuNBsVeiENlltFIbgQI4gUbvYJUVapI+RU5VY692lF/2qa
	Stkp27advSaUGCQ2nHIVYEZ2lTMoAkr4x6YFIMl2ugnVJmbcDmlx0q1X2oVKC2bM
	iBJOse3iq3lk8+9b/a3LTHgG9qMUGxc3AD4KevQFJuKTjzzJVb0qh/LkUnD0MpQS
	VZSt9gBUtibfgrvjysOalA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795021955; x=
	1795108355; bh=2LHhB3YdVOtFDH2OYkTj4jFKvnyNs9u2Zn5BtRaQPXw=; b=0
	DTRnGK/OwPNsgkF1r8OPQzJAVcljzU35VG7sK3pue5rS1Tip2f4TPLPTq4Wm+7+t
	0S2UACK4+rflq70WFO5nfJGYnW/I0Bm4hhK61Yo28eLZDTNk5GefhGIrR4Ne6SS3
	gLFE66w9DuQEmsnq9jontMYJuEiR6a5t7jbrrSeuIJ1EZl6gMLBh2VOiuTtzYrwy
	KqVYbzfcVy18Jg7u7YugDiAIfRA0CDn2uCt4kpKhU8aRfh0wuxGlyywDBf03Om41
	tbTv7qSIu6Ub/4d6TeErGOQ0qI1Y+xCmq6h2OTDTGFIRZKJ2nzbPjlAnhZdx6uEF
	RJv9KYo1uJhwfZJfKDsSw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795021955; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:kUnh+LMN8VFqqi2oXZI/mcHcyAPB8UCSHzQp4tZAaqPdOPY
	c0K47fjdE7cl7sL3LN2bCLcibhsBwnjvTFEXaXkD1WxKEp8dyS7om88sFjBV0ffy
	WpWNCtLiMBjwwSptz+FIhunZlAGyxt8ykNoQpVHGs/NeKvs5PABjQXGieTRPQ0L1
	tatSYm0m5Ca5p+Fkr9H334izmtTxKpT+UXnesbH7J31yjgtkZpDUW7G3ArQ5XK6E
	ysb9UNEARlSaI3NY+mq8yXN7c+2WhBi2jRnE067jJMBXcvEhAiyt3druhaizZXfD
	/jQU5mwaPFtg/kFx9FAKsGuqNzSIgcMuS6/H4bg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:baCs5u2x65MfB7EuP2LxxlHAVxlhMq0mQqUYADxt0Sw=:VhFRhgQhRFmNlSPVrsFgF5qRgZiDuZnoxFcsI51cxKI=;
X-ME-Sender: <xms:gtz9ape6alkAv0DaisfCFR6AeKwA0N81jPihld0N1x3V8BICIIG6cg>
    <xme:gtz9annQV7WAyKTN_3zXJrBoQw3SQ0V01fevgdOZjgFsfiaNAucj80WaDBxLunAQL
    E-1V5MlDJx8oqo3JtzP1dhVYfzRklkIXh2g1CkLhsvSz3B3eB7opLU->
X-ME-Received: <xmr:gtz9ajqH9rc3gIwZEWN9anl4kEMX_r2Tsflj84SbuuVYRfkT-Bb-GkCigOH9Ne0PPMJaOguFR5b4M46noTHTge2uSsemspCM>
X-ME-Proxy-Cause: dmFkZTGGAnJBO+n1vOUtbyLvPCGeQXC4RB28NGw5muzoaRusgTBjyZ0YQav5jEh7CSeIin
    ulZymGKGEkajcg6inrObbG5Ky/hGLALnxkjc6GTaRKPyIcXGltDk0c22Wjj9IbeL9AtzJO
    mKJh9GpXEHAljhm7yg3vM4qW/w2vMVd39uk7BEE/o54Ql5Y+yBOrftHs+w9OM952t0ay+Q
    bEK/YVxL1l7YwZ6bDklsmGOOCbjPtfJH2zRfEfedSgdeU2/mD05nkIWMfodbtr5iYpMsK3
    v0TpnZydX9U1Oows+EfyuB9YkV+Vf0HresacICshOJ9hikt8dnyjV6kXjxsCI/MY/va0sa
    /cB8Wv5BwJkx4e9Uwi6qPIIC4g+CqREVmEqDLS3tmzAo7gg2EokFFgMrL0kmstJ0r/jr65
    hRjhK+Xy9e20NhezUC6pTB931MivQdOwN/v12vz8BOj9iyy3Gb0i1XhT/jljta5Wm1p9OR
    GKqXgZnCHrKEEtHzc8I+E38vtLOkL01TdFQiyhBdOy0oFpXaJSpYlDJiiqN56aGuTd4r3k
    S/GeMTY8iK/V/r8TqDOQXepdWtpu37ESxniHbD2FsaO3/QUNQdr55CrrwTNBmv5kNgc3UL
    8WXw1yXuFBD+S22lTQTmvfKxIzg8lighJ4xk/1xJrx4ubpJLY5JkpQwt9zzg
X-ME-Proxy: <xmx:gtz9au9gv2TjEEVxVKby3xf8uMz36AQtczBwLEiELV0VBAAXp6MC6Q>
    <xmx:gtz9ak0EFhDUVKx-ed_ykr9VreWEwcVABGUL3WbuXTr_7S9EV6oxaA>
    <xmx:gtz9apmq9Ai9aGwaL4I-nnP_tfpOZMvmwL3-utY-EoLmAalVDyICQg>
    <xmx:gtz9ap22o9oFI9jtaX-19eJoaJWx552DIOjvICmEmvadrGABcwSeFA>
    <xmx:g9z9anGju1KyJ5ml_rh1CBUkKBQaKNp2QV6b-D2GiGGDSNnGDbvK15SG>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Nov 2026 12:12:32 -0500 (EST)
Message-ID: <e394ffc5-c69c-4aae-a974-d5e7a0461335@pobox.com>
Date: Wed, 18 Nov 2026 09:12:31 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
To: Brett A C Sheffield <bacs@librecast.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118145911.150052362@linuxfoundation.org>
 <av3U6pDFzRL3k0m3@karahi.librecast.net>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <av3U6pDFzRL3k0m3@karahi.librecast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 8:40 AM, Brett A C Sheffield wrote:
> On 2026-11-18 15:33, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.275 release.
>> There are 1848 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
> 
> Build failure on amd64 with amdgpu.
> 
> git bisect start
> # status: waiting for both 'good' and 'bad' commits
> # bad: [12d2575b30ab6dd7d0f61ef33860d08836347cbb] Linux 5.10.275-rc1
> git bisect bad 12d2575b30ab6dd7d0f61ef33860d08836347cbb
> # status: waiting for 'good' commit(s), 'bad' commit known
> # good: [3a323bc22b881a5bdc1646080f93f5ecb22850bf] Linux 5.10.274
> git bisect good 3a323bc22b881a5bdc1646080f93f5ecb22850bf
> # good: [48be8a7d04b11bd8a2d641bfb8965ee037cab57b] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
> git bisect good 48be8a7d04b11bd8a2d641bfb8965ee037cab57b
> # good: [7edc53e830e18e313c808faa4bc5d2e14d90aa34] iio: dac: ad5758: Fix the offset calculation
> git bisect good 7edc53e830e18e313c808faa4bc5d2e14d90aa34
> # good: [533ee956be520b32f60844a83d6b030ae2586849] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
> git bisect good 533ee956be520b32f60844a83d6b030ae2586849
> # bad: [6c4061694ecb407f5d67421f35e7f550f98805df] ASoC: cs42l56: Remove the ADC Mute Switch control
> git bisect bad 6c4061694ecb407f5d67421f35e7f550f98805df
> # good: [5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73] ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()
> git bisect good 5ed2a3e2073ef449d3f0c6d052dbfa8a55c2ff73
> # bad: [a356793651fdb50e5b5bc0558357d578b8d405d3] selftests: netfilter: fix return value in zone subtest
> git bisect bad a356793651fdb50e5b5bc0558357d578b8d405d3
> # good: [e9e79589baa60f79c75823422974ef46fd619613] ARC: Strip libgcc debug information when generating BTF
> git bisect good e9e79589baa60f79c75823422974ef46fd619613
> # bad: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
> git bisect bad 4428e62a30507763e58fb1bb017f273ec98457d5
> # good: [d0c3b85950d12e1808644f31f10a95461f254df0] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
> git bisect good d0c3b85950d12e1808644f31f10a95461f254df0
> # good: [1de066662fa2ef918a350698c90f873e803e61eb] gre: keep the UDP tunnel GSO type when completing GRO
> git bisect good 1de066662fa2ef918a350698c90f873e803e61eb
> # good: [51a5555c99ede3eed53b2999a4ab3245cf4a2e49] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
> git bisect good 51a5555c99ede3eed53b2999a4ab3245cf4a2e49
> # first 'bad' commit: [4428e62a30507763e58fb1bb017f273ec98457d5] bpf: Validate the SRH which End.DT6 uncovers in End.BPF
> 
> Reverting 4428e62a30507763e58fb1bb017f273ec98457d5 fixes the build.

I'm also having this build failure. It's the same one I had when
testing the stable-queue yesterday, before 5.10.275-rc1:

https://lore.kernel.org/stable/31a4ad36-33bd-4563-9eae-651e713adbdf@pobox.com/
-- 
-Barry K. Nathan  <barryn@pobox.com>
