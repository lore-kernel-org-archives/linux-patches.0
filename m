Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E692343B6
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 09:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741772117; cv=none; b=Cs25GoKYlLb37JhF4hSEFlAhJNrxDu2zQzJRYxMQ2B8SygGS5uEJhj/4cP5frBDpN0oHooZRQg6ANBZyl8RyL7cLI4lWAFC+jjtMJUzwEjLiLQUXpGfMXAWJdgaZ3xx0ziAS+dy2v0Wq5HVsTmdJbWntkK6n0T614YJ9O/q59MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741772117; c=relaxed/simple;
	bh=PmzjR4Cpz/cGaEj6B7a8P4PKsIGJbrlzZH11KwxHt3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqMI0SUNmK2u4b3daPg+R5HppxQE91DQDhNwDDtW/1a1rFuT3mL5+2Ars3y70MGlKWAtWIFfUsLh27ykGhJzsnnKLPPVdV31AcK/eIkdbG/2ZwQaXH6yECA2TZPnfcb+ZfkVnDV+7/euvNRoznWxeqGt4sVcDe0YLeXsg8XMZEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DcZxW3V1; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DcZxW3V1"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ff6ae7667dso12326699a91.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 02:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741772114; x=1742376914; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ttwRvArVp1ym17d1zB0rA2V5k7MFc9PYa4gsOt24iR8=;
        b=DcZxW3V1nTnH5kiZg1i6B+PEc5PbpnibJeao47zpFncF7vwFNZWsIrst011Fp9PJtB
         iXJQuB0vX57sY1j3gppdhsDqq03NGK57s1lRZTY5NbLiqJL29voJxmxmwx+Pshy2IhpH
         aNux1JwaNw1w2WfsuIvxNXBgI/XfHMucy40sp5GCk2vJShQPxvz1wW837+S9Q9rPzxiN
         3rpr0G9/Km5q5X1K5LU8S1Yjd+EasO0SNK0PAeYBsMqvMaWw3MXajqT8in2u3XvacPfN
         0mr8Kn1k8T62EtUWAxVFpaKxp2LJWB8o2d/x2xAsbwJHgiIFs9FCemePx4oxD6tMos1z
         NBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741772114; x=1742376914;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ttwRvArVp1ym17d1zB0rA2V5k7MFc9PYa4gsOt24iR8=;
        b=v2W7R6PcJOkWNFJzUb9GSpslF+NtNu63MsedWjZWKtBnIc0Ra6hGMcFPSjiba1nm+0
         EsYz2vm13Va8GnMXAcW79/Kqbh7RC1MwPZjmjl4SJkrnO9918QYfnMJAWYNsupATiZCt
         wOG63qcbFqKYUMToTRQywd4CXvax84lK7gmTvRLQ1vQMm1c6Hr8h7RZQ6aZPe4565Oah
         rmzDQlcpFnnimmsL+YDAhJZMnO9lT9lghYbEp8Xolvfc/ITW7s1ImLPzfiXT/BLz7gwZ
         AWWCg7kQOpUeSETLm1+Fzxg70CRMlLB21dvMNJk6NtvksWL6SzYvWcFvJuzreS3JbyDj
         wD9A==
X-Forwarded-Encrypted: i=1; AJvYcCXQHOCAAISh8dtvKYaSV932asyqKvHwLhpkGgJ9E9koF8IfTwrfC8DJkgwo3WIIXhcTNiggAlxc@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4nEoyYOQLMj0CTsbxUlm4wfigSictcCh2csMvuLCcTTSuunCH
	JcYKUYmmutVQrlMfd7J+V3d0EG2ZsDPWJR7/FZCkbFfhIuBhw7XNdnbTv4qyKwAVB4/BLZt0KDj
	XLcju0SoGbW4qDFpA6VcPTsIj578GmRpRAfVgsg==
X-Gm-Gg: ASbGncvO0RMfFh7Snk55Tx2Dph1oi4x4reWblLTtXA3v0iFfWdrkIzGA7yAjNkdi1IM
	QS/HlLWNhITDB7K+J9zEtWhHaJoavRagBX9bA9INTuDGLELjT0+BWJsEr77/Ib3jNAIsL+/Svun
	BMLU5NrV7oE+aL/GLMA2jgUCuoIiU=
X-Google-Smtp-Source: AGHT+IEYSRe0gRR5yo1g7wU440dBsuRnZCe/vswTvp6uZ5rlXqRYBZ9uB2Uyw4ni/IgE8JGFvBGWEL/ibOE2TyQi0Es=
X-Received: by 2002:a17:90a:bb8d:b0:2fe:b016:a6ac with SMTP id
 98e67ed59e1d1-2ff7cf5f7aemr32864523a91.15.1741772114286; Wed, 12 Mar 2025
 02:35:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311144241.070217339@linuxfoundation.org> <2b269f01-e508-4940-81ea-31c5cd961bb1@drhqmail201.nvidia.com>
In-Reply-To: <2b269f01-e508-4940-81ea-31c5cd961bb1@drhqmail201.nvidia.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 12 Mar 2025 09:35:00 +0000
X-Gm-Features: AQ5f1Jq0KNR5demOD7iOfh9YAuVYOUcWURsYUGw0TJtcXQdVfw8evk7uh_JbE1w
Message-ID: <CADo9pHgbPPFZW=TMBw9mF15f9hsro4E3bw8FnQUsABZEqROBCg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
To: Jon Hunter <jonathanh@nvidia.com>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Works fine on my Dell Latitude 7390 laptop with model name    :
Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
and Arch Linux with testing repos enabled

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den tis 11 mars 2025 kl 20:42 skrev Jon Hunter <jonathanh@nvidia.com>:
>
> On Tue, 11 Mar 2025 15:48:06 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.7 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc2.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> All tests passing for Tegra ...
>
> Test results for stable-v6.13:
>     10 builds:  10 pass, 0 fail
>     28 boots:   28 pass, 0 fail
>     116 tests:  116 pass, 0 fail
>
> Linux version:  6.13.7-rc2-gfca1356f3f51
> Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
>
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>
> Jon
>
