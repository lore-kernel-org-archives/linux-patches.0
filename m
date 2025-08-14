Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D72FF65D
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144067; cv=none; b=La72SXvFreE7RkQWAS5HsoFpn8aVL/A6fnYvLSAW326vim5QePaQnXW43Qy7fjaKcm8BFr7dbZnBAAF5ekddizyJqZwW1J5HEdLWFUZDA3SjYXfqxyt3y8OuTrikYZq6QfIDdLAYMh33XKNfklBjKd5udYVpAWLEYNBs/7Wleew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144067; c=relaxed/simple;
	bh=dLhANDlKfdf2rgsSdEAU+O140IGsNgM4aJ7VfsYJPP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRzO21ScrcIkGEUBvgNs0jtHxIFWsxLwi+VRWULL77/aq8y7PFRzVxHdsFu3SjIYsRw9MfhBiGu88fqL611+LcOumZrp9q0B6MvDO1NoG3Ba5KBO95fihUltmRbxfTCSkZ7h9ZIYQaca5lkA35AukyaBgZDRtryk+3l39cFaJIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZWWmrlm; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZWWmrlm"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-333f918d71eso3491091fa.3
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 21:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755144064; x=1755748864; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzUrh0e42gNwjwu5M+ISAP5VqZYMKnR3h64thSNiX34=;
        b=cZWWmrlmpCO2jLVbkYypHDPNmyJhI7Xp6J9/c0mXY8AzmlIbb4n2r97/LZPXhypmt7
         Q1upXB86QAtjg3SybSwngLs2vFOxS4rJikeTSOOcr/cUDvwhNEiR9VDbdj9Kwb5fHZRI
         Kkqtt2z1TB9JlLmwHKoNrZ8uSurXwne1jXEve7CNYfLgqrKd69DzwsUea+6LOzp982Yq
         EK3l7w4xRZWHuPQTDu2Y1j0pC6LuCs5xrKJGoXV3CQ9QytZodYZQgYhmCxwCIs1k/ins
         RD747SxZ0dUWV83DhW4S2Esqg7oRPmcXvesZBDKp9X3nD5UQWEwUIAGSYll2vt5AOvD6
         LgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755144064; x=1755748864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzUrh0e42gNwjwu5M+ISAP5VqZYMKnR3h64thSNiX34=;
        b=fHq0jMOwTxXxPw52KOVahBZDK1iBP//t7ZHW7wYukNMB/zsaiLOz7uhqUC/5fRLnB5
         3Gv0PkuAD1c0i6uC78iQPqdSBqItPQEoVADAdrKQWIn040pMqQFaKQrUzwVF983Ir/97
         6ktF8EvNv7f2ru+N3c24+maPSd7Gj5onH+ssaNmXJggAZ6jvhf4zzYbnQ4kxq5zoJJ/+
         vs5lv/QhfdY2LDRLGvPAxtdVF2uiOOqsvn+xUds+8kWrBP2Q7vRpfKm3FzevR3GiEr0W
         5TvRwfCPlqRVD2YtvkSjXvhmfY3zScDgvPM4QMVouDLtN/KqDTElN8CsFVtiMPlf3Iuy
         0DZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaOTxO9zJgrD4eVmA4dMD5W02n75UKQm5nO/nxVgs2ySzvuiqFzJq+FtUYT8gjLl/6Tw0ipSgi@lists.linux.dev
X-Gm-Message-State: AOJu0YwLsgjx8FuJMBmuJqLtqOcWt9UjHcUEN6Y4MJdIXVSShmdOi3d0
	vl+7XH8gGbZToT1TkEwp2yE1IiqlxF5g5hWZVP4tJh6I5dOH/HW6bYQ/
X-Gm-Gg: ASbGncs8CSLtdd2OkYwS77RIT8kgZ9eFcIBMxmCfiATRWYr+C03Evti0RFrOQiSTmMJ
	FIEJCkoznG1sEh+yj/8bZTUKTGB2EztAWcJt9CTZKTt4ikxIqDKPtK4mxgHa/huDktPs5C4sgCz
	sp+OOeRod2Za1KcvZGa26YEohtDSnivmUFL7MEkUrr7vL1vpFOP+KJaQa7SaewdY5JGVicpNWJv
	2uRawcxje7bgqu+R5SMT1loe18V8yX6fJDsRvf0zBBsg+KL8DkMGL54nfB7zRaQaG0VLx31ywGO
	Wajr2jYynn7L/md77GHgDwpPN2LG1MHecRKV/jBYIspOUxAmtWqCmWvCqbaxi3IMxL/e7HbHmuX
	MKIPBKBb1
X-Google-Smtp-Source: AGHT+IGB2hSnPfcKf0UCB/sWlPfcCkaffU+0E2DyA4PHaaSkmVONyTfaqDNvLwDl6BmNKeNDSIOfTA==
X-Received: by 2002:a2e:b5a1:0:b0:333:f952:e400 with SMTP id 38308e7fff4ca-333fa7d8f22mr2479451fa.19.1755144063525;
        Wed, 13 Aug 2025 21:01:03 -0700 (PDT)
Received: from elende (elende.valinor.li. [2a01:4f9:6a:1c47::2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-333f8cbcb08sm1366551fa.5.2025.08.13.21.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 21:01:02 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date: Thu, 14 Aug 2025 06:01:02 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Message-ID: <aJ1ffsxetEzx9HKC@lorien.valinor.li>
References: <20250812173419.303046420@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>

Hi,

On Tue, Aug 12, 2025 at 07:24:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.

While testing I noticed two new warnings compared to previous tests
with stable series:

[    0.000000] x86 CPU feature dependency check failure: CPU0 has '18*32+31' enabled but '18*32+26' disabled. Kernel might be fine, but no guarantees.
[...]
[   60.281912] sched: DL replenish lagged too much

Need to investigate more.

Regards,
Salvatore
