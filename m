Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963F72512D7;
	Thu, 17 Apr 2025 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900840; cv=none; b=ewRv94xBtNQQYWOYXxmN9eSQB2jIAqt2WfmMaPzKFbDWWYRaq6g+sSlmPNmVudSJTjC3EIeueOmO/mZJJEbgTGI83ouegBg4jmb1G4QCoHwiBiIwn8yCYJ/ZrkgrJhT72H9iIbcrO+4/Yajev7vbxRsbz+o0kzz0bSoBE69B7U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900840; c=relaxed/simple;
	bh=ZkCqmSbXt1v3PVfUXnyy4jP63qsdkBbj3FBpkdPeHH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F64vNd1VsTbNTIzFyKHEvHQr/8YMu96b7ZXsqg5W9rkng7N26ewbaxpHn5JWfayH0nw2ZMu/HvaAlJAA5w+8cJlnM+njhbd3wJieqn5Hn3/YchAQqLF7B00yI+OuSm+VPIVVyDLl95eyw2QHPSQSlCDbePAlXNHwALVCLmn0J/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=3uWpx2LX; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="3uWpx2LX"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 06A4448658;
	Thu, 17 Apr 2025 16:40:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1744900837;
	bh=ZkCqmSbXt1v3PVfUXnyy4jP63qsdkBbj3FBpkdPeHH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=3uWpx2LX4TTFi1PE/0XADmLNcMTSSgp6V32+y7Jg9w1nRQrdFpRAshKO/MlaYKmzl
	 Kttyj0sv2jvWQoOp8zotVwqMMlAQCKmYCNbPML6UF1D5se9TmoU4CvIYYUB7WJ29Hh
	 YCuyKsNnf2Mmo3OXZNrQmDlvgN/8GOUwV5PxfpzWW4NZ7ojBC28SJ+XuDZZa64pU9V
	 LdeFxt+6nerOumveCriRC80bM6PcRXDa7RXPSV0aZTjN7pRdclEJwA0TMtL9zXx/XR
	 PfZwVAfOpjAzu7vbS5fzJ8u/XVNitcdYRjWNcN+VNsc8QUkdsVvI5kkKABr62vC1De
	 GOaeG/ITg6e7w==
Date: Thu, 17 Apr 2025 16:40:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Neal Gompa <neal@gompa.dev>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 00/23] iommu: Further abstract iommu-pages
Message-ID: <aAES47w6yaRDFsLg@8bytes.org>
References: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
 <aAEPWXaBocqgsvbR@8bytes.org>
 <20250417142752.GH823903@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417142752.GH823903@nvidia.com>

On Thu, Apr 17, 2025 at 11:27:52AM -0300, Jason Gunthorpe wrote:
> I haven't had much trouble rebasing it, so fingers crossed, thanks

Forget the iommu-pages branch, this just makes it worse. I put it
directly into the core branch now for everyone to rebase on in case of
conflicts. This should avoid some of the potential trouble :)

Regards,

	Joerg
