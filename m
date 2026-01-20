Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D405249EB;
	Tue, 20 Jan 2026 09:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900761; cv=none; b=ktgNvp9OnAumcnSVxGdb50xNMjWHW3QnEvABV4ZmdWjVkHm8NAgfxMI2JE7y+nJNhQctIM/T8je+cnB9nbVwp6g8FT8EtmiCYEuO3dbltUKQKQXFHn8nj6xwa3hYm1nyHwkWEDao5ZRmLoWwZQlSWrzxtY8QCvbhmqNYOlYQzzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900761; c=relaxed/simple;
	bh=1e9mZsaiATXaIXW6CmBfDOFIo4cZshVuAw/kNN8Nwb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSmKMAdVNBA5IN3VW7t7xi9X+uqOaEgovqxmFdImX6yufecsf1/ODU5pyWGpDrh0HyvsHRPp9MSUFm9anSs6nEV7bWsw2PYobBaeClS+DHlpxFFn0KQXYa5v+EEpFvb8KUU6p7mmd2mEeMa63ZzEcHYg6MbH/SJbjnuyqwsQwNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=QtRuLDhm; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="QtRuLDhm"
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 04AC75E2F3;
	Tue, 20 Jan 2026 10:19:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768900758;
	bh=1e9mZsaiATXaIXW6CmBfDOFIo4cZshVuAw/kNN8Nwb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QtRuLDhmqskkqqQkOlNhBn4es4EF1Cz6/oOozVBEZ+8DZzjkSuayL//UKEpcKaBIM
	 yn51Rw7V4GvDGNL+UdVecTiTtDJqX4kPmlnyjPQWP6hpipB8ani/UtXLqMDkA2cjp/
	 jtb7xnoG0zWK2U9r93Yz3LsLRxQchkLPZG9BBpnIAIpA8hThb4v0kt2erWDdAxh0cB
	 XF7sUCp4DN9hVZ4gsMX4NrND0AYpMHyqKbsv+3do0WNn0Uq9mvYWUEShJZUSmPny4+
	 mptXcs8cLVSnCbXtmWnace4DbV2Nw+Rmt2UsouxAEADANUV12CESEBLe3K7JPA5XTb
	 2Er+8BAhLu9vA==
Date: Tue, 20 Jan 2026 10:19:16 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Justin Stitt <justinstitt@google.com>, 
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Chunyu Hu <chuhu@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH rc] iommupt: Make it clearer to the compiler that
 pts.level == 0 for single page
Message-ID: <r3isxjju2lbhezh5x747evatqyc352hworepwraaclwox52jal@ned62cmypn7g>
References: <0-v1-5b908a8b789a+838-iommpt_single_page_const_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-5b908a8b789a+838-iommpt_single_page_const_jgg@nvidia.com>

On Mon, Jan 19, 2026 at 08:19:49PM -0400, Jason Gunthorpe wrote:
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Reported-by: Chunyu Hu <chuhu@redhat.com>
> Closes: https://lore.kernel.org/all/aUn9uGPCooqB-RIF@gmail.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/iommu_pt.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
