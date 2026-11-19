Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795131431;
	b=HG7JBHINagRIFi4mQmXCnCe8SwMlXH6Lo8z0kNrh2lgR5ghB+V+hoPunphYlWlgKbq2r
	 4rk88GYVmZXE/hQmYNpk1fDzHnwD/fej0Jx6dnglkE7eisad7N6Xnjn1mvjnNDnNwvtWn
	 pes3yjrBfEwWNhA+tsOLfh8xL6lfA490OwjsTT2iusOMe5zVlGgb4xeoaap34t9vaeKj5
	 OOiIRbU+bcjROs7/DgjaMif+X+4fese7nwH4RP2wh7/p5dmaogsxSc/7gCCVysoKjqL+I
	 R2vTf2PUSMZkYfw5ZPYm+yQPAx2AvtDbvj4KmdIg9ULlSuLJVQ9daWweoLicBmEDJag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795131431;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=T2SMK4q3WQrDVT9Sd2M/tuVc/MR65skiFfg7F2qsQGc=;
	b=Er2wYXcZI6nh39lmP0NOiILYCN+eNdXJfH/IQAQ3op2vC8BLkEq4V3HCOpg3+Zpqh+dN
	 xFDV6yWJs8ccy7LSkqFW5yl4MNwp4rnFi9/ChV4N9LmnEXoh9HxK1V0YkH1Eeu8U6n8JL
	 Xe3pnE4tC9VGs5T7Sq4IJScP4+k8rZmDN+Gdp6oKsmTn/vHj4W0wld0BinawA6YtO/ttC
	 Totc4bIfcU54nVzqF+UvYmA1Fi47hPBWO34sHTaS59xBtsE4sFBe4o5qgQ28OKwEPmI65
	 Gb6RyS/9U7y/M7+Xeh3cyRvcdzGgBZEBRbKn+wBjhFh0hPxTt1v2PV5JdziYHz7iE8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFFC606A334
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 23:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABFFC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 50b654a1;
	Thu, 19 Nov 2026 15:37:05 -0800 (PST)
Date: Thu, 19 Nov 2026 15:37:05 -0800 (PST)
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
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
Message-ID: <303fcbd7-3cb-15db-a5ba-a48d9f5063a1@aaazen.com>
References: <20261118150007.957976754@linuxfoundation.org>
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

On Wed, 18 Nov 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1756 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>

Tested on AMD   amd64 12-core and     4-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

