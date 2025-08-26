Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBCB29DB88
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230182; cv=none; b=Q7Qtsvvxs3Co9SsxHZRYMAQDWeDGCNXZOj7SESS1FC00CNA8YGg07bGsZkHl2Y8V7Uu3/h12gD+kFb6jgx37nbPvvFqf3cFoNyF7YGF6Fs7nnTSVhof+MkGzEq0+MRNSm7Yxy/fj1Qq8UKyRRt8o7H2eTFAsPr60+r8ZIjxlNRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230182; c=relaxed/simple;
	bh=H2SMMWzVR4ZSZ9dW6KgvJlYxCMpDZKFqGFifKD4HpUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1EYyfzA1/sfp2Ae59c3tEC3zN+lTEvq230V7CRw2hK1MFYgfcLszf37VFHKoUP7/ZuWvvCVc3fRt3A0DdidUc1ejSKmqmtV6cstMfJwgs9PwpcNYR06GQdEHRqNcwrcIYuBofHSqvuH4Xbk6zXwfkBTOOlM4fIw/rFH5Nzukqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=GBCqfFbs; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="GBCqfFbs"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ec4802d43bso29072385ab.0
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1756230180; x=1756834980; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLat70Fn2scFAgQOgRNY0XwY85hhzAqNB6rfyJS0Gig=;
        b=GBCqfFbsR7JzpIsBekDLr6bQ3mJ6MxsKDYXbn6Ar5iTDkMa0xibLRB40/g/yc5cYWI
         S3VmNsBRuKg2E+s7wqxQ1ZCBtz/X6qhwbSURUA5cefAuFs36ADe9ZTzxPB6ILztckvTk
         eqn/CBsLA1A9eOZECfirKg+pP+Cw9jHZhWx0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756230180; x=1756834980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kLat70Fn2scFAgQOgRNY0XwY85hhzAqNB6rfyJS0Gig=;
        b=ddw2NEX6y74DqBwesjEk8hiLqYlrM+0z0Lru03Q0EDJS4BL2sjtWCRAayKjXdcKQeh
         us8zJCRInuO8oVp1hC5dGyCBPHqLTeCuHqUqGMxCBJyNRoLxJeRXgoi5EyXOWlNE67P5
         rMWo8l5abfHC7ixy5xIIbrtGNM68EUbR9tHnULlSJ7hY1Z33JW49/3MEPfYWiDIojpFT
         ixHsWNzl90/DM6tPU+FUtflDLNh4W4DqLQGApHfPsnPotwjUJwvWZQ4Hs/xuPN5EAqiy
         /IUB9IUZXWh6eICaBa+jfgi/GV+I/zaQeiK98DcbS1MUCBSGRQNQfJts8gFoAp3oMcvG
         6S0w==
X-Forwarded-Encrypted: i=1; AJvYcCVKYESMLRjl5J8Yg0iPUhVOSKopLyqbsGznuF9MpLFGErgN6CxfAo1Dre6Rml9YTvQ0LD7aH+oY@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0cgW8KZw/WuPmnLUJ2ZXChYF3gajV09jqT5ZJfZvFwt9TmuX4
	iA8WyHaH8hZn2QiynPNKDDauHuD1HS8vR19dTOikiECX9TKWMPOuMIgm5/o0y8HN3GRbKoOwnKK
	Gxk0g4nmm
X-Gm-Gg: ASbGncsfkaz9FBNyMR/KMI7yLq8L7Nvc2JvPUCKJFjdd/AFSxkcyHIDHMQSsoOob9nt
	5MrMH6uvTn6BQzrOKN96I2ioXBTdOzR0akujki33fUa2F7TM+FJrCczJ58A2ekDEhlccHz6WLka
	ag8Gxc0kmou9PAuxfckObsEuHEOWh1VxJkC3/YVDwSsq7PacLy31bdW4CaSY1qVbG+NcwOI5juW
	KM7e7P2L0/e++KGSTlt0Bf4x0nPQ04Q9FKoBOJQrZTWY5N+WxDXfjzX5nn4GX79EI1BRTfw2Vn4
	CYNFl5i32eDZqmS9CXu5jlsfYmZnNgRGnVBRl/PMJp7zCWpgNv61JuVhru8s3NpvbEZd+YvQpLq
	WuVcQWKECFSci/+V6tVpUKJowj7SWj3a2yCzDop7IdR7E21vsUVs=
X-Google-Smtp-Source: AGHT+IGEEt7ahjFtIRMy5uVKD3Gn8h5UtYr5/nf1Yq+VfL0Dk6Esf1pzUs2E0NY4xIrFkvNZj1AETA==
X-Received: by 2002:a05:6e02:3309:b0:3eb:1211:8738 with SMTP id e9e14a558f8ab-3eb121187c5mr137483505ab.21.1756230180022;
        Tue, 26 Aug 2025 10:43:00 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8ef4c42sm701382539f.4.2025.08.26.10.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 10:42:59 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 26 Aug 2025 11:42:57 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
Message-ID: <aK3yITcoPubsEhPR@fedora64.linuxtx.org>
References: <20250826110937.289866482@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>

On Tue, Aug 26, 2025 at 01:04:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.4-rc1.gz
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
