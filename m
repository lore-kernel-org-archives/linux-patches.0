Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE4E1DFE3C;
	Tue, 29 Oct 2024 08:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191964; cv=none; b=P6cVdMYplVXiB7eOJ3V7mhTgeOpZJzy+NTfY4dUUqyAXgpVxbSjRTDP32YeWBNWHWnTXp5E2bBz4f+FsUJwiz0Qanw9p/G99telifoRSX7EkEH43AwOBQMxm5PxjzsfZ2cj4RsGLCD0PF0tMDQTNsbjKwdjw9+GgZBUbLq4Qy4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191964; c=relaxed/simple;
	bh=r8TnWvzFwFG1ZkNSJpiJ9XxBf0K8xiJSxmdnFbPgKVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i636aXe1k0idM/oLzyX7h8WHCMPY/kjuDrB/4OZUOLs9fDZifLJ38OaX/YzZkAAfoy1EGIt+XXh2/deiByG/kh2VbVZKpg+876SX7+THB4754HnZs7PrNxP9O3mkZyLyaUIwIluPvYx6AQgGbyNB4+QuD3YL3qAqLkx0jBKymEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=OX7XsLMP; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="OX7XsLMP"
Received: from 8bytes.org (p549219d2.dip0.t-ipconnect.de [84.146.25.210])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 88B532A8D41;
	Tue, 29 Oct 2024 09:52:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1730191961;
	bh=r8TnWvzFwFG1ZkNSJpiJ9XxBf0K8xiJSxmdnFbPgKVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OX7XsLMPjRfYTHgTd4z5JHQiQkVKyiHiKClIwEu408/Bll0sInzgMkF4HU+5Maekf
	 BsZGw+N20Zw7xRnxriIQrA5y6Xi4IcxV1wwnUatEHHRiarDtYz4c5PFyDeJs6Ctl55
	 r5tNrMiMh4N9mNY/dqAKySKIG5NU9tenprRIB0PkvR1cURYRXPiJUTJSMmSoJ33dx9
	 bqqd1yPTq8b9aK+rfIUDDU3YEwU3MOfO5NAZDInef8Pg+7bJrPeG4LTJWC7Z3P6I/t
	 HfNNWPzdjctHFyHbOmh1+4eHmzrRR+57dsd9ZQaQ5M3xxeCZaLnjSXlPHZ6c4j77nr
	 s6NGOFOm9TBUQ==
Date: Tue, 29 Oct 2024 09:52:40 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Remove useless flush from
 iommu_create_device_direct_mappings()
Message-ID: <ZyCiWE9pjW6uh9LA@8bytes.org>
References: <0-v1-bb6c694e1b07+a29e1-iommu_no_flush_all_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-bb6c694e1b07+a29e1-iommu_no_flush_all_jgg@nvidia.com>

On Fri, Oct 18, 2024 at 02:01:19PM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/iommu.c |  4 ----
>  include/linux/iommu.h | 10 ----------
>  2 files changed, 14 deletions(-)

Applied, thanks.
