Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFC31332BC
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142045; cv=none; b=GPT9hIIOcVpnm6OPk1JkBf7MfT8N2PJt9YjkJx2983znJzwOoOV1MV/KMr43oVTtGQ9Ef0g8sOFbwky2VYN9fsW4Wsw9wpiwq8TZOdx1+J5aLGBQnqAo0tLVzJ1O89I+6EgiRdQQM035zToBoko14O/yr+JDZoHN+TpTUcDQLEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142045; c=relaxed/simple;
	bh=48CGxSL0nimyBR7hV1JMGOPtSOuj21Q9ZvH3thQgDzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R/aBY6Gvcr0yf9QKnQdO60FdJhnY0DrXN74ybMY9gMxF6eINL/fTRz12ucNRv4VMO129aAwdpUgwhIAqaRvZBv+QXl5LAyZG1KUVr060lS5+juu4A+RY8ft3gUGD7Sd+GE2o2Wo4kXUr7k+uOkPMdz38HZioK50o3eiIS3cxJ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bvq7M37t; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bvq7M37t"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4726608233fso318306137.2
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 09:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709142043; x=1709746843; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iUJmtckHKi/1Ij75fGxk5wcnwB8ZABZ/vlRQjgqtgfQ=;
        b=Bvq7M37t2PRIdaRyiEIz5/gur0jp7X7ctpV/NX5OHeGda45e22uXONYCUNz8WY8E25
         YE+8fWh4h6T4P53l/p+xaNoZ49vAaUfqlCVf2wei0kCtO45wgz7FqGRP1yapmizlbPaH
         Y0skZE+tt6GLQ+1WARrY+yHyu1foLxz3UZASVh6EuKei+dKzBM+w0DG9dtZCNNgJp1d0
         HjDmeLAdeWhHVVTxWFQUb7bRi+smBrpZ+fxY0yoitWA8eWDNCVyh0OC3Cz9Shx3WTU/9
         hR664c0Jz64+COuN5lr3vMns2j06Lxi1bTYbdcVfEvUMX2RzlKXfp0mNiyfBJlD4lsbw
         QlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709142043; x=1709746843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iUJmtckHKi/1Ij75fGxk5wcnwB8ZABZ/vlRQjgqtgfQ=;
        b=Z3qlGNnXQWCiw8goqtYP2gRqukwCb8HkHUgvADRJ97O+GOfXnUaTqVs+n6LeYy3mR3
         y42OvBZmA8YsdNt+xFEaqPciAEBX87ybvsWTcmpqTkGJz8/CYHw34PT7dHvQx7UWFoni
         ke8Yco4fexsCyHbdgaaPOzuu/jVhHMmftlmCgTJFJlF9rstkR8zoJs2NbVt5NhRQsJUI
         cXsTogMvJJgoLNcKOLxlwal2B1xAbN13MmKYRq9r8Nl3n2QMsMusU4HL4t8OArpQmlRD
         H1g282lZap43zfBmvX0oApzyDx+gTVnXQur1h2lcF2iv3jKfzjeT2RFjI4Sf6ow7p2KG
         k4jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP9OPR5ZhsuwAMYpFbryRcABG+h/tXjslnt/NRRCzkwFyttaj9NkK4YEyBsDBJ9tWo/a/qWR6VjT4pzJe1aAFpdHvtaWWX9w==
X-Gm-Message-State: AOJu0Yy7rGUDEbVZNeeHLmksLAPO3Rqwk3Np2GXbQ94DKlTzmblYkd8p
	rCi3gMKJd9qgxYpEFeJyu9+OPdBzoZ6LW/OTTrmJfwuEDqfGTUEcPddFUs6IIMWwHAxaTPP8Hzj
	ZQ1B9hBaq+/YXtjGPLQm8Pw6R0pM=
X-Google-Smtp-Source: AGHT+IFwbYwjbm+Zvkg0glMifQIhcw6NDLseE5sVvTj2Yw269u2BoSy382YAUgvL+7/vpr5MJiVjRPe3m5FpskF/+mY=
X-Received: by 2002:a67:f490:0:b0:471:e1ac:57a8 with SMTP id
 o16-20020a67f490000000b00471e1ac57a8mr259470vsn.12.1709142042595; Wed, 28 Feb
 2024 09:40:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131615.098467438@linuxfoundation.org>
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 28 Feb 2024 09:40:24 -0800
Message-ID: <CAOMdWSKV9H_F6gD0jkNzM0P4XkBax3ZONk9K1xPx+vWQdm7-vA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/245] 5.15.150-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.150 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.150-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
