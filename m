Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840B2F9D9
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 05:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775712871; cv=none; b=bxGMN96tKg90Z/ktRhBIioBuklneG1pLt/sHRfvNVkTkSFC+HHrZvQRkBOTFzaONfo/NUCv5Srlun7vtN7IVG/4SGBye6PBYD/v2Bx6rTIahI7WIJouKqhwGpzZ6qNz33aAF6Tvk90tZHoIYsm9EldciiLRPNVeZx6sTCaEJB0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775712871; c=relaxed/simple;
	bh=Mkg9Un5cgB9NSPjlEWpDDQ6+9KN7WP63n44zvC/hwV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byjpnVr4/JAQ/iRUurV9Z3y0lb8EOockQVe1oozATRw6IgxXgaF7SC/xxKUigbUb7ze+OKPPn7n/OfJ0KHqe9gGp/u/B7plLZ34F1DSj6JUxRxcKfZ5JAa2LYMuwj43HLg6AHyup9IxEEuu7vvQyXVxgEWheH4csIc+qFu2jLzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=gR7VliGG; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="gR7VliGG"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 8CD2826D2B;
	Thu,  9 Apr 2026 07:25:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1775712357;
	bh=No/JPx6toaU9+Gsaaj847WA34STwbHrqa/N+FSBUp7c=; h=From:To:Subject;
	b=gR7VliGGB/jgjgBqjre6or55ModvI0ct+XXqbb5WJAwBKg0pOUc0Auuc4v005Vacr
	 ZvWoomZdusP3ya3t+o5woV3BiyBa4AhtUCf1cZl3r/y+TCdj75V+BcXgJvSYRoaIA0
	 7VdG74PkRTbBzwkflgQLz0omLZ5mB6F9BM9k9mkalCR/r/Fh8R8zhuV/HPEtoh5pYz
	 iv/ZQXsdu8mHlZvrUhwPkAUnfdenE1ljf3yEgx0rbyU86ssuMbZVqP9H+3gqRWAZLu
	 M1PW0FkN1RhnhIkKHynM4bGw8R9zhBkORAPMEmt29ETIJthnOzyqiTR58HRxrmF0tM
	 UUADMqAeb9Rig==
Date: Thu, 9 Apr 2026 07:25:52 +0200
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
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
Message-ID: <20260409052552.GA4932@francesco-nb>
References: <20260408175933.715315542@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>

On Wed, Apr 08, 2026 at 07:58:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Verdin iMX8MP
 - Colibri iMX6
 - Colibri iMX6ULL
 - Colibri iMX7
 - Apalis iMX6

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

