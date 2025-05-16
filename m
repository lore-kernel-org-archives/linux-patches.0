Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031701361;
	Fri, 16 May 2025 06:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747378341; cv=none; b=CLmlrfwd9nzAjaYCwc1J/GsFwlbTEb8l1Yfdth8l3LH89abvCyj8QQc130lA5LFgRGXCIHTi0CE6KcHyc/srP+IvI4rlzQfk0B3XbPK0RCqTifxD9HOgcLK409scdxqftI0VFJJPP9ilpErbCvWCgyePUydh0MgXK0Wb2aqkxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747378341; c=relaxed/simple;
	bh=xJo7ltF1BGpnuPu41xTiTXxFWYM2GQAGauDeJ2u+2Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcWgu5fWutX1eRQ3+XnG0cJuTdVddlYip07ElmYCzxFOEHvU9iRKwfPVCsYF0BKY52eucRqGUVL4ScCSd6HNv530KaVYJKp+u9Pb6l5nZR2EtWUtwr9dJV8bp51n7Osn8Tk9jJy3GOfeNFJvSQkwlx7e3detcAbvPuBn5YozoUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=80zLoI0O; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="80zLoI0O"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 96ADF4B709;
	Fri, 16 May 2025 08:52:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1747378336;
	bh=xJo7ltF1BGpnuPu41xTiTXxFWYM2GQAGauDeJ2u+2Gk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=80zLoI0Orf6EdyvrNQUQlgpw/uvUsp73lXKqUCKSi20RkcRsk+u/pMZ+9znlu21NU
	 FnTQTSHmLQhTX4kuOnY2vZpYOjzVrjD1CQgl7EzDc+eYlmnBL0lDI5Q5WrxPA8uJ2H
	 fAT1zhPJy37o36X9Gl+Yx4biOm79zsd4d5QxwkXpndKVZQXqvoMTPniQJx/z2EmPW3
	 ecwtDiA6TMDugLGuLU3rOJ0QGWplbyV3JWYrUSBjnc34OJMjwtYySfQG+D6jhrdZKw
	 levDZFu4h6oO0b8GpzJL5gkn/sf0QLnYn6wziupW+6Bkn2xA46eFig0g6tt/wslFpr
	 yG6lxVx7Nmljw==
Date: Fri, 16 May 2025 08:52:15 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Joerg Roedel <jroedel@suse.de>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Clear the freelist after iommu_put_pages_list()
Message-ID: <aCbgn3fZrSZbl-V0@8bytes.org>
References: <0-v1-7d4dfa6140f7+11f04-iommu_freelist_init_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-7d4dfa6140f7+11f04-iommu_freelist_init_jgg@nvidia.com>

On Wed, May 14, 2025 at 09:48:55AM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/dma-iommu.c   | 2 ++
>  drivers/iommu/iommu-pages.c | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)

Applied, thanks.
