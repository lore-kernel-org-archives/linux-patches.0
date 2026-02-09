Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3771C134CF
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660941; cv=none; b=XxnE3aNeirnuqZHOYbbEZWCLh+QI9ktV0SNcdDXME2e9hGzGpgaQ/YaAigmX0HHZMhxoNIZ7CB16pMpmQ8dHku5l1rO7ZkdsCwephtnz0Dn3oUk8DllRTa5s9L1itBjONHZvo1ohlUG/W+LnIBIF0m+OGTmcnLOJ9H/uKofnM1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660941; c=relaxed/simple;
	bh=MfuYM1k1hkCOLHN+jXtIQy91k4JyxDXZIxJ8MzvM5dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBSVXIkjGS7WEEK/7fZCMhpczBgOnqtCpBwmZ4Z3lar6+vpIiAHWV6WtJQ642gkLTYOmqAJy864c9valvSq/FDD2sFRGSXAQkpEtOKErozRJfGY62enVQc0XjzGZot+FkcsMIDorZ+rK9EQCVHatezvfVo7oQGrsB0b0J6+Y2iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=O1jib3iw; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="O1jib3iw"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id A5A991FE29;
	Mon,  9 Feb 2026 19:15:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1770660939;
	bh=xf6v0wOc3Dw7qm3WTMUMVx8nBP27yXFa5RJFU86dcM4=; h=From:To:Subject;
	b=O1jib3iwsTwtcVrj0+FYXoVsnbnsNYg8XZKAZ7UUheo10EPQCWjiJBWV0F2Ud1Avz
	 Fa/Z5tYMnAjQWfAO4Ed2ZV2p5GzY98qE+K7847gzQajKZci1elYd8jOWhfYSXVBZIm
	 tQXXi+pdYpBEb5SAq1OnBWg+KKhJxQhGaH+w5QHLvm1MUjR2buUSezCM8qBJ2gHb4f
	 RsT8VBbJywv5IkHX2SL2azlwCWZuT06HhAaonNb6mUy28UXJsVi52+6zCi5xFT6ZpL
	 JU9G4E5UH2JWS6J8lrr0I8DNU0H9Bp0mRWCRwK63fZua6zbw1NwoRT385oYz5rAq45
	 B+dzso187w9Xw==
Date: Mon, 9 Feb 2026 19:15:34 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Message-ID: <20260209181534.GA430273@francesco-nb>
References: <20260209142304.770150175@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:23:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

