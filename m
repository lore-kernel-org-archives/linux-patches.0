Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B6132720E;
	Thu, 22 Jan 2026 07:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769068582; cv=none; b=YDvecusH55+GYyhBpXcoDqCoIiDQe3m75L0rF2yO0PAySB1ewvs4zj1p13iOQADLFakvLIs6g8G3lg7z6Ynwj8TKeN5dX6dgMJd1i8aDgwnQpmgEvOPU85W1E566gkiduYrO9FXlZUyZsoT7pAYLVieLtpAyhd+Sr7AM3JUMQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769068582; c=relaxed/simple;
	bh=YJic1/XLgE96fzrxFvELH7XvK4WNcmG6B4CpNmXzS8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UT30XAqbPs59/jGu08TTCiRcvRU9Pv/03wzYPpJfTcyNyH9DOa5E6zhfp/biMXJRm5MGvJ+On8IXNu5kpXJbLe/ZexJYoAw3P0Ubn6apP624kUg1oZeQYC6HAcJUU4NYHchD9fvZQlMCyePT+LJuITZ6U88QU35H7QqE89nSz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=KhMVwVRc; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="KhMVwVRc"
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 7C1181C03E4;
	Thu, 22 Jan 2026 08:56:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1769068573;
	bh=YJic1/XLgE96fzrxFvELH7XvK4WNcmG6B4CpNmXzS8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KhMVwVRc9f2h1Xmdana7v4gRcA+ULRSJdCOUCZTS++WvgA5jydfggsztHuq5BAjSF
	 BBEJKltix0gAywoM7Ck1wHofbpNH5iNs8QU/bOPkUNgLfg/waClrLZREbbuBaboZ73
	 tdmfjzS3CFWCeeOLidAtieVaMLbnByW1grp1Adj9sxFxr/M2qqbwF+/mdUhlCI1FKe
	 NOBvppWc2xyjrjCyS9V8zHBjWfbw2k1vj1jtzFkVMOgZIbvAxxUD0x1Jt30HIgyybq
	 F7fAxuW368AWVIzKHGidk+ewgNwer1xHAuowrJsKP4pMUvW8xde8Y6mcQqaam9zFdt
	 AMfscVcSbKzzg==
Date: Thu, 22 Jan 2026 08:56:12 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Tomasz Jeznach <tjeznach@rivosinc.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, lihangjing@bytedance.com, 
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev, xieyongji@bytedance.com
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
Message-ID: <72olk767l4goaqsrkyelhtnzg33nxbtwnammy4asnqxukbolnh@gwypmg6n5t3e>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>

Tomasz,

On Tue, Jan 06, 2026 at 11:06:44AM -0400, Jason Gunthorpe wrote:
> Jason Gunthorpe (5):
>   iommupt: Add the RISC-V page table format
>   iommu/riscv: Disable SADE
>   iommu/riscv: Use the generic iommu page table
>   iommu/riscv: Enable SVNAPOT support for contiguous ptes
>   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST

Any opinion on that series?
