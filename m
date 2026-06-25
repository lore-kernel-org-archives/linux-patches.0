Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10A72DB79F
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408658; cv=none; b=ge9fAEBaKHftoeEgzEr4RPRRdDAOSrQGN3sQ6XLT4HBpuqej8Py11p8XLju9umJtgtjleRhDklNMN1c/6sDV3vXMYkAzw2HjKncdFZQfnpnW3t8lhZy0AlKnAEYJQzuNT22nUvw+daSMaIPf0Z7Yw1/xYDaNkLaN57uST934R/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408658; c=relaxed/simple;
	bh=wVpHIkn3RE3gC/nfpVm3k2hccIIjRg0U8XV2yLjOTIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZO07mojDKa8zXwIQzny0EDldfIEdTjGkIcMGt8Caaj2bETI/Fyq2ac/3DYS7pP/c+R4zV/0eFOLd8xMUXfYU83K7zHxzGVApAxNM7brNycM2ZD9FgACZhpWtUfx76gjuhnCdvAP9HsI2dDtMzL6LCBIbm+GeO4VpZJAI+QhhYZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=WVEW3Mta; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="WVEW3Mta"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c7f123b1acso2382705ad.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 10:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1782408656; x=1783013456; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ns9Na0/3PBHaGaylTzimtteynQsaE2Wv7+sI3PG6dw=;
        b=WVEW3MtajIVC3iuhjablOwf5tnFB9l8gkdb0FbB489j/dNPqqA7Dm+9i7d6G4jZssu
         R9hg5M/7ZyLKuq/Qvirb4XG1xpSBnKhGKr3VwGF9Sj1+NJtJEbkiLR0L/V7Jz8jsIUDV
         L5ERhynRAH15j8ayAdyjJuEIMdubyh+cY/66A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782408656; x=1783013456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+Ns9Na0/3PBHaGaylTzimtteynQsaE2Wv7+sI3PG6dw=;
        b=bAhtm3UeSH46i4ExZ/IMWuAAp6vzrjxfKhLiPYneBhwqx3Wy8mhtkiCJqxHyZJWY6Z
         xtlOspY7zxCtBVYDti+7J1O0vS4BxTSkctorEl4JhGw5orAFNIZlCqtEwNf13zWdc4A6
         0vn8qgki1gu2H3P5N88tDYUmzKvcwb+1IUT5FuH6HDBu39S1jq7rZkxYk/8Cxx+pF2YU
         c5xtPSCfLQYhnQ80XLEBpNezJdOfqLX8dDBR3dKUOr9XpM4fF/4J2GKy0R5VjkP92Ge3
         ix7sCFLB/5wy/aOgwOKG8wHprdh7gD/TBJ8tOWdAGdrw925uOnDfV31+JYjhvTBGN2Wq
         GPCg==
X-Forwarded-Encrypted: i=1; AHgh+Rr201Rjp9jDOM77mOJSnryYps+p9IRVGnamZWWKlsUihZcSYwbFO/1OVFZb0Sp10+lb4GpLa6tl@lists.linux.dev
X-Gm-Message-State: AOJu0Yw67eR/rCEh0YVmzRQLUErtxhmZmujFrZTQTw1M+yM1/jdmlAwV
	ilTHjImA4fDWmYbzyTSRhJMuSGG5BOHLEpve+PdAaLizyXrGOumnRe3crhs40gIlRA==
X-Gm-Gg: AfdE7clwL/Xf/gc9odqsOoNwgc1bJ3N4Tcdrwgfn+YqIYtl9c5JTAdZP5fGwJGrNiDK
	ubS4OgjHy4NyIsgDRrbCjlC9UnHwfoIJYs/NDPi+yEbsOtfgSS/VXo/UQQarzw2SPkk82b/Zs6O
	l6AprtGfF5Hhi3HrvQLGHLnRG5g1r8KfZTbXeYNcptYgmtLeX3t0pNaJzz4YVAZGKdQQntdzfXn
	WPgVzIcRSvGlbUXzBDhpXaoPJeSbtVuu4XOQxUBkrRpVRdXJyws6c06iRQg6Lz+Ag2xJokZS/V8
	w/GVnBLOE+vq5E/jP4Jp0B7wfJaaf9+m7Hh5JIqQevv89E/9Rsdmli9qgW4gj6G69RrfzRy5PgF
	/EZmIDFSBE5N45Xh1sxwEjx0T0cGCLy8kwPBV25gNhzTGkdl1jn6JY0zP738rE7iLQi6vJJgqqy
	uMHScDyBhy49PlKt7nr60dF1pinTuXPeruA5aTbB6z
X-Received: by 2002:a17:902:f650:b0:2c0:db23:4c1 with SMTP id d9443c01a7336-2c7fc63261bmr39873245ad.5.1782408656107;
        Thu, 25 Jun 2026 10:30:56 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5ac8e3csm24377875ad.10.2026.06.25.10.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 10:30:55 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 25 Jun 2026 11:30:53 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
Message-ID: <aj1lzVpxbxFz2x0F@fedora64.linuxtx.org>
References: <20260625125637.527552689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>

On Thu, Jun 25, 2026 at 02:03:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
