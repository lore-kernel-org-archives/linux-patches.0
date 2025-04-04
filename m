Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1FA20C00F
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 21:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743802722; cv=none; b=sqizomBnLRtiAkuUblUu2VMEn1WZXcbaNZX0CSv2iWjo0rdoFKzi++P+iv1yB3Elx/RtyH/uxv9LIozpZnYPt/UTnNQ7TkTmNX0PU8GGdoygbOUXXUiD4iXF9OdLu1OuCNQy4OxOmRRyC28cHJc9l9y/m0du1LNh576KBjJQWfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743802722; c=relaxed/simple;
	bh=oeXi/OWda2xxmVGM4W74nFEsM/hWSjUkr3LPxXiu/Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qxcve9vvSDhxd7DPmYZzeO6382srDCUcmkZKEQDnp+66WCCzJDxXenQBlXx+Fyo+y2lP+kU9tP4Luv4NV+Cv7sZ4KrbHPURwamQIGXq6h8X4tFGoVxsn0PCe7mQbzb08/vQqpPk7VImbS7zeraqdaWWsN9r1oC0yO4gM0gIcUIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=OQek1tdf; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="OQek1tdf"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85b3f92c8f8so220719439f.1
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 14:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1743802719; x=1744407519; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0MvC/cEhqDtGi3cYQt3IC4fUmaaxTciOdN9PYiIFKME=;
        b=OQek1tdf9sHmUzfJWTQDcJDDwuW1zTcvCcN2MWyVuuSsaLrRM2AmoaSWJLjWjiAoN/
         sVpevcA9jTtLBZhIPTxzA1o0PNa8KP9+wzcGoUJQLkwAxQQMrnokdmjlvFHWGV2NzzVw
         iEzhCi8ZGope8Wlk9ZbRb0lBKFwv0JJryj/r8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743802719; x=1744407519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MvC/cEhqDtGi3cYQt3IC4fUmaaxTciOdN9PYiIFKME=;
        b=ZD3DfGN8efE03fCcSMpPglnfAQnl+RoPQ0UEnE90MQRFRaVRS1yI2D58sf5e94geCf
         hwYTd+Z2jPGGV/tbbQBj9pBDDlTTn/6/v6dBK1/0W3jFxtSgvOrOUTnm0hDhxVXk1ZgP
         LiWFKRF9K6PzKHjHNu1bIKexhLMNoPpyxUOOIyeGGxlz7NIj7BjFAEQ1epWIXKqH6/zy
         RcbX27MHWh/3QIUllzC2dZujxM72ZZ54hfAkun8qCYaw8MfJXHlkyPmfyBcbQAXsLomE
         Em+nRbWUnrp8i9rVnzSx//d3GjmNs4yr4Q54hXzuUi/93gTlt36txNyBh3yc4QUf2zx4
         YQcw==
X-Forwarded-Encrypted: i=1; AJvYcCXhusOTAr/qfhh2ZkE3gW4KIgg59uzkF9kEnXoeeMn/eq9laZGIEkjW3HMfkLb4AOXL9HCSLKRg@lists.linux.dev
X-Gm-Message-State: AOJu0YyVEKePOhBaJclYa+7PnPHQ0M4khsFWThUJxxk7Bgp1rdjKW+iT
	EQB2WLNzYgdiUPv+oKT8GZEHjosYC6LT7em413Yly3CMKEhM8ftjaXg6tsdq8Q==
X-Gm-Gg: ASbGncsHhmcQyxO0StcfvQrAbkC1E9NNfjzpQRVHlVKWijz8n6PJ/YeZCNRUkq8omab
	6JTo0h0UV6hL+Kwf4l1g2gWyS7LPucc5oCwizZfmjFiROo31Jc6WPRV6v23SF8HMwODgdeuTE8h
	MVq1/rnOasrgdqT6W1Cw2jYyU/CJ+tsRyG4I/Su5Tv4N7Jwulc5hdZ1nYM0frScEZ3/IUBK2ojt
	ki0FfwW27slK5EXELKhqUzeiRCV//MSPr4/p+DcU+rca5UkSHvvCMr7AZbKg7seoxtAsURL4+95
	AQ+suLC4G88x4FNHgDIU+rZPxBS0s3Q22Kc4sDY81Z3Uz3MBue7flTgzy+esDA==
X-Google-Smtp-Source: AGHT+IGB/Y1HSkOpJ2q0nvYfvc7mtN57agU2hn090g/NK0jiNIWgsZVZqVAQkC06/3IHoq7MmS2hCA==
X-Received: by 2002:a05:6e02:3389:b0:3d3:d4f0:271d with SMTP id e9e14a558f8ab-3d6ec5446bamr13709135ab.12.1743802719037;
        Fri, 04 Apr 2025 14:38:39 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de7b8828sm9984355ab.18.2025.04.04.14.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 14:38:38 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 4 Apr 2025 15:38:36 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
Message-ID: <Z_BRXGxg6McB2M_c@fedora64.linuxtx.org>
References: <20250403151621.130541515@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>

On Thu, Apr 03, 2025 at 04:20:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
