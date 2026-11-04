Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811249;
	b=PzDWY9EQ+rbh+p9114DFVsmeOMl/wojqjTsHjPAf4C8arxvB3mefBlxMFcBAjwhEiYF6
	 ptqcVnBOIbx2T8ktQ5+yKD78hI9mJW8qyUpj1hiiqtm5gOMf/oqK3YSbyf78/Ix8KkE6l
	 q3n9kw9pZrW+v1arpCucoquUSIcFXnwe5fgda0R80QTOszPfeehgUfpqGQwj4RO7Kegkm
	 DB5qnBez+WYFME9gS+piJ2wB9r3y5SPLjVQWDbP4B2fCMGnChQztDC8ln18Nic/UudyP2
	 m1VMMlC5xqV4cmBQQk+RWYNIp1jzgSodcR2vZ81JJPDjXxxlBU5lgVFG5G9sqMlyB2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811249;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=iEPD1QYuT7OH1ElfWyuk0psyrxzr5Rzkiw/WLwl9VA0=;
	b=eYS+JhNOUYijNpsMHvzZBdUYybp6CkmdIxjDnUZxXu7rncaGqIKoW1E4j0x1z9sa9DHq
	 XbafX5ZskKV+vc02bR3tX+RPHXZxV9iizhup07/LgDzciAkBRbk9Aon4m+W0sCTYn86GK
	 lpxJOfIFY+iKAGTXhl1RCS+vaYv+2CZ/HMIH9IfdQRvuuc1UJ9SQDflzZ+TtpJgiXnCid
	 RpDA3343AdAT2sRemoK82qeXD4VRu8LWbV1QJU3v8VNZorPpJ99mnG6Eo5R3ufXjUeA9A
	 7OHA+/NKMxUtYw73JNg1OaEFd3GDz7WsaCkEX8TKiubV8IZF2TkNvZqoVvq+HLa4yrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nS6yNFGl;
	arc=none smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883CA606A31B;
	Wed,  4 Nov 2026 16:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 883CA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nS6yNFGl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793811248; x=1825347248;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iEPD1QYuT7OH1ElfWyuk0psyrxzr5Rzkiw/WLwl9VA0=;
  b=nS6yNFGlSaqpItE/ZosU8/713G5AadxLJ1b75cZY+NF1VCAIj2OZG5T4
   D7SSlWWq69KTcnni4UT3gIsZ3Wfni73NXL/Zkg8zZ6Rubsmpj+srxV+6I
   3hMTGOb/LlpKrCB+D9RcecMH3jCDmp9fRL2U6sor6w/jkhC15wJtZO3Fj
   PeacPR2jyOPnhYiX0cW/ZKygbJbiQeuS+emaq/RCeKRjLA+7mmhOobeoU
   jRDjeC4ALbKgdvOItIqDi+XtBJOH5aK+0FmRO3KNaJOaavUxZONSmryfg
   BvEAW7XhWux+G0hKxQyJT1XIBkNiM/bumOm4K5iphLR/hTig13Vrd7+gr
   A==;
X-CSE-ConnectionGUID: zYl+C8YJRC+IrnqSzuBVzw==
X-CSE-MsgGUID: PGNgaGBgTMe8MONCrROAoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2458490"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2458490"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 08:54:07 -0800
X-CSE-ConnectionGUID: AMQYNewLQgCpnH6AqiAPnA==
X-CSE-MsgGUID: EIjoAzeaQ++yMPf2LYoI+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="6777575"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.38]) ([10.125.110.38])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 08:54:05 -0800
Message-ID: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
Date: Wed, 4 Nov 2026 09:54:03 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
 Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261104134119.GR274202@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/26 6:41 AM, Jason Gunthorpe wrote:
<--snip-->

> Is there a PDF for TDX's SPDM flow someplace? I will try to draft a
> more complete document

TDX connect architecture spec
https://cdrdv2-public.intel.com/862706/Intel%20TDX%20Connect%20EAS%20354629%20004.pdf
2.7.5 Figure 2.6

TDX connect TEE-IO device guide
https://cdrdv2-public.intel.com/861654/whitepaper-tee-io-device-guide-v0-7-0.pdf
Appendix B.1.1 Table B-1
