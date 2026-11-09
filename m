Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257702;
	b=LbjTgLVwWhoWF9iZ8yJqDsu13jQanHh0PJDeZscyb2Hxs1R1Ehkwxd8esCnZ7Q5JANL8
	 oqdAAxPn6re7IQ5XTypwUatqPFrUkzrQ0l+6mkQf2HyqKiI5lDjSludRom2xMHC4gmBVS
	 EkEn0IkNqY9qpy3PDM4JbDghlmAbO6IvOGoney3fLCq+7B0X+DFDV3JoQ3Qp+YWky6tae
	 MT3X0qIjgPlNH+PE6alXIdkqMs70LMH41DA1lEVEbAOAUYwamRUtSOxKflTtAbbb6fdOe
	 cc55Z4RTXt+5zahAPheTNFpU3YaYk9EGAvXCCxlJCLQ4A4SBNRKYrAx+jL1szemeG5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257702;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CHfhohJ+/rjeHNIiMoO54WoZRyK/HZc0Ka95/ZC5f9M=;
	b=1eZaxGYeMshgjuKj2Oldry038WsGyj00kaUEoBGLqfi3E8zHGaUFn4gAE/3M0CefcWyP
	 WAdsZCh0QQC3Ib8oj9AW9X1dO4FvNevekn2p1lEthqbEH6HVCC05yZlxvn2c+qUbqdyRS
	 Frg5eoZdXaYnNA+1zsKpvSXX1meI/f01mKuhKq6VmLRMm7xZbd7fKtXP4aAzh8lZEhin9
	 wS3n6QfWZpY45x1Bto29mZmmudCWJN6WlAe1Dhgk8McQ95mlwFhufgYwsI4ZlGLSvDz7V
	 qJ2t8AwxnmIH1UYuFx6cmBAeYvtcozZ28gYqrydtAiW1Z0cEGSt0sysJptMfPnlYl3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kmrS1twX;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C266606A31C;
	Mon,  9 Nov 2026 20:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C266606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kmrS1twX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794257702; x=1825793702;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=auhSrNaYOPJNFujFxRkBsRNtO2Uc+tj9FzTatr7sER0=;
  b=kmrS1twXcH0yFlxS0yaznBTisezxxAuD8UXFuE6AyH1pPYest6dtAeJT
   clwmDUHi50rjZxCPNQI4rRhOtQ2jFutEoW+2QNP8Ss5Cm1xyQCUfrjsqb
   5UynWjdH7Ouxq6nxSJEucWjvtAtdsV6ELXsM1PwyF/pHvcSPSEMWd3Rv0
   LPFwJTUbpQaoCdFcCU+40vafgvV9CujO9pQeO8AnCQTz+PkShM0OmOB5d
   f2H8vjoRJy9emS8ncCQuyfEQR1IoqcvX+5XVQWq5GaLJEErVygGHRpgEV
   kJ7wZAEWjYfhki6sCZd5vha3VcES0u3NbGGRNySSebGf1gr9ManKkYV1F
   A==;
X-CSE-ConnectionGUID: wudGc8FnQVajizpskSbgVw==
X-CSE-MsgGUID: m3arRSLqTlijMnt6Ep6K6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2872766"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2872766"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 12:55:01 -0800
X-CSE-ConnectionGUID: IVpcitA6TsWQVFPL2XWkVw==
X-CSE-MsgGUID: HrBS35uUT/+CBVyHYUZr2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8100554"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.20]) ([10.125.111.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 12:54:58 -0800
Message-ID: <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
Date: Mon, 9 Nov 2026 13:54:57 -0700
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
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
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
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261109185315.GS770409@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/9/26 11:53 AM, Jason Gunthorpe wrote:
> On Mon, Nov 09, 2026 at 10:37:14AM -0700, Dave Jiang wrote:
> 
>> One thing on TDX is that TDH.SPDM.CONNECT also runs a
>> GET_MEASUREMENTS of its own during the connect, and the kernel
>> doesn't choose its nonce. The kernel wouldn't hand that one to
>> userspace. Measurements only come out through the two flows, with a
>> user nonce.
> 
> Why? Seems like another wasted operation..

The TDX module runs it as part of the connect and with the current module the host can't skip it. I'll discuss with Elena and see if this can be different.

> 
>> That works for TDX. tdx-host's relay is one function today. It takes
>> the module's request from a page shared with the module and calls
>> pci_tsm_doe_transfer(), so att_spdm_doe_exchange() drops in there.
> 
> Yeah, it looks like it works for everyone.
> 
> I sketched out this library, and it is basically half or more of the
> in-kernel SPDM in just a different form. Basically all the reply
> message processing and de-framing abstracted into something a little
> different.
> 
> So in terms of *net* code needed it seems like very little
> 
> But it brings forward "rust spdm" or something in a new form as a
> pre-condition to do the TSMs. Which is annoying for sure.
> 
>> I tried a quick version of the capture in a test hack with the TDX
>> Module It rebuilt the VCA, slot 0's chain and
>> KEY_EXCHANGE/KEY_EXCHANGE_RSP from the relayed messages, and the
>> kernel's own check of the KEY_EXCHANGE_RSP signature passed. Agreed
>> it's more of a debugging aid. Two things I encountered:
> 
> So you (AI'd?) something basic up to do the captures and showed that
> indeed the right data comes through and the general notion is OK?

Yes. LLM assisted test hack in tdx-host's relay.
> 
> That's great, it matches what all the analysis points to. I could find
> no blocking issue on this idea.
> 
>> - The DOE payloads carry dword padding, so the capture has to trim
>>   each message to its SPDM length before hashing. KEY_EXCHANGE was
>>   160 bytes as a DOE payload and 158 as an SPDM message.
> 
> Yeah, I couldn't belive it when my AI pointed to this. Nobody thought
> to preserve an actual length so any SPDM over DOE implementation needs
> to be very, very painfully calculate a length from the message content
> and algorith negotiation.
> 
> My AI predicts 1000-2000 lines of code very careful spec derived code
> just to remove this padding. Such a big spec mistake.
> 
>> - The chain hash in the KEY_EXCHANGE_RSP transcript is over the
>>   whole SPDM chain structure (length, reserved, root hash,
>>   certificates), not just the DER certificates. That's how the
>>   device and the TDX Module compute it.
> 
> Definitely, it would need to capture the certificate stuff in just the
> right way.
> 
> The optional chunking features are a bit tricky, but I don't think a
> 1.2 only implementation needs them. They seem necesary for future
> post-quantum.
> 
> This also formalizes the version locking: the TSM FW cannot use a SPDM
> version that the kernel does not understand. I think this was already
> basically true, trying to do the 1.3 multi-slot flow is not going to
> work out with out kernel support to move the additional data. Maybe
> nobody noticed, but with this scheme it would be really formal.
> 
> In practice this means all the TSMs will need the kernel to tell it
> what SPDM versions it can go up to.

TDX has no input for that today. Will discuss with Elena.

> 
> So I'm a little bit stuck here. Some thoughts:
> 
> 1) I think this removes alot of code from the TSM drivers. All this
>    stuff they have to go back and get the data after the fact, or the
>    thing that is almost like this in RMM, goes away. The TSM drivers
>    are very slim, just run their communicate loops.
> 2) Clear uniform path to 1.3, stop after GET_DIGESTS, let userspace
>    inspect the certificates, continue with the slot. Again drivers can
>    be super simple, just need to pause at the right point in the
>    sequence.
> 3) The data collected and presented to userspace is perfectly uniform
>    governed only by the SPDM specification. There is a clear path to
>    adopt newer versions in the kernel with in-kernel SPDM that
>    instantly with nearly no-code works with all the TSM drivers.
> 4) This is about half of in-kernel SPDM, the receive buffer
>    reassembly, certificate chain reassembly, x509, padding stripping.
>    Each a complicated topic on its own. We always imagined having
>    in-kernel SPDM, so I view this as effectively free code - contigent
>    on organizing the in-kernel SPDM implementation in a properly
>    modular way.
> 5) Without AI this looks actually fairly scary. I can see why people
>    wanted to avoid it with different schemes to have the TSM do some
>    of the work. Yet we planned to do it anyhow for in-kernel SPDM so..
> 6) With AI this is probably a weeks work I suppose to really expertly
>    polish and make excellent tests.
> 7) There is clear overlap with Alistair's work, I don't have a sense
>    right now how close some of the parts in that series are to fitting
>    this shape.
> 
> I will look more closely at Alistair's series to see how close it is
> already.
> 
> But, I am strongly tempted to make a draft placeholder in C with AI as
> a way to get alignment and try it out. Something we can throw out if a
> Rust version comes along.

Sounds good. I can test on TDX when you have something.

> 
> Jason

