Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F6120402F;
	Tue, 29 Oct 2024 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730192203; cv=none; b=RL3UGgaDk/rcPc86sMcA8vW1Zq4zLElSFjok9A3EFrOhBiez+/rb3eahpgqJRwnFU/goSYK/V9kXHqGPmgiPLEoTjoA8Bm+p8XrZbjS93xlvwofudcgErpKTUoUueDUJSuxPTi5xCwDa9/B3DpG546xLnjDCqOLW85ruWmIeoHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730192203; c=relaxed/simple;
	bh=4Y+sSXKbkwF4OkdfHxx50k3m2tUxfOIngRvPj3uA6MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpBOEhdFURLzyYI13ILzfV1Gtkab5grniOTe0HL91ETMcBGyf4rmddj/8VCSULvJx1OhZLUPHOuDoRRBWMj8Wes73baLqAK3KaQROmAz0t6/Gu0nHbQZrYEPAFAjGzQQYux9RWJ3nq8LCv5WrwSTfgn5KrLcxrUImjD6xc93wJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=4kwF9o9H; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="4kwF9o9H"
Received: from 8bytes.org (p549219d2.dip0.t-ipconnect.de [84.146.25.210])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 465F52A8D41;
	Tue, 29 Oct 2024 09:56:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1730192200;
	bh=4Y+sSXKbkwF4OkdfHxx50k3m2tUxfOIngRvPj3uA6MA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=4kwF9o9HwWYnyMQyCJNQ+A2Hepu6c6XfofPalxcKdIVU0YQVv2tnwG18io7wdW4YV
	 EmI09wKMY+MRPaWtW77W/0x1kX8uiz3OMbyaQae5FcCpPcWat7L+NBl7OJnJunfgN0
	 YN1aOpOBbw0E/zL8rglPnsRomklKeda116E0NBbH9IsBJIh2A7RoKS2GWT4jxtrTmG
	 3ftcQDS8xw/qYPEDyHiuhJR9kgolBGvQK/wqsKKZcWjgEtngLXXfhsrd7aHyE8lurE
	 SgS2JiEVqYQbCsgKH5ScbyErKOJ+OXrXY9OmlEJjkmcLnIWS6DxzcGtZiwDp9D+0NK
	 h9NmvkqzusWrw==
Date: Tue, 29 Oct 2024 09:56:39 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommu/amd: Fix corruption when mapping large pages from 0
Message-ID: <ZyCjRyXXRwc6QjVa@8bytes.org>
References: <0-v1-27ab08d646a1+29-amd_0map_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-27ab08d646a1+29-amd_0map_jgg@nvidia.com>

On Fri, Oct 18, 2024 at 02:12:19PM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/amd/io_pgtable.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Applied, thanks.
