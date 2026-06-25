Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80DF2EC09F
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408628; cv=none; b=sY/zO44LvsSGSMcSMt1o/J3wYjzZY6iQehaqcaTCAvK7VPn0JrxBsfYO8Wl8aGpUdhQQnTQHSw+lzoNcONt9uw8SYTkQt4mqJU1NnNZPmKhupYdkqREUGfiGNEZNWNQB9Ei2chJBYS57lcj8OZ1RZ+vo2sYa0375pS0bdR1QPCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408628; c=relaxed/simple;
	bh=NoGkKodnObKXJR0Us6UBG/b/W7A24gDDiTNloh0Qkug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiM529lvs/byH2DhraVwB54K2rIEY4VfYYlJRcpKrmQZsG/jOdqH9W0oUcsdu10BekZHe+U6bV885nJFRffh0vdVF93NnmioGt4AKFDiohrVptfYqUEeN6erKmIsvkD3AO9Crip4ndREOq26kOlTRkS5e6tqzHgH/02TCK+9WLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=EMxutSX7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="EMxutSX7"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c7f1db3ad4so1641075ad.3
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 10:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1782408626; x=1783013426; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvlW1NLLHFTexM8JcQ2hd12AbG62cMkVNkCtboa04e8=;
        b=EMxutSX7aNWX25yX2UEhBxUBaKxscjoqcz7CDAZkCtNJIdfxbVubbqoVgNv1nYstVK
         tscPECBIEk/hVUIwDTIqF0exjGRfcmRfwpM+oXNtFVD5W/T48haPxb8+YCDOvgKQXiYs
         WvyAyHvV5PvV9bboB2na3eMgz2w7IP0kjmoRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782408626; x=1783013426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yvlW1NLLHFTexM8JcQ2hd12AbG62cMkVNkCtboa04e8=;
        b=fQqKhtWhPmvAzH5X0EYkv60vlsoI6eUcUmGyj46aFTVyof9FxsGky9t3G4CZxqOS+L
         tM2YFVFEPTumtpFg6yeuqixCBVHxlxLMl+vZMFFT62Aqy9h9h7TS/RllBw+UnxVSPkHE
         soHuYXUhP0O7M7ZRWE0W7CP1jc2eJIW0C1NtcehCYvFYMHE2pnirV72YLZBKR7rRQvPW
         eUolk0V49LsgP0choGBEZIUBp4Xe3w30WkAzYJ2qWJWSksRSSBVtnDWNhixIBzIGGlqT
         1M6qhqB14EEkj5SEC2VFaGcNl9iEJwi4dnohQxQCDtUTvEvkZ9/m7jvyTh4AIVIQ+W3w
         K+Ug==
X-Forwarded-Encrypted: i=1; AHgh+RqTNqDpkb8z2nHe5lpYJjtpFgP8ZdcXk8BHNGGwfQti8F6TiDyTN3685UqJaXSkfsZJwv49vKZP@lists.linux.dev
X-Gm-Message-State: AOJu0Yz82j4pFoifRz3Q7eoXFp6oFVomYML89lTnOKnCyESJyoQFNUrV
	pZgotaY4mxTAQcDYCW46e+k29Csxlz+DTZrw67JgWhc7uCjZF+LRA1KDAJ7Eyt8HgA==
X-Gm-Gg: AfdE7clETOCq6usaLAerCUe+8O39gdfjXdT0jD5pkaoBXLcHrFUOLAynxhUUKHR7+Gh
	FRaBxiR1n/8DXW1I57Yc19ekSwFXPh6jD48L6yNAIw45fDmNgAgn7w6W4KfB7Az3+o9Jnx65Fyh
	W+Do5sb3jK/3diaA4U+5w6fcMcyOYaP7t6SG+4klgkdR811qQNbsAnZijcYPHiFL/Dbgh9zG6b7
	9P/BH9kIpeRK6wOh6sA3vDNBj0CJn9vOlraILhFqGPsL31KS/YH+MRxH7/+UiX5iuZiwc6TjuWr
	/9mXmYDB+d5F03bO2R4kUiLEXPfgVeo59bG0k+ymX4F2rICGNyv/KC3Z4L3DNDtpLepU3s/Mg/Z
	2qnZwAmQj8LU1z12lOWSM9yDzbjaqrc/FbZZjVzPjRagNlN/2Fyc3SMo83N7QjPUhw3drCyN/2F
	K7d1TXP3VCVcNTUE+vwxR3yZD2wgAnfzligEcqxUmx
X-Received: by 2002:a17:902:ef50:b0:2c6:a2a2:13c4 with SMTP id d9443c01a7336-2c7fca716dcmr36835755ad.24.1782408625892;
        Thu, 25 Jun 2026 10:30:25 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5b0c1bbsm24633175ad.37.2026.06.25.10.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 10:30:25 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 25 Jun 2026 11:30:22 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <aj1lrqp9Atxv39j-@fedora64.linuxtx.org>
References: <20260625125613.243729608@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>

On Thu, Jun 25, 2026 at 02:03:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
