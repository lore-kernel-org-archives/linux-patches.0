Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE805384
	for <patches@lists.linux.dev>; Fri, 17 May 2024 00:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905792; cv=none; b=RJen5YBxiV7Pgr6BThIdTo+p/g6gg/LFDMW3dEZzb1pn4KgwZa0v6Fd41rDX6NgFYu1g5a2wsj2rdgAtmscTVmRMoouas+FFaWmqy2RwycIlrOKHNBcDJD4vYLTt0LJYNPZphboU+Jn8bhgdWpY83xW5hWC31GxkWYwP1ZzQLRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905792; c=relaxed/simple;
	bh=KH0mu/PBKvyDTtRbZDfMad/j9+AAEqnKA8oRnYYewaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ccBr/j1WuhtPvU5tSV3cPK37atlN3/zgBiLO2AlIHCYu4sUa2Kv7PoSG7bT9sohordQFD+tQfHXJSMZsJsN1ybO+HoDo8sQwj+ir9HH4CsriqAepA7u2pPgfXWiE0wlw0tCM4F5mxCTWnmAz4sW/DepW/QM7mfM0FvQvy0eQyLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gRI0wzLi; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gRI0wzLi"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-47f01a027easo2437280137.0
        for <patches@lists.linux.dev>; Thu, 16 May 2024 17:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715905790; x=1716510590; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N+KmOyC/iV8n/07rVcqpUpUm3beAF6+iOzU5m/G/q6o=;
        b=gRI0wzLiMi+E3gntx1JUOZPLD5XBoWxNyBMhuhuwgWEe9zdKgmcpwyksRWLtB8mUSz
         U10ufiIg8bTJHFftEgv1EslefM8RDbQGgTmcNYHxzeknAFAwDEDsHFDjPiYnryWX3ueE
         zs4tk+KAmBBNh6q9SuOVXB7/6xQ32w3zREciE+sbvoJO5R87Fb0D3gP6QjXISrb6RqMF
         9KXcqK6hW9/ffcmoGOwcRDNfBMM8gpzXWoFgGFHXVMZhx3x2KjW/urq7Ant9EHmIGQQ9
         fDLdFfAHbk9+4WyaHjMsdVOJHEeuTy2ObemhJZDUc0hyrKeyZRmNYGLTan5xbFsnVlEP
         3aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715905790; x=1716510590;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+KmOyC/iV8n/07rVcqpUpUm3beAF6+iOzU5m/G/q6o=;
        b=i9eGCNZkw83nZQGoeGZW5kKUFvhG+KhnoZ4BBC5GXRe8OplJM7PqDnksxcLjIcc3S4
         hC78gJZ4+ez5VMujQZTF8uz3hb6FD4do7MTX45/LjyGnjGbv5rCrp6+WKI3kRX1FsYmT
         ztQyi0l2hja6L+g1e6ORiPIIxXSH6KkbN6JtqikE9pRysvNB08COUUi1kgLBrIF3ml2Q
         PbYU1I8S8eAvAJUppojhzBaMS17xxE83OogXSN+SpZx/ejK2ZuLM0JyVHjy2Z3RemHcR
         rx2HeSz21gHrexcN6nrhgBmtqnD8d2y39YV2DDvVRB+QYTcRHTiNXYep1EGF4eNc336G
         4w8g==
X-Forwarded-Encrypted: i=1; AJvYcCW3zF6sIdESOSfPzAzHkHncjwcHh8ziqfHsZwpI2HP8xsPPxcWBb884UQoS74BcXic793hYX35wT2EpcqbuNVlZRV3qax/r6A==
X-Gm-Message-State: AOJu0YyCHn1IjGbGW7Kr5adxcnaD8uj0HSntgjXHCgEPEwCMTetrKTp2
	1VNSn/lDdYz+O5MTTMq/Ouo6WfyV3NESt2gMkpVP8/NZl5UUMV0NfSnqf4H07qbbBtLxXJay7Gz
	hctyt2RvrhK3nlNuCFBvVQQ/nosk=
X-Google-Smtp-Source: AGHT+IHvllubFZaKY6KPvv1qxfS9Saxnyz/cYL94fUH5oUTlB1YWBRPY36H/Sx5fd2+exy7HAXc8Wf55NEjs5679QeY=
X-Received: by 2002:a05:6102:14a7:b0:47c:28c1:5379 with SMTP id
 ada2fe7eead31-48077eb3c8fmr20452446137.33.1715905789817; Thu, 16 May 2024
 17:29:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516091232.619851361@linuxfoundation.org>
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 16 May 2024 17:29:38 -0700
Message-ID: <CAOMdWSK7KC18aVMn9mo22s3g8BFj2oGVRdosNkF4fY3k7xPp2w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 09:11:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
