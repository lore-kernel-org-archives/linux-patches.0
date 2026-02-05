Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27BE361DA1
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 08:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770279997; cv=none; b=EqPC4aSYKvnl62qKtQ3NF6EJNpvHdJ7hdmvMBBMjWSwaLI5gn4cbFkjb4wXTP6b4dxeaPBUaDNhMWpNbp0nQAIaPqfpPxbdzhOJWnz0tpsex4J9hpK/GY7d4Lw1cJiC/JhtSvqBwK/+kjZRPYzqr8NXMivl1OMzoTjhA8ZTTzEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770279997; c=relaxed/simple;
	bh=wmJ7fByinoHPUYfvpDGPNK6BxbIbXFCCcc7rZxoW1z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyVTY8Xr0bakXDkpAKbuw5+TjcIs8086WXNBAjErKJfDGKd8vCjgL5Xz2L3+iLRDursByURKW+RTk3ICq9K26q03a/Fq0l2FrK+gdhdQmyMZzJ0bVRlp7V5xQUnjCrbnpV9vLdMtSAVHR4l44gpf7V5yVY6aM507VPhjiu78+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ZFoaNkDD; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ZFoaNkDD"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 9623B1FA65;
	Thu,  5 Feb 2026 09:26:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1770279995;
	bh=ytEPcRZ+vpftJH6ei2YD+mfiF96bUkJzJYMxRgCH3B0=; h=From:To:Subject;
	b=ZFoaNkDD9yDpp+0iG5XO1uoc4OB3GooZe12USvCG17SyWhnDixmd3JHV0i9VC4ZJO
	 dgsKSy+jrk/A0DVIYV1uCglGQIy2yRP5cfVRY40xOSpHa4oBeTN9QIlT/PoHr3wQXl
	 GM3it+W/hwY1fR8O5hMpdau8JbP8UGA/Y/6JBTqc4ZzyrmTOpSaYeYljaiSetKXmjm
	 8yImwB925EL77xw9qBMaE32aGUn1/MCXLnNOrMh+WLdUQ+3494hwmZvXBnNsEcMp5C
	 rDr/K5Mkvcdv5fcDmji0d7v3qdixJK/m37CouxFc2sXNV0QBUbnX0wng63p40Xjc1W
	 XO2Q60DjnK0zA==
Date: Thu, 5 Feb 2026 09:26:30 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
Message-ID: <20260205082630.GA16166@francesco-nb>
References: <20260204143846.906385641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>

On Wed, Feb 04, 2026 at 03:39:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

