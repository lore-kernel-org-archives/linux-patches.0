Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5D23BF91
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 02:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771467137; cv=none; b=oA1C1tMJS8KShWpyr/IKWjJdncKSnbWzmeWo6ENrC74ok7KfG5xdAW9SLZnLOqAz6f2A9ZtEWkIhgp8JgWiAbffN7dldlNvobMhJOCNf51Vitc6761EEW7BfWFM5w1boptRFQQEK230mvlt3IeYS5a2ip7kVpDB0vh9oJGhmyuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771467137; c=relaxed/simple;
	bh=LLVOK3lAzVZENBOpVcKzg/rnIE4l9DuvGV586/+9lp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jV1pvrLBMTDJGJ0cOZE/JbXE+h8Gz9+D/ejd0TFyq1jdItjNUy36XpPXVu96rUwhSzpBKqxPJPvcMAptoahDndLokO9GdmbXtF/fKGsLD402xV7m+/HzyIspa5VzhGlYJ+//8/jU+1sTqp0mNZS0UG/9gn43GTYpUIiirM1OW+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=ZvEVUrpG; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="ZvEVUrpG"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 3B54914C2D6;
	Thu, 19 Feb 2026 03:12:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1771467132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hhynICUA46JXJAJaiCQFUnZCIDyDscyYC+Ay4tiLXgg=;
	b=ZvEVUrpG7/tT3/p++XfHEHLaaAPGhKJQdpl+l4DVO0qSj5jbgjGS+s8ol3G3q4lhMom5+N
	Yz6c8g3JtpEzVxo0v0ROCR3jFD6jRb6q0cczAsKiAPXJD0khIR5lbB+3KMVUGuSm8ssIqE
	rUhPLuSBxquUjteisWDNWH5HE8QACOxj7WVaNQSWeDVp/Hq6Hrmh+ekNZDu6bkTA6VKVw2
	zCzf2lGICb9VSPMWsqxsx4WMeJzjgTd8KXUAx14pzK5VyYDLA8h/nBgOjcLA76qO30E9z6
	50oY0QFCniwcdmnUUdgZ72d9HbsTVPzbf3uVYrRBzcybK3nsr3GTARjLbcJS5w==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f4c612b5;
	Thu, 19 Feb 2026 02:12:05 +0000 (UTC)
Date: Thu, 19 Feb 2026 11:11:50 +0900
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
Subject: Re: [PATCH 5.10 00/24] 5.10.251-rc1 review
Message-ID: <aZZxZuxT9LAUIfdK@codewreck.org>
References: <20260217200000.708219618@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Feb 17, 2026 at 09:31:13PM +0100:
> This is the start of the stable review cycle for the 5.10.251 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 25b86d4e088d ("Linux 5.10.251-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
