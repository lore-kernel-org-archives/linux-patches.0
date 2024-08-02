Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C131E2894;
	Fri,  2 Aug 2024 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722607200; cv=none; b=EIh9PX567tot+/kwNE4FVUbXSYPweCTELI/Uw5u0rHSb3QyjGr9Dn9JF+6wceTDF/j7N6UeQLjor8DfV6wNXomYTQsIRg0yTgBWD+vyK/qJMnWSlpbTpKWLthVWPOZJabWycI46KXSKYDRZfeKMrWHdETMourXEvWnHkEiqBH9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722607200; c=relaxed/simple;
	bh=EeHisQoJvRHNuhbJues0OBjMZm1RIQx7uM8MGkBztS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQ9PAeCUnbEYg/x/XCx1jnWiFQtjswK9L26lGY+U80epiYYuSUKQD79Dh865GJjPeE1usMWWNRGq/pgLl3CLRugXwkLemPVVo9shjnpbGbtXzMVhplhTbwP9ovTKvwX7977HgXc+m9Np8YMNhjnGGxhBhDUh4OUkLo9dUfcXmFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=OR+6+zwq; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="OR+6+zwq"
Received: from 8bytes.org (pd9fe9dd8.dip0.t-ipconnect.de [217.254.157.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 401062A4C5B;
	Fri,  2 Aug 2024 15:59:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1722607196;
	bh=EeHisQoJvRHNuhbJues0OBjMZm1RIQx7uM8MGkBztS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OR+6+zwq1HkdsXEUKRTOyfR5ajUE0GuYYbfJtPyAWFUx56c28vNfGOT8IllqoqPaV
	 yxcLVIaSAHrP+6fzzIsKTfQi2SMmPFYMkG1jnyzgKomvowbsAX6dNW07/zqgglO1Ug
	 LbqqzH7OC6lA4lfC4LeeD26L/hLFnehG3KVppBne3gXxzx/srOCcP2cGGf2/CA9ozO
	 qxV/h6PaikjqgmO6+9vEcNqgDHiuiEMkpwIqLSzUoV293bCxEI9O9uvNTsPO5PlhFW
	 Q7Zk1IiRCjxSlgUVY+EdqeDuDAElwHXAaivIBFZZb0+KT8Kb0TxexKFGFRwoeWx6EI
	 CR5dT64lrIo/w==
Date: Fri, 2 Aug 2024 15:59:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Barak Biber <bbiber@nvidia.com>, Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu: Restore lost return in
 iommu_report_device_fault()
Message-ID: <ZqzmW3_A6FOVn1x_@8bytes.org>
References: <0-v1-e7153d9c8cee+1c6-iommu_fault_fix_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-e7153d9c8cee+1c6-iommu_fault_fix_jgg@nvidia.com>

On Thu, Aug 01, 2024 at 09:26:04AM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/io-pgfault.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.
