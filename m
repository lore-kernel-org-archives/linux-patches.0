Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228399;
	b=lE7RIXkuTmAiHqdOSIcZleb049wPaa09xImFHM00JCtG+Tr+7QXLkfJYLQfAafxgot5V
	 NkqXQFd4mCLJV9FbCx3d/i7tDaTeu4lN4Bt5X5WMh4HVfJRAZ3h5651lPutfrX0yGrIU/
	 w+zHSPKTNxq3zZgaNAfCe3N+OZxf7GSnpr2K1cOyOFzbTPK+76UbzXl7UqnKyNYCl9Wjj
	 pHAL9KZkcONZYIuFBV8UHheAPP+5mOYECiW4/W2Fw9dzENsaVB9znISkCQDlfnxD03iA0
	 GLPDxLZL5g8495xLL+lq8SoUrHUn82YwWVoRtxIhDHd+RAXam+izTjH6QaKvrddeGrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228399;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=ZnYCK34Xz7IZYtTASnBAQeSR2jtkJfs0D+rbso7dODE=;
	b=zWMZMM7dCo2WCsR+8LOqKNm8bakJwggrOJCCnSeR28IVLSAafSDl5zCPlfE/WpI7IkX0
	 ZeVMxIr+uF9cXRdDOXtsgn1w0WymykmYiWrEP8sVnmFtR0e7dMLeu6LnjmkhcAsqwpOYZ
	 vspoRwDQ+DBx81jsnjlmKwXJWzJgCGYJhuR6l3Qc/8ggXTWZni+DTzXx7GZpv5U7/iipJ
	 nj2DqAtiSy7d2isBIw3Ea11N2r3S/PpwN9wuUTp6VOWZ6cfUpQ3h+jRi3gOQ7YlLhDHDo
	 El0ET2WPyN0ctANM10NeZEg6zQpHM/2fJGA+8RHtli8/yfYNDuHu7f5dusnGEOV/N6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCB2606A31C
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 22:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDCB2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id aba075cc;
	Wed, 28 Oct 2026 15:59:47 -0700 (PDT)
Date: Wed, 28 Oct 2026 15:59:47 -0700 (PDT)
From: Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
    akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
    patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
    jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
    rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
    achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/571] 5.15.224-rc1 review
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
Message-ID: <6b5e22d-fe0-9171-9e70-8e1016cb82a0@aaazen.com>
References: <20261028170008.009143722@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 28 Oct 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.15.224 release.
> There are 571 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.224-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Tested on AMD   amd64 12-core and 4-core and x86 1-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>


