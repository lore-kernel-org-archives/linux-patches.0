Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910BE18B1A
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727452283; cv=none; b=XMeUH44J4N3a3cpc8UpU0KpMzNpgSIIwvf/AzcHXms6Y54QewbkbfcX5mc7cPuvdxBa3uCDRLBaXG1O6deXZcaZNNRbsWapIdUxCxkRVYNtTGAk6zXG+XWQ8Z+Y12+Z3nqqRg5naEGmdxzzqvgfYZH6+V3bZRpvKCtr3OcOItIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727452283; c=relaxed/simple;
	bh=4aXRDxXbwjNUV0PLxI23rShqr3O7FVVGkTMLLEsf8aU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MAYG7r3YpzCr9lIMPrKXsLgXbPwF0fZwsMeDLy/aRXnxFCxF9EgFTRzW0f8IWNG0tfuMH/NV1d/9HE12BNlZypgZdL/FnbkcSkyydeQS8pZ9zMPht/kclEuHE6YJyS909inm1kdfwHvWV/GMxhPmAspbg4c5BhQeC9O92avHaZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPitc0NM; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPitc0NM"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5090e09438aso7486e0c.0
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 08:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727452280; x=1728057080; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXxprvEH1bwArWzkjF+rjwkpLdCy+DXaOT6jNfrQ7yE=;
        b=IPitc0NMMEENqz/IfpPQeIbjkElDCg0RJnugVlJ9xjFjnB+tMjQ2BUq50syEYaigXN
         srxbW22SREDuE8wgpY5C+nZDrIC8dTX3Jt0sMEkJs/Z52scK57ZPv5rev2bXe+1PD7K8
         joKpQW6iFCMTf5lszk2iGeTSquuxpIvbLNn/Yz0IHMlbiiyeiyxE22nPWZ853cybbwue
         VtAuVSf010qbZiphpWS66QioJVMK7Bmnw4kiWLLbFU/Bj3tR4MbgvgteELqsFYY5ms/M
         mUKPeLcbUCLRAe5VADvAjYnsF8qj2/pTaNshiHpoLjjJRQmizfQto/IlAG0Xn4PjERkE
         I+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727452280; x=1728057080;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZXxprvEH1bwArWzkjF+rjwkpLdCy+DXaOT6jNfrQ7yE=;
        b=vZjG1ErpVV+ngmLrAqOxWZQ2KfV8HEon9Uh0J6s+PYQxkdsanNU2QCwsxpWzYkSW/Q
         G0zyATTGNssyCXs4mDJwFAcHZwBzPYzurJU+LxaSU5cN8s4Mttzoe1IL50ZJ3l4xFWzv
         g5cBlA09nTgcSi41hd6dvGL+2QEcvWaPesJ05sx6XdIYLE7o4fZNAFKl0wKvxpxjkK2D
         PxtODZq3jJBLU6yDvWpR8ksxkyv+MP7HlPZCwWJyUe8KreokHlarEOtmpBeAvr7Zm6s+
         WIDRFcboGPSUXs5coWscpedoAbel/mcxradKnCTh8wHE7xrHa8a/WiS3gBk5ZDTxNz6b
         RHjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBm6mly+G5fNrpwfYTzc/lUp0qgyQSy9+nzvI9TiKJS5kiyIhkKoPWthAjMeWyGhwVIM2NR3qT@lists.linux.dev
X-Gm-Message-State: AOJu0YwmibIbpncNd8gzyVd2jqhKvTylAhoXgWumSDwu5VXs92axHi3H
	8X5WOJh8iv9KTmXObFxsDrbreKAL4OCy8YOT0iv1Qou6d0RyRGgxpuqX4zLS4FRHz/8iwK7jUnN
	oArqapBxKH31ZbZRYuTSMbjLoMaE=
X-Google-Smtp-Source: AGHT+IEdoXUnMlm+gDhGJAihsIQSq0mbBB8QgrMsHJiuvXwZZCgfLgwidGkQsY+DqAWVR3rAnw4s3XHBjs7SALSDicY=
X-Received: by 2002:a05:6122:1689:b0:4f6:a85d:38b3 with SMTP id
 71dfb90a1353d-507818c51bdmr3033612e0c.13.1727452280556; Fri, 27 Sep 2024
 08:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121718.789211866@linuxfoundation.org>
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 27 Sep 2024 08:51:09 -0700
Message-ID: <CAOMdWS+W23H+fc_a0fz4cJcGdMF7gkLL4fo_BTewBX-+ey_9mg@mail.gmail.com>
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems.
No errors or regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
