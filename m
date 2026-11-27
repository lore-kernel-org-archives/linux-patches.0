Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795737996;
	b=voYPfX/0SOEOHlT6uzQ4xwSdA7FcRj8OD0SmzQoWBKr7HTQ/0/5YzWcGIjZuuATW7/J5
	 /XtFr2wpSWVKHWoRn9HBCDxb97X8A99/YjCFgIbqVp+FahcxqfVzyFOVZJWTKZQTADOKU
	 fjpRcQYxnZ+Q6BUO4wy14odWH17yMiqq3VMCYUjhuGQnroyS+k6BBzFaQhlyaDiqi2HBc
	 DilFxugVBsA8xqhon5vgnwm8RP7Vm9hadzWYEnIIekoczmQx130Jrt7sRS4D2TP9kTVUg
	 DBa9Amn4OGSU/3QxHcjD3AkWDE2KKavas0W2t86U+YnS0QYooZ+tjOXfs8xP5+AuSzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795737996;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=g/UJ7v0tCb57TrFBa4mDGQ10gY4hp1sR90rabdB2JT4=;
	b=kgFPVVBwqM9oKuezOgvQqYrEXIixnnD8P79zMZ3if6egRuXTwkz4bgzTODadj1lERjxd
	 lQRsrtAWqn9nEWfvzcP1wXsVrheZzMheqyzyAOcKEh28uATmw5p8uUatw6jG3lxzFAHQx
	 vyddCsiPtZpTTCuZ3Ldx41CVLnWSlDG4l4EiIuEmWb6iu8SWOE+Wysykq96Vvsen0uGW4
	 sgtDC2UAP3eqevgikjvUfKeCAKdr0fOkenBwrVY3OVgtoOsqfdeOxk2X5GdJ8bDJACsF4
	 x/NWJeX2CFhHH89xwqRKdChEvi4l9jYtnEosmOQa5ee3qtGYWVfWdUl6YnugeJm/xcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7D606A31E
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 00:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77C7D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 2572856b;
	Thu, 26 Nov 2026 16:06:29 -0800 (PST)
Date: Thu, 26 Nov 2026 16:06:29 -0800 (PST)
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
Subject: Re: [PATCH 6.12 000/815] 6.12.120-rc2 review
In-Reply-To: <20261126105709.009001842@linuxfoundation.org>
Message-ID: <207e54f7-cecf-1322-73d8-595c2b676148@aaazen.com>
References: <20261126105709.009001842@linuxfoundation.org>
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

On Thu, 26 Nov 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.12.120 release.
> There are 815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>

Tested on   AMD  amd64 12-core and     4-core systems
and    on Intel x86-64  4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

