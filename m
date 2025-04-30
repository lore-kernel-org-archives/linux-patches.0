Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753911494D8
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 02:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745980828; cv=none; b=QMcu3IsRwznSVM1QHNv4n9eHzHctDf5eYSNTBPPd86IH4z1tUvF7pHg0RZ0mD/1CjbmvF+NGEcuROXOkzubSSDJTIRakuL3Yd1tvgH55oMtWv/LE15BOGV82IhM9CvdyKZgDmC3BRs6etlcRXmVFmKjvapg6NF5a4rTaq+ts7GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745980828; c=relaxed/simple;
	bh=mU7mJLta1RGfF4yRKijsEDRGNM67H19F80CUaYD9AHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sUz/TUErn4aT1pogPO5blRWR2prBspI4pJODMeNpUtIs47gaOLAmeFi11KfP7zVJRhVJ/TMewpwlSvj7F9tWcyJwhFTPCHrmjQn23F5tez1ILOpXVH4MxSRWcd3s6aoQhDTrM8yngsJbCSBTfgS1mQTS2MenB5PvnIiezAVidh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Yoz+gXrZ; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Yoz+gXrZ"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-30332dfc820so7992114a91.2
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 19:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1745980825; x=1746585625; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KE5kHfQorZNaYCIrdId91DC7N7tm0kAhCZ61321pEas=;
        b=Yoz+gXrZzel4YBigrWPwA1jaa1bf1kM/aZNg6ZoJIzlbccPTGdJuUSHQH7xYKgI1cN
         ziwIqeyEDwa/iYUSIS3DiqI1R5XI0HjDOD/WQCLrG+J6Lf5KLVl/1NHeY9uRD9bejZyP
         9Vl72gSDIz9cMDwFOgA12aEmRnHpOVMym18eVB/m3YZh40oOQCwoqaFTY2FopEcxU3Wc
         9bdrMWA0txb+1j0Vy7JXMV7p/HxZboCSsVoYjctaVpYZlagYc/08/9jBb8jO3lI6nvc4
         rmABcCTMyIvha9/iqBf/YnB9Moos1X8Jt6r4mU6BRmcJLh5YNOOQ1qK7P3vkZ4VEoK4c
         CmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745980825; x=1746585625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KE5kHfQorZNaYCIrdId91DC7N7tm0kAhCZ61321pEas=;
        b=j4/GAWBvmvw/sbEvmG9ZcIUJjA7azgVMWPTsEpkwgxcqrLZdgFlcJgqnaglZ2IcNVf
         qT6W8i5h2pEmUHp/rLKAuxEAokTraksk0MTBCzgvM5lCBnXJ11uLsS93WUlrzvhQETTI
         HQDqamSegYuLuWU8+5igNcSwtlRQ+i9/q/m10vDAj9RgCsphjKXNwq4aK1nUi/sl/n5y
         M2jjYK2MUz/002tVGd/4mV3gVKaDGhdndECkRFkXb/YK5vw3VGGXxsJ5l7TMkLFPvF9j
         5oxHEyh6BgXjJtBTToVFEgllCFGsB3e+MnXtDTh4+bh++QiRPBsZkdX9JvmSfssQ4dxH
         S/qw==
X-Forwarded-Encrypted: i=1; AJvYcCU2HVowbp0JhLzruWfiMyvr1x0fNJrDCDIC0cYgFKG3Sr58xTKQem0B7lUJSDvuTVjS6zMi/d9u@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8tIENlHV7C27dTL1quhxAYTgxV9mLk9Xa2SdqBibQB1VClkgP
	jyHL6Mupwfe4KPgkPRxJl2A7ubPeRzw0jwqsHBMOU+xZKDGCC+7GtJ07U9b6oHuuGCRytguwaqE
	g2QJk3bT7hmGLXKYbZbz048RnaIFSdGPURbAeqQ==
X-Gm-Gg: ASbGncvXgzxZTKgdiIMWGRAmDRcJaEfIkrAFl4rAJ6Pu1BuCFTlFkclfaW82ueIdWe/
	gLN75ohwwfKugaSbK8BpRHrlTEIXW6GXTIGKUPUW9P6h30MgZX4O3nuI9NtvFgmaDiImuZO/Q/2
	mE0XViSi8ODRXKbDCEsCk3+A==
X-Google-Smtp-Source: AGHT+IHoE0eDvAqSf3SZxWvSFjBHfnIh0KE5oMgeDFXJL2YDQ9zk2a6IYWGwd91OMiJ1GIcoG4YuZjdrlL1l+W+2Oo8=
X-Received: by 2002:a17:90b:2d4b:b0:2fe:b735:87da with SMTP id
 98e67ed59e1d1-30a331d4e32mr2569324a91.0.1745980824704; Tue, 29 Apr 2025
 19:40:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161121.011111832@linuxfoundation.org>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 30 Apr 2025 11:40:07 +0900
X-Gm-Features: ATxdqUFGhSy1JnAQnnn0wNQBiX4TxdyonVv9lW6DvIqy86SE9Iy8dhorxCLC82k
Message-ID: <CAKL4bV4UVPgNTS2hS02A2BgLKBUyFjDKawHWK+oGQgNd9jXbXQ@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
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

On Wed, Apr 30, 2025 at 1:55=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.5-rc1rv-g25b40e24731f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Wed Apr 30 10:38:19 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
