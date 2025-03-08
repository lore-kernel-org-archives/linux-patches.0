Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6041E8337
	for <patches@lists.linux.dev>; Sat,  8 Mar 2025 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741458281; cv=none; b=qfYvHinTg6k3TwP+PqMu1ad8vYRpHYwbXc3yZntZhjyZxrfOwLUj3aznQnRiQjrpj73AxQjjd8kdzDhzJybP/rjhBZ2XU3RAGIwX9ieICCTm6OakiboZPdvyEdGJMm57/Z+aODfIt+UCsC+YmI3bLu4HiH8+xANNOjIq30h/T6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741458281; c=relaxed/simple;
	bh=Ex91Fnzm2pOZxAoz7jFo9ArugUV39OZ5TQsj2eALoPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gG03UXvHYZjqjsIJqvRACDOsKRnBQj2qjK4e6bua0TiVJa/+6ZkjUDAnxuvX4gggSWeh8P6icFRyS7MThsTnrx76Oo+ltGR1hzY0WZ2h4mAxxJe37OWNxWP038EBdgJ8Dve3YdSkem3xosedHD6Yben3R3j6QymM8Axm0NfMLiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KA2Filbt; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KA2Filbt"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223378e2b0dso43461685ad.0
        for <patches@lists.linux.dev>; Sat, 08 Mar 2025 10:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741458279; x=1742063079; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mD5I6E5iqsSGKDuW5ALiPqqhXMadeoFBk39l810IWd4=;
        b=KA2Filbtw/OQaMpmItHbIjQGo5gJSu579XHToaKN8fWR7TlbSVmNl2AU3yRuWmJZlv
         mvsA6fEcDLqV8BSZzvMGuDas5HO97dohLY4ZkIl5oNHQJOwgQpBccVeNJxo9oFVixFWE
         HBuEQ/DcuAeE+ggAVwmg5xOovf07sfYuKBxZXuM/H3rJWxjGjvN8mqh7cjKafz4Exz6M
         DbNjYo/Ym0RNez6oQOsxmq45lj0Hs5AFprrxqErGsCtgq/ffcy/UorUQkrf842M7y6Yn
         ua+6wE+YUyiKUkOirCbTBBohijAAtamaQIEGga799YWJxgfDRI9AzMXLwKyQztQaiFZn
         N19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741458279; x=1742063079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mD5I6E5iqsSGKDuW5ALiPqqhXMadeoFBk39l810IWd4=;
        b=g3RpgY+UG+s8qXkjmGTNCqMTS5PsXJqCLQI2axC9I351q8eTKpdFbH1rPDFPysjE5Z
         DfN3dWPUvVj778V8wAbLeYzmQFwm/Jy+i7zGAfTO7X8DAyvYLaBtGMbBGWA7/QLui2Yd
         3wl5Or22bvz5CxeYRpbuYlXRRsSLXkgP/h025i0/90sNeUunJ23xpjr9BG/zhKhP+5MF
         g3UuMJb9jdNTz7cqdmeV+UWvFH47MpNfdsdTH1KatDdwuywkWzRU6A4r7hTEP4imA04j
         Z8dL4X7MoFy3gQwrxIAqV5TbtAcqdTtnGhC4RPT2XEwK1gA1nAW4ncT4MpW7nPz5vwuu
         AYPg==
X-Forwarded-Encrypted: i=1; AJvYcCXVy9Vs79Yo2sKPWu61xqFqTtwjQawiWPgzmwCCFDVhkyxOPjE/rWmJSHRVDcsfMRV2d3bHcTiw@lists.linux.dev
X-Gm-Message-State: AOJu0YyB+QIGWsgORcEkbADa+jzDzp8DjCjCzHGPfbtwThsx8shHAvek
	pUSO0ZWpP0Cf4YZayFlJyYcQXLOumAMAIEJ1w447kFc3m0Nazqqj
X-Gm-Gg: ASbGnctLaH6PgkubaqMJWrYlfg2LLLVwrvZnCqb/QjSwljcGth1CBvJlXB69vOMVmsz
	mVk85F4AJvABtoegoJOzznEz9ISe0+ht5a/D7GPnwmDm3FHiKdC7DQEK9aZ/l4F120GvWGJ3QyV
	SK2jaNRZ3Ro7G8dQtTwpX4vC5z4CEEMOd3reFqQ3NFLitj0QrV6Ur1GU2Kl4M+ZOV3qfpQpnpwa
	niXyXZO1/ROz0WorbLt7xDGhKpRbQckRD+TGj9cQ8E11xGNRnB9uzrrx9mSGfmzAyu6Dg2b4DZd
	A/Q2pMy1W67d/cNuwcpG6rw8H6bjrQqPdHuDj+qGk5gjwlhnTvAbDC/7sw==
X-Google-Smtp-Source: AGHT+IFIriNfji3U4cU6+vyYKbGBdNwqtnp867yNUQakxaOvbR1n8eOo3teInhy883mWIKgfAF+oyQ==
X-Received: by 2002:a17:903:2405:b0:223:64bb:f657 with SMTP id d9443c01a7336-22428c02a95mr130001765ad.46.1741458279527;
        Sat, 08 Mar 2025 10:24:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e9f7bsm49489445ad.80.2025.03.08.10.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 10:24:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 8 Mar 2025 10:24:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
Message-ID: <3d99c624-88a8-4a98-b614-7565aa5dc4ba@roeck-us.net>
References: <20250306151415.047855127@linuxfoundation.org>
 <1c813c9d-de04-487c-a350-13577dbdd881@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c813c9d-de04-487c-a350-13577dbdd881@roeck-us.net>

On Sat, Mar 08, 2025 at 07:15:35AM -0800, Guenter Roeck wrote:
> On Thu, Mar 06, 2025 at 04:20:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.18 release.
> > There are 148 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> > Anything received after that time might be too late.
> > 
> v6.12.18:
> 
> Building loongarch:defconfig ... failed
> --------------
> Error log:
> In file included from include/linux/bug.h:5,
>                  from include/linux/thread_info.h:13,
>                  from include/asm-generic/current.h:6,
>                  from ./arch/loongarch/include/generated/asm/current.h:1,
>                  from include/linux/sched.h:12,
>                  from arch/loongarch/kernel/asm-offsets.c:8:
> include/linux/thread_info.h: In function 'check_copy_size':
> arch/loongarch/include/asm/bug.h:47:9: error: implicit declaration of function 'annotate_reachable'
> 
> This is not surprising:
> 
> $ git grep annotate_reachable
> arch/loongarch/include/asm/bug.h:       annotate_reachable();
> 
> Caused by 2cfd0e5084e3 ("objtool: Remove annotate_{,un}reachable()").
> 

The same problem also affects v6.13.6.

Guenter
