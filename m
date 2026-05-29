Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48419346FAD
	for <patches@lists.linux.dev>; Fri, 29 May 2026 06:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035809; cv=none; b=g1DuAYRd8/JWsstYWmvcU4J+E5gRHn9maPmnfDLlvKDtHsM4X8SBSPAGTIkenMxqc3Fy5i/hIKF6JRHsLYivW/Tdc+hRnu1vMvw+1vOAprc8yspelAT7ythP3L9eqT74f2oH2BE58W5HchYG8Bpdbxn54fMYJ0BTs/+1UAYAc/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035809; c=relaxed/simple;
	bh=Nt63wxbAy8bs8dYhkxGT3I+5Jid+IdEDLj4QP1oiPqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=juIIekQip45F8HovbvF5U1NBKe3gpJU479elPF3y+dVVa/xIM5HA7kpvI/cQjpy5r9QiK1smLZS02fY9zqyXhSywBBW4N6hvYBRofERkJXTZx1xRrSh39GOysnsG/2JjLgFRSQtbyazogORIC0S+9wYJ/HU5Wn+CH42T8ZGCfG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=jSkzuecx; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="jSkzuecx"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 0C7FA20E6D;
	Fri, 29 May 2026 08:23:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1780035803;
	bh=6ekWEv8EpjK+ZbYox/6ZLNvXibxTf7rZjrKm2MtcN/E=; h=From:To:Subject;
	b=jSkzuecxWbl6T8ZVjRW4hbAEsPA18RlKDB95zfgjN9E1Hc89Ya6UAAK/zGWYzAN3G
	 d7UC7gw9Fs004Wddv5V6vixqdAT91sAAGEfUlt5xdDgZBy/owrq+w02s+cueWb64vk
	 PE64Al8eZDX1rvxFdhSziUJeWpEHLMa61epA0sNijJe00BZi1y7MYarlObjxqQRmEw
	 5mQLhdIE+J0TNNQnhAxx8iul3tZvj2cuL82O0/6uuae/gy0zTFI0t+b+CjZVQojiqH
	 MTqof9Dt1ibpogx7pJzLxOtCYfIM0kKmthWKifq8r6k/5H5YYgKWtvM35J63gkkUHX
	 g2umneuwZqysw==
Date: Fri, 29 May 2026 08:23:19 +0200
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
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
Message-ID: <20260529062319.GA11349@francesco-nb>
References: <20260528194629.379955525@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>

On Thu, May 28, 2026 at 09:46:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.92 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

