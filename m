Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7358A280325;
	Sun, 18 Jan 2026 09:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768729635; cv=none; b=HHSPo+DpdJ8VwYHsyyVlVF1rIBDLQhotynln5Oh2ELmJtRd+evJv/0lAkoK+6bEXOmUOtAHnDxmUEaX+KvyIatTx9k2F0kJAkMIsKlgJn8wLm1jATSVDr8Dkx2maHF9XZ0/Aq0jYnYIlFZIucV8VBcawwb7lP6chdWRuvNyi1jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768729635; c=relaxed/simple;
	bh=8iKWHE439+Kv8ItzaeIxmsbO/iGWOBbKxZWzeiViago=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzZfMwPu/QcCwrsFMu+LJGXt+pxgeyWqT2qEyv4wwx3uFNgTQTxTkdzSA+hxBpyR5pgNd3yyODmf13e5ShhFCpgGti4uBOX1GLtea/9Ol8dZWb8fHvk1yYinIRmu9e0MrRDn1+EDsPHAW4G6ucxlIZVHYu3LAG+CuP+jN/9grCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=LUImN+rp; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="LUImN+rp"
Received: from 8bytes.org (p200300f6af1d960047d77347aeef488f.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:47d7:7347:aeef:488f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 6909D5C16D;
	Sun, 18 Jan 2026 10:47:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768729632;
	bh=8iKWHE439+Kv8ItzaeIxmsbO/iGWOBbKxZWzeiViago=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LUImN+rpN377qF9Tp7yCbJW2MDSjy4wP1EuzBDf/5tZ2XstUYeuIYLX4J3VJPUPme
	 kSVf5PPG11XJxvL4Y27xpY+IuB/l9v+KGdY6gL/GpX745zFngJv7ffSk6EfC+I6PdR
	 KzxREW4X6YSCa40aF1AY0tICNDXpNoxbZdsLQbqfk2PP3urn8Ryno2xaAkBXd2Q1yf
	 ADR9M3iMMakbf/Nu6GmooKz+tgZGFgjZXkimdAS1ReOuXliLYWCJkE0P2mQzB88EUP
	 IQQdV+YLQkymr1BQh/tFvuBzNb12SDEhgRkCz8OWTGIvGMLtZUoBZPIL6T9fuXIKue
	 bTrc1ZM/HaYcA==
Date: Sun, 18 Jan 2026 10:47:11 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	kernel test robot <lkp@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 0/3] Let iommupt manage changes in page size internally
Message-ID: <wpqmukpcurzufu4nrbnjox3scdfgjqwfrjqk3ijmd7oo5gtrmf@vx4tw4usghkg>
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>

Jason,

On Mon, Jan 12, 2026 at 10:49:01AM -0400, Jason Gunthorpe wrote:
> Jason Gunthorpe (3):
>   iommupt: Make pt_feature() always_inline
>   iommupt: Directly call iommupt's unmap_range()
>   iommupt: Avoid rewalking during map

Please re-spin patch 3 based on the comments and resend it together with patch
2.

-Joerg
