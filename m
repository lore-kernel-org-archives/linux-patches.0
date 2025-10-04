Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51923154BF5
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 02:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759545626; cv=none; b=q4KW0fcmGpsvmgMFPbqgKFLEc9vf13J9yfHmChd1vlCywO4e9nGkmZGKDJ1vz3TU28tOfwFN4T+cuixzS4VGAHoN/BIVgnqeKOO3pnwDun7bRYwxIo6dIOMK9as1TIsepL9Md4SMX/9pZ6MTcmAHoBulpySdfCBLPd0k3ERc/qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759545626; c=relaxed/simple;
	bh=WZHBqjpgenWM6lUWOGdfdtHCtjWENrrZy4ZRfETPkw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V12HSvQ0fq5GexqPh7cbitXmbGnS9vQ9GYg1IZtGiHTIclVrwnQ1Is9/od9zcrgGRn48gl3I8wbnRLMXC2BXXvEM71aCwRsssZYvfp02rlIlH+XRk19BTZl8bmfS/WdxPphStiUNu/HWWMGsUdw45MHnqzIxBYzOixzjQ/1jSCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=FsfbozRU; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="FsfbozRU"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-42f5f2d237dso11708275ab.1
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 19:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1759545623; x=1760150423; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lfGV84g55Fp70doV+YS/Migev0C/SPjmIXXRQJSXnGs=;
        b=FsfbozRUOE0YVW+3pQk6S17N5iaA9KqoyDDk6dUYcPFO+9OF6n1JjDCHir77Ot/SDI
         OAEKPlQgl+nH5lhRgf1CDC9zItmGvZZo2sM7uRepE3eXniYwIg4o2Q7hv9MaHAwCQDNF
         PyaUzEPKztRBExTkPxE0DdqYt8PucM9XDdBn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759545623; x=1760150423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lfGV84g55Fp70doV+YS/Migev0C/SPjmIXXRQJSXnGs=;
        b=PD7hYu01h7OjkYcK98Nijbi9y5fiI/M1+cxAO4Xi8x81SFEope0u4WYWHOPvmOHBmm
         oElorFxHkzuduv26fDCLMMUA3O5FFEJ4RGW8OPpdCUM2CD2YOdPEHDDzUvVueba2+MFj
         g5vi32QLV3OYSmYDt+nbbRtx2fB6w9d8VYuiTLXOHjK++YYubep39AxpBACStkHkDdv0
         s5HHEHysg4ViLDNxwGKgLbm3d94HQYzqZvMXRaUSbPtys2sfTs/iuaoXEMn2TjIkB4/S
         +bLUN1tpYx6m5EYm+iSoA812wbsRMd29Nddfu8Yu/oo6Aaz1xAexu/7/KxK1BQC1wzO6
         ozmw==
X-Forwarded-Encrypted: i=1; AJvYcCWMuapTOV78C2DnwOi40ImOHRdh949WGFkxbl7Md0Aaak+VPwiqjoCN+XOpZG4TxJ+d11aIkRsJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzDcciErVNNbxk800NNse2aQkIWty6bGBSBVcLVtBA+Z7gmNZyY
	20W3eJByJzDkNxZfmhiE7uSRE+hGYhE6zLboy9vYvCyx5y6daBrWUF6Fy6RaYgl1CQ==
X-Gm-Gg: ASbGnctK4VebLQT31Rvn4PGDsrct06aP6oq3ohBv7t0X4anFfLqA5lUptXr+c2mcW9S
	6C+aTczFFSVJn2B3smhsVuOBDQ/hrPCA9iG76y4T7nPG2/nWULNmyUS9toV0456X29fbIlNHRUY
	Fe1KhpgMntjfkUuQ3+sZl/vEW+Phiq28lRzsnjEJX5JQfJDUtLclixjhCP4YiP3mZZ3aA4ZUp+3
	FoGbQ7L2MwglaK43QYfVosnxdpOkmiN2s3yGClAWRGWS8W8b6KtGc/NG76lhGAmnEuSRPBj73w8
	VISukB75yRVCbW36eU6mpxzo/bxac4OtXHKXZlPoLjxoSfxuR33LK4X5T/N4m5awSxVzrEOIueo
	oYDfx0xdBwxzC66pQrNYIzJivgn4EMQKp+m/pZWKw9vnBcLqxwkc97mZ/qZh6g0sc1wa3N/SqcU
	2fM8Q=
X-Google-Smtp-Source: AGHT+IEioTJIMNzacqCo/UZFC5W1RrKFxPYXMBDo5m8Vs8tnZCDhSKd87QqfaWpv2/P8gUHneV9Gkw==
X-Received: by 2002:a05:6e02:3e91:b0:428:973:797d with SMTP id e9e14a558f8ab-42e7ad258f4mr72119735ab.9.1759545623294;
        Fri, 03 Oct 2025 19:40:23 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.126.122])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ec10511sm2458733173.63.2025.10.03.19.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 19:40:22 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 3 Oct 2025 20:40:20 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
Message-ID: <aOCJFN5CttsqZJ31@fedora64.linuxtx.org>
References: <20251003160352.713189598@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>

On Fri, Oct 03, 2025 at 06:05:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
