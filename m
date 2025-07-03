Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995481FF7BC
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 18:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568534; cv=none; b=JYwfRwTz7kH9uyp5+H1JlXq+OmhXmGMKHbdNJ0xFbJGbalg/iiHN0b3Bmz/TH41bn9tt0la6saICypaZJDY27YWyM7aVaStHvHgnwU+qKfTV+Hghb7h8mJKRdtP9Fuk9C1z69Z7wNLRJA0KRh5s9UR2y3F4eX1ynTqIucux3WBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568534; c=relaxed/simple;
	bh=5O1P4Qi5Ly7Yl1j45j9wqhnY5nin4eGqfmQLo0FqHpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBbEWUvqzxbF8F4JDs2u6n45qG3dznPIDGgkQVM2rAbYYHlkas5zt0TuxkF7s3k3GmTaLA+T68TRhTC2O7c9U4UAczeVpOrnfplg90hDpfh2ESn7qohPOTT+YG2qfyL8OjB/VZc3zUJvLdiNlODNm5w3+rq5gjWBGPaVX+4uDoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Not6820V; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Not6820V"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2357c61cda7so193045ad.1
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751568532; x=1752173332; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qvzyiHvZKWRtHA7KGz4JH1KLn6i77WWlalz4Eq7c2XY=;
        b=Not6820VU/nIiIx+77bNTzUtaZll6jvNAhFD6BOoGOeUyZ7xUR5+jxHnDFbF17rjue
         KnZXNTevO8CX6rnfT4DoQSSAmfyomIb/fqdFmgTihaU1JYs2yIeDF0Ro7AsVADfJ83U7
         HD9yEjqiY2AkIxTBb5qcyhutx+TreMeX/ym/D337C39YQXCb2+Cz8V/cYUYTzLEgT4+T
         qLvS64RsSgbb82F+SE3tbK5WiE/Bv1oPRFhiyTDE792IjDbuEahwGT75XvHFuOmrSduT
         gAB0QJ+qvFPLdVVu9L+u+C3+xgBkI8orE3K3k9HEQ21vayW4uqVGKz4FYLsGH3VsyrFu
         efAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568532; x=1752173332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvzyiHvZKWRtHA7KGz4JH1KLn6i77WWlalz4Eq7c2XY=;
        b=b5NMjNEvmERrh5xhff8MGz6RRYx2Wt+/1BaK1WoK+P6Ov1JeEKGB7bbUFUicQH1XLg
         6Qhyve8xq7kl62ucS1RToRL2EgdtOEDzifGUnnXt7Bf1gzcaHFS0OedBu2wOJke6Uy0R
         l/J9yUVJktX8Ny6mrZZFhDG1MFOvJ1hvnLvSSpY15j42zoPvpUkfg8EKKSFPgDJorhGv
         vMUk34nu1KDkj/vBufsI9Fs4Z5VXmrck4TE4BNqWrjXDqi4mWkKvbz30Cov7W/DzG5E7
         1Q26EWOcRmePd5nLgwkfOJEUnKLokoz7jWff+3T2xZYJsn+YUfdwkO7QbxQo/fPRZN1T
         HdUg==
X-Forwarded-Encrypted: i=1; AJvYcCV+1gfbU/xyNevXp1/AoQ228GQkdNUzYkLxEqM8DeOPzRbrt/lsm1hvmVpS5rfwrI6czMmRsP4U@lists.linux.dev
X-Gm-Message-State: AOJu0YwY7cZqMhBmXSuPYiba3T31EE2GwTsfF9376ZDFU2tlfV5lJeGX
	1VJrUqAsY5OrUcZWug5QFel+1fZ57A4zAIy700Muz2fWIuJcR9mXcFLgAIucmuuEAQ==
X-Gm-Gg: ASbGnct7taOaOjddO5SVBdb/1cOb5CMNu/pMfPoNC+BeADhSILGAhvSRJ7kEVTSrSiP
	lRrBckx0OjvpWXkzybFILDkq7BhRPTQBBnS9EDG+h03Qh++Ff35/W3nwyo0B+6rz7dxsWIhSTUS
	5eUblNvWhe//HDOJ0UVxCJfrFZg2LyRUyQvgPCgLF+xhothtS3sIawnlzBAeFySTSoro0k4ns20
	EmZh7NxO9MdrIzc4Va8Kwvm3xpHoVztbVV3+E8rm8TmW26SPbytVT2gKt97snfTgk2pwtfzJsAm
	7jl17ySoRlLu8zBf0ftcj/FHjjrz11NLEM6JtbTQB5OqRuo4SsBxTtgn3qzgAKix1KPAZePS6rh
	x3m80SlODAWdPgv+JligR
X-Google-Smtp-Source: AGHT+IFuOFQYDWLy9dMFwm2BVYD/G6HSHUIkq7TbiXmhTvbZxzCpO4493oWkzZnsDCA2OiWThdj2eQ==
X-Received: by 2002:a17:902:d582:b0:215:65f3:27ef with SMTP id d9443c01a7336-23c79ada924mr4107505ad.12.1751568531582;
        Thu, 03 Jul 2025 11:48:51 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a381sm1926105ad.20.2025.07.03.11.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 11:48:51 -0700 (PDT)
Date: Thu, 3 Jul 2025 18:48:42 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
	corbet@lwn.net, will@kernel.org, bagasdotme@gmail.com,
	robin.murphy@arm.com, joro@8bytes.org, thierry.reding@gmail.com,
	vdumpa@nvidia.com, jonathanh@nvidia.com, shuah@kernel.org,
	jsnitsel@redhat.com, nathan@kernel.org, peterz@infradead.org,
	yi.l.liu@intel.com, mshavit@google.com, zhangzekun11@huawei.com,
	iommu@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org, linux-kselftest@vger.kernel.org,
	patches@lists.linux.dev, mochs@nvidia.com, alok.a.tiwari@oracle.com,
	vasant.hegde@amd.com, dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v7 27/28] iommu/tegra241-cmdqv: Add user-space use support
Message-ID: <aGbQipeSn0aZnwZU@google.com>
References: <aGRIctg4T6cQECx4@google.com>
 <aGRcPSwaJkTeUrMx@Asurada-Nvidia>
 <aGRmaOORg-YDfncY@google.com>
 <aGRozoIDIlgl9H9x@Asurada-Nvidia>
 <aGR55PUBnwb8qT8U@google.com>
 <aGSBTpY0nkdp2TTL@Asurada-Nvidia>
 <aGSNmf5Q82xEbDpX@google.com>
 <20250702180541.GD1139770@nvidia.com>
 <aGaXqwzfLwsgCH6n@google.com>
 <20250703175532.GF1209783@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703175532.GF1209783@nvidia.com>

On Thu, Jul 03, 2025 at 02:55:32PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 03, 2025 at 02:46:03PM +0000, Pranjal Shrivastava wrote:
> 
> > Right.. I was however hoping we'd also trap commands like CMD_PRI_RESP
> > and CMD_RESUME...I'm not sure if they should be accelerated via CMDQV..
> > I guess I'll need to look and understand a little more if they are..
> 
> Right now these commands are not supported by vSMMUv3 in Linux.
> 
> They probably should be trapped, but completing a PRI (or resuming a
> stall which we will treat the same) will go through the PRI/page fault
> logic in iommufd not the cache invalidate.
> 

Ahh, thanks for this, that saved a lot of my time! And yes, I see some
functions in eventq.c calling the iopf_group_response which settles the
CMD_RESUME. So.. I assume these resume commands would be trapped and
*actually* executed through this or a similar path for vPRI. 

Meh, I had been putting off reading up the fault parts of iommufd, 
I guess I'll go through that too, now :) 

> > > The goal of the SMMU driver when it detects CMDQV support is to route
> > > all supported invalidations to CMDQV queues and then balance those
> > > queues across CPUs to reduce lock contention.
> > 
> > I see.. that makes sense.. so it's a relatively small gain (but a nice
> > one). Thanks for clarifying!
> 
> On bare metal the gain is small (due to locking and balancing), while
> on virtualization the gain is huge (due to no trapping).
> 

Ohh yes, I meant the bare metal gains here.. for virtualization, it's
definitely huge (as reported too).

> Regardless the SMMU driver uses cmdqv support if the HW says it is
> there.
>
> Jason
>

Thanks!
Praan
