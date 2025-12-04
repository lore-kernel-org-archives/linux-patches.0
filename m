Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE9398F8E;
	Thu,  4 Dec 2025 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865464; cv=none; b=qu3e5dHkFNwUCdCKLND0FK+mI96K3/IwXloju7xax7Ne6ZaHCPFNDoFfbUc5vGjBWPObX1+t7S7dsU+RMe8tkDpJwATjm7tQ2rHoS3qWLHkQDQhgSdStOEKLe1Mnd8D1qEAjkoegp9JobTmkOU4bQyaOapkiYKbt06R2AiDihn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865464; c=relaxed/simple;
	bh=cBAi73k5M/LbMrvTmfP21IpHLK7WakRe8SwnFy7o3bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9SeyW7eG0yQPjZfTXUuvnzZuloxvInGA83Ky6ErbulnRyLkQY+Ptl3pPHgxbdK3nNyYSlK8Nz1hxomMs1HL0tYsr/FBOOq7rlGl3aGDQ4prM2Qu4u0CMCeBlT90LOFwfhwS1ZTVlC3IUoutYw3ptmadgH1cKDQWGxfe3uXex0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKUff5LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKUff5LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7559CC4CEFB;
	Thu,  4 Dec 2025 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865464;
	bh=cBAi73k5M/LbMrvTmfP21IpHLK7WakRe8SwnFy7o3bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KKUff5LUeI/VcFh6i9GXwXGyRw//sRfM/MTup7vsDPfgot+c1IfB/tFTp5UXSshU0
	 HEQA45rEwDOg5aROJ3s4XcRqIFSHloXgVD8BfYik6ldXylAYEVExZ9DJKQq1OIUv7r
	 fuhFBXGVGGEMHGuVCiC/VQs6TnI/+nj8ZrocU6hQ=
Date: Thu, 4 Dec 2025 17:24:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Adrian Hunter <adrian.hunter@intel.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
Message-ID: <2025120401-sturdy-passable-859c@gregkh>
References: <20251203152440.645416925@linuxfoundation.org>
 <CA+G9fYuoT9s1cx3tOoczbCJDf2rtrmT1xSg-wut5ii6LG6ieMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuoT9s1cx3tOoczbCJDf2rtrmT1xSg-wut5ii6LG6ieMg@mail.gmail.com>

On Thu, Dec 04, 2025 at 04:13:58PM +0530, Naresh Kamboju wrote:
> ### Commit pointing to arm build errors
>   soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups
>   [ Upstream commit b9c01adedf38c69abb725a60a05305ef70dbce03 ]

Now dropped from all queues, thanks!

greg k-h
