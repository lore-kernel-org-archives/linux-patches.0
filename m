Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9761E27281E
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771004280; cv=none; b=ZFLi0NHhzsjWQB7mqB9FwUqQ5gDenvw0ie+p4RDPkSCYPsAHaPBSNYzqoF1HxSPP510dlVx5lJR+onyg6VCLdip+q1YivabGBDrM7Ztt5pUI1PKhZ9FvfM88rnXmNiqhKxU8tagU4zOhp3cSi/ryw6mq/jIDMt60av7HKMn1TKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771004280; c=relaxed/simple;
	bh=fxpZJY1R/RlEn1RD1v40JkIHBzytpC4+Tt3THW2KLk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUYXLnsSV560jp8r1CU4aqFLFKBrWMDL5DBPu9x15z262LG4rx0KBAGUG8InW9S2CpAmN/3uw6HBm0fNAEOiRmnkBcuT1mwQTCtk94gLf4xdZ4ZTiFTrow9xZh0/m8QvVemXQDExWZZwKg00QJmtP9vSjwPhMsihc75owaloE+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=A4uYbDjV; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="A4uYbDjV"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-124afd03fd1so1988541c88.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 09:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1771004279; x=1771609079; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60UOzH3bYxHjDmgksh0UlfnGbcvWJmcMj9ZhhGnbMCw=;
        b=A4uYbDjVjlJO9AFFecRVqxskZ+rFt3w/uq8755ao8NWwcX70AsPxakRzBsPX2sWfLn
         9njHRPls1nndKt1Hm8TVMQBLCOyQSGYRUuopfwlln8Cnpr5nmRWbyK5MVNe9FQDl9e0U
         xWnfAvL9FhThhYYPERogywpE/xBEEFHK1bNMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771004279; x=1771609079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=60UOzH3bYxHjDmgksh0UlfnGbcvWJmcMj9ZhhGnbMCw=;
        b=T8GDgfx2QH8p3WxDQjT8q2fAXGUfIdlJXx+jcivBc+4bGAtcWDbtlM0fWYP6bpcfb0
         t9jTyVmCcFTyh09rHyCj4p5htHFXX/qSeMe2ZgS6ujV/Hoe33eOJSZoiZxC9T9GpcosA
         MfMKoKrqy5FufWxBB6KDg7R/y8IqTNW7CZKcKZ7UlDX525qLZu4UrYSHu7E35p5yBFXX
         CBmZA9CMS3lh13VFiw960r+IaNwkR9o29xeXV41KWSIRnQiKe2kUDRzR8+jhxpJL1I37
         ABzGPdyuHhaliRtt7+1hs9W7PaSXBwHBZ/w0JzJBSTmpep+8H8lw1C5y/yakVIQ7L8Hp
         Nh/g==
X-Forwarded-Encrypted: i=1; AJvYcCWDOqAQcM5Bj/QuG6CI8kdlZsEY9N5HkmvbtLqZtzPBQtvst02iZ9N4ICZUTOVNJoX9IAlKtxIb@lists.linux.dev
X-Gm-Message-State: AOJu0Ywb+gA8aHHnINhOGdlU4jKnzPmMPT6jb0sQ8Ytev+IgDOrkKcLT
	QS8yU3CxiMdBoLWJ93UGqLsRSiRdoK8d8xaf10FtfB9lRk8weOg7IZ89k24PEaBX+Q==
X-Gm-Gg: AZuq6aKWEyA6vj3cZ3aoPBvRT6uTYiOYSIvQlaQPWtae5MpVbLB3W7OXKoADp7npQB3
	xh0/aWn1lGQbPYBC/fligLWjcQzSCMzP+zbPdROgvTsC4W+4kBk8UIbWRozVNC8mKSBle11o7eH
	GeTZs9DCAX8/je9PAbKwDGbyl8GHfPdvX/ZyX3KRwZVDojpTDsnjJ2tmisrvhTmXJh8/Z70YSwV
	W1cak10DBqU3m5m4BTUilFYcMTLiHT0Ul7aFioU74h4+MyBQk23lcZh7t81HVt/R0KIf/S5xByf
	Ec4gmo2Q+7/GWJyq/zYL10txeATKkHkjMN0VFNL4Rgu4XmMvebLfRtaxf4vav3l7PSSV6xHT8ds
	x9alzoThA2DHJFrxZPPxsuYmA+x87zm74gaezdHVa/ibg0sJC5dksa6M/mb5EM/atGjUvtE4dvi
	Vtqswno5sm1cdeSFl9yVAWBXw/KwPfDwaNgwlw7tmByEmc
X-Received: by 2002:a05:7022:618a:b0:119:e56b:91e6 with SMTP id a92af1059eb24-12741bb83aemr134625c88.23.1771004278771;
        Fri, 13 Feb 2026 09:37:58 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.125.148])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1273c38fd8fsm1705834c88.9.2026.02.13.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 09:37:58 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 13 Feb 2026 10:37:55 -0700
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
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Message-ID: <aY9hcz-Ly7wSLyj3@fedora64.linuxtx.org>
References: <20260213134708.713126210@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>

On Fri, Feb 13, 2026 at 02:47:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
