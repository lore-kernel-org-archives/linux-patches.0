Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AC4430B8B
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 09:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772442308; cv=none; b=S8siYyzesOOY0BMdnTf+bLNTnOJFKB0Pstkwb6QglODNt5Imtx+6DIW/NFgs+71939z53XAtseIkoXkJ+Mduq47rykHb9g9UiA0l7fUf/A76Gj1BmVKuGNIdoxdzsuCvdz/46oQYl+be3faJwaq9+4gz7F0oWWnvO1Bf5ICzXkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772442308; c=relaxed/simple;
	bh=u3DgpLd28AVsbLrzNwHmeAcF+EcunPZQhbms4bkHqIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aw9L3gI7CV+NJeFbLYDSCtr1rxc1aeh4IQMwmIsxLnpnzvVAGxb3qXitzqWbYLTGL2+W1qOrJwjsK3l/1sVTVU2GpFJM1ojJqtbezQgURXuU3ynRkpYOsXIWt1p9Geg0WSFg3q+wndKO5SnXEmfhFlZlzS+AwJnotAumUUHOf28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=vv3XPz4A; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="vv3XPz4A"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 7A39F14C2D6;
	Mon,  2 Mar 2026 10:04:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1772442303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S9o5p+VVqn/i9LwyTPc68+ckEXvb8CszYG2c2lYIBAg=;
	b=vv3XPz4AR3VBiZyAP4p6LNt7C7hGqL2CDt/BMdq+LCrdU6tz+1sdDEd0RPiQCDlRjwm6gG
	SVpAq5g+XTkPtDjlO2WzgsDNxfCuVGQB2lmvXTt6X9MRIpKRDHXnzwjNS8SdXgF0iVMjE9
	Qc8Q1mpsklVUjSkf6M5bwfHZl+SDz/JM9vFGqiEddOG5NObsXVpmwpe0YNlM5O1Z9iOIjs
	FfiPmyKkLjJRpgV8PWI3v/ZvDo0wc7R09Rfau2cm2h1Rq54yzKOSxiBe50BCTk7nc8K9gS
	xTIps1hoDKnzDK5UiXgEPZs6tsLS0v/6IsVOq9J6vHozZUmZqvE9mtDqR3MWNA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e3fb8758;
	Mon, 2 Mar 2026 09:04:55 +0000 (UTC)
Date: Mon, 2 Mar 2026 18:04:40 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/147] 5.10.252-rc1 review
Message-ID: <aaVSqOvgwAkWX59X@codewreck.org>
References: <20260228181731.1605473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260228181731.1605473-1-sashal@kernel.org>

Sasha Levin wrote on Sat, Feb 28, 2026 at 01:17:31PM -0500:
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:17:30 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.


Tested 403b311f5d6e ("Linux 5.10.252-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
