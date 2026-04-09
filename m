Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAE02FFF81
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775720286; cv=none; b=OQ4w2uOCvXZJIVWFrKsLlpEwVAWocHA22ApvzNeTeY6b/jKn/P3NRlN7AgPeSdmsgzVhRfi8HQHJ2FcWyWc6Ql2Mf8gvE8VEq5iPYt1G0BymkI132CR9x7vh2QapEHgykc6VEiEw7OkT3yUnmMRYjhdzGFr1glacVM49w66aIcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775720286; c=relaxed/simple;
	bh=BlSCTi6nsCyyLTqX2bs79ozfG7AIrAlBBm+tvYc6RS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqV4Twj63lKvC6kgEQW6QnaoT30T94GSCb2cfm07kd/gUsgDWWPv9OZCT5LEv/AUcNOEnjN1plEfGMlVlS2VT1AvXRPphtkCHzJlzn9V+jQ/ASYTYHXX7qAhU5IIL/B9auhN0bYgbyy+qkzdU5VbPV0M6XkY215sN30siu+A/zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ecagFyBJ; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ecagFyBJ"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 237521FCF6;
	Thu,  9 Apr 2026 09:38:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1775720281;
	bh=Q02o/z9ztangTxn0WhfPvglX7oybf+r8cpY7+/HRFS8=; h=From:To:Subject;
	b=ecagFyBJReiPwhG4SPxyAupaDT91sAhfjSDCteRwpSDslMvaO1GRtmSGZT3UTUzgZ
	 f9TZRMDsls3sAuzEVEjBQ7n9u4q4oa5i23DqodQhYyTBU9WlGqI2HRcDm7EkZMKLW9
	 tfFRE4AAgzP6OI6NFS6osx8QHwFfj4vpcKGCPhq87gwRizhsekMZmHehpE/y8AzVQI
	 Tc5TYsxVuLFVhuD/j3/+JyKJEgUctpGnyrT8crFczjITbOBBwa2Xj717KYnpdrdBjo
	 5biCa4RTddG4slob6CdoLJLbaWRDe7dMzbflTBdLq1zhnMrTBRUa2vVH3WdJ6I6s/7
	 QfUvXBBE7Fsjw==
Date: Thu, 9 Apr 2026 09:37:57 +0200
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
Subject: Re: [PATCH 6.12 000/242] 6.12.81-rc1 review
Message-ID: <20260409073757.GA31878@francesco-nb>
References: <20260408175927.064985309@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>

On Wed, Apr 08, 2026 at 08:00:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

