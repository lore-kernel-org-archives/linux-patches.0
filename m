Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A793D9DC5
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 02:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228021; cv=none; b=C9wU2F6kv/0ngrzIKiX45LO+KY8ZOo9pkudrnnI0ICCRXzZJCBi1r2+xw/eS+jly3tw+vIGvF9XavFKpGMBq7UD6OZFRC1yUHKVcuQGKeTu7iD/vFlcRCZ0AKeYcp80Y3i/P+icDJf1imoC4K/mabxMiJExD33+8cf0J0SQ9yng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228021; c=relaxed/simple;
	bh=RzoEoz4fxfaTJGURjalPXBLAvHBtzkIBZHb8qmJbcrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAl8fyLE9Dr9sskw3mWCUDm2vijc1xVzeOEOucWbdiN7xaLnrjGFMYG5S0upzHGRmCz0ghyB9DsVdYxU25QzHKg9gw8CRhdV83POZJ0yrscCs08eXCX3y4XLAtfByMb9OqiT+sP34xWX9k1MbdsMWXpzGt7ZWLdLZM0f6qBZb18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=acb0LbUh; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="acb0LbUh"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id D910814C2D6;
	Tue,  1 Sep 2026 03:59:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1788228000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6n7n8eGP5hIXfZP6OGVaAHN/TyazJnQKelruRbJARc=;
	b=acb0LbUhQN9XIpaNz1MBCSyXNa4QsMP3WnvkuMo415GF1wDp9lo2SwcoyT0tVmARvAJcC6
	bw1WMLK2BmNVfJBgOtqQSl3mVssyfrFrYNVLYOsgXggO3rHcvcUy/SM1b3DH4wXviJwas+
	7IrWCiy1zCWDe5cBhelTad9Lgp7/K/8A0k30Bcoq5ttCDV7LtgokeIeGkS1izruPH+sB5g
	7DIfBJiWVSWDpNVC4HWup9i2GDm716mhs/6HRo5z7rFIqUzNoL478RL9f+lpEeWvUmdByU
	jauRKEWZr+hnBNul9vZEdoEaHJOTcLxMPOYZ2GK8UCHp7wyuHxG81cVx4b22DQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 571f9e7a;
	Tue, 1 Sep 2026 01:59:53 +0000 (UTC)
Date: Tue, 1 Sep 2026 10:59:38 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
Message-ID: <apYxiu_whjTc696q@codewreck.org>
References: <20260831133359.740409777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Aug 31, 2026 at 03:33:29PM +0200:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 7e0459c39579 ("Linux 6.12.108-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
