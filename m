Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0F71B86C7
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726083123; cv=none; b=G96dBbUzIVChNqGGM5KFZnbCEJj154bcRzmhHGfjqH+vGqeJWptiWSl6vC1IRHyPuNG+QWQldB0/Si/UpTwSZ7KlPJoGdSPIo/w43QuRBcK5lPYjHwVMPTeu/xxtVK9DBVKc0A5CBjl4L/9h0ubLktbmja4QPNYlWvN6z/TvKiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726083123; c=relaxed/simple;
	bh=07yVX+a5HKymQT/kEVbwRWOHz7xK4lZuHdWBrjAUKc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRWdA7f7XfU6MyayiDCVEmr/jNxJWJQeQcBF4EZPxLvNjy9ofkPb8dK7ilW+M9NeqAwy7n49E7TULc5AXVNxp4uDJLIBWwDEbUM1LBz3IoIZ9sCy4Mfuu1MSeyf0WejkWdAkNf9C0IucPqlBMtCsKqXD3cZj3hzT723lnmJB7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=VaswZdLV; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="VaswZdLV"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-82aef2c1e5fso6548239f.1
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 12:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1726083121; x=1726687921; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gtmb2W0kiaRq3w+FhsyuW0F/eW+GNWteDIgqlZPPh+o=;
        b=VaswZdLVhU+/R0OuL/lki88C1o6vURvD++8elJ+3dc+SsBongqCemjLI7+wukW8psP
         a4d6mm/TBwro+Ov5tgP3Msv1NhDcDzjwz3XcXGuAIYg4p7MjPSYHi7/jmqJS/I02oXjl
         0RXBcBHRfJfSeGpe5Lq5OwtYeOq0T4Bo+3npI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726083121; x=1726687921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gtmb2W0kiaRq3w+FhsyuW0F/eW+GNWteDIgqlZPPh+o=;
        b=Q0clYVYZ5Cl5NIY3ZCEox9NpkVyOqlz0YCWIx29w0iInnqU1jHUbAYlBmGmpHFzM/Q
         RayGpfXZAvTWqJ8zLpNcFypW1bkt0RmBNRrjqMGhyIZUaJC9i0W+jHbYxTetrx6GI1qj
         zgao2ECLpbGIyEnxyKLLaFTVs9LOCcTgP7h4ZSNzNW8w21+wL7Tp8gvsho1VyxwUKK3T
         mNs6RgMNk0ZEIWtQPR/2b4AxxvpYstPF+OVOuRhFWh+abNuhnPHwA6oqRaNH34FMYWdi
         PiwU3S+j0aphVxjw8KFXSZIVlUuTLFiMTLtaFmh94HAx92KTrIweqrisN2llp2uyq8JT
         J2EQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDgc4968Vls6MMqxeGn5pcHwpCP8z+90UeN9KtesFOoZ4bt6q0Q9ZOUtxRxTvUgyHfvGja9Drt@lists.linux.dev
X-Gm-Message-State: AOJu0YwVF3XNQXPhw/+icG40mXgLGi2s4i5oLS3ulXJYMbUEU+piUYo5
	hGiX768djk/uEB7aBQstBzMK1ABBdmrzLt/Z24216mZ9ysfpLJO4jCY3XUr5Xg==
X-Google-Smtp-Source: AGHT+IH61wJeAaDsZVI0UulLG1dxqR8dVtT/hu5F4TWg8gxDaOsHx00AEczVpQO1l7iNb6Sv8R042Q==
X-Received: by 2002:a05:6602:6c14:b0:82a:34da:72f7 with SMTP id ca18e2360f4ac-82d1fa93764mr101635039f.16.1726083120696;
        Wed, 11 Sep 2024 12:32:00 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f433dc4sm159871173.25.2024.09.11.12.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 12:32:00 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 11 Sep 2024 13:31:58 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
Message-ID: <ZuHwLtRJkij6oz15@fedora64.linuxtx.org>
References: <20240910092622.245959861@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>

On Tue, Sep 10, 2024 at 11:26:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
