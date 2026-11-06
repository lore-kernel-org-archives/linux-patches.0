Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004802;
	b=1E6oUmFlzwpITdLXFY6x4ppUlx6qUBFXpBqLnbmurRgNBMJBYALChFwZ7szpHFl5KhZe
	 wHeRP9IeMXEAdZ1hZ73wNNqWb9CBqb21gNWvU0CbYHGyvv8IWNlyv9/sYG7z7GKgvnsh+
	 an+JiyAJUQS9TJCa1knWAOgUTbPvUb2VNC+D0NlbIbgYDQNbBSGua8bUGcdAo40e49djy
	 Ecx0eEtb+TXS1vSi4o2Cv1du31JrRxCxTHkJHxaldKRC+UH0Rh0hDWkGghGkqUq+tlXrY
	 x91cClEptyjr60Dtmd5BzB00Je4yWT719VgHhh38kUt8CDJrVQh1renL/A9HdIb9+bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004802;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UQb0zZ7n4ydx5RDPO9Yj+QuPTDNkVDd0snm5YtUuA8o=;
	b=nqolUANaLVYqPESC3k/B1EqK9J1QoQwIT/S89H9ky6mz1J5md2n8P+1Vrj51DvOfTA9z
	 UE5gT8Yn8JCiHmKH5QUZcWeMApkOlSokNub1tnNY/fTuvs/db2s00Z/i1nuyh2mb31w4A
	 xNWhe0lHYleK+nEp8ILf4FOeTMJZTbCrG/BqpzhISBOMjz+JCY1xGaOSFNXgknBgC5FTg
	 gb6Pj/AtblZUmS17wXEv8Rls7k1ruz3guDFCS3u/SUcot8wnA+RoLdAksXzS1qZ4V6Ac/
	 U+LUVsVPf4fNc0w32AhODenTOreZAn03JOGFEt8IQPIj8kn6QsGnkRTBG3NsqeTB3dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BwsShdt1;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C335D606A326;
	Fri,  6 Nov 2026 22:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C335D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BwsShdt1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794004800; x=1825540800;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=74E1si3ElGIXACz5hfJQaQ4Yk9CU9EM2zeIjC6z5OcM=;
  b=BwsShdt1hhmeyM+XmefdqJ8hmgSjz9aNgVmP/YAH2dOLorKiy0Yqds1V
   B8fRwGhwoONlBgtekES+ji0beTlMzLzWpbYFTP/T3XOLAroJaPfh0WQqC
   Qjea5TnEY8MDdHauJUhZIh6RYyBA0NqjiZw0zCfNIQClOSO/F3tKwALJt
   Ia6FS/rUr1xDe1HcZIpnhQu2s1oA1HBRVlNAc6cC8WieYuJMiHKb7RREQ
   w9j+t2iCfNz0DIJpQi6Z++0tPnqHpNGpn+Xy94sHb5RaMuLYZg272MJZJ
   lq2xv1R7YHngRlSa1KNwBZ9T6Qykxox3vbPxa7PbneVoMkVNE7CuzSIKp
   g==;
X-CSE-ConnectionGUID: v75a4jKCReqbapsrR1XoAQ==
X-CSE-MsgGUID: HywUfRYwS+O/Q3h+FTnKIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2704235"
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="2704235"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 14:39:59 -0800
X-CSE-ConnectionGUID: /BJfX/irQhSXVVIaUWgbzg==
X-CSE-MsgGUID: C1HtDEdSTiuRp2iQwoE1pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="7277358"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.110.174]) ([10.125.110.174])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 14:39:58 -0800
Message-ID: <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
Date: Fri, 6 Nov 2026 15:39:56 -0700
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
References: <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261106193018.GK770409@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/6/26 12:30 PM, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2026 at 08:53:39AM -0700, Dave Jiang wrote:
>>
>>
>> On 11/4/26 9:54 AM, Dave Jiang wrote:
>>>
>>>
>>> On 11/4/26 6:41 AM, Jason Gunthorpe wrote:
>>> <--snip-->
>>>
>>>> Is there a PDF for TDX's SPDM flow someplace? I will try to draft a
>>>> more complete document
>>>
>>> TDX connect architecture spec
>>> https://cdrdv2-public.intel.com/862706/Intel%20TDX%20Connect%20EAS%20354629%20004.pdf
>>> 2.7.5 Figure 2.6
>>>
>>> TDX connect TEE-IO device guide
>>> https://cdrdv2-public.intel.com/861654/whitepaper-tee-io-device-guide-v0-7-0.pdf
>>> Appendix B.1.1 Table B-1
>>
>> I generated a diagram that hopefully better reflects Option A with TDX better than the current public documentations:
>>
>> Option (a) on TDX, with the current TDX Connect ABI: slot 0 only, no TDX
>> change. Numbers in the left margin point to the notes below.
>>
>>   ---->   call                 <- - -   return
>>   <---->  SPDM request and response in clear text, relayed by the host
>>   <====>  the same, inside the SPDM session
> 
> It looks OK, thanks.
> 
> I have a few thoughts
> 
> 1) I would very much like it if the core SPDM code in the kernel
>    can snoop the DOE messages from the TSM. If we do this then the
>    kernel can directly capture the full transcript:
> 
>> (4)  |                    |                       | GET_VERSION            |
>>      |                    |                       |<---------------------->|
>>      |                    |                       | GET_CAPABILITIES       |
>>      |                    |                       |<---------------------->|
>>      |                    |                       | NEGOTIATE_ALGORITHMS   |
>>      |                    |                       |<---------------------->|
>>      |                    |                       | GET_CERTIFICATE slot 0 |
>>      |                    |                       |<---------------------->|
>> (5)  |                    |                       | KEY_EXCHANGE slot 0    |
> 
> With perfect consistency on all vendors.

I think that works for TDX. tdx-host already relays every DOE message for the TDX Module, so it can hand them to core SPDM code. Only part of the flow is clear text though. With the current module I see the VCA, GET_CERTIFICATE for slot 0, and KEY_EXCHANGE/KEY_EXCHANGE_RSP in the clear. There's no GET_DIGESTS. FINISH, GET_MEASUREMENTS, the reads of slots 1-7 and the TDISP messages are all inside the session, so the kernel can't decode them.

So the kernel would get the VCA, slot 0's chain and the KEY_EXCHANGE transcript from snooping, and still take MEASUREMENTS from the TDX Module's device info. Would that be ok with you?

> 
> Further, it will also be able to capture the GET_CERTIFICATE during
> the preamble so again we get greater consistency for everyone.

That's the chain the KEY_EXCHANGE signature covers.

I tried disturbing the session from the host with a test hack in tdx-host, right before KEY_EXCHANGE. A bare GET_VERSION makes the device reject KEY_EXCHANGE. Replaying the VCA with one field changed gets a KEY_EXCHANGE_RSP back, but the TDX module rejects it. So KEY_EXCHANGE does blow up when the host interferes, as you said in the other reply.

> 
> I'm very interested in this because it frees the uABI from any
> variation in choices the TSM may have made. I have the full perfect
> transcript in the kernel and I will ALWAYS present the same uABI to
> userspace regardless what the TSM offers.
> 
> Like a whole bunch of TSM FW API just to do this:
> 
>> === Step 4: query certificates, query final transcript items ===============
>>      |                    |                       |                        |
>>      | query certificates |                       |                        |
>>      |------------------->|                       |                        |
>>      |                    |                       |                        |
>>      | slot 0's chain     |                       |                        |
>>      |<- - - - - - - - - -|                       |                        |
>>      |                    |                       |                        |
>>      | query transcript   |                       |                        |
>>      |------------------->|                       |                        |
>>      |                    |                       |                        |
>> (6)  | device info        |                       |                        |
>>      |<- - - - - - - - - -|                       |                        |
>>      |                    |                       |                        |
> 
> Seems pointless to me, and could cause uABI variations I don't like.
> 
> What do you think? Am I off my rocker? At least AI says it looks OK
> (always optimistic!). Undoing the chunking is annoying.

Seems reasonable. Every TSM gets the same uAPI, and on TDX the host already has every message in hand so the driver side should be small. It also lets the kernel check the KEY_EXCHANGE_RSP signature itself instead of taking TSM's word for it.

> 
> This is close to what ARM did with CCA, it seems very smart, but they
> seem to have provided some help to the OS to locate the bytes in the
> messages, but I assume with some work (and we have Rust SPDM) Linux
> can decode them autonomously?

For the clear-text part yes. Rust SPDM already handles the VCA and CERTIFICATE messages. KEY_EXCHANGE and KEY_EXCHANGE_RSP can be added. Everything after that is encrypted.

> 
> This would really slim down the TSM drivers since core code would
> build up all the SPDM data and the drivers just need to do the
> communicate loop and little else.
> 
> 2) I do not like the idea to refetch certificates:
> 
>>      | nonce              |                       |                        |
>>      |------------------->|                       |                        |
>>      |                    |                       |                        |
>> (7)  |                    | TDH.SPDM.MNG(nonce)   |                        |
>>      |                    |---------------------->|                        |
>>      |                    |                       |                        |
>>      |                    |                       | GET_CERTIFICATE        |
>>      |                    |                       |<======================>|
>>      |                    |                       | GET_MEASUREMENTS       |
>>      |                    |                       |<======================>|
>>      |                    |                       |                        |
>>      |                    | new device info       |                        |
>>      |                    |<- - - - - - - - - - - |                        |
>>      |                    |                       |                        |
>>      | one-shot result    |                       |                        |
>>      |<- - - - - - - - - -|                       |                        |
> 
> That's just asking for trouble. Our general security statement is the
> kernel & TSM validates a signature over the certificates to verify
> their authenticity in the HW. Re-fetching defeats the whole point of
> this if the responder can supply something that differs from
> GET_DIGESTS. If it can't differ then it was a waste of time since we
> already have it.
> 
> Further it wrecks the point of the transcript and the 1.3 multikey
> signed GET_DIGESTS.
> 
> If you *really* want to do certificate refresh it has to be a
> dedicated operation, it has to be supported by the TSM, and it has to
> get back another SIGNED GET_DIGESTS. All that would ideally have to be
> dumped into the transcript again.
> 
> I feel it is alot of work and not valuable.

On TDX the re-read of the chains comes with the measurement refresh. The kernel doesn't ask for it separately. For option (A) I think the kernel can drop the re-read chains and pass up only the new MEASUREMENTS. It already has the copy KEY_EXCHANGE signed.

> 
> I generally feel a 2nd measurement is not a valuable activity in the
> first place. There is one meaningful security measurement. At boot,
> before DMA is allowed. It must be logged into a measurement register
> and then after you turn on DMA the device can replace every byte of
> software on the system. (hello ATS). Only the logged measurement can be
> relied on for security, any post-DMA measurement can be fradulent.
> 
> It is OK for auditing, but not for security, so why would you even
> look at the certificate chain for audit? For auditing you should check
> that the PUBKEY is stable.
> 
> I think any device that can loose its private key while an SPDM
> session is open (ie with live update or something) is fundamentally
> broken. If it wants to do this it has to break the SPDM.

On the host side, should we drop the fresh-nonce collection before ACCEPT then, or keep it as audit only? I'd rather not carry a uAPI for
it if nobody needs it. The guest's lock keeps its own fresh-nonce recollection, as you asked for earlier.

> 
> 3) Obviously TDX and everyone else will need a 1.3 multi-key upgrade
>    I think they all look the same. I would like us to settle on this
>    API here and then we can describe what a perfect TSM would look
>    like and people can go write their specs for it.
> 
>> Notes:
>> (1) Creates the attestation endpoint only; no TSM call.
>> (2) TDH.SPDM.CONNECT has no KEY_EXCHANGE slot input.
>>     CERTIFICATE_SLOT_MASK, the only slot field in SPDM_CONFIG_INFO_T, is
>>     the "Device certificate request slot mask" [ABI 3.3.2.2]: it picks
>>     which chains to read, not the slot. So userspace can't enumerate
>>     slots by repeating step 3.
> 
> Boo
> 
>> (3) TDH.SPDM.CREATE runs first. The kernel sets CERTIFICATE_SLOT_MASK to
>>     0x01, so the TSM reads only slot 0's chain. It could also read slots
>>     1-7 inside the session [GUIDE B.1.1, Table B-1], but no signature
>>     would cover them: KEY_EXCHANGE hashes only the chain of the slot it
>>     names [SPDM 10.18.1]. So (a) doesn't report them.
> 
> ? this is confusing. KEY_EXCHANGE slot=0 includes the hash of the
> certificate chain in slot 0. If the TSM doesn't even read that slot
> during the premable it is impossible to validate the KEY_EXCHANGE.
> 
> What prupose is there for this configurable "the kernel sets
> CERTIFICATE_SLOT_MASK to 0x01" ? If the kernel sets for slot 1 then
> KEY_EXCHANGE must fail?

No, it doesn't fail, and the note was confusing. The mask doesn't control slot selection. It only picks which of slots 1-7 the module
also returns. Slot 0's chain is always read and returned. The module reads it in the clear before KEY_EXCHANGE, even with bit 0 clear.
Slots 1-7 are read inside the session after KEY_EXCHANGE. Setting 0x01 just skips reading chains nothing signs.
> 
>> (4) The host relays each message over DOE [ABI 3.3.3, 4.2.20]. No
>>     GET_DIGESTS and no CHALLENGE [ARCH 2.7.5, Figure 2.6]. The guide's
>>     session setup example also reads slot 0's chain before KEY_EXCHANGE
>>     [GUIDE B.1.1, Table B-1].
> 
> Yes, you have to because it is necessary to do this:
> 
>> (5) The TSM verifies the KEY_EXCHANGE_RSP signature [SPDM para 630]. The
>>     host trusts that check, so it keeps no KEY_EXCHANGE messages.
> 
> Yes, but if we do #1 above I would keep it anyhow and optionally give
> it to the verifier. I agree it is fairly pointless, but it is really
> cheap to do if you have #1 and simply capturing the *entire* signed
> transcript is forward looking from an ABI design perspective.

Agreed. With snooping the kernel has them anyway. I'll change (5) to keep them and hand them to the verifier.

DJ

> 
> It might even be useful if we want to use
> GET_DIGEST/CHALLENGE/KEY_EXCHANGE as the sequence to support
> multi-slot.
> 
> If people start adding more messages in later spec revs it simply
> flows through with no ABI change as additional transcript meassages.
> 
>> (7) DEV_INFO_RECOLLECTION puts the caller's nonce in GET_MEASUREMENTS
>>     [ABI 3.3.2.3], and the TSM reads the chains again
>>     [GUIDE B.1.5, Table B-5]. The device signs the new measurement log,
>>     nonce included [SPDM 10.12.3]. That signature is what protects the
>>     new measurements. The verifier must check it with the leaf key of
>>     slot 0, the slot KEY_EXCHANGE used, and must find its nonce in the
>>     log to know the result is fresh. The kernel hands the result over
>>     once and doesn't store it.
> 
> Yes, but in 1.2 there is only one private key so the slot doesn't
> matter. There is no reason to re-read the chains. Kernel would throw
> that information away, it already has a signed copy that it got at the
> start.
> 
> Jason

