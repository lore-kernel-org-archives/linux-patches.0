Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8838312B17C
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 20:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728417639; cv=none; b=BNmE1Uo4D21MClQfR+V8yrpYTmoHwmNyor1OaauuaN58kwocEEQp0IYRyQhlZwtY4OtsPeGRkLMHUQRCLaWp8d4zuY3z23zowReIHANq8hNjzq+u+M11OwGt++/Bf+MENUzB8CPB5EmqcDXWpAyB2AZcHJLxSSWK+N9U98r5SQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728417639; c=relaxed/simple;
	bh=L4TMzRNQpVPOWbZCOE7cE5N/YZQtaIt1D0aQ1CVJWFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=py1LHRtlspYDLh0LPq1rKPhV3tB9HHtSgjflrriN3WSveUSWQUNt/Z04aOihg5XCYkSjrZPLZhJF4WUALw3wNDU+9KgmnSMRHBA3GJg9jfkNLJSQWlfdQDwYxy/mxwfe6UBBGlzkzsJIzCdPHmtBQGnICCTwx6DygZCFirUvDtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Ajd0TtYK; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Ajd0TtYK"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a1a7c0f612so32841295ab.3
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1728417635; x=1729022435; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4O2hLyv8Z5OXOMWkMIh4iHKBtJhUPpKJ2CwbLJFGltQ=;
        b=Ajd0TtYKQj6djugHu2m4G5g7DQfyRRRuhttEv9gqQAVHxOzkjdlQpga+biiStUWX2Q
         8xAit4iQAQEmaoS5GC2+l7zY7DDorjWkqQR7cS8mV2oUOIN5IKFLGAopzZsbmVrENjCr
         ntmvzwtsov/62gx/ckx7AZt+R/OEkdccMe6K0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728417635; x=1729022435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4O2hLyv8Z5OXOMWkMIh4iHKBtJhUPpKJ2CwbLJFGltQ=;
        b=jZUTd2YpRYj+XgN7TAGmv3ghBSoVTJ6caSXia+qyR8bUpl5e/T4pSq3CuBj1I1qXXp
         fDn0cLYZXXzwQUSJPydCgGS7EMY8XObFzme44AraZv8HGlIlKY6ilXTBzdn9h3nqg2y6
         stPxPKOj/9UCjl7riSKGdGNQsQ4I9BXec64Uo5ZBKx5sLDBh7oHYfF+d9n16Tgt0VNPv
         aZuq5G4jCRJmqnIsVUm586xshvG/wtlMhM23g4YbwvVFZC82vz3wSiY7gbLC6NHy95ri
         uxNxgvr6b/0lUBqW5CzMOl53CfLeUVVjJS6IclTwg0YGKwTds4npFivqaJmZlwc9BVhh
         oTbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm7LT3rVEgmHR1dQbaFGTEMNEsjpba/g77fOhp/YzvnuUOo9Q0dmp52uqxb+kBPseN9RjPcp6d@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp1KUTqNlX6ajS583N6rxdtQLFKcCyR98iBvjgOmvKsWskDl4m
	6+Xyt36FEPcxGGuSNVPJYG9KVMgoA+rBXvKIm5HwaRrm/vPIlHi2aKYOGrZKeQ==
X-Google-Smtp-Source: AGHT+IFXaXVZPUVw+PPNy6YxHhk8v1B842a1sIITVbdjK1U0Q3vtvjyULqujLR8b8ghr7BdgMAXAFw==
X-Received: by 2002:a05:6e02:1749:b0:3a2:aed1:1285 with SMTP id e9e14a558f8ab-3a397b9104amr950425ab.0.1728417635219;
        Tue, 08 Oct 2024 13:00:35 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a37a7e790bsm20079775ab.10.2024.10.08.13.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 13:00:34 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 8 Oct 2024 14:00:33 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
Message-ID: <ZwWPYdVuMOQj5iw5@fedora64.linuxtx.org>
References: <20241008115702.214071228@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>

On Tue, Oct 08, 2024 at 02:00:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
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
