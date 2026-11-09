Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245839;
	b=JidGNPKRldns7jzgvgm+CRLctapfAjEfZc2w88WXIFyiB/ueufoSjCMjHbSlofxUJe+S
	 sv0C/IOlYLLaRyaaMmUOb5vxEO63P7xEW0mMPlHHkKF5yUtH6uja40TSbrwMHch/YqpW1
	 gwWROrLhB39p6n3QyM5MPqtHGGvXHs1FzlP+qjhR35I8moAfnJRhCrXSDnlB2/3huYKJY
	 RolSo3Jlv6866VYRmkd+3E+sBWoC7AvKSfQqvNNWq7s+J5IUsq/8L40UxXvFIHw9a3OFA
	 /16hXh+Of5ib3Xw8+89n9Qy2/hwTCTjoGoj2FdS7yP5mRdtysfeEXFGo0loG9hnxD4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245839;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=6CXJNsJLcYr7DCz++xy0LDDCohElFbou/J6Mw5qr5fQ=;
	b=LsbT149G2jtaz1X4PQKhVkppKJ5AiPUcfpYs3YzDbqKCnsDD60X3hndnTXssixIn2sxS
	 0X9efUz2Hni8hDI6O2KRqpyz19BD92FWCNTaQ12txifsr5waypeBxSQ3pA2Q2+iX1OUaP
	 2oNw8nw/WHoOtYJ9rh8zuKBh4rQIHocqHGYFMk6gl9raIgilqlSx3DMKg/D3gcq1eC3LQ
	 68res5zT1KCvwqqq1i+eVMqef3zF0N1QhpsOQmzd2F3sR4uqUqp8EHptCVHquD8vdJG1v
	 wCF84ee6HiuO1T8KQpVQ+al/ACH/3sA9ZUuiVG9zU5Bb8sMgt2FEYQet4IMazgMTVBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lnaIfhaF;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0D1606A321;
	Mon,  9 Nov 2026 17:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F0D1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lnaIfhaF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794245838; x=1825781838;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UinYI/6HI/ZaJ1dbH7aEhOKXCkNmi84bLrKsPg96CFc=;
  b=lnaIfhaFVqTpwm3epEG8L5KybuCx8Ke9TRXK5sa0V8/+LSX/CPrIUz1j
   U1wjVJf4O/w6kiVfdUMU4dkVY5sR0W25TpNn8W5mK992Nxi6+Isn+DjC6
   WgES9udL6tiQ8Y754xNv6g7cKGCiynVBe3/v8EvM6adOG7lPLJjzXyjq+
   VpiaJ1TCOQFnIV31zuKL/0Yr1HwiRUaznScNDkHUHsE2j7Zcrw4GVjokN
   27e1seiYwGLlxwqtvpyug7QMypczJJIFOjVRFN/ixsJMgOGb99ybd1i7S
   lKfcCZiua3orphBFyflWPljBxFrXqBgfxwWPv5gzDxfUx4ZrLjKjqYeiD
   Q==;
X-CSE-ConnectionGUID: lcBgdatCQW6jiBjZmxbZwA==
X-CSE-MsgGUID: O+5V0X7bQWu5mP00uSnQzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2876729"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2876729"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 09:37:18 -0800
X-CSE-ConnectionGUID: lkAeOzKjQlGPPJ4vFDI4hw==
X-CSE-MsgGUID: fD7Zf1BcRzOmUcNRd9IzRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="7924446"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.20]) ([10.125.111.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 09:37:16 -0800
Message-ID: <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
Date: Mon, 9 Nov 2026 10:37:14 -0700
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
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261108183337.GL770409@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/8/26 11:33 AM, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2026 at 03:39:56PM -0700, Dave Jiang wrote:
> 
>> I think that works for TDX. tdx-host already relays every DOE
>> message for the TDX Module, so it can hand them to core SPDM
>> code. 
> 
> Everyone does this right? TDX does, I know ARM does, and AI tells me
> AMD does too. So this is universal.
> 
>> Only part of the flow is clear text though. With the current
>> module I see the VCA, GET_CERTIFICATE for slot 0, and
>> KEY_EXCHANGE/KEY_EXCHANGE_RSP in the clear. There's no
>> GET_DIGESTS. FINISH, GET_MEASUREMENTS, the reads of slots 1-7 and
>> the TDISP messages are all inside the session, so the kernel can't
>> decode them.
> 
> Yes, but in 1.3 there would be a get digests too.
> 
>> So the kernel would get the VCA, slot 0's chain and the KEY_EXCHANGE
>> transcript from snooping, and still take MEASUREMENTS from the TDX
>> Module's device info. Would that be ok with you?
> 
> Yeah, this is what I was thinking about. I think this should be
> completly universal and uniform across every implementation.
>  
>> I tried disturbing the session from the host with a test hack in
>> tdx-host, right before KEY_EXCHANGE. A bare GET_VERSION makes the
>> device reject KEY_EXCHANGE. Replaying the VCA with one field changed
>> gets a KEY_EXCHANGE_RSP back, but the TDX module rejects it. So
>> KEY_EXCHANGE does blow up when the host interferes, as you said in
>> the other reply.
> 
> Yes, this is a critical security feature.
> 
> The host could inject GET_CERTIFICATES on its own right before
> KEY_EXCHANGE, and I'm wondering if we end up with this scheme if the
> 1.3 mode should simply have the host issue GET_CERTIFICATES and the
> TSM side just does GET_DIGESTS.
>  
>> Seems reasonable. Every TSM gets the same uAPI, and on TDX the host
>> already has every message in hand so the driver side should be
>> small. It also lets the kernel check the KEY_EXCHANGE_RSP signature
>> itself instead of taking TSM's word for it.
> 
> Yeah, not sure that has security value, but it is a nice debugging
> aide for sure.
> 
>>> If you *really* want to do certificate refresh it has to be a
>>> dedicated operation, it has to be supported by the TSM, and it has to
>>> get back another SIGNED GET_DIGESTS. All that would ideally have to be
>>> dumped into the transcript again.
>>>
>>> I feel it is alot of work and not valuable.
>>
>> On TDX the re-read of the chains comes with the measurement
>> refresh. The kernel doesn't ask for it separately. For option (A) I
>> think the kernel can drop the re-read chains and pass up only the
>> new MEASUREMENTS. It already has the copy KEY_EXCHANGE signed.
> 
> I don't know why you guys do this, I would take it out, IMHO. Just
> wastes time. Yes, kernel should forward the chain it collected with
> KEY_EXCHANGE, it isn't allowed to change and there is no need to
> recollect it.
> 
>>> I think any device that can loose its private key while an SPDM
>>> session is open (ie with live update or something) is fundamentally
>>> broken. If it wants to do this it has to break the SPDM.
>>
>> On the host side, should we drop the fresh-nonce collection before
>> ACCEPT then, or keep it as audit only? I'd rather not carry a uAPI
>> for it if nobody needs it. The guest's lock keeps its own
>> fresh-nonce recollection, as you asked for earlier.
> 
> What does this mean?
> 
> Every single call to GET_MEASUREMENTS should come with a user provide
> nonce.
> 
> You need to provide two flows
> 1) /dev/attestation/xx on the host does a GET_MEASUREMENTS for the
>    host's use, with out *any* disruption to *any* guest
> 2) iommufd command 'get attestation fd for vdev' ends up implementing
>    the hypevisor side of guest/host channel and does GET_MEASUREMENTS
>    with whatever anti-tamerping scheme TDX has.
> 
> Both of these need to accept a nonce.
> 
> No GET_MEASUREMENTS should be issued, and certainly not from accept,
> until userspace specifically asks for it with a user provided nonce.

Sorry, that was unclear, and the guest part was wrong. The guest collects no measurements at lock, only the Interface Report. It collects
measurements only when userspace asks, with userspace's nonce, so that's flow 2.

On the host I meant the optional fresh collection in step 4 of the diagram. That would be flow 1.

One thing on TDX is that TDH.SPDM.CONNECT also runs a GET_MEASUREMENTS of its own during the connect, and the kernel doesn't choose its nonce. The kernel wouldn't hand that one to userspace. Measurements only come out through the two flows, with a user nonce.


> 
>>>> (3) TDH.SPDM.CREATE runs first. The kernel sets CERTIFICATE_SLOT_MASK to
>>>>     0x01, so the TSM reads only slot 0's chain. It could also read slots
>>>>     1-7 inside the session [GUIDE B.1.1, Table B-1], but no signature
>>>>     would cover them: KEY_EXCHANGE hashes only the chain of the slot it
>>>>     names [SPDM 10.18.1]. So (a) doesn't report them.
>>>
>>> ? this is confusing. KEY_EXCHANGE slot=0 includes the hash of the
>>> certificate chain in slot 0. If the TSM doesn't even read that slot
>>> during the premable it is impossible to validate the KEY_EXCHANGE.
>>>
>>> What prupose is there for this configurable "the kernel sets
>>> CERTIFICATE_SLOT_MASK to 0x01" ? If the kernel sets for slot 1 then
>>> KEY_EXCHANGE must fail?
>>
>> No, it doesn't fail, and the note was confusing. The mask doesn't
>> control slot selection. It only picks which of slots 1-7 the module
>> also returns. Slot 0's chain is always read and returned. The module
>> reads it in the clear before KEY_EXCHANGE, even with bit 0 clear.
>> Slots 1-7 are read inside the session after KEY_EXCHANGE. Setting
>> 0x01 just skips reading chains nothing signs.
> 
> OK.. Weird, not sure I see that as useful?

For (a) it isn't, which is why the kernel sets 0x01. Elena explained the reason for the mask in her reply.

> 
>>> Yes, but if we do #1 above I would keep it anyhow and optionally give
>>> it to the verifier. I agree it is fairly pointless, but it is really
>>> cheap to do if you have #1 and simply capturing the *entire* signed
>>> transcript is forward looking from an ABI design perspective.
>>
>> Agreed. With snooping the kernel has them anyway. I'll change (5) to
>> keep them and hand them to the verifier.
> 
> So what I'm thinking is some kind of little library with a driver
> interface like the blow. It would be used instead of the driver just
> calling pci_doe() directly and does all the capturing magically and
> transparently.

That works for TDX. tdx-host's relay is one function today. It takes the module's request from a page shared with the module and calls pci_tsm_doe_transfer(), so att_spdm_doe_exchange() drops in there.

I tried a quick version of the capture in a test hack with the TDX Module. It rebuilt the VCA, slot 0's chain and KEY_EXCHANGE/KEY_EXCHANGE_RSP from the relayed messages, and the kernel's own check of the KEY_EXCHANGE_RSP signature passed. Agreed it's more of a debugging aid. Two things I encountered:

- The DOE payloads carry dword padding, so the capture has to trim each message to its SPDM length before hashing. KEY_EXCHANGE was 160 bytes as a DOE payload and 158 as an SPDM message.

- The chain hash in the KEY_EXCHANGE_RSP transcript is over the whole SPDM chain structure (length, reserved, root hash, certificates), not just the DER certificates. That's how the device and the TDX Module compute it.

Neither changes the proposed API. The library just needs to handle them.

DJ

> 
> Basically the only thing in the driver will be the communicate loop,
> and the little bit ARM needs to get the PUBKEY out.
> 
> I've got some AI running through to make a sketch of this to see if it
> is a terrible idea.
> 
> struct att_spdm_connection;	/* opaque */
> 
> /*
>  * Called by the driver (not the TSM core) before the first GET_VERSION is
>  * issued. @doe_mb is used, not owned; it must outlive the connection.
>  * Returns ERR_PTR() on failure.
>  */
> struct att_spdm_connection *
> att_spdm_connection_create(struct pci_doe_mb *doe_mb);
> 
> /*
>  * Release all capture storage. Must not race with att_spdm_doe_exchange().
>  * Sends nothing to the device. Evidence references already taken stay valid.
>  */
> void att_spdm_connection_destroy(struct att_spdm_connection *conn);
> 
> /*
>  * Forward one firmware-generated request over DOE and capture it.
>  *
>  * @doe_type: PCI_DOE_FEATURE_CMA or PCI_DOE_FEATURE_SSESSION, as chosen by
>  *            firmware. Any other value is -EINVAL.
>  * @req:      may point into shared or firmware-owned memory. It is read
>  *            exactly once, into private storage; nothing re-reads it.
>  *
>  * Returns 0 when a response is available through att_spdm_response_len() and
>  * att_spdm_copy_response(). An SPDM ERROR reply (Busy, ResponseNotReady,
>  * LargeResponse, InvalidRequest, ...) still returns 0: it is a response for
>  * firmware to handle.
>  *
>  * Returns a negative errno when the exchange failed or was refused before
>  * reaching DOE. The error is latched: every later call returns the same
>  * value, and the caller must destroy the connection.
>  *   -ECONNRESET  GET_VERSION restart, or RequestResynch
>  *   -EPROTO      malformed or illegal message for the current state,
>  *                including any plaintext request after KEY_EXCHANGE_RSP
>  *   -EOPNOTSUPP  PSK or mutual-authentication flow
>  *   -E2BIG       collection budget exhausted
>  *   -ENOMEM      allocation failure
>  *   other        DOE transport failure
>  *
>  * Sleeps. Takes no lock: the TSM core issues SPDM operations to the driver
>  * one at a time, so calls on a connection are never concurrent.
>  */
> int att_spdm_doe_exchange(struct att_spdm_connection *conn, u8 doe_type,
> 			  const void *req, size_t req_len);
> 
> /*
>  * Size in bytes of the latest raw DOE response, including DOE dword padding
>  * and any ERROR or chunk envelope. Valid until the next exchange or until
>  * the connection is destroyed. Returns 0 if no response is available.
>  */
> size_t att_spdm_response_len(struct att_spdm_connection *conn);
> 
> /*
>  * Copy the latest raw response into @dst. Writes @dst only; never reads it.
>  * Returns the number of bytes copied, -ENOSPC without copying anything if
>  * @dst_len is too small, or -ENODATA if no response is available. Never
>  * truncates. Can be called repeatedly; it does not consume the response.
>  * An undersized buffer is not latched: how to react is the driver's
>  * decision.
>  */
> ssize_t att_spdm_copy_response(struct att_spdm_connection *conn,
> 			       void *dst, size_t dst_len);
> 
> /*
>  * The driver calls this once firmware has reported that the SPDM session is
>  * established and valid, for example when the firmware connect command
>  * completes successfully. It is the only point where any future kernel-side
>  * validation of the captured evidence may run, and the only point where such
>  * validation may fail.
>  *
>  * Requires ATT_SPDM_CAPTURED. Calling it in any other state returns -EINVAL
>  * and latches the error. On success the status moves to
>  * ATT_SPDM_ESTABLISHED; on failure the error is latched.
>  *
>  * Evidence is only made available to attestation consumers after this
>  * call succeeds.
>  */
> int att_spdm_session_established(struct att_spdm_connection *conn);
> 
> Jason

