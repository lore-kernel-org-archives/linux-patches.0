Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC6D1EBFE4
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 22:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725401844; cv=none; b=Mb+DByDh5r5uJBLeh5uxLo1sjouRWEWugd2HYRTeiu6Mi1ypLZRtkmOU31TIXhieHB9UumOeIc6GGDcmQ3PflhmE7wLs7/BD32fg2K/1du1T4QTXMSyeN3OCtpvRqutM9e8QWbWcEg+8zG4muyR2LAjAw+mhzEvRALq69WwyRiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725401844; c=relaxed/simple;
	bh=ixiIN7Un+lKbuuqP82YDNbIrIqTLTw6W6vi/Xln3G3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4NybQMZg2UlmQAvPIH3darm9fGdqSwvLfemfBv+i6gDKTZ/Umro5iG1/Pcnd+ggOij4W6Mnq+y0NyAod6yEKPO4R+vzwf3+VXRutgB1xxsiPXkUu1snmnrMwbIxe5SNJtHKAuwRsRyNOnpEuNKYVaFACJCho64qLrmfJrnpm0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=W4VYcQ7O; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="W4VYcQ7O"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-824ee14f7bfso237879539f.1
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 15:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1725401840; x=1726006640; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s38PvxZbBMTVGvQ0kbtSdyWDBrmSjvOO/03Z8xfaLco=;
        b=W4VYcQ7Oe8Bf6z3tRd4quiO+9tAOT+Rnzsa3iGlm1vTX1KH4O5+lkE4jtKO81uximQ
         SOYXZRD+CktLUzt60DCCZ3GNxt9THTplH6aT7/gEP9QLQ4Ab8APhaZSLz86l1X5GRKzF
         kFcbsFy0OQ1Udc4HD/W9Y5+C2UroGZmiDAGms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725401840; x=1726006640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s38PvxZbBMTVGvQ0kbtSdyWDBrmSjvOO/03Z8xfaLco=;
        b=KWxNCKRPVvdWqrZ8Pf+IRwsqcOvs2tM+s+CDd8Wl2naM+R0xQ1lhcNxQcWPBG3QB5r
         /r2kCPdAd4LAnCZKHKP2Y8JU253JmYrKIolPvKrZPEWk9gxVLl4uBU8ZoHxWMHvpNIWb
         Mp9MzmMLkc0oHsZS0hrP69Dlw6AXRts1VTLR6XnTxCaqVz6ZT6o1Fa+G3l5KZv+vID1/
         PhzOIuToUXBSOPjgT6vImR+o1L6SCD4ZyOynjhWAxhJHiVzTXHEj2UrZjYg4GfJU1TYk
         +yp9A4BT6xY6wEuXnB4P/hF/v2RoNrIk/p1473LbqkXhHGOjNN3vYU4oqM3NWx0K9PGF
         dq4A==
X-Forwarded-Encrypted: i=1; AJvYcCXQLWCLiEK/uVQza9nxnO9cT1JQjOex0d7CY9jeWj5DAybm/GXoQCxgHRc3606H0+tSjM31gYy4@lists.linux.dev
X-Gm-Message-State: AOJu0YzKm6gmrY8JLbbVsluEyNSOUUPtloaqJEWWWq40/8HBThFMdLo8
	duuRFC8iZ5dTHEE1UXWde2qKQUlG10Ewzwgz06f0SIefSNZMdfmPLkITbeKO3A==
X-Google-Smtp-Source: AGHT+IHSG24Jh26pxj6oDOdaXB3yvTtI5BWzt2ZuQfpSpL2rvr53tFFIUcwfaMJpX+ZdObf03WdX1w==
X-Received: by 2002:a05:6602:6b07:b0:82a:23b4:4c90 with SMTP id ca18e2360f4ac-82a23b44d62mr1661524439f.1.1725401840339;
        Tue, 03 Sep 2024 15:17:20 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2de5cf8sm2805547173.37.2024.09.03.15.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 15:17:19 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 3 Sep 2024 16:17:17 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
Message-ID: <ZteK7TVPmK09RSz4@fedora64.linuxtx.org>
References: <20231218135104.927894164@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>

On Mon, Dec 18, 2023 at 02:49:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
