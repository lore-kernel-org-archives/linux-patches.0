Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79804F5FA
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 09:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629672; cv=none; b=ZkKh4Spcc8DmHiz8yvGcFBExAP81MMNk9L49XqGxJZLFiKVIb/FY2aK9XkfCvdDpy1KNzIaLxxA8P9jtHEwYSKmG0rl0EYrTNrf4ub9T3BLk/uHlwR+3TJi6XiUbNFiYI94xiFDv4IQrmqYdf7gh3wyeL59Fg9S2GMAd1UI2RBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629672; c=relaxed/simple;
	bh=9sSwvYiVNiVEMFJhGyHIfjkNYJ+8iisCRGyT03Xnpzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=luSpWG/rLebRwjAdJTWdU2it6h/5Jl2SwNDb/ZxAPH1K7Y0jigLwCzs2eRWwHPfHQcYEPEphberhPW2dpc5Uf5umEZ4WBRRr/dnHPFYJNMrX11sx10eHVMYD5LQcCLMrMX0/25pYFIX36yF+6U1sKkkA7KX/IifaK9tGdUuKqY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ll6MYhkz; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ll6MYhkz"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d4a1e66750so4061800a12.0
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 01:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709629670; x=1710234470; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xECqrC5wW8C4gpURucKnrkHYEZdlXOnIvk1nQsHS7MM=;
        b=Ll6MYhkzPyJNeQrQ0M0SZc/11HhCPnagWQvEkOpZvzRKPrQ6N4+jULs8YrjwD2jtXl
         4F/KYMuYKhlJxBi10IPvC/sxLc0vyx7Otb5QGS4uHiPKDQCOYDtvx5zSZWy5ly+lrUPv
         Ld/3L7kw6liJrtBkoqG/yrUQW2osDffiNrwMuBi/CkZwCSpy/dHndVAWG5h5MlnzlY4X
         T9KRo76/NKUcCSt/y/QYHU4OQRTgsXTB+MLvCOHOdS3zqlO1YHZLGkC4OoU1echkx7Uw
         /d0POxlU4r7vBtVRqS7KCpcQ5qzLe+n3IpFfk9dgKjakvKiLdLFuKUNCUHe4RQL/XzND
         kN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709629670; x=1710234470;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xECqrC5wW8C4gpURucKnrkHYEZdlXOnIvk1nQsHS7MM=;
        b=ix1CPIzDryNZkpKTtJ4qLctLqbAaI9Z7m606OHo1qgwyZ6YL8e6x6uHotL0oMZv7gc
         KJiWryV2KYrwsB5lBgHHqvjtcz+8TuYVXYljeJE+b2B0ahlhNNNVUqtgxPPv9I5HAtcn
         C+QeoIw7khE8cgCqsj9j+OisC0N/evFGAMQDeFDId/7s4jN2w9Xeva8Y3VYFvtH7SvT/
         0JSK7dnDu5L28nSnCaTvtYNMOLsfTb83/grl0rUPagLFyNOxudp86YXaQexhECr9iurW
         Ui4gc+8pjMoM9SkiFEDWOMeC31s+dMRR3xQOi4ekHTpY7gXgbGIzmHJRZjwsGttIrWbZ
         K2kA==
X-Forwarded-Encrypted: i=1; AJvYcCV41mij7OaXrDzWrx3PnS8rOPoviaLCm+EMXhXT9qbToBUu07s9TWUVcoshYC1dn1a68C3QsR3Q8cA/hTkFhOydFIzEMhJ9hA==
X-Gm-Message-State: AOJu0YzJ3H4aB/4Uo6yDcSNY2lDuBucs/MsYKbTVFZAyq3i5MXIOYPM2
	hU8Bdq3NP8iCMVLmqhepnvur/WH2jvx4Obn7Vm+f1xEewTXzqUiI95fIZqFa9enV50UWpXgfm+4
	QB+nPwj6rHfzdCSVQoI8TK81s24Y=
X-Google-Smtp-Source: AGHT+IHQCsAc5k/dqnxRuofGLrxJI5VV9DX8j35EwjwxKG9bP5pOWIbRfkocDE/Kxr11z/qfnCWoxfbMUcq/eJzkogw=
X-Received: by 2002:a05:6a21:6da4:b0:19e:2d04:d775 with SMTP id
 wl36-20020a056a216da400b0019e2d04d775mr1121314pzb.50.1709629669859; Tue, 05
 Mar 2024 01:07:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305074649.580820283@linuxfoundation.org> <20240305-arson-panhandle-afa453ccb0aa@wendy>
In-Reply-To: <20240305-arson-panhandle-afa453ccb0aa@wendy>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 Mar 2024 10:07:37 +0100
Message-ID: <CADo9pHg4teVS7Lt1j+gOt4G9U=dZF9G92AUK=Km6PTdURkc0pg@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/163] 6.7.9-rc2 review
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

Den tis 5 mars 2024 kl 09:32 skrev Conor Dooley <conor.dooley@microchip.com>:
>
> On Tue, Mar 05, 2024 at 07:58:57AM +0000, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.7.9 release.
> > There are 163 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 07 Mar 2024 07:46:26 +0000.
> > Anything received after that time might be too late.
>
> > Samuel Holland <samuel.holland@sifive.com>
> >     riscv: Save/restore envcfg CSR during CPU suspend
> >
> > Samuel Holland <samuel.holland@sifive.com>
> >     riscv: Add a custom ISA extension for the [ms]envcfg CSR
>
> I left a comment in response to the off-list email about this patch,
> I don't think it's gonna work as the number this custom extension has
> been given exceeds the max in 6.7/
>
> Cheers,
> Conor.
>
> >
> > Samuel Holland <samuel.holland@sifive.com>
> >     riscv: Fix enabling cbo.zero when running in M-mode

Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
5600 6-Core Processor
after the Arch Linux manual intervention for new mkinitcpio settings
and version in Arch

Tested by: Luna Jernberg <droidbittin@gmail.com>
