Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0132F069E
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 21:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763759650; cv=none; b=TXGn79Jc2nQVROotBY3j1mtgyztGm0R94vrPYAP1XpxNrxTyE7OKcLJdmwYSMszvTIWwLzgLr6wvfnsQAIZzd9E/yHmPZBcSnUR9YyhUfFAzPSdDextehdyrZig+p7EKpWYMYXaMCmpzbI8mYBS3bZHaVLdj5Ym2kd+s4ctGyUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763759650; c=relaxed/simple;
	bh=pEFooFR78YrhIvGWQXoeWCNC2kSSj2NyKh3ms4wsbIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7S081nqYN889T6J5/7RtEC2IbxV8lCI9ehLFT0/MA1cRbr20OEwDT4kYtWB9h3CDWBvkUS2DPBF883thAltXc1Zivr9aHKSYLN9fZi5zCBrDNO8UEQqSZgU6ix6IiZMr0Gsr4U330PnVXp6V86lcJhP73uVpW8cg20K97rd9po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=QSH+eBmK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="QSH+eBmK"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29812589890so29458055ad.3
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 13:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1763759647; x=1764364447; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DefMfvVzY19z1+5A+UQbLAdG6uc9MBGDJLgUd7SbSRA=;
        b=QSH+eBmKdC18T3kLqDgSOwd3PB43/zAyMzO130yt+tpEwQDm/kfTwM3QD49NWnf9KB
         UUDBA1glGcnAPIFHS8Vdv8WK2dGgb+Sxvx0e9CLThKWFPiGrckxkXndEDoPFQvWneN8J
         DBV/jY09cT6zm+r+NI3jR3Boz4+IHCU8t58sE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763759647; x=1764364447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DefMfvVzY19z1+5A+UQbLAdG6uc9MBGDJLgUd7SbSRA=;
        b=FYokMy1XQfhchZhcUrBLbrl414GEH02tceq1vyQqnuRDjuyC7bRkJVCNROu1umW2Pj
         H3Fz1Pwa1w18y9oct2zOW/o3dAAvGLKKh5JGBvrcbLEeqRUfCKNgg5EIyNZ8XciyyJTP
         eWf7/a/uSsa3sexco5D9r//Ml4SszGPHuqx6gdH1DVAmI7V+OiZC7eq+gs+8WfSN6eZI
         GYPpQcTNoq4LMPuZkzSwPqiY6f7qtOv0lSxf6Zlj+7HguX+Upe5b9qkQMG9qiyEPpDgB
         PEjtqFNkedHX9cIeLzmiYqiy87VQDlRz7Q+6/dD2ewFJXozcTwgPCrAjqY1IigsrXK4g
         Hfmg==
X-Forwarded-Encrypted: i=1; AJvYcCVWv+lmK0oNT9+PCsva/PC5HUwd9cGsRMQQM5YMRKw24qdGGoGXeDjHKasTga4EMYbWxOJe+Bba@lists.linux.dev
X-Gm-Message-State: AOJu0Ywd6kLNZzrhKgOxTK2KdGFvjU5Bk8GrVQT/wDWi9cF9i+hg6JE2
	Ew42NbA4eqoG/q7RSvmVxX8spSBLCUSpwq1WD5tcTf+nqjV9/T4orRkrDn+0kU1w+A==
X-Gm-Gg: ASbGncvJWFj8yE7yktPF0hHgueyWjoXM76drriBTbAn56Jo/6J4BK4NsEs3XTK1gnxo
	kXIFrwbHkrAD5yCYqyXNyK6JvZmNmv7uqgng1PS7evUfLZNt+SYDrBn011ljQ4p+Opv6WQB6HJ1
	wWtQXuy1jMtjFpisIqOHN1tfiuqm15wp2HKCvVLGwJbKN0HVbEZ4OxcmBTXBNbUVimPYG4hiBD1
	dySH3ZLba+rdwQqmD5hLO78s+tg2zu68EAOqUR1WQEL3BnnFTDpR0HF1fCS/hUX++jUwXsFIE/j
	OGvTa03lu9xvKqHNyCps7Uah3h6XHu4aNB9RmHKMB1mrZEKba+DUhSUfKsGFcbmv0bLwPjkuuTp
	yjPTbxE+Bkhw7M2XiH9/g7E1OGjRRd4fwqkngsOwxE8PAAFb6lifDVxzvyvEH+f2qteDWBocRWE
	IMX3NC9KRNksWf2vKkCxwt+MLFE9rxdWzs
X-Google-Smtp-Source: AGHT+IGoICO5vKGUzbvGQPv8FA6NHPI2AeaS2RMHkJJXNl2UM/lBqDzjcLi9woXD/2w5OzxK19kA7g==
X-Received: by 2002:a17:902:d587:b0:295:592e:7633 with SMTP id d9443c01a7336-29b6bf3b62bmr46414455ad.29.1763759647409;
        Fri, 21 Nov 2025 13:14:07 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b105f79sm64411075ad.20.2025.11.21.13.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 13:14:06 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 21 Nov 2025 14:14:03 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Message-ID: <aSDWG9xH4l9QJYQK@fedora64.linuxtx.org>
References: <20251121160640.254872094@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>

On Fri, Nov 21, 2025 at 05:07:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
