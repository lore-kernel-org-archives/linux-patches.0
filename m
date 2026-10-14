Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4F84E9C13;
	Wed, 14 Oct 2026 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985436; cv=none; b=WdARNde6C89LvffuTyfTVpSDFhQrJUtdIR9jb0w/Imbx5mDpObB/kNpuqILF8h0EQHFq3FaHM1FDeb6JJZhlWW3BvG3K/wxNR44+oDkVS5hoWSMTdDFsOq5mXNP4Qz0C4yC8HBy31A+vxyK/xPN7yuWVZgA4L7yCmvAeN64/RwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985436; c=relaxed/simple;
	bh=y0YPesD0ZaFM0SAufa5leh/c1CV8HTUIDQrJ3EWms70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpRYUAKp3y227qZd8Z5f8oROxX5YPCvYJmNyzAUv95ZgXa264G1UG6rXX3yhmnNaHDXvZBV//6i2PvEimPdY6mM7W+V+e0hJnfctfjAtBZgtmdUSdaLbD1LYmsB3GyE5QK28189vIwPcMRtN+A14G2EA8gk5sBxqfsEAuPVnaxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af404a00b07e11c7dacd6f16.dip0.t-ipconnect.de [IPv6:2003:f6:af40:4a00:b07e:11c7:dacd:6f16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 333971C7802;
	Wed, 14 Oct 2026 15:43:53 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:43:52 +0200
From: "Joerg Roedel (AMD)" <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	kernel test robot <lkp@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev
Subject: Re: [PATCH rc] iommupt/kunit: Use if_changed_rule for the kunit
Message-ID: <as-G_wceROT0osZz@8bytes.org>
References: <0-v1-fb494403c1bf+137f1-iommupt_kunit_kbuild_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-fb494403c1bf+137f1-iommupt_kunit_kbuild_jgg@nvidia.com>

On Tue, Oct 13, 2026 at 10:13:30AM -0300, Jason Gunthorpe wrote:
> Use if_changed_rule so rule_cc_o_c runs cmd_save_c_flags for the kunit
> objects. Without the saved flags CONFIG_LTO_CLANG_THIN_DIST runs the
> ThinLTO backend with no --target and generates x86_64 code from arm64
> bitcode.
> 
> Fixes: 1dd4187f53c3 ("iommupt: Add a kunit test for Generic Page Table")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202610110841.120JzAJG-lkp@intel.com/
> Assisted-by: LLM
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Applied, thanks.
