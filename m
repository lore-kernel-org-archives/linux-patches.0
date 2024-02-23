Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4F282882;
	Fri, 23 Feb 2024 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703139; cv=none; b=WtmD0ZequGpg5V7XiWFOzuEkbH3CFFlDA/uyNMq4Z0j2IG1UiS6V/doGf0cH8E1dPO6OgZx8SjRmo1V/LSYMF3z9AtTTYstWMnagmzRGPWpVhyPGj6MGCtFU/6Wazse+9QJTXXLD8JzZpGr2pciM6VrlpAqaLcmF+vUdKh0Kb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703139; c=relaxed/simple;
	bh=oBwGMhIyEXE1Wg/ft/QwYveG6kjLJ2PjtYifuEHcAZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVz4lRHJY3qR47qrGUJKOEmekNFxCHkWFivfipwILzvRKlv2N0G7s7WrshouN2MRWoFgbmyGhS/xJIMiKbMjkK6gZZGkgD136XLBIO61+eDTN7rUQRR4LEE4kKnt6hdFZtPQa9wip0/FJwye/fTCJYfWq+HwNdQ+/cZzoBfM1go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=inZAMjTK; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="inZAMjTK"
Received: from 8bytes.org (p4ffe0c3c.dip0.t-ipconnect.de [79.254.12.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 9E2DE1C4F5F;
	Fri, 23 Feb 2024 16:45:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1708703136;
	bh=oBwGMhIyEXE1Wg/ft/QwYveG6kjLJ2PjtYifuEHcAZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=inZAMjTKEeQYS9jjtxz1x7Rhe2SQkyOiLiiyeeRyEQVPzb07tjHH4v+qKM7ixfFOZ
	 EHXH/D5P/ja4fhkP/mylp3qCh5vJuCpasRvfuO801tU/JBR+3XcTyitk9Sf23zPMZV
	 6xm3uwtpdjMmVypN3cVn6XTI7s4GPS/OrIQ2Ab0tom5oRfVAeo+kuExYwqAVVklHhR
	 Gm0NoPFIoU2ibADIJH05ytvADaLtUhBdtnddcA6awXbXE31D0qi+G/XQbX9chIgjil
	 hzCVuB9R6iamB3yF26lhQU8qlIlJ71ZbJLYtNpZuyaUwrtT8TJJ+sYW/yAmy06esgX
	 FxJdEqQg7mJqg==
Date: Fri, 23 Feb 2024 16:45:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH rc] iommu/sva: Restore SVA handle sharing
Message-ID: <Zdi9n6-O1U0lktNT@8bytes.org>
References: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>

On Thu, Feb 22, 2024 at 10:07:41AM -0400, Jason Gunthorpe wrote:
>  drivers/iommu/iommu-sva.c | 17 +++++++++++++++++
>  include/linux/iommu.h     |  3 +++
>  2 files changed, 20 insertions(+)

Applied, thanks Jason.
