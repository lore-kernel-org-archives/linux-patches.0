Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C8818026;
	Thu, 28 Mar 2024 05:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604451; cv=none; b=MQXGw3h3qsNTJ3zoLvChlpblc1egVab2HYaxEV3bmipYAxUEJZgQ4YUuovoULhc7m934PS4BAfsbee6bzU8oFiBkOmcIK2WZIQIA/+/lu3IvHAQZ1yCHW0mJtoXznLlaJD2Ivw3ZQp36gOH83bu1thC2gJqGdi3unhrxmMRIxv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604451; c=relaxed/simple;
	bh=v4lWGInDDcySJdRMnRH/BxLRcxDc680sHLmeJGYgYnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRdXxQJ4rDl32Qp7JdzLQAsRd/ZsmJolmL1j3EVYgKZK5/zCoWsiEg3QAoAhzpJdXycW6o+bfhxtcRaEH3W6hoU/yeaiKWNVckavH6svuVmAFmyk+aX5a/Zi1Bfv42BBXWBM38yFsLQeCnxbN4XiECnUFuxgwkxThiYXpLE1JgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=ZEsPWWho; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="ZEsPWWho"
Received: from 8bytes.org (p4ffe1eea.dip0.t-ipconnect.de [79.254.30.234])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 229D0280F7D;
	Thu, 28 Mar 2024 06:40:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1711604448;
	bh=v4lWGInDDcySJdRMnRH/BxLRcxDc680sHLmeJGYgYnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZEsPWWhoX5mAnSoIIrj+QVA7q52wVsImiaeaSYkr3UWU1FfNI7bFkssRG8njMowBK
	 gbfoyNN61baPffOAx9rBVHXhLuznANCHvG4w8nWETM1XbV5Rj3b74vxRGH/8KtzeVp
	 8GytXg1AEmPv8Dr/dLw8WtVdI+4icqI34wXi1sE3KHV5f9/6ahEulfMIPYbb3O0GcZ
	 hBi5fnJrJY3r9y6px36FLD7G1fLQWO7FP/ntlU5Z7pBRmwhP1f7btJdWpO+niTWBiB
	 gId21AN+cy0DMwSTf8HCtsF6R0iadbH1JuGeKI4njWHAanYW9+E88LJDiyfubv4gPr
	 h8OOqdjPdHwmQ==
Date: Thu, 28 Mar 2024 06:40:47 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Message-ID: <ZgUC31c7zlhQG-Jb@8bytes.org>
References: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>

On Wed, Mar 27, 2024 at 10:41:39AM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/iommu.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Applied, thanks.
