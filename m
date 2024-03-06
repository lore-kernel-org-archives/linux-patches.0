Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF155CDE2
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709752186; cv=none; b=N2HrlPsu11ZDipsCBzG/j/+eyeWxsQ01zIDbdtO7ij4NiUwdIqv5smuPS++7BXx8To9eywmu1CM5hzuBOiip2bIxLkxR48szVRkS+9GUSfZffl7NA1x9TATn6ldg9QYEGHmewKI20VlQgfrzOqgFOXBgPriwfmE6H4y6p2raisg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709752186; c=relaxed/simple;
	bh=4L8LHyQdH8SBj7ATuuU4Uw6f2FPEEYofQRuz+BIR/yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ClV3LZPdQmR2ezcW21W63dj9CiA99jVtchjc+a9ymQKIIkTQIzFvYzU6PsDXOviLsyhHtMs8MZNKfoDWLoc0bVxDQ4fhvZahXo1jD3ypkXytZDGUHlaBabvmLa60dbK2NB02svKlJTE45GG8OaUFXdOgmDIlcvEUSQtFOM4RIXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkxcHpa7; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkxcHpa7"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4d34144d710so63627e0c.1
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 11:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709752184; x=1710356984; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BvLOKtxiGQGjZaRF5g17w73aFUlyA0qVFVQbFcy6f+g=;
        b=JkxcHpa7vDI9VccOaC6GBFqC4oHHsDHsVYvMyYHENwKy2Bo57xFfEH/1Xv3onA/1P/
         QZBTScA7xeNh07utikNhfFLHgPl9T7k8nQ32vaULBE/1S2xXY3sYrOl7jN+6RZ9j8P6y
         AsgSNAsMne4X5zv6tzzXnP8FiP7Kn/jr1nQU2RY9bMReMtMWe9O/7LsPp7n+jw4WvlCo
         KLrfQ4/dRfLuAUt9f8GH9OWQTOMYueXUvrGfJZfEtD6eqAhyM0jo5TpFSejju2VIL/jn
         DGS0P2N6U/Mf7v6l5F/7PyyZUVeWSGPhwIKHwySRnAgDD56iPMU7PAw7i5F/4nk/Xrv3
         8s6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709752184; x=1710356984;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvLOKtxiGQGjZaRF5g17w73aFUlyA0qVFVQbFcy6f+g=;
        b=JoDGQYaWPBs+T2wzgDikj0xYFDAdEQVYE7m/OlJUBZdxiRXHDz3roLwILfWgQkgcUW
         OeeZZBF2h3wiBcl8xSRR0dZ+ejCKOQ9/8NygL0nSvBj6YxCfTsDrrrJTYlhd+01Ug35L
         fhMMPggWRWOuYiCQClS6LJ4Gwxyq+zpYcYngIQ5HrWk67xjBMerz/Cf5a3frKNKiZOzP
         PubycAtZhQqSsdhMwb9PWUnZ+ZEmJWJ2ONFM7K9tixBASsVOTlSTyRUgt9pCrgBxs7ie
         I6pRpV1FUMJga+cSZ/BcJEvP5RMKQOM13yzNUFWxRqZUzVv+X9fM0Vq3JSKQ51/lXzVj
         iO8g==
X-Forwarded-Encrypted: i=1; AJvYcCVCjQbH7nFbogBeJ6udQ3UglCHz8V5kLCkiGbzUkg5wl/F0yWuSeGTeuF52sgiwelTbB5td7zyeapqsDBrDu3bR9FxdQ27Stg==
X-Gm-Message-State: AOJu0YznOMIlrGH4xv9zVSDlOb6df1EbxIZfMGOZYmXu+06NZ9SeEcTY
	guZcOBhX9O5L+R3mBH922/GsQI2QG4BVLGANgtAoS4V2uQacWtWsk2TpR5pelpKHAW4T8ENj9s7
	H78N4KD4NU9eMajwi6itDKWwa59Y=
X-Google-Smtp-Source: AGHT+IEjwTFwDlSaSFYvKetNc8j6jOH06q9zwQAceNwgFjwl33dhCH2ajP3ql2biNWrFSKs/VZko3X0KPbl/qIhJ5/I=
X-Received: by 2002:a05:6122:1c82:b0:4c8:a2c6:c2be with SMTP id
 eu2-20020a0561221c8200b004c8a2c6c2bemr1659479vkb.8.1709752184153; Wed, 06 Mar
 2024 11:09:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305112824.448003471@linuxfoundation.org>
In-Reply-To: <20240305112824.448003471@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 6 Mar 2024 11:09:32 -0800
Message-ID: <CAOMdWSJT_zBETx2XoYOE3kCfo4VXYX=fqa1NrV3W0t9Kb5gFNg@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/161] 6.7.9-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Mar 2024 11:27:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.9-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
