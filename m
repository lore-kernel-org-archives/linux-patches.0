Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8438E1B85E4
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 21:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727989608; cv=none; b=XVJY+kGgKWGVkhs/vNbXLeBND2d/a/3arAiy7EGPhS7fS3/8M8hjNx8YZ/HnQnR1v5R9TKoYyibuSt64YcF7BY+W+mXMdGcdR3HAXhsylXN6eo2iwbEyTU8C5rlE/45HnqEpaGW5woNtZ/YPwnEhBb90p+py74Wb606H/wjZjN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727989608; c=relaxed/simple;
	bh=ol/+aWm3RXmSOdAyVG0PXsSoMwIO2p63dptKg4Sh6J8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hjejYzfeKmCmjzDR3hqaM9k6yUZNBmdsg5ObAbcXbOq6kPz2LZdf+0MAWfbPUxtWdrbNBOc4gOc3Z8jkeLD6t9dpHuXf2N1ONLMegd2AiTse+lalfj4OSBFq/xSWOFvLnMcbvOPSM364bcBsbU+h1RpqE9jVl7QZMj/twbp1hoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhrliFUL; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhrliFUL"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5d5eec95a74so701515eaf.1
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 14:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727989606; x=1728594406; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q8968dxVOOGrCaJH4A89jcshoXoU0BkvZ+8XBq1T7h8=;
        b=HhrliFUL0aitXekzMP2doWTFmJMBRsJwQTq98pkRIgiU1XmrtjIy1O7Nt2bkfPxoR2
         9mJn/0cf6Pv7RaPniE66mfxAuMuW2tLgQN5ymEwg599tVkV06Ueh3KG1Vz8JP++/N8Bq
         /rkoVYvUwrIqLTMDEwRu11AcUFDrsM+1pt6AGNOOCdbyCr77Jyl0Wmtp0l1v4alqrqhZ
         JxLEQUADcV2czQ5bAwamnzFxbfb2AibyeY5fwcjabsZHhjDTdGICKN7mc/0HcZgcTOJh
         2AjKrCWZ1y6NvknPWRkhPXczPSbC0unCUwEgIwNsa7tw3rc+QWZna7jVdyLB9nhXEHB0
         J+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727989606; x=1728594406;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8968dxVOOGrCaJH4A89jcshoXoU0BkvZ+8XBq1T7h8=;
        b=n4GzUKOqeFhk6tJiWhQneRHYKIe8DTL43iOF3y7pL8SJFTjXs/GROSrcn45sbNzVuo
         YUdyOWcII42+/muc3T0vgySGs2IZ6WnSiFha5czAhow/WWiTI7h0wnC5kwjqxzJNFum+
         VaWbi5kD6HQXch6iJYHdEs1RWAe+0Rk3EQc7qYj761TJf5Bt6bioMnJnslCA69wrF/gT
         nX7dL9gH6Uyy9nuP3jh6lv8xOOBk7Y273ovBiklRXGiWo544CA6ey0hMyB+P113hCn9L
         V6hENBctAAMiJY9a53UAEVa5eRc+r6jK1dBYw8B8Oe5rePR8yw97ARhOp8tw1FqC2vPJ
         lyEA==
X-Forwarded-Encrypted: i=1; AJvYcCWBgmCsp5MSJLRFJsOLwRsgKAytUAk2rNsJR5dXUzJppwi3J/v0RvRRQS1CBrSAYbQgDghY2357@lists.linux.dev
X-Gm-Message-State: AOJu0YyhFOXKPX2hnm5Ipcq3yiJzsoIv5svLEDWSM6ORwkWTkt3ma+jv
	jeaQhZg1Lcd/CEdtAhPEODQmrhmd8h761l8FwZ1U9c5rGUkV5PaagPq7tgPcRbV9Q4jGDEU6cXo
	+jbORxNxCDIXoSFWvVf1SrgB/ZKk=
X-Google-Smtp-Source: AGHT+IF5sxcLBv45je3SkotpU5f9m7oZxQlxAwDwlb12VyV361hYsxVRbYWq3YL1qFjNZEqy6L4DLZFmSo04X7eUlHw=
X-Received: by 2002:a05:6871:813:b0:287:34a7:af9a with SMTP id
 586e51a60fabf-287c1daa2c5mr674457fac.12.1727989606522; Thu, 03 Oct 2024
 14:06:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org>
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 3 Oct 2024 14:06:35 -0700
Message-ID: <CAOMdWSJ0io4Nsgf5GTARYcbJpEAxTq+VEggiQBG7iwCT+rCb0w@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/695] 6.11.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.11.2 release.
> There are 695 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
