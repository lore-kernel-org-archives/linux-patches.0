Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162FF357CF7;
	Thu, 11 Jun 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781191957; cv=none; b=Q/qAC0mqXAEXhBznD2+xq0SCJMA99Ooe5xyei4PcHlr/inpXhnqcA659mD5nUWd5nfpQHTEk1QDsWLfvXSOndWsGVtsrU+DtkokKi5DMYXsOPw4NCtIWH9uyFocG9Gf5sL9R8I04fNPflfYWleWtxBcnWWWbqnHta+6GC8RsKw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781191957; c=relaxed/simple;
	bh=rriirequBUj+ers2KgSj1eUQrKfyoc9tLCvD7D9vgfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bjn9Sp/hVZWp/o3SpGA+Dhwjv4OmC3y1eyIE+gPKejFLDhak74n5TEmW2S/9C05p/XUzdPRcf6bF8yI3jE1MEqEfNlawtGmkqMI8Ni0Pygdoq256pO0Qx6orzyj2R08ZPYp8tCck+2YBmUS4+WMZOJ1JbmTtEQcaOFzs3n6cYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id A036E1C1C3A;
	Thu, 11 Jun 2026 17:32:28 +0200 (CEST)
Date: Thu, 11 Jun 2026 17:32:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>, iommu@lists.linux.dev, 
	Robin Murphy <robin.murphy@arm.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Improve the invalidation path in AMD
Message-ID: <airU7xpucwkZMAo7@8bytes.org>
References: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com>
 <20260611115611.GE1066031@ziepe.ca>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611115611.GE1066031@ziepe.ca>

On Thu, Jun 11, 2026 at 08:56:11AM -0300, Jason Gunthorpe wrote:
> Joerg?

This waits for regression test results from Vasant.
