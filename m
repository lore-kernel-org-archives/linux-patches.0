Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D32344023
	for <patches@lists.linux.dev>; Thu, 11 Jun 2026 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781195601; cv=none; b=eN+51ybxJygfDl179NOMDRHu0eMS6JDJ1PCJfo9R7LgEhF85Ou+wzYwnrg3rxmj10XyUBSKLcsJhm3CSgt1nEUbyGQ414tv9kJ8r7Uy/2+pFWHmww/Grr9AQFKan+YxgBLhTuBgzU1/oN/+msk/SWHjXS8ZY4n+VgPU1L9VhaoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781195601; c=relaxed/simple;
	bh=7Rz/uck9FemFjrxC3sfBD1FDGz5n0wMB+PX/5/B2crY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVKXZUlKJpzC5TvJiJwtmPx+/KXCBTKeQPVTGPXaBRot6i9Elox/RGYphZncScRcafId/NGmK3YWU5q2ugJeb7abE6MSZkj7yqN/OLhMqrJCZcXI5M6DZkL5xGasCN1jdFTgs8RL+AztaX+Wqw65snDfnwruUWovbNTkyeWgrzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Pr/EKjls; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Pr/EKjls"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51761d27612so94821361cf.3
        for <patches@lists.linux.dev>; Thu, 11 Jun 2026 09:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781195599; x=1781800399; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tf3FfoqnJ9+cjTccQxxTp03MxEBoO3jeV0rLfBYktsU=;
        b=Pr/EKjlsqiVd5I87oAC3n0jALYSDi/8N+EVBZf+wM1Dxn18LVewvMZqecfxygYlDvI
         vUAYgHxeYuz8hY4R5F5+/QFnomJkN1JbNeeM7jzOLYg1bk0ZsK9+plr0boVU6mmM8mBi
         5oAoNq/Is7AAdwBhsLjC/N3fERuFq3ZtpPBhEjBsEEO0P4/eS5ntr9sdzmo6umQGoovP
         WG5a6RqyfEAdZ4k2QU+1dsin40fvc0ZMukQAOV1SWwjo3hD8aY+GCo/zVMzAob3A1f+h
         osQElW3Jbneimw53fTyLAcfoJ1I54GOTa4XWPBTTuSNKiAOvwV80zIppQ0VhZYENOWyp
         HDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781195599; x=1781800399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tf3FfoqnJ9+cjTccQxxTp03MxEBoO3jeV0rLfBYktsU=;
        b=OUg7PHTmv+bnEYMxYyT5mmsZvP6sp68zoOjLbkwnIz6lrcOYa1W3dOgnkZZRS0l4Yz
         WX7oWaMxN4CWGrWlXbvkhPfMNc4eGq6fVi8e+t/mVyAFM8Z43ZBM5ZaxbkQK44PMYN0e
         fLnNe1w4O8h/XXkOBUPktBnv9lbOv0ERbVJMtWzETYWjAVWtqChjEgOVmY+Bh5D2tzLv
         FsxNtMXUu+NnX9vMpKDJGyOjhiFDiTDfshJ4ipZL9ByYFWZ8Tfny6nlxw1lYMnNvVpzQ
         lc4ygJipTLPoyfCxUS5gajQFMJ3VX9pxapVseEwBAdye694yDotUxLhj1XxhvsAvQ+t6
         +yeA==
X-Forwarded-Encrypted: i=1; AFNElJ+bUqDd4Lk22jC+0UB9Q3MSgGXBmAwnQ0JATy/QQRuXvfgfoCDViMVD1YLkxmT38hsGPw+4xMxo@lists.linux.dev
X-Gm-Message-State: AOJu0YxDPQAjcw8t+rvXVdi9CcSKIwgvNm2ltqDdjFXgU8gYm7cnIj8f
	oyqw2BKEXea12IPucEfXCQb1MoIkQsaeps4c2yabQkAmwF4XDzd/f72YZkUF/+G1lPg=
X-Gm-Gg: Acq92OHSj8NE3LFAeDe4+SXn2ZYXKa3Iuqbx+x5ltcKTybGblLK1CTUrG6jAFuDufGN
	ej3vuZtZUhmYIPPtQjeYrGHMuOclMOARE1tkAVkM6TwUxyfVZjLha67IPmkf4k2k1EO881xocho
	V+Px1VUApesBJ2pGKus4/evZPCE3PsvogjV1xj6qurT4jxVNNTSG/YoX5qvJ9YTjOACZ1ybUhWh
	QuGdhPQGP0fCQzfhiq0qdHcAWKmeZhccmXcXfFB4nctzfrnxPpqac8bEq7OLHj/7gnp0jqyxmj/
	iDFB6Ne0kNlsRtQixkkB0+QsqVqQoT0Qw/RUc02aD5vyUvMs4qiXi2Ub8HS7/H+js7Fm84RH9TV
	Igq9yiamZ0N+JWA0y9xIJez0uR5RvpTCXTLSxfBLr0QAB0oBrTGQ9aR+za8L2iPoUzaR1vpEg66
	HuXsiCpqd4dqTsLxIShQEznT8nZNc9NYaxNGirQ0Xiau6suKJuVA3+NPeELx4sT7XdksiCIBSHN
	HFY5Q==
X-Received: by 2002:a05:622a:3c6:b0:516:ed02:c85d with SMTP id d75a77b69052e-517edccccf5mr55036161cf.3.1781195598504;
        Thu, 11 Jun 2026 09:33:18 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517ef3ea534sm21939251cf.5.2026.06.11.09.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 09:33:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wXiLF-000000066Hg-0vrF;
	Thu, 11 Jun 2026 13:33:17 -0300
Date: Thu, 11 Jun 2026 13:33:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>, iommu@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Improve the invalidation path in AMD
Message-ID: <20260611163317.GA1453429@ziepe.ca>
References: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com>
 <20260611115611.GE1066031@ziepe.ca>
 <airU7xpucwkZMAo7@8bytes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <airU7xpucwkZMAo7@8bytes.org>

On Thu, Jun 11, 2026 at 05:32:27PM +0200, Joerg Roedel wrote:
> On Thu, Jun 11, 2026 at 08:56:11AM -0300, Jason Gunthorpe wrote:
> > Joerg?
> 
> This waits for regression test results from Vasant.

I understood he delegated this to Dheerja and this email from him is
confirming the regression tests?

https://lore.kernel.org/all/83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com/

Vasant reviewed it here:

https://lore.kernel.org/all/4cc8368d-3972-47c6-bd60-7fc8b9c7be3e@amd.com/

Jason
