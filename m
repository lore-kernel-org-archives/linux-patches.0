Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A3E5474F
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047384; cv=pass; b=nmpKcQYe0vD70eHSC1qsroqQDfBa9zGQpUatRX2Mst7ydbNdpxprcZXUvI965CHveEbhfRNq2SII5G6Ore36JaMIsqhl8varQxeZjbxnuHwpS8dpkLTkKFluNReAStsiCjNGHbyyNVEvObmzdRbHLx2TxQC0rN2ek6T9rnqsDP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047384; c=relaxed/simple;
	bh=78uTA45DXLCX7o2HwRklFyYI73EcDwhCvnZ3/iY+SBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BKIs6Cmsl4FHdJiK0H+XDoaIMVrF8GymHiLE+ovVJvwSPrvFEGGLPVFAacxdCTlhG2AdD9CSmJX8GVwx8KP9gr3Fw8DqqtUGCOmVqUSFgItzJ4aZnnK3+nk4egMOPvqsbbHWsX4V7A+vxf1vzD0UXPXxl6LRl0bAc/wytnyLnck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=vQkSF1rq; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="vQkSF1rq"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so442352366b.0
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 03:02:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787047377; cv=none;
        d=google.com; s=arc-20260327;
        b=YVBxvAALahWdRI/IU4S+wGb76ylp3UCiQix4z1RPIMtiT4eCGp1u4ofZ3Vwe4Q0OQe
         NS6cJEjfXCSfnZdaE7fV3gXHAALGtROLw7rM+J7rIwmUqTtxpzwHfaziTWRORkOwblyY
         K1Z1ZzFFQqL+AMfXXNYp81KBRO0WgSofPOpKf4wQsg3iTfGqMwhsAXfezzCeg6Mce9aq
         Mf/kYlfr11F3OY2EgrpR5JHJRGd8CU9d4WbxLvypobnjVMb4C5NS4WhukhB6OlDXX0Po
         iRmy86HkTzkvttWXAr00ed+Xmz24ee7rfN1/Y0ajVu7pj1+CZYSWfF1YC2CmBK9i+uaI
         8rWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aR7I93O4QF6pVY4R1vWgpoacJUlAWf8vZMgfdYCyiF0=;
        fh=fLVd6keW5so1t1a4idcsA97WG5OXm4XX0my1686Eyr8=;
        b=jXlJVcvIuYzVNQpODqGc/j5guYN+4FFisaf7KTVsD47UjOJS5pidvYMby6ilq2JGg+
         S0OGfqLiAqLZOjB49uHJfWw5O3KhZD11rOOaB2hF+bywlUtK4xh5hC9TUPOmvRhA1Zc+
         nE65m1/SNuhChltjyORqJYDXxu4IdytddeKZ59x9HP4fPUxI1tfAp11oYP6UGE3UR3dR
         DAW5dxFy1B8vxBT6H5nvpJnmQgNerKBvp1Bt5XqJykfBGEPjzKj88Lp6d6HhmFwg3C/k
         O4JxnbL5SMIbUn3mURlYb45i+nr1sRrkjQY9r6dWiuvU0OCam4+ohqneFA/UNTcHxotQ
         SPRQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1787047377; x=1787652177; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aR7I93O4QF6pVY4R1vWgpoacJUlAWf8vZMgfdYCyiF0=;
        b=vQkSF1rqUbjwxrv12R49v/voMqpxn4AyIW1XQwJdIVsbXeqa1vVQysTWwI9ZyrVyku
         Jj6qNTljCIghipRQZGR9Q1Ta6fWvJUWlYBvZDekFOTre+A0VJgAY6UeXwtBBLJLTzf1h
         DR6CLPLvBMIiuQZCSM7TtXJO8zcJfQnDrpcFNzXU+Fh4pu+0u2udRwmtOmDa2mhmzN/R
         OBCYXxlQ0c6aqvjPxPMP4Pdm2n0uaUgP72u1indAKT4DAPwpQ6SEOK4JGo+vSgYCljUv
         bBxqAgi/IWDyt6pdV1MjC/RgD3uiso3c5MS4pxdj6yykGQCkS02Nr25F4cjtfXnSR2LY
         ZUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787047377; x=1787652177;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aR7I93O4QF6pVY4R1vWgpoacJUlAWf8vZMgfdYCyiF0=;
        b=NUQYP8pOmvhjJ/ffBLTMUsBjQure4lLqlCLmuJS4q9ONi8EV4ovOc9SbRBHL8/b3AC
         DjYqihoZpLZIcFs2qH2LKwZ4ZNuNWupvHK9eP/iV2N+fU9MepBgbeL3CX4NPo26gaQdU
         lKfsBOi51TgSyWmqgcIA0knX+XRJXWkvinP6Idsr/1XXNOFL2cSmySCgwMpIYIqoCh5N
         39ESDwn5bZVAqg6gEicFhFRFxjB+jXVC8+BeFdvcuCKiJSbvYGJtJD7I/F92aiXy6pKy
         yeJF9qr1J5YWqTrOzd/TY/oJzZRGOPSEqweDHUqNSotcEcjfEYBNtFs7ASFJpphP1yQy
         mwIw==
X-Forwarded-Encrypted: i=1; AHgh+RrX8YFH7NuY+2LfkAwWrxthulFUiB1HqNhkW4pMCEBwp0FuMtNEBeX6/NqbCFaskrcaaqv+KeG0@lists.linux.dev
X-Gm-Message-State: AOJu0YzPEtZlfVc00wSmy1WK5ce5+bsQ4wiGfLe3338mam0hrtSJtmAn
	mXU6mXjWIKLbZUkewMKao11WnnDOz/Fl5fu6pBdB5PbxxYNyoZ5F/0fNc3SfKA17+WzJ3sI4xxK
	Gsh3gBvZHlvVe+MeXdxEZat1djYANLbf6sIm/DgqGHQ==
X-Gm-Gg: AR+sD136xUga9aRwstmv8TDXG6F5TE3zB8D8vs12ZmB8fpL58baOnXCSED3vWzGtCsJ
	TXzZsrCBPGYS8QIRHum4Nx1D8nSXyh++JXL1sw0ii1h4UpLGDW7hVAtb2hQl+eN7NGv2nmGuc3O
	bDJPvJCGDExUPJ5XjZI9eNF/qSFlSi1X7Vtk9Lbn8Pdo0YNFLaKlYPq2zPU1w5kSd3Evm7vtg5S
	6OEDcHs7u1aw0yFhUK6Xpi4WeHHGIRXIA96CyKIzkFMzZ7+2Hn3Pua3NFCp3E3wsoIlCRGrNMHm
	yy+hSb2WkMtWHB1mywmgmgCLpnx9hmqjMwzW7m3s+Qur8XZmGOK13R1vWWCW8g10vPszFBvX2R4
	dDA==
X-Received: by 2002:a17:907:1caa:b0:c15:f0b8:eb91 with SMTP id
 a640c23a62f3a-c212a092f29mr1387506566b.7.1787047377259; Tue, 18 Aug 2026
 03:02:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817132536.752504388@linuxfoundation.org>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 18 Aug 2026 19:02:40 +0900
X-Gm-Features: AcwNN1VSv3tFMRKcB8Zt2MmvSfZEIcWruvB_pq6_KadCv4U1NRYiAfbL3JXZGaw
Message-ID: <CAKL4bV5_5nvLXtc4GKhrvgjhdCerbyzqyVb=bfZwj26NUnJzYg@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Aug 17, 2026 at 10:42=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.9-rc1rv-gac99063060a9
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Tue Aug 18 18:11:50 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
