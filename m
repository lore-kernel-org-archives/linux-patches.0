Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F83C19CD1B
	for <patches@lists.linux.dev>; Tue, 27 May 2025 23:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748388289; cv=none; b=kqSoHzZ7+Bk83yz0UBIcvq6BKj46cHN5yiGe9d5ScGXkUtkWrcBPia723ka6SuFiJA87x1wSlcO0yFkFrL+wKZlTnySlCN0fAaKYgcTGrKSvTyJgmODrMhyog9Wks0/9kxSfYOmVGNKYt1swQvcXJf+Cr1GsBUbmCpd4Y+YQlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748388289; c=relaxed/simple;
	bh=jKy9NgchQt+WvfZ21StHpNggfPe2eTnQo5wDW9nwTDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VpZ0zaZQtYlN/+kt7Utv93uw2Brbg5RMOaIVEnry6xnKni+HG5g7ysF2u2rgvOuygh+JUTr7ztucdVpEn/9fRaunKqyUvwUP+L9sMCcLVCHJS3DRi7Arg9VRKCZ57AymJOQiwoVelxyy7h5AMZq069JcXPF6cn2/JtSZjVla1lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=lO0Yd1tz; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="lO0Yd1tz"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b13e0471a2dso2293521a12.2
        for <patches@lists.linux.dev>; Tue, 27 May 2025 16:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1748388287; x=1748993087; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/AdhCxX+fhaAjqKIeGANn/dtdFJvwGse4cpAiUUl8I=;
        b=lO0Yd1tzyF4uv0by6ERvwA/t4+hsWjZcTNL2cFWpH33jjEm26Tviz3OZo21Ny8/rnY
         6lNMHNAeBrMQILwX1C2P/e36eWLxvWAzBoMSE/xbbSgdOmuT0Q4lOBV5cRIR4Qr8NC96
         l3opukzWzXMEh0Y8ovgl8kkDMk25bB8ccErroT7Xnak3IibjgDWhFuuARPWn3kBUMVQy
         7vVBO11sXZHcFqxz0fffR8n6Dpu2uqPI1qU7MwN3ewfU993cKv+toZLHvxdnq4s3GUse
         p4IHvqBopj0h+1Sl1/A4d/8iT5R6gb1NGn/7Bx8aATsZjNau5MWi839EXANkqMaahDM/
         aDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748388287; x=1748993087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/AdhCxX+fhaAjqKIeGANn/dtdFJvwGse4cpAiUUl8I=;
        b=r9pvXASkP3tHRCTHzGzvcRRrJJWG5swVuPhxamRgeSX0gY5VKT+KLpKrtKu7qlLMcl
         GQUHEgx/EugljBNiaBNMrtqVOLLtdinyr11VOl5W9bpKYrbWRZHwdjJh867AqjKitLov
         ntUOrYqTGfyJVuMe5lsDFUuaqnYZ6bAjcxEI3hAodfMbuQ/q9Vtw+AG8a+pJ7LFt9b5w
         AkwbXKbDvGUPsdWxL7KeRBeNVE99y5h5DgpaAqW5kqbmHVsymdW6/J6aoanJx9Z9aBPb
         GWSSqTeTqo/nWzBg5ubnQaL87gnyatzIoLdfACy0/lTc7v04wLMJOWQ2zyiKWxgyaGYD
         XBLg==
X-Forwarded-Encrypted: i=1; AJvYcCUZM9Taol/Ip9T5a96I55elDeT8cA1hWGtvEllwQoBHmGvVO2sGKsf+TA5xBz6BSHfpkN2rd0Em@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo2HLNNcxeT+CWFI4hZonllfd4UjWc/YF4+SfoS642vDjoA4ef
	RcC3jrF1njxivbwBCrtTiG1xbH7oqwt58/iwZ4NTEV+oL738tjHUfWRgi9VrniRjtJuK8mc8+3f
	5W87rLIqf/Pra0mLsFqOcCsGI2BlhghxvTK+8QY2c/w==
X-Gm-Gg: ASbGnct2MwLZq/bIfoBGQiEClcDSKCWseD9tQ4efSoc0EzZW3i2QO16PVYWdce5VWcw
	JFE7VbnDYET3q6//qkVsEnGbw3mgx85SICLKXiMKxAd8Yyh74o+mvyMn1VLMmeoB9X1kd2Mp3ut
	/dpQJ5jz7dK6XH37IrSYmL6WKqMMRVBvdM
X-Google-Smtp-Source: AGHT+IFmwubUy4FOTdwjh+r8gzogSmYCj71cSJuKN6sXG+aSYoZbuPnq23rLrIFrYEL3P6VofYv7oiykuQvdMbGlOtk=
X-Received: by 2002:a17:90b:2790:b0:311:d670:a10a with SMTP id
 98e67ed59e1d1-311d670ac7amr1862164a91.21.1748388287317; Tue, 27 May 2025
 16:24:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250527162513.035720581@linuxfoundation.org>
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 28 May 2025 08:24:31 +0900
X-Gm-Features: AX0GCFtS3HerPG9aWFxPBUWJU-YtanQX6WBozRmlEInmQtVP7B-aaEmISIQqRe0
Message-ID: <CAKL4bV533B2X7zzAUY5VMUD0VWey8AK5LFVC=nXOdYu8stf8-w@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, May 28, 2025 at 2:19=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.9-rc1rv-g10804dbee7fa
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed May 28 07:41:25 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
