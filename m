Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4E83BD640;
	Thu, 19 Mar 2026 10:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773914548; cv=none; b=f9DSi5DLEeZe958t9KuN/46Ez2uH5jqKUiqyyUVGWyPZuG1gBUwdYgVo98mzeW2E4QPYgWoDKxNQYy6bRr4MAIUJWEeXR8HvONV+0KYJwmYz3zjc0NNDdyY1/9t3QPvZiZ9bZxhNjdKhqlT/1Q1OEH8y1Ra3FB88A3J+VgrZCT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773914548; c=relaxed/simple;
	bh=RPvAUzkCv/Pg1fjsxwFvMt7kmQMeT2lgZoA0riWocrA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P7Z3UK2szp7VdcShGewksj9ngD7+0yjjiWcw/V4BQxE/tfxmWMqxNkGApFBFDU9s8+8EUXn3vUn/pQnCqlg8CjLKgwQuvk57unWtiX82yJx8YBRimpVJ1UpB2g1XtuGnee1iEF8g3P59gqJ8PluDz6NG1aVTNRHKGYlZMIAFfdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktFpM7N1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktFpM7N1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773914545; x=1805450545;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RPvAUzkCv/Pg1fjsxwFvMt7kmQMeT2lgZoA0riWocrA=;
  b=ktFpM7N1wHwZmPE6RZj7BCF4TQGerpPFU7+062BZS6jndAiFQ7L4PmaT
   9pK2KrarbT1tPBn7PBqDmp9/W4T7Mg4LxWGek5h0bjpm50/1ENmVX+Kd/
   hNYsq1vRYf9kwIakWU5ltuYlVxLeBSrdzdPZZB65XsHxJknPJHcPoQfY9
   aael+bdpfK9pofoSo5fuH1eB93oXLO+tKIZ+JhS+vj9aQMUp1zF3d8DIc
   vx3FOViAhodSJnOd7nsZ+S76ckkKv+IGIEBM/mNhFM0kBdl1ZnXBQy85H
   lIaHW+ua3LxXrKZmsImYsW0zh9W0s3Rsm4gHzksDQ7Vb1Nc/PeTKwjWiJ
   Q==;
X-CSE-ConnectionGUID: ikeoipgGSByfuZGL1nCrCQ==
X-CSE-MsgGUID: JnsIzTcMTDmxrFMy7DuUYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="86343481"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="86343481"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 03:02:23 -0700
X-CSE-ConnectionGUID: A09ByfiZQamABRDREZboHw==
X-CSE-MsgGUID: PEsfxwSjRTe84v9y6cuxPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="218840320"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO mwiniars-MOBL.ger.corp.intel.com) ([10.245.246.121])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 03:02:21 -0700
Message-ID: <60a007aeebab10377b66951d958e711ae89e573a.camel@linux.intel.com>
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
To: Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, Will Deacon	
 <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin	 <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja	 <skhawaja@google.com>, stable@vger.kernel.org
Date: Thu, 19 Mar 2026 11:02:18 +0100
In-Reply-To: <ed985e72-dbfe-4d60-b5f1-581ba58e3c18@arm.com>
References: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
	 <13e28ac2-a4d6-466a-aef2-7b3d7d9167bd@arm.com>
	 <20260303130420.GB972761@nvidia.com>
	 <ed985e72-dbfe-4d60-b5f1-581ba58e3c18@arm.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi,

On Tue, 2026-03-03 at 15:56 +0000, Robin Murphy wrote:
> On 2026-03-03 1:04 pm, Jason Gunthorpe wrote:
> > On Tue, Mar 03, 2026 at 12:53:28PM +0000, Robin Murphy wrote:
> >=20
> > > > Further, there are several callers that can trigger empty gathers,
> > > > especially in unusual conditions. For example iommu_map_nosync() wi=
ll call
> > > > a 0 size unmap on some error paths. Also in VFIO, iommupt and other
> > > > places.
> > >=20
> > > My instinct is still to tidy up the 0-length unmap case(s), but I gue=
ss
> > > iommu_iotlb_sync() is itself also a public API where being more robus=
t
> > > against erroneous usage is no bad thing.
> >=20
> > I also wanted to do that but found enough problematic cases I lost
> > confidence I could reliably catch them all..
>=20
> I reckon an early "if (!size) return 0;" in iommu_unmap() would suffice=
=20
> to cover the internal error cleanup paths and most careless external=20
> users. However if we don't trust iommu_unmap_fast() users to always do=
=20
> the right thing either then we want this check in iommu_iotlb_sync()=20
> anyway, at which point the iommu_unmap() check would really only serve=
=20
> to skip a bit more unnecessary work on error cleanup paths, and do we=20
> really care about optimising errors? Hence I'm satisfied that this patch=
=20
> does in fact seem to be the best option.

Is this patch going to be applied soon to one of your branches? I'm=C2=A0
waiting for that to happen because I want to cherry-pick it and propose as=
=C2=A0
a temporary fix to be applied to our core-for-CI sub-branch of drm-tip=C2=
=A0
until=C2=A0the original=C2=A0lands in=C2=A0mainline.

Thanks,
Janusz

>=20
> > > > -	if (domain->ops->iotlb_sync)
> > > > +	if (domain->ops->iotlb_sync &&
> > > > +	    likely(iotlb_gather->start < iotlb_gather->end))
> > >=20
> > > Elsewhere we just use "gather->end !=3D 0" as the "non-empty" conditi=
on; how
> > > concerned are we about defending against more-intentionally malformed
> > > gathers here?
> >=20
> > I choose this deliberately to protect the driver, a malformed gather
> > that is 0 sized, or negative sized looks like it will have Weird
> > Things happen in drivers.
> >=20
> > We could further classify the < and WARN_ON the malformed cases, but I
> > don't want to pass negative sized gathers into drivers. We'd probably
> > also have to de-inline the function if more is added. Do you have a
> > preference?
>=20
> No, that's fine, I just wanted to confirm the intent - this isn't a=20
> place where we should need to be concerned about micro-optimising to=20
> maybe save a load and an extra ALU op or two, just that I don't think=20
> it's worth doing any more than strictly necessary for our own=20
> robustness. Thus there's no need to change the check in=20
> iommu_iotlb_gather_is_disjoint() either, as that now just serves to skip=
=20
> the redundant reinitialisation of an already-empty gather, which is=20
> justifiably a different thing from the actual validity-of-sync condition=
=20
> anyway.
>=20
> Cheers,
> Robin.
