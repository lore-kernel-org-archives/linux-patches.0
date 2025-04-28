Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59D81DE882;
	Mon, 28 Apr 2025 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745840032; cv=none; b=Agr7MD5FMdwuA38Nqg/qS2RG0v11HuQoJxioqWvEnR005Q7bOGDXdbi5Bs7YJMe4xovx/mZ+RhXmauN29MW96YwTH4ANkYSe5gFBUtosndchsRDDzAVp6uAU24Dxgwa2kYWp7PdIkcgg8MieT/EoxmYNMnD/tXJKySpolNy6aAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745840032; c=relaxed/simple;
	bh=9T4okPNTs0MHWE/sG64YWjUUENeoApInA4eZA5osV6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSYDu2b8kC/foIYZwpta8bdkRQmsC+OJ/CYXqFttNTHAdG3SA0sU8KxNXaX6Jzowx8QOuocyOmJu2ZGWaayi7RadSqPEy8NMKwkxwGeQnHM7ZHHHFcGms8RHGmgnCtBJ77Lk8MGjCFZSHxfjQN+YEMbY5z9LLf9tiiyaVzQimfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=maHVEgY9; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="maHVEgY9"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 912E2470B7;
	Mon, 28 Apr 2025 13:33:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1745840029;
	bh=9T4okPNTs0MHWE/sG64YWjUUENeoApInA4eZA5osV6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=maHVEgY9gKJWlX1XELOUuOrJE8Y1mbgXggYljrA4R/Ip5ngHpuDN/fsBVqgx966BF
	 0tS3hhIQVvI+9yHVC3ZVcYTW8lwAlNg0yBRFK1iJ9WBZ3RXZ9TXlGOdeNqgbq6UgkH
	 s9YXZqNCN9TOom6mwvgZtgGYh6mx0M/HWt/iqOqo85lcRSUeXleLv9XOwvXKnrSEAQ
	 /L2VWQdpPIo2PvgQQhKk7p5UgGSa39OqYAnC7oMfOdyKFVcshilEXO7mogYAc9rDmc
	 nJg8+p4lAQl9QYsOUsco/vR+wv8Ggo8U4sDdhlnpJhfla3jPxCOXF2K47Whg9Nvj88
	 yLx/xJOA48scg==
Date: Mon, 28 Apr 2025 13:33:48 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"Isaac J. Manjarres" <isaacm@codeaurora.org>,
	Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev,
	Georgi Djakov <quic_c_gdjako@quicinc.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] iommu: Protect against overflow in iommu_pgsize()
Message-ID: <aA9nnMt_nKVyS4-f@8bytes.org>
References: <0-v1-3ad28fc2e3a3+163327-iommu_overflow_pgsize_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-3ad28fc2e3a3+163327-iommu_overflow_pgsize_jgg@nvidia.com>

On Fri, Apr 25, 2025 at 10:08:37AM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/iommu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied, thanks.
