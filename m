Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128BE15ADB4
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 21:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718831638; cv=none; b=sQbN2uHsuBvsdrOMtOGZeXTPJo+8YcRDSoNeJKAI5HRyb08FIFqOFXl3ku7jl17KlB+rolcUM2XU/nyHConJ5faLakJK4d9n4E35LTaChAW9GLDAAb2Tdn5MV970vUZHuj6T5OuG4OimTuEqHDKT0EypVBSYTuAr/mDjgxl6o1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718831638; c=relaxed/simple;
	bh=rpOVe1jItyq7CejO1NxThDWJH36d0/VyRsjB7hMyk2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yzox+cImL73oAK8OQTlkKBbSJZCYTdUy/MW+P3uNtP6YmroRQtpo3owyI5MutyFMpSTEpaobBzHxtAqwzc3mdB0Yg8TaQOBD8UPTbv2P60Vf9Ed2buYoMnW4/jqrgQao20+SWqxsmmJB7T82mMCnMvdPIl/lzmHsww/Lda3i0N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Law7GwYk; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Law7GwYk"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4ecf8af13edso60664e0c.0
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 14:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718831636; x=1719436436; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5lqTl+uAxp8s2vfx7aDxDVmFRnQKP/tGJxujthBDYjI=;
        b=Law7GwYkJX2IN0iSq3w8dzzHrGP0xcjzzPLPjKtHlWUwVLFxi3MvrP3EBFSd3o9lOK
         3Alot92ED6TsTkFxbWjlOGjJinYry5tlpYnV7ZKcWP9b556mzGvixd0qFYKRusjfeTip
         Qm0rqWfi0FZdVUH3ranc3y0fOT74wuZneK7reLsfI6iRNSJei7a2u+Zq8pESSdw6Cf9W
         HZTm2fTbNgfLk2cv54AsKVjJIua7tSDjGpRv6Mni6pcmJ+ne6xIV0x6Ac2bc3h9aYY00
         T7i/jmZY2eZETVZDuYKeE7CtUxNqW1BVAdb95bTyE1zL8Ua0OIlFCA06JPeU5xzPavQa
         2/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718831636; x=1719436436;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5lqTl+uAxp8s2vfx7aDxDVmFRnQKP/tGJxujthBDYjI=;
        b=B4urgsJiP8uxG0zzE1p9ZcRpheBaSxBofaLVbZz+SvLGckcW4afErXSuPoLki720H5
         OHLjOCCiZF/PjxvQL9z31JHWDnok6poYSgL1V51AhostgOZiJZ9uy2tspFEQfWLtEU1E
         rxsuO0rI2W6c3iHWs5TCNfeFtYxIrLEJ4vFDIWqQ3f13eCyy/OLwawsjfYhoXzFAQuvh
         RS6x+u9P7DLrVZW90P7sg6U1EkRrBawzX5F7gn54KhUHnPkyNmwkqS1+L5nBJpDpZfs4
         21HkJxQUZsDrKsdJR3aNr4LE//jvd+R9F2lyGRoDuAtXOBRs1XppKFD1xRW+/VQ/jItu
         IK0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0vb+UL1kk9Ny704372ArANjnsKq+0v13H7rG46iA/iSAVxvZoR0+oQ5ODCHr0N2sCLvScH2eVW7brEonnAGGAEn5fL3gz9g==
X-Gm-Message-State: AOJu0YyPAIpzbPxqJRF/s6l8WwzkDHA9/3Aod/x/cXKilBwlxRmy2qjg
	LKES0Ke/X2O9vkMP7LrgHaeBpFJ2gPN4Y85ZJe3A4lnCprE/OsNiMnbtGlPWPLauwebn9Q1nWX1
	RkQcCL1u5EqbZs7Y0FlnaNzOpCtw=
X-Google-Smtp-Source: AGHT+IG+nD+fZRMU/xOWtMG+hZUji6SWhy84IrO3OtuENFQhrKrpf0j3Ruw7e7xZ80w8ValYIl4HkGMyoFYCtLc53Dg=
X-Received: by 2002:a05:6122:2093:b0:4ec:fc23:7928 with SMTP id
 71dfb90a1353d-4ef2777f84bmr4352731e0c.12.1718831635757; Wed, 19 Jun 2024
 14:13:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125556.491243678@linuxfoundation.org>
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 19 Jun 2024 14:13:41 -0700
Message-ID: <CAOMdWS+Q1U0jzwcTiaXTj1RRhPVdpp0e=4dCQs3JLAJD+YT9cg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.95-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
