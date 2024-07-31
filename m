Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17E49627
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 20:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458255; cv=none; b=qo5WgAhJEQr5f/E8t9hkcpsQ6kxBzyOoehdWyztTon4KAiLyTpQuq9StOeSU5Vmkkb+9banscIoyq1A82P6Q5C4feGMUSbAOHBS6F2nlkRqKW3VThpG+7KW+EWkcVy02ObpW3c/c0ZXCUeXUiZKpzL7v2W2jyVgV5CubfkhRWD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458255; c=relaxed/simple;
	bh=nk2rtqkALrOEJI4zx8bHmEo90G8/Hu9hDFGoit3/tbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jRpUwIILfs99TyGIAn9dzYyvh+A2UXTJzw9lPgzRnBFyZGguw+cBsnUZ8MBqO3Q4JWdURn771KpJiCQeGSWGbxfhzcZJBwY7TkTLyV9B4Y3KeJn5n0G195CRzaW3cnR9XMeSfaDuuv0NMVdN20dle/SqHGw9vziZa+dyJ1N8cNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GxMmOlE/; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxMmOlE/"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4ef12e5658bso1900024e0c.2
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 13:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722458253; x=1723063053; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kOhDM8lQxiqkUUvDaagzUqGJjpM37eXS5rnNFdsUI48=;
        b=GxMmOlE/Pws81wAjlhOer3xtOH8iCenRxvwn1IEvrxTDYS3rvG6M0QIEMDEkVbgpj3
         ybwEx1/Ih0Oiu7MeOlzdvAJyLiptgOiXwGdAAa4fQNYUg3TbnMi61k2Ek2g6+vT+cbaN
         9ILfhLJjwzp+jhAvPDeRi56Y2aZLLqbWWBYOk0e8tVYGLnGdcsfNYC9P551BTdfHxgwi
         IMJNzmUo8WOOEMkltgOuD0oKxlyDkuOel04XYxmpGuTIi+Ockrws4JYXuEktG1PUl1i4
         +ZFZLJS3hysuUcH3QX3ioXzv1dcQA8/BL0MnUUkr14JA6huyGwRi5wy3ht7c65f1KDbP
         p1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722458253; x=1723063053;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kOhDM8lQxiqkUUvDaagzUqGJjpM37eXS5rnNFdsUI48=;
        b=jwGoh36UoTJPc21xtt6f/K+QolLH1ris18JaFfQYK+Rz7QtDGaAD9adBHqd2KApcsZ
         mbvGOtuYajrPR/hZ+v0vS+FploLsHg7eweYnrPsONQwcX4K/EyBM39ukfZSPdM6rfEET
         L2mhWdczQ186rvn1bTTm36HYJRgbPYi9pO2jV3v01MGSu/CXezKUFEU9aGFK+i2BotJW
         D9kQx1UhD+HhDhaQ9M9AiyOaAcd+8V5V4ZlbkCJcyJmvVRKGdK+6Rj8GHsMk4SvJbYiK
         5CIEL0uKBnrFwZNRxtgVKgzve76rKfV/R4f8AQbiE58c9k/lhRCnuHmN1KUBBkHjWr3+
         3RMw==
X-Forwarded-Encrypted: i=1; AJvYcCWq/2P0mSGDuj1k8kqWTO+4tbMVtOUfJAB0XFd3CjFscxp3EJRWOVjCA4H87SPAXsJNJ6d7dHHTP0bW9BXxqKD36f2QlzC3iw==
X-Gm-Message-State: AOJu0YwL7yK4wZXIEomYFihEjZsJo2+8g9Uym7CXO3nCDjAr99TfXAtU
	iwbjHYY89ayR3jzF1b+fKJxTpyVD/2CgI6xpCRjZOlRUGsiRfxhI7ZMJesHNj61NWuVelNWJYKy
	cm4AtS9lPbKs0DDLmmN/IRL27RR0=
X-Google-Smtp-Source: AGHT+IGCtBkZqYwESM19mphPCC1KETf+G6XCOtzGQJrvZIQ7BScn7bT6T4xToOaNhXCTMK5k8/U4M8JbJXfbi95YdxM=
X-Received: by 2002:a05:6102:5493:b0:48f:3bcf:58a5 with SMTP id
 ada2fe7eead31-4945099bbafmr568249137.19.1722458252937; Wed, 31 Jul 2024
 13:37:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731095022.970699670@linuxfoundation.org>
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 31 Jul 2024 13:37:21 -0700
Message-ID: <CAOMdWS+tfMZ=aVjChQJ8n-ih_6_DmjY-xGPY2XOq783BuTmE9A@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
