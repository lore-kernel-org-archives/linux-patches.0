Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B107A21770B
	for <patches@lists.linux.dev>; Wed, 28 May 2025 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748458863; cv=none; b=Uy7hkF6dQoMpELgwRGTcOtsXuJIqNrzq3upivrk17GpvsOiomQRBg4xQYyyDFw83GEcS//Yz3cny8Oz6TO7dc3KvA+K/UGpAGziZGGEqAnMIvdRbMVpTczPhwfWbkZNYOkQgFHGCjwgpCTQ8I48jso+hHfTPo9cgRZtgZEnvq5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748458863; c=relaxed/simple;
	bh=99lZxN5vhS9pT7XjyafkDptBxd868nvYUBqPecl/XbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJKS5XPCt45pq0T5+eQ4P+etK1ofLrTHoV6lDAea3NtH5pwtrVuGUhfVYtLmMBeHZMU4tlfa09ISLsiEpvzGWy8jXbNxMysoY+sRKSwVjXtK/Dl3PM3Tq1evW4+vqdjiruw6pE8RhIZyjilMxJ6/ZOtGhWToMbV0pZRLgaFKMT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ik633yzD; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ik633yzD"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3dc8265b9b5so943795ab.1
        for <patches@lists.linux.dev>; Wed, 28 May 2025 12:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1748458860; x=1749063660; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6uMWV3+sb1xZHl//TOe7Sv20/rDXHWApZwSoImEOEg=;
        b=ik633yzDKZswE5RUcUg5IQmciGg5oCIAHvknU7oxYNm4rGWzCghA3ZaX0Fk5LsKthr
         /kG8OIoN8iXOfaUkvhZg6YvLflGQkkQ/Yg7JlV2Y3MbkKIoJuWUkF1UBgWi/MnWyHh8j
         sWgCY2D7FoeXHjzgogc03BS+Zz1aiqIDdP+rE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748458860; x=1749063660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6uMWV3+sb1xZHl//TOe7Sv20/rDXHWApZwSoImEOEg=;
        b=AXuByKQXcz4K2LqVtxhotLjDaCdeq7ARaBthzbu+0HE52wmaLU9/0l8lxfivBClL/x
         9ROLFzDNIabhMKcBLNYyqgrAOCCr1+r0Kzu+0E8TyUIoa1ikcmE3iceJo+2EPBT3zrqx
         13DBc4m0hR0elMcIuuTXJQ2G0nFk/6JnIovFvIN5Hz226aynsHoDmYo78NUro7xzm+fq
         7pE4DhGF8pnt/KLYTLUbBhqtWvlkrovj3R+EKQs8/DoR4iZD0H2QtFNJNipmsz816XPg
         9oySDnfz9y1e5rJnxA334nR7D2fGXCQkNhy7FcLPp27tEArudxeUON3aNoj7W4QD1O8K
         tSeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9bQBdDrKVHsc+uT7rM6dLis+bRCMaRYsQxS8ynt+fs5AgrzF+WTrr0OT5GI7zQWDcQt3gP76x@lists.linux.dev
X-Gm-Message-State: AOJu0YxOHB0LG6zGUVmx0cXkNIOl01mkpTQ5zT6d5Qfx8T4prfISYqNh
	jx3GdzqFlmXrK+Awk7DgA0cam2NRsZemyAkY46x5kbRGxg3wEOsXnjNwO5qgFPEuzg==
X-Gm-Gg: ASbGncvgmg35/yxk3WUHK7OCpQAtV8rom8CFzbOmkRe2zRlyzimAJVoVqzod59oybFg
	oxOBXHmqiv3h2OXqluKKULBTWMROKJzkONuBROqOvdSOEFfgAaG2nN3KxSfn6Kg/tNR1Gml4LAt
	320bMbp5/64Bie+f1HIBbEpaPnqpu+yWyUfizaJGOXZlTTFpzishwVIvqz43aR9BdHm4MV5BXFj
	bv7mRL4MWmXRsVWLaRgoakBVAEd7t8sqk9OnCDlLpRT3qZMkhIZShcgOVA5ejPlX6R42GXM/xWv
	daLVxwHjyAwn9q0s0Wg3hzFfwLAw2xvzcRiYbf0KT4zsj3VTiZF5b/dI9PR+lUTBsLehT9u+1nO
	oZvs=
X-Google-Smtp-Source: AGHT+IGO2PTzIAqkK41ccV62UVml+KrtjC/CCurWR884MEq1rueZvDmtfrOp5qmDL+URey90IDvSbQ==
X-Received: by 2002:a05:6e02:1786:b0:3dc:8423:543e with SMTP id e9e14a558f8ab-3dd8b044b9bmr36739375ab.17.1748458859626;
        Wed, 28 May 2025 12:00:59 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdbd58790asm341459173.95.2025.05.28.12.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 12:00:59 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 28 May 2025 13:00:57 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
Message-ID: <aDddaQGen1YUVCYz@fedora64.linuxtx.org>
References: <20250527162513.035720581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>

On Tue, May 27, 2025 at 06:16:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 minus the broken "s390/crash: Use note name macros" patch against
the Fedora build system (aarch64, ppc64le, s390x, x86_64), and boot tested
x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
