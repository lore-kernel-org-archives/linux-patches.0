Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9C53BE144;
	Tue, 17 Mar 2026 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749702; cv=none; b=tqiUV+d991gh6C4ACguS9wmwIxBrfL71wP40Yl/VfQxW8UWI0jADKA+8SSyawq6rqeZVROw/gcrmLAgDY0a6yoxLeuauRRRMUbN5jOmHm9l9nvx3pIsDao6/vN8ICMLJX2b80O3qkDhkW4WKwDOGZMRt1uJBCs1VOEhDNtWdir0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749702; c=relaxed/simple;
	bh=uAKahsM/qJGr5KlT8cxvZposlshEw4Sg6KAtjjfWjMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2nGqZgJr7M+9BdFQEivqTClMGHEUN3bOlyFtJf9Vm7HAnWDCCIFmRh+ZgBrOXvFOy2t8udXe0B10pKXp6g72CN/ckhUjL3NxVBhO25nywi9rGZdP9ESxPl65iz5qbnvkldAssBcU0DJ5PF9dGJyMm+5XTlm0A56Xl9X4NuS878=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=gL70x0AH; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="gL70x0AH"
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 4DD8F1A3FD6;
	Tue, 17 Mar 2026 13:14:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1773749699;
	bh=uAKahsM/qJGr5KlT8cxvZposlshEw4Sg6KAtjjfWjMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gL70x0AHPs4b2MXLmZcfKMG8XHMhjQusoC21eu4NG4CVOhElQ9MGMAmnAvuD2ueIa
	 xZ972IBnjrY//f+clncSB2uqqEQ4n/kg7BvJevZGHsGftVRvAOExXPaaLvhtyrPozA
	 nGm7W/Enw0cVPhUt3LX351AbTgZKfxMXhvSLS4vAL6x1tDRazU6TPtwFVUDparXMWc
	 dYfkUDJVlbdyIWiU71spAP3hp9DenKTDjlYF2DU0DYcHJf6i5kOnGHo9WPpLcRFHVF
	 r5ZIFD5OxSzGBC622hg+jVVB5UuFg2PBDRZN2hIjBSYlDKWHqm8Ug0wz42KKCgvcuK
	 AS9J3iabHR6Ow==
Date: Tue, 17 Mar 2026 13:14:58 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	iommu@lists.linux.dev, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Joerg Roedel <jroedel@suse.de>, lihangjing@bytedance.com, 
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev, Tomasz Jeznach <tjeznach@rivosinc.com>, 
	Vincent Chen <vincent.chen@sifive.com>, xieyongji@bytedance.com
Subject: Re: [PATCH v4 0/6] Convert riscv to use the generic iommu page table
Message-ID: <3ottjudlj5f6skb6oopihesuuio6oexs5ycbajxluihdzj6spt@3quz35c6eddf>
References: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>

On Fri, Feb 27, 2026 at 11:25:35AM -0400, Jason Gunthorpe wrote:
> Jason Gunthorpe (6):
>   iommupt: Add the RISC-V page table format
>   iommu/riscv: Disable SADE
>   iommu/riscv: Use the generic iommu page table
>   iommu/riscv: Enable SVNAPOT support for contiguous ptes
>   iommu/riscv: Add missing GENERIC_MSI_IRQ
>   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST

Applied, thanks Jason.
