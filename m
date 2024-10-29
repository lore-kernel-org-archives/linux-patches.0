Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818DB2071E7
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730211562; cv=none; b=jiCcx9vk8AmpUmKPxalgCsHSw7XytBvn3Lp+nU3bHJapSa1RxGSWDCtL9XYnEMOlcHl5j6KK7ir26mcNq2GWeQdNpJe8Pi/gAfS+G65bjlROPUndDcWL3CAOnEEht6tXsPRZ5L/F9ECnWWNiLQjo24MFWKrS9IbJjDR2HEaiYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730211562; c=relaxed/simple;
	bh=tA5sCYoeUjhRtn+y9hymUojsFEhOSIZxNR2YW/DMXsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dJQgdQsnEXiJsVK/ckKnEAm5yAyumLyGOV/EPCYnCi1/aXAjfRtcWwallB1zqjdbEsbXBZJu+8U9xiP80S2Mtog6KS556Ixmn9puYrrlG3unkuEgyq92PN6i0r6fnNjm65MhlM57hch8J098N1GCIyxRnlCmc3i4LAaz44e2n1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RNva660X; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNva660X"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3e6359ab118so1790785b6e.1
        for <patches@lists.linux.dev>; Tue, 29 Oct 2024 07:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730211559; x=1730816359; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7HYSwpcECGpfVNHidkAxD9FJiVwdCLohbwQxJSDtSc0=;
        b=RNva660XeAramscaYPiYvOGynpQA1PpmZFo2DxGmpNv6M9o0pcaNdYDnLVbB2+F4Op
         ui/4wyznXSvZM7LIxunp5YBN+i1Zn/jXMLhCPeCRjfwKO4DRRP9uDLuvxAgh6tnleTux
         wZ2vAIK3d4HPZdn8+6GxpHnnHv8yeKmofu2QjK2EjK9bSxfzaqr8UwDF0RlUwSIL1oET
         +d7RdnUwkChOe7g5RNECH/XOAj5I31oWSAlwo1lDMld8kBBGrPjLlyhPmVUziNYhi/gc
         4YR8toK+VfkNwgn+vB2g4+JGguaP3wF7m6ipK2ijDLACBXffHUPgnv6LyLh4YY433lAd
         JxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730211559; x=1730816359;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7HYSwpcECGpfVNHidkAxD9FJiVwdCLohbwQxJSDtSc0=;
        b=E0GgXdUlw9GRfjt9u0yzlA2XJ+olYG2rn2fh05pLrGyc3OvLbo154P5pbvD84ZYsAY
         hk9lxiQh4jAxO6uqmciqTOOnZEudMZxsk6IgLzv/P5wIsXAlSdwx/rx/AZ4VNQPXOlD+
         a9NRcbnxCo5RCz876GsLIsw+Kt5zsCBS6QLY80aogc2hpchijNnTvB0fHt6D+VPPztWa
         2fPCuF2+sacDr1QH36CCxPbxT3tYRNO+tUCZkdGDpdcY+JLZzedbfZbsIhoXfaOvdBgY
         XYSn8jlqsyHUlUenbtwZfjOiCxTdF7CbdvciaXSEgBkEYrRry0h/UZevfAdbCVTT0exl
         /C4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJZEdgVMraIQMDxVQKu9bxXSXByU/J21y2dqEDAgqXi+M4jnD2O8j7wDIWnT3drptqsZj26wLv@lists.linux.dev
X-Gm-Message-State: AOJu0YwTff0n5OTp7/g7pXxTw1ANddsEwxdwTCJvltu+D45R0Vi5Ub2C
	OfKboJxd4xAUn/RQ1o70IdhahjmCpD9NKXhpDOuYdUzCMuM3/ha3Y9NnWVNpjXQxU0BYafHSf1t
	SfTnwPWlb1WO61FvTcxTE9lclPZ4=
X-Google-Smtp-Source: AGHT+IGwmosdiSix2Ury+05PZd34B1zjQ6eUZ7gol1Akj9wSD1CftDjqGniqYvswO00427L1FytOlVJiyySkAayLY8w=
X-Received: by 2002:a05:6808:1a0c:b0:3e5:f4e7:82e4 with SMTP id
 5614622812f47-3e65256f9a6mr1302706b6e.21.1730211558095; Tue, 29 Oct 2024
 07:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028062312.001273460@linuxfoundation.org> <dc2297a1-aa4e-410c-b4a8-ded53a4a96a1@heusel.eu>
In-Reply-To: <dc2297a1-aa4e-410c-b4a8-ded53a4a96a1@heusel.eu>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 29 Oct 2024 15:18:59 +0100
Message-ID: <CADo9pHi+=T-oQGeL8fAAf_RDx1xnSYD1b1AONmxo66CqaNz_Fg@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
To: Christian Heusel <christian@heusel.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Works good on my desktop


Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tis 29 okt. 2024 kl 12:37 skrev Christian Heusel <christian@heusel.eu>:
>
> On 24/10/28 07:22AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.11.6 release.
> > There are 261 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> > Anything received after that time might be too late.
> >
>
> Tested-by: Christian Heusel <christian@heusel.eu>
>
> Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
> Steam Deck (LCD variant).
