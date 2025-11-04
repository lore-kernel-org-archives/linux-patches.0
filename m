Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617EA2652A4;
	Tue,  4 Nov 2025 18:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282622; cv=none; b=PRjlCYNRUaOuj4w7YU+iUTSkBwQW3aGnBwKOgCPSwSA8M/dMhFHQYjnOgiSPPpneCGOolWdgl2fStHbstt37GidWSNarGl8GKlvqSfDquJVbASB6EdtFmWChQ2XQ+M3sIWPkwaQOKib06Zfg+BK5o992b1vuAzJ/7N+05o6l8kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282622; c=relaxed/simple;
	bh=3P1VH9nzE1I9RH6Gvhm6wC4ulAz/KTpkrTAqw8/Kqow=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZ1q4g9PgPiHqgbgBI+Hr9dAylMZ0IZNAXmNlZ6NwGX+u4ng7D/tWl3orXlESJ9HvtsfhO6V9a4qJLoHoxcFciwBMclapSST9JfoRGgOzwze4WzHOfvPYH+wEgiHHso+tTJqZqTKbsipFYdYs+S97ZSpoMNbHZ9YU/d1tezen9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=7E8KWjus; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="7E8KWjus"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A4H58mZ219977;
	Tue, 4 Nov 2025 10:56:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=uNk9b4+QPm55cP1BfkxT
	m1aZO4U0ayIiuWn9/M4J/S4=; b=7E8KWjusEBHc5q7UbCXTW3FpJkqXaWLfNPYD
	zTtZQqCQVodF2P1V9JsgwB+coN+HfKQKOAcWWaemcVmLbNZFBW3yYsl92toBSgsE
	clZyAhAhKvRIOLBnuUSTiQKve2/gRLwIQLkca99rgbRnKG5ei/Y3sYJId5nc4zNk
	9LnMx3+es7eS+3coeQ05Yq3KTeInsLu6swP/RKATvVvT2PlGBsTd+Cvqw8EVrZFJ
	ULXw2VYKTD987x4pC4XWXImRXyEDn/w71DMLQegCes6q37w7W1A7K0qKdVwdAh15
	zEnOMR8ZY0KFQaWsQeAyioqg6ystcDXYvu3FhQ3ZwG+qqzz19w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a7nk01133-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Nov 2025 10:56:48 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 4 Nov 2025 18:56:47 +0000
Date: Tue, 4 Nov 2025 10:56:42 -0800
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
        <linux-kselftest@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Shuah
 Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>,
        Eric Auger
	<eric.auger@redhat.com>, Kevin Tian <kevin.tian@intel.com>,
        Lixiao Yang
	<lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin
 Chen <nicolinc@nvidia.com>, <patches@lists.linux.dev>,
        Yi Liu
	<yi.l.liu@intel.com>
Subject: Re: [PATCH iommufd] iommufd: Make vfio_compat's unmap succeed if the
 range is already empty
Message-ID: <aQpMaoKSf7Zblkjd@devgpu015.cco6.facebook.com>
References: <0-v1-76be45eff0be+5d-iommufd_unmap_compat_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-76be45eff0be+5d-iommufd_unmap_compat_jgg@nvidia.com>
X-Authority-Analysis: v=2.4 cv=FfM6BZ+6 c=1 sm=1 tr=0 ts=690a4c70 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=3j4BkbkPAAAA:8 a=FOH2dFAWAAAA:8 a=Ikd4Dj_1AAAA:8
 a=YkFqN9IMLvb7-OaZgr8A:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: gF3lzBHrKVsacJLNNPjEssBYTSJtpDls
X-Proofpoint-GUID: gF3lzBHrKVsacJLNNPjEssBYTSJtpDls
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDE1OSBTYWx0ZWRfX/wiuQM91XC5h
 5eMWH/MXYPjMJds9eWeJ0Cq2bBauSNeAdDWJ3gM7RKHj3/p8zCRxJyChYm9bDCZGJXeH3jggfYz
 Tfik1XdgeOQLLPZ8wyj+fO2/9D8MtSRuBh4ViHAr+uxO2DGzXL5sNTLqdblnhislDv6tEXYGxzB
 aGXDSPHdKcbzelDsrTHnd5AOUGcvsUOSiaFIi+6qqj9E148WDM7fuok8PRUQqYWwpU44sdVAxHE
 tVb720z4OaK7sWFGrh9Wyb/eR3q6CIhEVmh7pN714j1ARVPuB6BnmL+kgjQRPrlruBOxy8NLZuW
 Czc9efbf3UCmsaVLa7iUuMwYVZGYbMhljrFVh2hsQGgrHoHB0YifpKVm9ThkYRX5bEiU7icU8px
 RnbhP/pL70Y9EIN4X5bfvSeV0lL0Tw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-04_03,2025-11-03_03,2025-10-01_01

On Tue, Nov 04, 2025 at 02:11:49PM -0400, Jason Gunthorpe wrote:
> iommufd returns ENOENT when attempting to unmap a range that is already
> empty, while vfio type1 returns success. Fix vfio_compat to match.
> 
> Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
> Reported-by: Alex Mastro <amastro@fb.com>
> Closes: https://lore.kernel.org/r/aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
 
Thanks Jason.

Reviewed-by: Alex Mastro <amastro@fb.com>

Alex
