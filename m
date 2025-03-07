Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757D21C184
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741360523; cv=none; b=M7QNy1K42mBn7OI0NXjm3OcGUQjg5VVosxHVqw7MoL3bYD72L/MfhHr84i7qDo1/ckL2wEnbJv0iuyHkrR/FkadrYxCgbgR1NqpwFgaFC/ONkSHq0n5Fm8Heb8KLXPTve9yGnQuZWmIxdcjQbZ5QlIwKVTlQTs3MmnGbad6UvOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741360523; c=relaxed/simple;
	bh=Jyg0BlNEVONMN3/qpK5whDdVuZ36nVAtfOMd2YynnAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghDMTs7ATMBQUbShjlZuy3XjCayR60nxjuIqIoXxmBLOGeiGFtesdd/7mL/9ONHCuXzXw8vdDq0+oyc539/RixUotiuKqRtPIWAhExtL5UBHCx0kQUwgWyRUFpVcXaeU5V5rHMmVlNBrYol9mYWZlMFK37bq096anps4gvdamwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=XqzzleoS; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="XqzzleoS"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-855fc51bdfcso96583539f.0
        for <patches@lists.linux.dev>; Fri, 07 Mar 2025 07:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1741360520; x=1741965320; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNhnQrGFa2eZSGaA05d8tH8yb8bigPtWKz7iWwlz8ks=;
        b=XqzzleoSucYF4RE06Tdd8cMIYg5Xx917IWI25p13IuwMvcsZgrnJ6FyEdwdKxZFGwg
         GFPpcWFneDcreWbAYq1O08sqH+wUteXFepfl5xKaxU8K0EjnjlT21EfK1O241O9Q3FxX
         J3hHEk5ZJQ2r+yDVHii1fU0eTbjwsyUbfvbmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741360520; x=1741965320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FNhnQrGFa2eZSGaA05d8tH8yb8bigPtWKz7iWwlz8ks=;
        b=tegQHjKp0nN/PS4MWsMWOJglEwNThvGvvmwO2veoX5mzsBfrU7zsHTjGeRYDXUye/7
         XPuk8FP3EpJhAC0hNE3cDBRdnEpF+jrmVC+fthExuV1ieoGLNPrtpMc5N2kGJiLyf1rF
         E0aK4kwLvSZv8jSPPLVxGY5O4nvtnqA+fPuLTmrFy+O0ezvuRcTKnDAcq+Aw4Mja1zgU
         00+50tdVCh48SJrL578xKAiEh8oTbWxyTG0R4Byd6lZ1HIUtaFAy4Rxuv404zWjmXHjv
         tXpyUThcTYotx3dxnNCmdsBeQLzK0eGcnuFGv1PqQoC7+Y1ps1XWnijOMQu88LLxAi1M
         y7EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh3dkl5yoHKORKTAWK8UTQRq0IFsVcHMpu4sCCh86JqSTSeFM/OQMPwZEcWyZawX+uYwa1nNu6@lists.linux.dev
X-Gm-Message-State: AOJu0YwLsiGgh3MpobzIPNWuvk0xa+kSj7ACRRfW5H0jc2RnSzr2K63z
	mT+b4QlSEwNjWizPtIBfp0tY+iqtIlhncAjhNeuzgIXmiAsTwrsf8U+BiTt3jA==
X-Gm-Gg: ASbGncuoh6qHFTWAvoR8Hg4IQihI6Ibhukl+O4GJ3BdZHFT5FmUZSEkskdmHUMFNR8I
	RU14WCn2BRPQE15rVbm0Rmbs9hsBtPmQZATVTRoM65p1HvKBLffjYtpD3QfDaoj6Eq2VqmJucrc
	ajETVGhypEqRGJdFeUoX8VU1Q4EwVB2pnFcERODzg6g8axhqmmIJ/VQkBt41ZHKOSPXYNQdNDlz
	UwCyZpcYZeFaL1LHrqV9rjd5R17/XYjb+ZbfGgIfLo/RKI8jZm7bmH0ZZ0aoXMKOgtvAGp7tDJl
	DaavnmH9Ylvlz5iTz9oig4L5AK9UuUmQnSMB7FtaXul6j5OzoyzDHUwlIgUPCQ==
X-Google-Smtp-Source: AGHT+IGJMJxSyE4UNVIY3LX2S7nhf3Y5lt2eLGH38VXXHHpoq/52h36JCsBDp/RY5WFAtMDkWXBzow==
X-Received: by 2002:a05:6e02:1a84:b0:3d3:f72c:8fd8 with SMTP id e9e14a558f8ab-3d4419b2bb9mr42285385ab.6.1741360519989;
        Fri, 07 Mar 2025 07:15:19 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43b599080sm8399705ab.60.2025.03.07.07.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:15:19 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 7 Mar 2025 08:15:17 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
Message-ID: <Z8sNhU27IirlaPn3@fedora64.linuxtx.org>
References: <20250306151416.469067667@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>

On Thu, Mar 06, 2025 at 04:21:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
