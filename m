Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D784A27
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712064797; cv=none; b=g94Gm+WuKGzITRrUCWItZTk1puasFIzYvvUetYD8cqT9lIZ5vJDrziY/CqVKVC8HHigzrKOW3Ww3SWzvrWuzlqoXyExhnA3OQ+kLw7+BwF6OJKD3VqmpDMOp8OSWZ6AlYEkUZQgq9+EqmAYM7hyPbxvjFeX5tL9yPyxC72esH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712064797; c=relaxed/simple;
	bh=gRjg45/IctrQIu/6W6PlRyxAxtvj4BHh8gNS04jmN80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9u+YcRs/XtrbhLPaAV/Ht2xq6uOdMWkuojbQKM/V4ZCY6fSdnuqqqtw7DOhWwpq22qe3lJ98BCcF0OJo6yO71ssc7jEGdBxsErLYUtXNOudV6EUSUVxDbZC/XwcYLnnUOGWVbo5RPkC1lsdwX/PYSfYy/CXGYoXBfm/iFoWvuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=UfrlzhP6; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="UfrlzhP6"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-229b7ada9e8so2318665fac.0
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 06:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1712064794; x=1712669594; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAhsn8hkNoKhwwl/nXRKoYjZr1I0J1JHEwu/MNqQsKs=;
        b=UfrlzhP6UWmIQykwLShcHaTtK4hDzu+xNlcmsfD+1pCcGRNFiIN0TfaaRivggKqage
         h5D143mRwsdHulslJqe4Y/NpfJbQPcdv9wEsc/VQ59s8gxVJxoPde3jGK+5KbEeNzjdi
         s0P/0zgzmF+L9u5GGBpDnK5fxV15ek5Y89qWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712064794; x=1712669594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jAhsn8hkNoKhwwl/nXRKoYjZr1I0J1JHEwu/MNqQsKs=;
        b=PbO6XYEy2iQa2KPYwCgCDrXcZzrZCxccoVLvSxHml78utwJNWk8AQ6Dpyw1chgO2xZ
         S5HjX4EZBfhmW2G/VuGtfzzLD2jM0enrCyKXTkMH/HLH/TNVeM1IkyPYyLZZmkLDlKmf
         4WcaaSQWvA7zppttj079v0RrzZn2m74lMBOAM/BL0zyQtK25GquIqRmxFxvaGhC+VD+C
         1k/+63ESJmMIfEj/vt+AKYAMA9qr6T8UV0qP+8LtoCcOBuUZ59buyOJlTMSLE+MHwlKn
         ++eo3ZR/E1yvPpcCVsK5jqCmT0zhFzCf9mAMUp6Q3tRR1ESGZyep/JayNKAi9PWGAHZ2
         JBsA==
X-Forwarded-Encrypted: i=1; AJvYcCV0ZvwjPllYtXKq1PRkGo1nX6y/YITwtc87MCMKFHnKVKnUDmB15KVqD2Zo73hkTdiakcWRPEIXzJpF6bzVZOkOvDiPXSFcXg==
X-Gm-Message-State: AOJu0Yy4trXaBF1YFHfyehhsiv0wdu17dgj/6B4qsWzZZyoxcfR2GtFL
	jYZB/2pW7wuXM14hpGKDgWml6ost884lz/Lir5tJsMN+zFpQhjre3Y/V3SGKSg==
X-Google-Smtp-Source: AGHT+IEmdktlG/bLWeHAf98nPjODsS9Xnop/ympsC418g2OXevOGyMcq9kJz/Ps+yK4aVORa+/luiA==
X-Received: by 2002:a05:6871:7411:b0:22a:a11f:5513 with SMTP id nw17-20020a056871741100b0022aa11f5513mr14486738oac.48.1712064794554;
        Tue, 02 Apr 2024 06:33:14 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id qb9-20020a056871e78900b0022e89cf40edsm28077oac.57.2024.04.02.06.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 06:33:14 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 2 Apr 2024 08:33:12 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
Message-ID: <ZgwJGDNx7vQ0_CrB@fedora64.linuxtx.org>
References: <20240401152549.131030308@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>

On Mon, Apr 01, 2024 at 05:39:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
