Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3141A9F8C
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 04:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760848740; cv=none; b=SskqH+R6dmOt8DDOW+ufxwzaIy4O5eXgCem/ks86xEjQck6HzAHxxXMgABHCvlfZMm/0MaRf1frwspQaak4ahYKsopSCUsNRRyAp3oed1Nv/c4BUoDFdewJPoVoTgSC4YE2/etSNfNNa1+pY0JM9PidcEzNT/8SFd2F+kG/0z4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760848740; c=relaxed/simple;
	bh=0VL6UvbA1L9L3KYApi2HBxM5osAN5B72tXfZdkax4n8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJYlk8OulcUZLagE6ePtSta+UG1o2PzOrERkB3g9ZFHGTCO9joemYDoSoL3PZQ1FIV5yiqfIKKUNfQNtoiZJSlfsYBEOMLJww9M8+cFjk6RHG6oLAoEmU+tVbx5b5uKaDCGxgVqH4sUeqyaLHjNgmmbN03+4CPDAKeg5pE9hqtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W95uloig; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W95uloig"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-28a5b8b12a1so33647795ad.0
        for <patches@lists.linux.dev>; Sat, 18 Oct 2025 21:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760848738; x=1761453538; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pmK1mTi1aKqF882bTtKfCSZ/kTsVspf2lr8U06HUrwA=;
        b=W95uloig8VAnETT+1vsu/FurCoWZDVBKYJ/ysdx/311EmfEKRlvmJdZo9zseru/jnd
         b8dwd/oDN9PQvm/uScdhVpNtJoRYlYVdNhYtHBTZOVfhVcRDfLTJhQ8hT7nDpq5wpLUV
         IlxcV5+8urV9/QgfPCGhluB9Ruk0untrqkjVXTsLrGnJxLTmXxrSbl0nPMIpHQOjkTSU
         h8SB9pZTPWx1xvTD0os1HfVurGYPA3Zmuy8uVx/SFHOxn7BhkKGQLn8jGJ55TNcS/XHk
         pAImB1Rj5nrN8zvkr8NEtJE9h8jM9g5+7XrmvtM8Q4T839Qb5psQtPaq4A1XWls4t7eg
         HpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760848738; x=1761453538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmK1mTi1aKqF882bTtKfCSZ/kTsVspf2lr8U06HUrwA=;
        b=QhtOn2TQi7zYeryAa6oZCGdkXNotleIbJ3gNtO861r/ndLxcKCBoDrkb2RLvA/bU6B
         8zs3tnnoNgPkCtbdSu2D8FOs0kfyjho7+Ugwy/GtqJBYdctepXSYUGkE4/iFIjMeFshF
         +Mo+h73WFQAKsjsNVh3AU7rn/0plVoQw/2U23B6KjXz/kwHOnfMkcTTQNGZarmW0ILOQ
         l3A4XzcxDA/SzXiH8OKjPB8100WNQxmTLAImYsxOBUYXFyVQ/6QQCU0ux7STWmXhVbf1
         LjYvaVgj3zM8a1LGqkd77VGWdskOwdaM76Ae86IRWmAhj+nXVff/4CcvlJ+22+gv1JxG
         73Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXF3u6FTn/i0GRojlTR11PGi2EEc4+6Gvw/kf58n2dgm0oWuSjq1XuLYkCyh/LclYfDXco7ctS0@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8UnD6soENyPlweMxMzJkXz0wNiVuDWtITb3clC4UUeGm2jlk9
	6OWhu1cuCTNSjUJ3uu/pL2XDAE8dUhorned1pyq8FzvyQDiC/HikCZxl
X-Gm-Gg: ASbGncuYm3N3eZ1cSaC9yNyjYMuQrI7ZJnX+uht2qQFrTPLpAHg6iCF6QUyYyRnyUbP
	MA0/mbUqe7170RJUOc1BYt1i/DCevjsgNRb3VlArxJfSfjNQ7HlOyk8CX6PKf/fq7PjFx02w4Y/
	ANO8mlxWclHUxNMBb/I3cFXEY2fIAHUMmK7PKJeUZt/qNqsxXKAw+Otaew8MdyriiwPM3IGez3C
	18K+t/8/2/8LA5HQL/gjlWurj7dHJiP5PzBlwZJ33aiz/C+DH1fwSKoPgtDVIUfyKGH5cQa5RjH
	YdKDLycBjU6C7KwwmxTf94KrdO8ekMp+zI/l1s4fwbt4lsdpds1RNr1ivnPKxD9bYz24OD+zW45
	c3+tHxE71gQnIqJtfaooe7n4eTnIbNpOMHKGhdPU07uiWUEpQwrB8AW/NCqjAF4kXQSr+iFFRJK
	FusWAT3gMEHy0R
X-Google-Smtp-Source: AGHT+IHdS/E/u65fGvAAeZHq/8Z61TPZEPdEbbbaTroydHGnbRpgb6AV15wzVJl9z/JFGKzlDshZFA==
X-Received: by 2002:a17:903:19c3:b0:270:4aa8:2dcc with SMTP id d9443c01a7336-290c9d34dddmr114629115ad.19.1760848737742;
        Sat, 18 Oct 2025 21:38:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5874sm41615345ad.54.2025.10.18.21.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 21:38:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 18 Oct 2025 21:38:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	Yi Sun <yi.sun@intel.com>
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
Message-ID: <58d213af-f422-4b70-8821-9777fc1b7020@roeck-us.net>
References: <20250917123344.315037637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>

Hi,

On Wed, Sep 17, 2025 at 02:32:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
...
> 
> Yi Sun <yi.sun@intel.com>
>     dmaengine: idxd: Fix refcount underflow on module unload
> 

This misses a cleanup call to idxd_disable_sva() if device_user_pasid_enabled()
is true. This results in a warning backtrace seen when unloading and reloading
the idxd driver. Upstream does not have the problem because support for
IOMMU_DEV_FEAT_IOPF and with it the cleanup call was removed there.

This is just a notification. I'll send a patch fixing the problem later.

Guenter
