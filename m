Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243CF1E51FB
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743772838; cv=none; b=L/0p61OeoIheAOgLAE07MUs6x5qNmGnCGQWFf7QRRPm8BYyCMx7lmJWJyZdRiwvkzxwQNRPqsOVtVap38o2eYe5m4NH83TffqwSag5pSsDfxiK2gMpB5MNfoBYCso9194P4TW93oMwtg+eSRnVPZReVLMcWCKwXi9gJRIlJazcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743772838; c=relaxed/simple;
	bh=hJW5FZE9wzMGEzmWLYyjuRGd9tpoV26paptZV5/csOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VCu3OI4Qx6xXiTFdTd72Oe97XiSkVKohjcGGVGRADQZkGsDP7CbfFvx0biDDTtTzbogdqmJ9vfGSi2ivHbnRAHT11qioprWSz4cE1yOihbMxy3icPygqCLWOWi12Cpg+llohmSfvnkkGZfhUOZqlOub3LgBodiA69I5bJiJTDWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=NCTInY50; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="NCTInY50"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-30362ee1312so2022137a91.0
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 06:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1743772836; x=1744377636; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Kiqs1g4/i+eKRX3/NK1xn8WGoGucOOXfAlNORNd6cI=;
        b=NCTInY50lVAmPEqR+mwXo7rX7l93dtmqqGqQodogqcUeHz8BP/20JweCgiocGZ2HGL
         8TW9Ib9egJJOfrJptuekYcQ0dWnEY/kPy9uxAUg5RomufQWbjv2O9EMzz/B3QgGpuyAL
         FEm4d/WvmZqfRhtSS1txIBDs4AVZCr3hHtpaPSaGXjgbdk3jcsQUgDIb6ABoCQgRrzAC
         Bmd34S9sEqtWcuFii5my4xPw1a6SwnmlO+WafIxAzmkJXNAcxR/pjzlR8dk63P6Xa2ik
         yFzls02TFuKp63UsZaVURPiNJ8BH4HLx4KHhVRpFHrXp1TiNFTOoELBFZhVPWKKCLBcH
         TAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743772836; x=1744377636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Kiqs1g4/i+eKRX3/NK1xn8WGoGucOOXfAlNORNd6cI=;
        b=sDFyzXenOneXDdwBCHw+0W9z1gX9EGfcBaFaprdrpS3OCZS/Af5EwWqn5/2hLF21Uv
         C+/hcCOMdfq1Nv3ZVoteTqupIbFKCNyMV28cjxwy54AZh32RC79mPWNSIamDU5XRM9SZ
         aMYh4fQ24KqWpY1HXVdSFTBjx7M57JS3UhPZH5nC+Pm43pnxiByWNOQciSFIOCqoVfn1
         U0M+xMmvYNqnP91HDxLah4xZ2WwS5h77eXBEeNVbxkw/xLzFYvjzCHvqiC8oJUKpPSaj
         Ai6J+Dre/wDgamlkYjOApAMr6Zbo7RkGOD0oVfVOc5AhOr8AqNQbSnTbTanbhOJpkJVB
         Gr2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDAaNiLddIS6NPz29b0thkrBxks+ahCYC8kc84TpUg2tJMm1piSetL66NIajEVE31+tTs1yvpg@lists.linux.dev
X-Gm-Message-State: AOJu0YyBY8OsJ8Qn2xxpBTIaOtN3fpWrTSmrjSZoRb8ZapbxieP9zu/Q
	49m+sMOVTuUwvdMy4Lozl1+vJQCGgWDRwB7ONrCvPgeoO+jAoqUu3GFel/TQVC0UJ4aTLWllK9R
	ORYqL21xxGZWalmUTt2sNXT8LBmGstCm1l/weYg==
X-Gm-Gg: ASbGncun08obk7FtMlvg8ku3QZaKl7IA9T1aIg4UBRqen0LOsWQLVthEfk4ynDme4IQ
	uxeB3nmcwo91fC32iFcc1UvULLaak1mSDXSwEzI4DEc46DpZN0BGQpFB8nNNJcYyjAO/PMyclP/
	3z9gDgMnzYrrT/QHdc/GMpkYYcFw==
X-Google-Smtp-Source: AGHT+IFulkjD6tJbY4C9BZj/bnJRutZmb96NKhGLWA8BRDLemCTGRD/MaqJKIKr0q132IsKbryprJauKtWGVOBdc1Lo=
X-Received: by 2002:a17:90b:514b:b0:2fe:b907:562f with SMTP id
 98e67ed59e1d1-306a488a241mr5725486a91.14.1743772836383; Fri, 04 Apr 2025
 06:20:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403151621.130541515@linuxfoundation.org>
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 4 Apr 2025 22:20:19 +0900
X-Gm-Features: AQ5f1JrOLjXtchCUzPwJ2RZcncY7USR5UWmg9tb-6yrsTcTvmjvQ9nHhIM79vXk
Message-ID: <CAKL4bV6hBshXXw5ZCMV7XMOehheoEmwJ8XcDceXDwuUq15H1EA@mail.gmail.com>
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
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

On Fri, Apr 4, 2025 at 12:29=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.1-rc1rv-g8dba5209f1d8
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Fri Apr  4 21:24:59 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
