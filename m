Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912CB2DF703;
	Thu, 18 Dec 2025 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766053993; cv=none; b=lg7IA46Qf4oeUqJ2IwE9xgiTed36NSdWoNGduhO9lS6ED+StIA9lrZZQkn1HVf6fwlI4XfPgGnNR3IX0fiySHHEovjsrr8eqH5c2RcyfM6aVEjtThm3E/67tusB2A4qu0r1aHqAORbPx07GEA7EhRH8F9kkKM+fLeIHXXxSsGkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766053993; c=relaxed/simple;
	bh=jTRzKZS0NL0uNBu6fLbSCUUmW0GosI5KovBJurrP5IA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkT6FfvGfOx2Ob+iNzLnKV0cLbuOOT/02zFjei9QAXQynyy+UPRXwZqBO/rSKyXLHbhiMGCpf3EqNuSYOxjvBeZNRLqmw7yi+r5mca9rX1Nad43C3s569IvTdKGcabLHdEM79U1EDfJVEdHqQesHtaq2NLdAL4VWEC+dC4SWFmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=I+rmRX2R; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="I+rmRX2R"
Received: from 8bytes.org (p4ffe00f4.dip0.t-ipconnect.de [79.254.0.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 075FC5C364;
	Thu, 18 Dec 2025 11:33:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1766053988;
	bh=jTRzKZS0NL0uNBu6fLbSCUUmW0GosI5KovBJurrP5IA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I+rmRX2RI2ZS8oUKC6cklP7xjnHMdZnB3gUGj7ByxrHLl2Zif1pvXf9hbIejUi9AI
	 fOeEQ7diLPO1uSI2HDo2/U3G0hHNIsqaN6vXcv9BsIuN8FZ5GC83UEYEOht0AmgAu8
	 NtEMUTZWfn8KQaY0f4avU6VOomOt1jyHYZYaawTQd85ez9RL0l6YynPUWaNUz4MycL
	 gCJ5GwqsINS/DPrTypt1th20ro4GoOAIUfcuC+HTZAwgqiAlMKO71xoImn7fc8KMhr
	 Nh5Tft6FfScDserzhJxZT/kMHJneAtKxOHO1/aI9miZ2yFcKYahaDd9dwJksW3Wjk5
	 yhTIC9SSEqfNg==
Date: Thu, 18 Dec 2025 11:33:06 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>, 
	syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
Subject: Re: [PATCH rc] iommupt: Return ERR_PTR from _table_alloc()
Message-ID: <epidizojefhne3jubm4yish5wdcsrmoeppnqsdp3hfqfvma7xs@4r74ez4n67fc>
References: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>

On Wed, Dec 17, 2025 at 01:43:04PM -0400, Jason Gunthorpe wrote:
> syzkaller noticed that with fault injection a failure inside
> iommu_alloc_pages_node_sz() oops's in PT_FEAT_DMA_INCOHERENT because it goes
> on to make NULL incoherent. Closer inspection shows the return value has
> become confused, the alloc routines on the iommupt side expect ERR_PTR while
> iommu_alloc_pages_node_sz() returns NULL.
> 
> Error out early to fix both issues.
> 
> Fixes: aefd967dab64 ("iommupt: Use the incoherent start/stop functions for PT_FEAT_DMA_INCOHERENT")
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Fixes: cdb39d918579 ("iommupt: Add the basic structure of the iommu implementation")
> Reported-by: syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/693a39de.050a0220.4004e.02ce.GAE@google.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/iommu_pt.h | 3 +++
>  1 file changed, 3 insertions(+)

Applied, thanks.

