Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779805;
	b=pSGf4jiQaM9QK1NMNHIAJgPUW6qZR6Hi7kdYF6Y8kJmy1SxYWfZu7YbndOCCN+39ASHk
	 FVJjjOewhxtAz/cyVv9/ISaRIGKJavTT2iT5OdoWpMBh3Gh75PH2DFXVNTUpNhSGMiYeA
	 8deAkX1Hm98sTaC/GzbuTKRBJbukSKi5ES+6omnJVvPeN1IpCnN4MATzVNp2wRCBFvpRu
	 eNFBgEQAgv/tuGlRw5k0ndX0gY/M81yMJUc5PcUpjXwwxhCevAAWVSvzioS3xJ8jNqA3I
	 0j90j7uB53v+DiSEuO6TKrycO24a6YQbPd6TOG/sKKonCrjxcBUfZ2fQpqOCQh6GSiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779805;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=E+JxZbx85M2Xp8xD3uoS5dIMs0SBsQVMzQFN/HWdTG0=;
	b=OKmK4TXjklNxHcndPpK2C3t5NLAGFYOy0m3GfxfeRGJbH+WAwUX0D88x8bQ1IE8NPXWV
	 1XPcRUB1ax/J+krMtbAQsz4yOVr1zwqM0pvo3J5YslLHIi3lX6UvVplZhdoCLicqfzKm/
	 Pqap+p61s1OpYVksnrHuzAOIIhMHvvgZWogBmGwEIVBnwZlrI9h+IdAstYYpm+zGBgZG2
	 xFK5aYFmvLlpMRJQ6eAfsM4cO6YEKtFWZGUc4FMFAVWWUkOGzjyGx7v7jxdOjE9mQ0brW
	 jKnHCPPOH8C3LOTa4Wq5q4RwP7/NVOknfL2OkJ5R0lAlF91qsrruaGrhKDGw5dYyfSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gVBbWxzu;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E17606A326;
	Wed,  4 Nov 2026 08:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7E17606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gVBbWxzu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793779805; x=1825315805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5aBF1wvyVYVfeB+FOgw490ImJbOmiAhqtuGr8CeBSQU=;
  b=gVBbWxzutmLX+30BBXSjPGFcRcFftyV7zpXlAVUWALlVh4L5t2+qiwt6
   NYoInGWJCnD/qRpIX2plzKIGd35/KknGUCAyXZeS13vLKpeDw50adr5tt
   y0nyc8Va67zZPFBtCsnzOkeMRR4Iy63lT0voiW7gfPu+SJXWPz7ZPkrxs
   NCCWMxCg0+1VAzbERqYJY2mie/SqizPYuiwtjknz8Cb3RM3mC+JGId1rF
   gNLmSRgesnSO/EEGsVR06yLstoi49tSPXPcRMJATsPMOPz5LxCNHsaxT/
   qGLQ1UZo1lbcX63buKwLZLEbPk8KmCK/yh2OxAKJBqI3sQJVETqMVWUAp
   g==;
X-CSE-ConnectionGUID: 0lSc/acnS8qC8fFik/E7lg==
X-CSE-MsgGUID: r/Tz2gDSSDSXvomALl1HhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2426469"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2426469"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 00:10:05 -0800
X-CSE-ConnectionGUID: jOPdA1nTSCG8CtHL45GM3Q==
X-CSE-MsgGUID: jbjYg7esS2G17Mi2rpP18g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6758879"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.47.46])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2026 00:10:00 -0800
Date: Wed, 4 Nov 2026 16:03:01 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
References: <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103151643.GI274202@nvidia.com>

> We will need some multi-step sequence from the uABI perspective:
> 
> 1) CTLV command START CONNECT:
>     TSM does:
>      GET_VERSION / VERSION                          (VCA: Version)
>      GET_CAPABILITIES / CAPABILITIES                (VCA: Capabilities)
>      NEGOTIATE_ALGORITHMS / ALGORITHMS              (VCA: Algorithms)
>      GET_DIGESTS / DIGESTS
> 
> 2) CTLV commands:
>     query certificates. TSM will issue on demand:
>      GET_CERTIFICATE / CERTIFICATE                  (every slot in the slot mask, all chunks)
>     query VCA items
> 
> 3) CTLV commands:
>    FINISH CONNECT with slot:
>     TSM for 1.2 does:
>      CHALLENGE(slot 0, fresh nonce) / CHALLENGE_AUTH
>      KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (clear text)
>      FINISH / FINISH_RSP                           (in session, opaque to host)
>     Or for 1.3 multi-key does:
>      KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (now includes DIGESTS and CERTIFICATE)
>      FINISH / FINISH_RSP                           (in session, opaque to host)
> 
> 4) CTLV commands:
>      query certificates
>        * Only certificates kernel or TSM has been able to validate
>          with a signature.
>      query final transcript items
> 
> Then there are five implementations of this:
>  a) Today w/ 1.2 and current TDX/RMM/SEV specs:
>       #1 is a NOP
>       #2 is EOPNOTSUPP
>       #3 does the full flow from GET_VERSION -> FINISH
>          no GET_DIGESTS
>       #4 returns only the slot S certificate that was signed
>          during the transcript

I see Elena's proposal [*] for current TDX:

  #1 Does the full flow from GET_VERSION -> FINISH
     no GET_DIGESTS
  #2 Returns only the slot S certificate that was signed during the
     transcript, this is my understanding, not specified by Elena.
  #3 If user selects slot0, pass; other slots, fail. Actually user can
     see only slot0.
  #4 Same as #2

Seems same to me, any preference? or do I understand correctly?

[*] https://lore.kernel.org/linux-coco/DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com/

Thanks,
Yilun

> 
>   b) Improved 1.2 TSM:
>       #1 TSM can execute GET_DIGESTS and pause after
>       #2 Ideal TSM allows the OS to request each GET_CERTIFICATES command.
>          Less ideal is TSM pushes all GET_CERTIFICATES then pauses.
>       #3 TSM issues CHALLENGE and verifiers the signature.
> 
>   c) 1.3 Multi-key flow:
>       #1/#2 is the same as b
>    
>       #3 The function of CHALLENGE is absorbed in the updated
>          KEY_EXCHANGE which covers GET_DIGESTS when in multikey mode
> 	 No CHALLENGE issued
> 
>   d) RustSPDM flow:
>       #1 becomes a RustSPDM session and includes CHALLENGE
>       #3 starts a new session
>       We have to solve the issue with ALGORITHMS mismatch somehow.
>       There is no verifiable binding of certificates visible to the
>       verifier
> 
>   e) In the guest:
>      #1 is LOCK
>      #2 is preloaded with the transcript from the host. Currently
>            exactly one slot with the same number the host picked
>      #3 is NOP.
>      #4 is the same as #2, it doesn't change
>      #5 Additional ACCEPT command is TDISP RUN, after we have
>         logged the data in #4
> 
