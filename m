Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D028F326938;
	Thu, 28 May 2026 07:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953153; cv=none; b=TPyYJK8FaBrHWtBTv3V3VPpbwYPsTAyXGlAmbMHhlqhIYLscEf2jGFVjUydeydKZOcN5/VeZ3IePyDKx2XlKJ5/cgzJrllTBJD/OGN4ygpU537/PYcSSjNeGy0b1BUA0E8wLVOa4imMmDb/glSMR0BHo8zYx67nQFmRL/SYibrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953153; c=relaxed/simple;
	bh=eqkR3PbNTOFY93Bc8ZF/6VgSGAzup93FgATqvdeHNTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtLADYOYwLbbecOxSSkWAsxKWxog7BSmXalR+cE4H2yBIXlwD/xgKBUH7xrO9Y96Ul7wtiMKd59VGRmZCL1qlNNdiVtIA2rSZ6lCzZhsFcc0rSP0rPf5OkG58uXsxrvNgEKnowzFL7coKavc9ZuCeCchTKY5CuwO/6CGWpSPlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af4fc5001a5b4667a2accba1.dip0.t-ipconnect.de [IPv6:2003:f6:af4f:c500:1a5b:4667:a2ac:cba1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 99B971C59BB;
	Thu, 28 May 2026 09:25:50 +0200 (CEST)
Date: Thu, 28 May 2026 09:25:49 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, jgg@nvidia.com, patches@lists.linux.dev, 
	robin.murphy@arm.com, suravee.suthikulpanit@amd.com, wei.w.wang@hotmail.com, 
	will@kernel.org, kpsingh@kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH v1 0/1]  Don't split flush for
 amd_iommu_domain_flush_all()
Message-ID: <ahftwWxiL9NlJ5g6@8bytes.org>
References: <20260414210626.2097722-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414210626.2097722-1-wnliu@google.com>

Hi,

There is an updated patch in this thread, can you please re-send with the
correct diff as a new thread and all Acks/Reviewed-by tags added?

Thanks,

	Joerg
