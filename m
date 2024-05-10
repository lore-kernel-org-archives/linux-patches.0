Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06EBE15CD7D;
	Fri, 10 May 2024 07:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715325092; cv=none; b=EKrURtat72MniYo50Dn2QoHYDxRx6dh030BfmvVscK4/J9wbQOI38gcPMdjXFJl/0kODb753AXZuAGlALR8OKRogxGQYRPenHSSDN8AnfGFGAaDbGq51Eaq7TPkn6jjI2HY62/OthUjVcAN8gFQAH3eL/kjYzLl7pU0RMQcp4OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715325092; c=relaxed/simple;
	bh=nnBkEADATwC2bFh8jaAMicJ3r9ra8T81itTzCr608lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9lQGYi+vYy+lxDBSEUiMDbTVCH2Vjd5tE5ZHc8xauyJXSmFSu+nB0ZjcTMD70ArExfSNNXupLQ3sWhL4xHijBH33NH7bYj/1Rqs0wwNKUrkCj4e7d7OUM9q6t6h0oLn2HWidsBwmpFbJ2n8RBwZufVYZWwZhWtiyiD8ZM8AbAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=PwDvwU+V; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="PwDvwU+V"
Received: from 8bytes.org (p4ffe0bdf.dip0.t-ipconnect.de [79.254.11.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id CFFA11C278C;
	Fri, 10 May 2024 09:11:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1715325089;
	bh=nnBkEADATwC2bFh8jaAMicJ3r9ra8T81itTzCr608lE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PwDvwU+VMnsVx6ZSoPFSzIX2doHv5edF1Y52oRsVkHLyjilqnE4GyYA4yEcgMVKUN
	 I2yoLuHcwg/iDZo/UM2Fy846VhyupZOcHwW1XTEuyAk6z+K9oBuCABRB//m5ftWyRb
	 j8XJFqQfb+nz3tKqA1OVmK5v2aaiwlwsappWKHvQiI+z0kfhb8Pn3BLHUjPxyfn3cI
	 Ie42tKJBnGyIb0NEOdq3DkTuP9bI04OKoYi5DD8KhsQ1+PrfTTOnw7uSc4qrfkS7c/
	 uyzv8awPF10eNLdHnigvqYOfRCg1ZP0zxZt9Otm8iVMefGAbqky/VWnucEIwGmghhV
	 kM1jwkSeZLRCA==
Date: Fri, 10 May 2024 09:11:28 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH rc] iommu/arm-smmu: Use the correct type in
 nvidia_smmu_context_fault()
Message-ID: <Zj3IoFN5SmCI9rjg@8bytes.org>
References: <0-v1-24ce064de41f+4ac-nvidia_smmu_fault_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-24ce064de41f+4ac-nvidia_smmu_fault_jgg@nvidia.com>

On Thu, May 09, 2024 at 02:45:51PM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied, thanks.
