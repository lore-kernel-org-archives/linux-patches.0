Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B7F625
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 00:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732233908; cv=none; b=Nv1BDd6Ds0MOFmNxreEzpwazO5f4zzaaeWSAl4RRZ3f/LZUqhKdM6BXaOvkcUX8d1P36J17fJn+ErPU9Hndgxge3q8V5iuYjsy7682LrfSidH/p63Uu4jbGU0pR3vSx61EVssemB7MVf+Jm6CGxjLKVs6LXp7kz1GKmpO36r6HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732233908; c=relaxed/simple;
	bh=b8zZutAt+QIFWYnPwEoeJWUZ90wviQXtYZBmgBcpsM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q355Tzcv6d1t/dOPmLX/1utrYDGmvGJe2qky9+d6maqLnVWZf3csdPJ+CLNAzCoH9fLFs6TFuMYlTHWzPfHSeVw0ZT/PQ1HPe70y4PXzGsog01sGBdUFP6E9im6bQk78BT4CIuRxg4kto591vMsP5X2uhvBQgMonV3PQQXTdu+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=cGgMc9xK; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="cGgMc9xK"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a77c066a15so5401185ab.3
        for <patches@lists.linux.dev>; Thu, 21 Nov 2024 16:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1732233905; x=1732838705; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pNfmZ8kLGk3Aq5GrsdbwcV0OpfxOVZ8lGDQ7ouTp+RM=;
        b=cGgMc9xK5SM7IRek94M/YkKvM+tjnsgcN/vnFDjKbg09kYuyKsV+P3C5nEx0+YMZpK
         uETNH7gAvS8NkyBhwiR6x2RqKed/fYk30IZR4pG04TnxcAxMqRZtanoigNtJcP0wMqOA
         2pq1S8ErpIWQVMQaPGU/7MS/yxnl6GjJczg10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732233905; x=1732838705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNfmZ8kLGk3Aq5GrsdbwcV0OpfxOVZ8lGDQ7ouTp+RM=;
        b=oeaR2C5f6VVbWJMCT1VXG8LwjVXkwT1Qya5x/JoDmYHoqtAR7IAPjm+I/fywfm67jf
         sxbHyZGpmH4sh6bo4Db33wDzrw4Sj7cfZORKTflx4wIQ8oNYLrMFd4NlSrSX4mG1EvIn
         YsrEloSgOsv/tIPMepv2zZius7rFiKPC29TRmTsjxnh6+FLw4O10f5mqNK3aBwL/ptj1
         zkzAxneS5vMvDMDaMFqxSAkPx6ro096en4uJTgs2cOD3mYAPxI6LEUr7HTtf3hnN/3v3
         vhJD2wUyYkDQ60IgztPBM8fOeFHqfzHrXW8GorGd6pVIgNStoVWWTBOOVml32aHqIvqd
         XQCg==
X-Forwarded-Encrypted: i=1; AJvYcCWq034oEViskurHEh6Neg6+ETWI4CcUthJv4WpzXiX3rJPM42cnYtDAbIup9/SkWKr7fELpcZrL@lists.linux.dev
X-Gm-Message-State: AOJu0YztTr5o7cj1LCdz1w8QwKBlVtvBxXsmV6wcAXtxtvCoUybTKLCY
	arCS6b6mYwwO7okHaN+T3++dVsEOahvTtfTNI2iw46wDRGRwj9xZib2SQY8HPg==
X-Gm-Gg: ASbGncvLmuJi1iANNrx4a1jYj3JTkck4Xplus95jgvYzKmEnx17enenKHq0Fdq6eTvv
	wvPGljXD1v3zc4CW+d+mGt3o7biciRkVZJlYzeufUnCPKBgPnd6TlhewuRU7MmbmTxW/ftUCsvX
	eiPHdscH+Y5Q8hDUgQe6XeXN3gHq2szWS8gnUiElqitLS6gZh98SwZinAEqsSpwpvPtA6r9W/Wb
	uiLkpjp/zOYkSf83ECAWVU8tYdcsCOAHSKnQPt7IKj7B2OsN6jdbxYHsgaOr8g1Psk=
X-Google-Smtp-Source: AGHT+IHBJJmVoqdEV852lyYDSdtvwnErbqQGnpMTbpDUvDdyHZu4U830e97nzCavsnPBEQLf8xCSqg==
X-Received: by 2002:a05:6e02:1a42:b0:3a7:6636:eb3b with SMTP id e9e14a558f8ab-3a79af75f91mr8552595ab.17.1732233905230;
        Thu, 21 Nov 2024 16:05:05 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a79ab86c6bsm2352495ab.16.2024.11.21.16.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 16:05:04 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 21 Nov 2024 17:05:02 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
Message-ID: <Zz_KrlE59xV3BV8I@fedora64.linuxtx.org>
References: <20241120125629.681745345@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>

On Wed, Nov 20, 2024 at 01:55:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
