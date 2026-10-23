Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792798975;
	b=4WbQCYrFYCWnEH/vcXftNU+77wsgDhRepcwgmrHlT1FT9oSgNBApu/J2vjATokcd9BdC
	 qMA0XDZkmgw+xKx5sHCjZIdExPwW3y7/o61UbaZ03dyrqilYzoDUSfy0qrzSqPiKGZ6zH
	 d29aqqb4y6+pYDYVeGyVznD7mlhgzCahjNbSy6z9ZmAXjVO80U4h2AxitrObm00WtSnIs
	 L9Ti601ehkgvjJ+5QzrRJD9wUOzt4T1Y28weubPh/dOn03HwiOX3ZAHlvjJ9qo7WphpGO
	 BXYPtprJDY3tV8MdpnednxGE7Gsz7heoIz04UDAntZIHIsUkQtak8cImuqF9bnKnjew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792798975;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Z9P74CI0r1RddvuUNcaySIOSlWLt4+nM23rKxRc7/y4=;
	b=QB1wbrW8EbFRCAcPn8al2Pn8hI0RW3p1ZYSkTti88ngSqHEZO7hbbBH+E3LcK7Ihb/rf
	 91ME3XKimsfwx9S2mNgismYq5sWHz9yrDKZIC/3RqyhWklhKFuE8koi0Rt0kDxaqdks5p
	 REMFQNKrtdkmwixGjbqqmCuLunT4tgOU6Cw6LadJDxrXKfS4vd72p5m1vYkP2DO9Mn3Gp
	 ZzKakCQy7YLxOsknfupIXZKUjD+W1JwLPRNMHdvU1kaI0jmUVRI3bpfINbDlyt7z8vJXw
	 +OUGNwgY73e/nAX+R4b/f5UptYZU1ZsVMUpW4q4HmMYVDxIlsiXX8PyaS/z22yr+TlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=awbqjPaQ;
	dkim=temperror header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=pkPNel4q;
	arc=none smtp.remote-ip=202.12.124.150
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF95F606A31B
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 23:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF95F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=awbqjPaQ;
	dkim=temperror header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=pkPNel4q
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 686161D000D6
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 19:42:54 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Fri, 23 Oct 2026 19:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792798973;
	 x=1792885373; bh=Z9P74CI0r1RddvuUNcaySIOSlWLt4+nM23rKxRc7/y4=; b=
	awbqjPaQGh/daYR/oAq1DC5obfU5HxsZX81vOJ9w7sTVphlGdvYOzLWUl9dm/o4x
	uFiYAcgzkaCJP9Z6QZTLCoiPtCJuA/ug8/7ePfbBWmi+ixpDAHGLQB4/7h+T9NAW
	woBBBRfzEWasy1lnzFk/ewKGfNjepVVByjhSbnOv5sGitJozRIeG1TVfitljx2wt
	ihpyXNGFNUfbf2k+CXTSGf4A/XNnbEWL1YEtXk9T16X6xw5LfNPjfCuS4VG4weby
	E0OGPIYCe3R4RalkRpdRXoObJeXvqLpfpRScThR6h5+kEBFDyFMnGWtK3gSWRI4u
	BDTuMxDEP5HQKD2PbQFbkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792798973; x=
	1792885373; bh=Z9P74CI0r1RddvuUNcaySIOSlWLt4+nM23rKxRc7/y4=; b=p
	kPNel4q0CxPPk7dRjjYaBpGex+SeTRCS+TNmF7byY8wu8RFeNGP05TKThbt+8lS8
	PAvjPV7NXdIGDftAO+Bp4DrkFaK4bHiS742LPcwwTz88t61Wc120qv7YAHSAPLO5
	sOA2cCzbEff52Di2G9f61J1dXoBKe0wAEEIFQZGeRf+J8t7ksC9BIaWkO3PJmT6D
	CnLC0aIOuyz+uAz0DgC5r3tenO6O+W+vOB+b2Qt5Cb/gTKXWq2pIAo2TzpWzadOu
	+ms+AYTXlC33SIyanx2JDxoCnWAJY9NlIt1QOrVuL6govXRFo3XBt4hpDCdiwC0S
	MYikdEQgTvYzMTljcPsmQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792798973; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:f4x530i31uQOfQT2Q83NsykvPVIopm/tFL1OyOx/prD4ILM
	FDnNWPH47uOhTAweMEAEwEXDKoD+iEzvUApDeuaIGOun/FlxFtX4qH+DIiWNu6b1
	n+/rpAm+uGwXBa59Huz4xX5vQIB06oh0Aelrf7cCsmXz8o4rXgwPkdKkr1Wgt2O8
	DwW6ox45O8pvnsnLmlmoOGqoZPwE4G039DhUTjs2bw/aSMS/NfAJjKnAvQ4MvPR2
	iMq3rl+xPrfAVOr9QVMdziwA1kY019ZfmE8WAMRSeGxKEoJE01hbWyA4ADX9xP3v
	clvx+3OcRvWhiWRFSdhfRQYDHnJLZsUnW1E2s4A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:mpENlhJDLcrNLVWhxJQ8LMFCJakxNviL377s+zp5Th4=:B0xxg13vNGYZtNVdLB67EwJoOy1l46HtwNizRlqqpmI=;
X-ME-Sender: <xms:_PDbahJx67bZrz4t9bbI8joUjd8Pe9196gzv8gwutnerzTXSwYBu4w>
    <xme:_PDbatgEfAyv947-SkVsojdPC__su8NfBPz7C7zd4kz33zrNHuzLtpuXoUIAnKsNi
    P6I3YX_qWhG3P5wEFsNgEJL43sJzL23Xej33rzn5FkhlWX2euKbKZcmug>
X-ME-Received: <xmr:_PDbaq0tAgNV-JdolvtfjKVJl0AFrNQ-WYZrq5ubuJ9dJuWr9zcZ1hgSazc8BXDYUhpp8izoMUi1ARyuDTZHEWagSOLfBh5I>
X-ME-Proxy-Cause: dmFkZTGAMV6ryyi2zzDAeZTalQoh5YlTGHDdses31aRzp3bRBC9dX4FojypI65ul7r4nN9
    Zy/TyM76E6h3Rkowszr56d8pAmGb7qtMcSOxYpUWBn9mTm0ChqC/8S6Ci/gj/5r2HSiHK9
    69D0gSEGWqwYDPofdDpHbF+tSnltfZzV8Y8l70RnWBM7kDPCUym7J+Eep0wxVLs5LpTPDg
    oX46IjqvbFgu7VpNeStGxy3wU4OR9qkDQFyn7e85AxRvnjy3pfmXUogDzpdWenMQycERjw
    tzfD8CnrOOCnvwiLQb3em2YLiQh5zBsd1ZuV0Oo/0UGuchDyOHotYzMAaAHOQ80Pvhy6PC
    Lu6UthHbKHcYxCyUP2vZD+FDQShN3INDY0qVi/N8w5tI9RGRaHdSPNEWr853DnuWAnUOvh
    AxlKwYNTlqHFXLR4IOlu8IRqB2T8PodKAmgyhGWTV1dTxOQuIKAIKT4oaJyOLmml/ubwg6
    PhYZvmYy1ypx3+Tys/lNZvWxgNAVqYloURt0yDoC2EwOWqCwuzel+oNU6ZCDLw24k1vpAx
    lma/sm0mhvyZczDSYK8Hy3i7PivkADW0qhaqp26657D5jlCW8f42ITF5qAtDey7roml9np
    zlMqNJ/a6ETE+LQNAiUTb2388VX7wVWS9W3SN5+XX7FXmL55pcEbZTBVoQ8g
X-ME-Proxy: <xmx:_PDbauaRRPwVUmVEpXKgOJQeqIZUoESDIkzDohWt6cqYVUe_GJ9wCQ>
    <xmx:_PDbanjHfZP8_GPkGLwuebioiFsSSbzLEmoIX9SsQlVLMzmco00ijQ>
    <xmx:_PDbauhlH2tOsNmHoGD2MNjCMEZiI9y-zAKtZVcOYm87Pz0EgEBuSw>
    <xmx:_PDbakBx8jkwJGyVKGrb0us7k7PNoByACPjWEQMdFw0LwjTacbu_aQ>
    <xmx:_fDbair8B7bsgMCQEfZ55FFH4FDyTAEggOwDJLOyruv0fqDywRPtHQTI>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Oct 2026 19:42:50 -0400 (EDT)
Message-ID: <d2810142-fd45-485d-b325-f6d494690747@pobox.com>
Date: Fri, 23 Oct 2026 16:42:49 -0700
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
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
To: Florian Fainelli <f.fainelli@gmail.com>,
 Salvatore Bonaccorso <carnil@debian.org>, Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable # v4 . 9+" <stable@vger.kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261023163713.816071858@linuxfoundation.org>
 <atvHKoRHHjKV4l8A@duo.ucw.cz> <atvS68GhCvmAphrQ@eldamar.lan>
 <7540e723-054e-43a2-859d-616010fc7bea@gmail.com>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <7540e723-054e-43a2-859d-616010fc7bea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/26 3:44 PM, Florian Fainelli wrote:
> Same here as well, bisected down to: a0c935bd1f76 ("fs: add umh argument to struct kernel_clone_args"), it looks like we need to cherry-pick 14adbd5341aa ("fs: stop sharing fs_struct between init_task and pid 1"), with that I can boot a kernel.

I'm experiencing the same problem as everyone else on 7.2.13-rc1, and
I can confirm that cherry-picking 14adbd5341aa fixes booting for me too
(tested on both amd64 and arm64).
-- 
-Barry K. Nathan  <barryn@pobox.com>
