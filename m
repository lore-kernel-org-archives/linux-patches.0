Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687111E0E08
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742495496; cv=none; b=mKdddCtAjJGwf+x23zi0NbYFKXOS0AN4kMlj7D56tTjSFtVwiNxikeSeYnXKODqIWTyX2P88+PCsVyfnI+FNvtICu5ZMJIbx8wwBqbCKZmwyymBK/Xga8dsP4VptOvmk7dPX7dYqk1+vsPaZdHplS0iVGQVsWEXGIhdXQb2e58Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742495496; c=relaxed/simple;
	bh=KW7c5R9LPeRvdEkyrrPNb19Z7ay+Q1gA6RBTzjIj+9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxXkTIdiXTHxVbWRsDEji7yRjycTBbWSW+WDG6u5mwTxjpNBlVkhrDMifnF8AF45etmZ8IPKUEy9dDkXj6mwF5T5nJO02IwLtHxwQ/btIBf07e7QswkIbSECw3ppbU1AGLYVy+fF3kZUObWJ06K2qO/3bAQDJUnVXaZfaoueJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ew49KBYL; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ew49KBYL"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d439dc0548so3624895ab.3
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 11:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1742495493; x=1743100293; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xs9sWGtkq4Oqg7PObi/N0JVnImd5J4EMGp3yDmOQZM4=;
        b=ew49KBYLCZWACKIq/M0IJZl0DBfFx1/ABaL5Db4CQV8qYYNiREonZWK3TX6km1gtZW
         7I2xmSVFDol9Z4Sl8Gd1YTNnpyWUKYdn/BWFYypNWpKd6vd3r3QHgAe6Uiywe8uJbWir
         v43a60UgbIxjFdLAnMaNNvollnCCGB2f4ZO8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742495493; x=1743100293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xs9sWGtkq4Oqg7PObi/N0JVnImd5J4EMGp3yDmOQZM4=;
        b=JRVZI+1nljcpl2NU0iQiv1j+Lyc25s9MT4VaS8qRp5oB5kH3zaRByPe1cvhkjYVdLh
         Zzj/U0i80GXCTOTjFLYfJYBBeFfoqU1i7qZJRgYCQPuELaT1iMprhef3X484eI25DQPx
         9PcYHxlnZ0MVEnzApfoTnpp++dmM13K7DHLUAmTMjJtzau+zcb+Ostw7vYGGTIeH5nhD
         l4bZmAqC64xtmjSbCNRUUctILTR/frKG0z6V5apQhJWODw2poaHBrrfhZGj1HBHQUtBT
         IutnbN0iHl1mfCaeZBhgfWj9BEu6AZrq0u6TwzuXFoFh5YRPJOCLL3EQQjraPfVWdVwd
         otbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtjhN9Xy9r3eiV8kYIcX/7NnAdxe21+l+YKaU8bwnuYSQT24dRgUdD9qyykwR/R2eO3gn438uV@lists.linux.dev
X-Gm-Message-State: AOJu0YywFgvwvizOIym/DUdGGe+nI68BvjJqzK0fUP/v8hnPGEIQ6M22
	pOaoZRo9hHaZDCFxAZXE5Y+p1DGkzuo6gQdAeJ0pMEHRl32aYXRAGqsmJZxoPQ==
X-Gm-Gg: ASbGncsxxWtJvB2wuImbcj5oxabFLMScqiwifWHpI4H/gTPLkYdIuiZevs0a114mOrw
	8W8uh4QoBEu/iAETs3ovpjkXCLcF7Pek+dXXKwSzt5va48WdlWziOB7mAPNFrqGPpknljvM2cG3
	i+piow6ke5IvYAjV+7Hu1w9sv2YoezaPsvtI41V1B/KkKBqeQBv8iubWqwRFTvKxiVE2/ERU8Es
	Sp4r4dn/tbLkEIPMPg81IPk4BVIAq8lU9Yz1GK/GJQNx36Gp6gcSd6nZ6UZtDd/gQTcK23p/8Yq
	xjL2CK9LVZst33AOS1ceizM/umWQZ1ZPGf7WPEmEtvhvDTCyPjyLainR375WqA==
X-Google-Smtp-Source: AGHT+IH1B/ENspb1EAT9798Q5mHyvjf0wtm7TPVZ0us1pA6jy9nfdcYp5nR3VG+erfS7FWqlo6BnRQ==
X-Received: by 2002:a05:6e02:188b:b0:3d2:b0f1:f5bd with SMTP id e9e14a558f8ab-3d5960bf875mr5574885ab.3.1742495493404;
        Thu, 20 Mar 2025 11:31:33 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdd17f0sm45233173.45.2025.03.20.11.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 11:31:33 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 20 Mar 2025 12:31:31 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
Message-ID: <Z9xfA8UujBjRf5l0@fedora64.linuxtx.org>
References: <20250319143027.685727358@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>

On Wed, Mar 19, 2025 at 07:27:50AM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
