Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D2E1946DA
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 07:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523501; cv=none; b=mDDfmALVMUTQy6jncviikUtUnwHFurBt6xR+F8Wu2nQP4UHyps4lxzcjabETcj7ExHA92rxOTFVPpKJVmHln4xJVgqh9ZNaGpywm3U5wfxKTRXhUDkqyxsawTPEEjzrxU9bPFfEY/u31bw//FKNCkO8HxDnfk/jGyptogcjFhg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523501; c=relaxed/simple;
	bh=57dc+1rv6+AWXx8ZhGesI25y7zW6BfoymQJLxbQfxe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6ADWsHg/VqINkfdHA/yfhhctmEXYa3yJijtf6whidF0ktLtUAdmsyjxNtzjZmtAIUYyBTYTPcLvLoXJcwwRzE7iXfFh9D66uPAhKoV0wmqWRFSd2Z22a0NM6b56CjLFn0nKjmXNjCBUHSEOrm8Zhq4u5769gpcWBxsTeEVXNMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Shdpp3Us; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Shdpp3Us"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 0677C22AFF;
	Tue,  3 Mar 2026 08:38:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1772523498;
	bh=zoUq+WxL1+1IXlpZ9uKIapxMM07hoNH2I/Jhsn30X/4=; h=From:To:Subject;
	b=Shdpp3UsGiLDLgN0mj2t5yNDHk5VueZ0+72Wpzgioax2sgkL3la6zQdbppeCWXWEI
	 GiulZcQbr+CvI8x3eO3xudxQXGknurRSw84hPXlmDNuEU67Wv3NLYVfcpocU3C1COz
	 Eo5xE4fOxkicOBCLkoU41Si+5aYDCE7eBAElBQGnefXP0UXWCjF+zgTw8PaycScrp9
	 7jYtOgJWLd8MVRo44vn0oyu7TOVcLKrLdeR2UoX4i+feoAsep1sCrlUdBtJg398mUz
	 FhJUDqR4SQIuv3Xfa4TCFw1nmVuIN4SxR1NjK8ZME1PBGo+VMItpHiWQBJ2eYevV3v
	 e9JZu/7p2a31Q==
Date: Tue, 3 Mar 2026 08:38:16 +0100
From: Francesco Dolcini <francesco@dolcini.it>
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
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Message-ID: <20260303073816.GC9569@francesco-nb>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:09:18AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

