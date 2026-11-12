Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498484;
	b=h8JClwASKt71ZCpUHOpjGCJXGcngy74TltH9w3YiNORzOiAjpwoAFAv78L3q5Vu7twvf
	 cIwb0uyB2ekaWAR2MeYwEdLNQftkMTGfkc7GnD4MWTpJP+yVAHxwWPcly1f7SrLArP3i/
	 PmX7hfiuipGEE4wDg7sW3oGynW2HY8N11OxrX48GHuGkGlDnFvvqE7QrDUKutVaR5XOT5
	 NJMsx2KrF17VupKerTkoelpDnjIcIhUICOt5z7Zu1OAw4ef8A1qURCG/hnY4I4WCyZwYT
	 xciFQMX+4hjoaAZTZMcOkkl/Rjr8b5Au8rqAzEQMQyAsdbCpHms40UFKOYlTozArgLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498484;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Nhoq+o2AeDmgf3/B6h8p9oadn4HbvW4I9vcVLPoehOw=;
	b=qqBLiuazpMFHEdOwq81FgFmVHQEbNxMOpQUkOl1NAO1L7a33MYNkuSS/ZKKp3XbviL0p
	 w25Nh+GGmBobk+Yci6VeAPoaq5xfix5XqeG062I8F4QfG0wlXHGeodXJ8wiSGXMl57nwq
	 kW5Hl1C0oHmcEs90j787gJXCEQVHUILKnUdYbBxm/XqH+cQIls4nTHUY8X6ipEhe1Jnev
	 QTiPlZompvS15//fAH/GlLWqi6BUoO/u6li6/QN0E5yovvz60RGOZPp66z2aZQsvUo8kU
	 pIN2PfEhrSzMW7aXalOcZPhZrxZbdp95JUBigZ9QlFeAiGWQWtVPNM+sSQG2Sr5bT4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JTXFbsAh;
	arc=none smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E2A606A321;
	Thu, 12 Nov 2026 15:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46E2A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JTXFbsAh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794498485; x=1826034485;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eS7l2d7PKAcY7eMFzNb1ANKCPKCISimctsodaPJo3Pc=;
  b=JTXFbsAhXdByQNcdhT4sCPWGdzePI0Blb7BemiAlnGEnJKiSpCl8sOm/
   LBGoLI3azeIcWs4dmv/pAuth4/bsIbW0dyDAR1aohG2ElnmwWgLU4elgq
   LqO5kPjRPIEtJd5pR2b1J4IBNWzyRL6Iyk8svN/u2tb4M2u4A0rPUJaXW
   qQ6lrDlYWQhg4xddpxZXkKsKJyizKhF5XqumMBA1/QUK3/QZgf/ax1vpE
   Hg3qkmGAMJdTT3TGmqbaMxhXI0whvKtgruV21Tuy7URYDzs1QjZ10Hi0G
   6+zx9sKMYuF3U3zzI0dIPx4GDIzRL+cTL0x8I2/gP4smFrg1NdglCEewY
   g==;
X-CSE-ConnectionGUID: X4VkpnMXTyuCMNeHa/PIWg==
X-CSE-MsgGUID: O8ICs5qATJ6JjU6h4mgmmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3157205"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3157205"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 07:48:03 -0800
X-CSE-ConnectionGUID: ge6dskz2SgGLmKSGJaxWDQ==
X-CSE-MsgGUID: WmvcEHbcRcCvtAp7Jskxcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="9248431"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.173]) ([10.125.111.173])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 07:48:01 -0800
Message-ID: <21bd5c40-7d32-450d-93a9-7d5ff6693c34@intel.com>
Date: Thu, 12 Nov 2026 08:47:59 -0700
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
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
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Alistair <alistair23@gmail.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261112145254.GL738765@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/12/26 7:52 AM, Jason Gunthorpe wrote:
> On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
>>> Like a whole bunch of TSM FW API just to do this:
>>
>> Can you help me understand why we need to snoop the DOE messages? IIUC,
>> the earlier proposal for 1.2 was to use Rust SPDM to perform the
>> following:
>>
>> GET_VERSION
>> GET_CAPABILITIES
>> NEGOTIATE_ALGORITHMS
>> GET_DIGESTS
>> GET_CERTIFICATE for all slots in the slot_mask returned by GET_DIGESTS
>> CHALLENGE using the slot 0 key (At this point, we can also verify that
>> we received the certificates for all slots supported by the device.)
> 
> At least I wasn't proposing exactly this.. CHALLENGE ideally has to be
> connected to KEY_EXCHANGE, ie they use the same nonce or get digests
> is hashed by the TSM or something to have the full value that 1.3
> brings.
> 
> I've also been told that not many devices are implementing CHALLENGE,
> so this may not be that useful to invest in..
> 
> But the main issue is we have to use the TSM to initiate
> NEGOTIATE_ALGORITHMS because that defines what the contents of the
> slots will be, and a rustspdm has to follow the TSM's selection.
> 
> So, any version of this flow would require capture as a building block
> anyhow, and you have this awkward version where TSM does all the
> negotiation then rustspdm injects its own messages according to the
> TSM selected rules.
> 
> It is possible but very hard, so I think we should set it aside. This
> is something to reach for if the vendors don't want to agree on FW
> changes as part of the 1.3 upgrade to improve things.
> 
>> The host then select a slot and use it to establish the IDE connection?
>> (For intel we can only select slot 0 here?)
>>
>> What does snooping provide in this context?
> 
> Capturing the transcript makes everything 100% perfectly consistent
> for everyone. Userspace sees *the transcript* as defined by SPDM not
> some mangled, truncated or processed version that the TSM decides to
> provide.
> 
> Userspace gets to see KEY_EXCHANGE which means the verifier can prove
> the certificate binding, this is the ONLY way to let the verifier do
> this proof if it wants.
> 
> Further with capture we have a nice primitive to pause and do slot
> selection before going to KEY_EXCHANGE. If we know the kernel has
> capture then the ideal FW design for 1.3 multikey is much simpler and
> clearer (more like ARM).
> 
> Also, ARM decided to do capture already, but directed by the TSM.  I
> think it is the right and best idea, they just made the implementation
> too narrowly specific. eg it doesn't split up VCA, it doesn't capture
> 100% of everything to get KEY_EXCHANGE, etc. Trivial to fix while
> upgrading to support 1.3
> 
> Finally, Intel actually seems to need Linux managed capture (Seriously
> Intel, WTF?) as they don't have any other way to get the VCA, and
> without the VCA the measurement signature cannot be checked. I hope
> they still have time in their spec process to adopt the ARM approach.

This has already been raised internally and will be addressed. The TDX module will return VCA with the measurements. The host will get it in device info and the guest through GetDeviceInfo.

DJ

> 
> The ultimate goal is to get *consistency*, especially a consistent
> uAPI. The second long term goal is I want the guest and host to show
> the same data out of the same uAPI for attestation. The guest should
> not have an inferior view.. It will take some spec changes to get
> there.
> 
> I've now gone through all the exiting choices all the TSMs have made
> and here is what I'm thinking
> 
> 1) The uAPI presents a transcript interface, every message and reply
>    individually presented to userspace. Perfectly future extensible to
>    include GET_DIGESTS with 1.3 and whatever else comes down the road.
>    These are consistent spec defined message blobs 100% the same for
>    every single SPDM implementation and TSM.
>    The kernel will start with a partial transcript, but the API
>    can carry a full one as we improve with no uAPI change.
>    The guest will see partial transcript until/if vmm/guest changes
>    are made
> 
> 2) The uAPI presents the x509 certificate chains in a consistent spec
>    defined way that userspace can hash back to GET_DIGESTS
> 
> 3) The uAPI presents the signed measurement result and tdisp in
>    a consistent spec defined way
> 
> 4) We have the four step
>       Start
>       Get certificate
>       Finish using slot
>       Accept
>    Flow I mentioned earlier
> 
> 5) We start without complicated capture. ARM will collect VCA with its
>    in built capture. AMD will do a measurement collection during
>    'Finish' and extract VCA from its blob. Common code will transform
>    both VCAs into a truncated transcript.
> 
>    Intel don't get a VCA at this point, so no signature verification.
> 
> 7) We implement common direct capture and throw away the VCA code from
>    the drivers. Intel can work. Every host driver has 100% perfect
>    transcript.
> 
> 8) We have a nice think and Linux sets a recommendation what the FW
>    TSM interface should look like and try to badger the TSM FW spec
>    authors into something more consistent than this mess as part of
>    a 1.3 multikey update.
> 
>    If everyone can standardize on ARM-like TSM managed capture, with
>    the proper breakdown and data inclusion then we can get 100%
>    consistency without a complicated capture process in the kernel.
> 
> 9) The VMM uses the above common interface to reconstruct the
>    RHI/GHCI/AMD. That mess doesn't leak into the kernel on the host.
>    I checked this and everyone but Intel is fine to construct their
>    host/guest channel from the common interface.
> 
>    Ie fetch the x509 bundle and reform it into whatever was speced,
>    then undo it and put it back into the x509 bundle for the guest
>    attestation subsystem.
> 
>    Except for Intel all the guest defined digests can be calculated
>    from the common spec messages. Well, maybe AMD has an issue, their
>    spec is too vauge to tell exactly what bytes are digested.
> 
> IMHO ARM has the design that is closest to perfect, a few tweaks and
> it would be excellent and support 1.3 multikey.
> 
> AMD's is weird but at least what they have for 1.2 can be made to
> work. Will need to be rethought to get get 1.3 multi-key. Copy ARM.
> 
> Intel.. Is wrong IMHO. It is still unreleased, is it too much to hope
> you could just copy more from ARM?
>  1) No easy way to get the VCA, no easy way to do capture
> 
>  2) Wrong digests design for the guest. SPDM_DEVICE_ATTESTATION_INFO_T
>     is a terrible idea since it is not grounded in any spec. The other
>     two have multiple guest digests computed directly over spec
>     defined objects.
> 
>  3) Even if you like SPDM_DEVICE_ATTESTATION_INFO_T it includes
>     TDISP_CAPABILITIES for some bad reason. Nobody else even
>     exports this info from their TSM or digests it. Thus Intel would
>     need unique API for the VMM to even build
>     SPDM_DEVICE_ATTESTATION_INFO_T. Not nice.
> 
>  4) How does future extension work? Oh you probably have to pass 
>     SPDM_DEVICE_ATTESTATION_INFO_T as an opaque blob through to the
>     VMM. Lovely, so only Intel needs a special Intel specific blob
>     uAPI? Bah. This is a very bad idea.
> 
>  5) Several unnecessary collections during connection setup.
> 
>  6) Confusing/bad implementation of 'TSM selected nonce' and
>     "recollection"
> 
>  7) Lack of an API to do evidence colllection for the host, the only
>     provided API always changes the guest visible information.
>     Not nice.
> 
> Jason

