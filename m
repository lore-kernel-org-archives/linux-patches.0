Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A182335DA63
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 11:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775043925; cv=none; b=aP+tjlO9vLAJybCzLh759z7mUUL81bXfUdbWfMRSFm75NOQJB/6QnmNkRlnh2OGu70txUuy3/cRnamDhCjsNMIzckytyVxcTHRZZNKtWSIMy4oh9iVhT1dAyfOmn6XnrRjaWn2J8Ovu7YeRoyoWv7TLILdZe4xoKtC7UwS/hU4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775043925; c=relaxed/simple;
	bh=4jo6BTETHiyWpccqWA9MPJzlgYWvkHD6JRRiyt0kkhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ga2qrGY18pHDq4DDOO6qfjnncv4eTYnFLvoNwkFOUYKq8W3mL8ipnmcwGzT3wwj/LDqU0cMUa3liPHWfS05Dj+g0Z3cbpqvN+39v9uW9tNwuYCB8NcHiM3QjIpHO4Bw9SSOS+f3lJfRybvav4bTZbiqKpQ8C/k8imKi50OZ76nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=X+SyGWSq; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="X+SyGWSq"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 433FF1FF70;
	Wed,  1 Apr 2026 13:39:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1775043551;
	bh=6qNd9bnbfnM+lpsSSdxoEjL198lA7nJU9UOBNjk9UHw=; h=From:To:Subject;
	b=X+SyGWSq4MOzfX6jrM4brwx1EPv0L+s3XnM7FUUHfwdAMLeXHWSMpMmecrGUDWesv
	 mDp2ECfFgiARMZD8JDISJZWZBX9kqlNj+/FsLySWYVbiDToU7YTYOVZ/E7kYJaVSwJ
	 POgyqRoIXv3lGNnewA8UgTmrC+oiAVbublFRJcbLXmn5MHOHlx+7F60sSodK5qU08A
	 9dChg0suW9VlshMXmIEUD2r2j2lqQLlpqt6eYl3Te58kPZPlk4zIhmvLQ/kQa4+ypQ
	 hHoUNuFAFbpLuTt/gjwAYySKfXtEtkmlIveWS0G2HP4i1dmdyImj/D+Uv4N5+DLN2I
	 a6IGKulbSOl/g==
Date: Wed, 1 Apr 2026 13:39:07 +0200
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
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
Message-ID: <20260401113907.GA23291@francesco-nb>
References: <20260331161729.779738837@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>

On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

