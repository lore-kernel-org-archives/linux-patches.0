Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191EA231C8C;
	Tue, 10 Dec 2024 09:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733821957; cv=none; b=Q9UVkpa9zyd9nzQCiCVAy9j5fYJlkFa4ZiRUp1I/OYrJIPtLSPl8yJSUt3VZvoAcn45HtP93MtVsWWQXu8t5cPZztomtURKY6oMe/pDFNIeGz9sQNt5Gdz/mUpEiDYZZLz+vCOsCkBAwoYPkrQCeaChQZIzs9qTzkbB0vA53X10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733821957; c=relaxed/simple;
	bh=+HxkhALzNnloxIupZOFpsWqM7Wu7CVxgUSzmPWNMbR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2cT+YYBaObTCQwozE60dyHVDg73fpNoGYTfvCzXKC6jhUEjiCc6Vw5VJ4IL9hkBv3QIYsuNB6A24SJcICtftZfW09A82wqspg/V/jmwlFvtdek6Wn2Izzo1nSE16gblQkIYG3qjAMvNr4GMDnsdZycDP9RWExZYYePaASOgaSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=l/YZcp9z; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="l/YZcp9z"
Received: from 8bytes.org (p54921e31.dip0.t-ipconnect.de [84.146.30.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 775612C0A0D;
	Tue, 10 Dec 2024 10:12:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1733821948;
	bh=+HxkhALzNnloxIupZOFpsWqM7Wu7CVxgUSzmPWNMbR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l/YZcp9zKtLvq5eM3fuxGhHKPLRbEaVuy1/OrXqKfnyTQ93a7K1HFiknsv2lgDGZs
	 7WYt8D4HzMBuaUcvhl7kWLMEVyh7f6KPb40XcgyQX07SPn6ZyNc6D0i29eVe1K5QLA
	 4koHRtYiFI1umtZmjMaa7e3/mmQrlzv0ltVeUPWhMLzPoT7kyuFQBTKAYRACY3XMcD
	 0OYW9ETZdM0L9vIlzn2IcS6ELWQvgelFKdtnCzEXtsxR07xj15i791RaiGIqGDWpkX
	 9Ucjac0WvqilDAVzNHVVdSIAueN5vPzXPiTCR0pSEo7Kxo0UZFOHUSAPRVCHzqF/8P
	 ZYtp/KHE3cZxQ==
Date: Tue, 10 Dec 2024 10:12:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev, Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH rc 0/2] iommu/amd: Fix locking for domain->dev_list
Message-ID: <Z1gF-8nJdD__Jptf@8bytes.org>
References: <0-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>

On Thu, Dec 05, 2024 at 08:13:40PM -0400, Jason Gunthorpe wrote:
> Two small patches to fix locking regressions around this list. Found by
> inspection.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (2):
>   iommu/amd: Put list_add/del(dev_data) back under the domain->lock
>   iommu/amd: Add lockdep asserts for domain->dev_list

Applied both to fixes branch, thanks.
