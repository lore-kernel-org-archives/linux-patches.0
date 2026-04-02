Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0AB36E46D;
	Thu,  2 Apr 2026 07:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775115372; cv=none; b=mTXZBEWoNWSjdlVMpHE0TUj9ETsD3rIYHD8kPbBVuKfYnxubQQSja6WqDylo4dAXXuQHeuoPF7wsFrsxiWHbsDBCEz6SKOy6VOJPrXt+/LJXFTL+plFivbDZ0yyNG5SC1DbTB+GFGphhZuyrYWssb6k7NGyTBv/gRsd3bhCF0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775115372; c=relaxed/simple;
	bh=mqWV3JlY3aJsYMOVTGFTC7ckdC9nkLHFj2myWjU9Byg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUq+gc+NkUOADpei3ao7rCS5ujvPrqVbQ0WPnK4RBrv9H7A2XgCPpgCp8uS5utzsbfq9h43RMVDbPvR4YE9WYbdAEt+DeylUgduG4XXdxfkohaNKx2clI+194v2lAxPHx+RhUYcUXAy8UcddipGYMckocdMEOl0KJ+ED4yH2ELI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=LEi2RUUy; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="LEi2RUUy"
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id A0DBA1A7158;
	Thu,  2 Apr 2026 09:36:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1775115369;
	bh=mqWV3JlY3aJsYMOVTGFTC7ckdC9nkLHFj2myWjU9Byg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LEi2RUUyCAMWWB9Gsz8YvnhcVw3I5hwB2NV5rigwkJ/+yRO1P/7E/eR8igXqMfSAe
	 ibGReGFjxDZ/dVSEzNQLqpWEjfHeujCq+AWH5+Cw6a/7sySJjHS/BnqBWhQ9/QM27+
	 0ifdcl6Bj4ZL4ajQCgB3VMHXd2+aSxTuoi68gPj5UERqHw5okU5X6/i0zW3VH6K3Dj
	 hOmjyQFNZIs5sv+5gGQGuDtNClodIgUlOP3PmJJVsfkK8cdihuq5Qv6IcgN/uaSpaa
	 hvuSryrAzIjNSRPrcNXrruevbfBXplO+/sqiXAM1nkKkJNw0PmcITKaT0bKTzSba3d
	 HJUx5TBas7Ngg==
Date: Thu, 2 Apr 2026 09:36:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	iommu@lists.linux.dev, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>, 
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev, Tomasz Jeznach <tjeznach@rivosinc.com>, 
	Zong Li <zong.li@sifive.com>
Subject: Re: [PATCH] iommu/riscv: Remove overflows on the invalidation path
Message-ID: <necasbrohxayccg2jlgqjnmvwewlur2beiqf45hac5rc3xj6ww@6fmz3arzbbub>
References: <0-v1-0f76ffba5af6+11540-iommupt_inv_riscv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-0f76ffba5af6+11540-iommupt_inv_riscv_jgg@nvidia.com>

On Fri, Mar 27, 2026 at 12:22:10PM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/riscv/iommu.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Applied, thanks.
