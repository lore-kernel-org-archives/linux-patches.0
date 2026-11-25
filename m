Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630351;
	b=rwzDeNRnoxJ+jEOJthInVmhUd2vwuRK33rPu7qHnrUkVC4eDwqTOaPvim+K1zP36C19X
	 CuBd46mD3neEOiZkXEfYwz1Ph0f//nMSnPnEwi/XP4Wa6aj3a6zEBLOk2Z29GW3iI6wxa
	 LeHnPQxDMPB4LbtRIxxphHZVplNqOrK4NRSKdHzuktrntHz4TUwHqNJ4BH28exXWmmW0K
	 MMa8jlr+oIqWDZUfs3mvaGirlFPkMHH6BHDWSTj3F7RTqfWT6jlRAtZTZTfa2+tJPKl10
	 5qao4susVk/C9HrzWAAQrKcLbs2g68H+QDebQ9nGdXl91giGN4z3OC0+89PkT+d2fpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630351;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=ffC/msDkl79K0imvuc2FZy0S9PJsijs8dfXh50KIkmo=;
	b=yoCLahuxjdhTJp4OIHAMTtdp/f4JvWlklFrOkxWDv5VLWN5nQyTOrjtnvujH6NpexVJ0
	 88rSD+o6sCh5AZvFG6P9ffeErF7Fs8yFenlRF9b18O4fHxY/eHtchrObnSc+mzSlRxMwA
	 TPliD6d2kz6SLn4lmPEacwBbChsRjKdVucvwavz/sdjmJ/5gCNl8HqXtpFfqH4emDqMXR
	 bHWR9Luh9sCvGa3GJo1S6wrVliMFaxajOiTsTYgraWctXgDC20z/wL8tRDUje13xKSKC6
	 qBaDCUhfdCuL+mnx983cFb0P9YIJNPXFtP4OWBbaDKrra8tiIRYIm3PvwFlxMdeUJNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=I2bVFzQN;
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71046606A338
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 18:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71046606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=I2bVFzQN
DKIM2-Signature:  i=1; m=1; t=1795630347;
 mf=PHJ3YXJzb3dAZ214LmRlPg==;
 rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
 d=gmx.de;
 s=s31663417:rsa-sha256:PJ2GEOgjWcMag2k+LRam625fX+Mt
   kHCjT5fZd+5FUkxtWfphSN+ZVf7KG2lCwK7ITchmy3t/gS4NUBvN9MvPl8a4J17N+Cp7m3mAFxd
   FeVdE9zDqeAOrHPGBtoyBsb9TJAQnPSDsHaSYcwSnMlEYe4Wu5Ezz4ksZnJAkCK05u463Gt5Soz
   Pxk1VBQEJguZBHCWkhAFaeuWFTa6tHjTFQhSkeRWBceklXLyBK38h8KyPRCPWR5gHLfxuNI3P5l
   5X07t6lQwp4qBImgOJ98E29u+aRnnDorw2dI7ctIDsPaGDNuoQ+Zpb/X+4IG5MSk/FE5H8lJUxC
   F9hRMgfMgctjDw==;
Message-Instance:  m=1;
 h=sha256:
   +DCwjWrYo3omIui1IBXvXJmJKZLgJjdZQ0cOZhtZUnU=:
   AMRqUy4G14QnvnxLw7iqPpvMO9aQClfTVNXovI9ETeY=,
  sha512:
   veGL+fJP0FEumNIwMsimtDggsEHOQHFzXDDiIO8WX674apH0AKDN+bu8xonGNI/FcdsxnCr/sQaLn4Wao9H19A==:
   Wc0EctHmYZq2dyfawmHcZr3nIqjbGjCW7GZjMoL04A4Gs6lJ19a6Ocu50pAKQbMfG7H2xgDaHWjnPxR1rvAN5g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1795630325; x=1796235125; i=rwarsow@gmx.de;
	bh=ffC/msDkl79K0imvuc2FZy0S9PJsijs8dfXh50KIkmo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=I2bVFzQNIwdHB1birMPZ3fvhUzpDetc2hfQV97s521RwJ5j3qHP7D6zVsLvqeQF4
	 /4WX/aU/h+7LoPl6BXwvLBlXXUFnUjVcrYb8EKgRRIoPclbsXJ53fzJElc8NFAYAk
	 AW9+NU4XAQXpEgocUkjD3vvP8ocYYdUuMN+0jmTynjuMdCXvxjbmxGlXEBzUcF6xp
	 932TgcQ40qX3vFuBWbfxK+vqtZP49pf2//QhITNAPZfpT8Rtt6XMIhQlSqmo8dbFl
	 hw3wej4vcFapPA/AmxFHWlMx4+kFBLLPzlaC6hlejInAcLh9nkbUdkvN8S5DDqlHA
	 9gyEvjPnXotqsPztBg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbzyP-1y5tk21A1n-00oe5X; Wed, 25
 Nov 2026 19:12:05 +0100
Message-ID: <1ba253a4-fdef-4169-9e9b-cdb6652e47c6@gmx.de>
Date: Wed, 25 Nov 2026 19:12:02 +0100
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
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261125143821.729802100@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GUKjJWxMhUEIBddBicRc1UAD2SfgNSwi3OM7/F9H+sJEgEWXc+k
 hrZLX3xgy87Czz5ptpF4Knqk57jbSZboXUCFUnRGj1zVSoV/MpVbweRKjlIMKMCalMiUlpu
 klW9HVCQlOzRCsBAwnM2390szFhCpTwqxFwWx4irM/UseqKgHA+hRBdaLNGajSiPQeKFfnA
 5pS84mYtKqv9Ac20bduLQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7qoLUd0ra6s=;DzWVfldZp+/t1jbhnaIv0CtNZ7n
 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

Hallo

RC doesn't compile here and currently couldn't figure what's up.

Question as an git greenhorn:
Is it able to bisect a kernel which initial doesn't compile ?
if YES: what is the bisect start then ?

Error:

In file included from kernel/sched/build_policy.c:71:
kernel/sched/ext/ext.c: In function =E2=80=98__scx_disable_and_exit_task=
=E2=80=99:
kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function=20
=E2=80=98scx_reset_task_fields=E2=80=99; did you mean =E2=80=98scx_set_tas=
k_sched=E2=80=99?=20
[-Wimplicit-function-declaration]
  4223 |                 scx_reset_task_fields(task_rq(p), p);
       |                 ^~~~~~~~~~~~~~~~~~~~~
       |                 scx_set_task_sched
kernel/sched/ext/ext.c: In function =E2=80=98scx_bpf_dsq_reenq_task=E2=80=
=99:
kernel/sched/ext/ext.c:10432:20: error: implicit declaration of function=
=20
=E2=80=98kf_switch_rq_lock=E2=80=99; did you mean =E2=80=98switch_rq_lock=
=E2=80=99?=20
[-Wimplicit-function-declaration]
10432 |         entry_rq =3D kf_switch_rq_lock(src_rq, &flags);
       |                    ^~~~~~~~~~~~~~~~~
       |                    switch_rq_lock
kernel/sched/ext/ext.c:10432:18: error: assignment to =E2=80=98struct rq *=
=E2=80=99 from=20
=E2=80=98int=E2=80=99 makes pointer from integer without a cast [-Wint-con=
version]
10432 |         entry_rq =3D kf_switch_rq_lock(src_rq, &flags);
       |                  ^
kernel/sched/ext/ext.c:10450:9: error: implicit declaration of function=20
=E2=80=98kf_restore_rq_lock=E2=80=99 [-Wimplicit-function-declaration]
10450 |         kf_restore_rq_lock(src_rq, entry_rq, flags);
       |         ^~~~~~~~~~~~~~~~~~
make[4]: *** [scripts/Makefile.build:290: kernel/sched/build_policy.o]=20
Error 1


Tested-by: Ronald Warsow <rwarsow@gmx.de>
