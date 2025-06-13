Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1BB1E0DB0;
	Fri, 13 Jun 2025 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826799; cv=none; b=DfvBMFK5p4zFfjFe2RSaZBF97hjf8587rubmAIJ82TkB6/Ilocvc2+0vaNodEX6XqypPlRblD7ekScydQdGW79yFAuB0bcncXyqVUxZ4KulKq+qRcLbeh7D87K9fQpb/6T79Ow6Vo8X6tkkJ/qPw32GEtNpLYieoi8ZcSe4nw0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826799; c=relaxed/simple;
	bh=3ppJWzKDJi1wtpzhO66WoauQQqFh1eRKXyoiEs/PGmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXM0c/qWL++xSfr2a9QBRXA/aksa98s1XDbR3yaUww/P0dBAQIb4f+jNNVbxFdeFxARMjhQysVWjG3X3W40AI6PdCewkE8BUzv0BqRFAQGq6RZqpincLnjhjNn1kyyFnFR+I7ZvGOGa4JlrfQ/Ai67K3HZLPKA0WQlcJquj/Rnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=NJst9FHW; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="NJst9FHW"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 0596E4DD71;
	Fri, 13 Jun 2025 16:59:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1749826795;
	bh=3ppJWzKDJi1wtpzhO66WoauQQqFh1eRKXyoiEs/PGmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJst9FHW4pYQByzRPbryjkSdyIkisIJndEKIH8BkrIKQ10wkvBIsF1uCHdPLDrv9L
	 ZUu1uMYlkHwAsINXbyKDNYk2LRBFAbxZ9S8I0y+yreBq1YeB/ipNz7EmEKhPJ9eRu0
	 X6VOEcC+7cgYhMKaHIRQ5OZkNa+x07uHepeDITQkV8NDgfD8eaYnKnd2T1xnn0Anl5
	 CRq2G4xeFwMizt+n1oYa4cXUCuU0dn8nz9LUMO1nUm4rsniQzD/TDghBH6Ic8zu2H2
	 Hut0A/O6B7c8kHj7UGty5mVCtN6lfNQJQaFDrDn7FL0DPXamzb8Kap71k3CjpcmMZS
	 h0u3Zf45CaOjw==
Date: Fri, 13 Jun 2025 16:59:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/terga: Fix incorrect size calculation
Message-ID: <aEw86Qacxj33dv_X@8bytes.org>
References: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>

On Tue, Jun 03, 2025 at 04:14:45PM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/tegra-smmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.
