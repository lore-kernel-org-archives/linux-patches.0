Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784070;
	b=VsCzyo78SbH0REYxA9GQY3KsPhX5kJO6095R+rft3cG9TBYEzFt+wVdfqqJ/AX6I9g/V
	 wsi/G5/zjAB5oRAQgcQbBrrj40Y768NeoT8sgG0MkP6dP+YqIP32IUarjJ7g2z9AjLu/V
	 yZ7/f1PHNz2M7Y6V2hZoq1YtVWiW63s4WrjzYO7eCizBPbd+GtbZAmS+N3aIJJbBva97C
	 wW+ye2Emmm/oFfWLgDocd7jj0c/05f2eYX+f4BYHcY0Anfi6Y1u5UCSspM83wcTHs9Y2h
	 2q5eKwQxU0ltx0X8S6uoOsjcOrR8sC1ZlZuviPTASi40OQi1GoEfnIqIpYQh+Gn4C1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=qP1P0URjAjWUED6GlzWcoQ/XZcfq40q7E+n+HZe0Uyo=;
	b=WAYmwenIs1ftYxHRaUNx25SUfS+Nt2LuWwcaSxF4vKYUpYJvrx6Zd7xGEpyPkEseCSoi
	 w6/hJbnr+xuMcgQC30b6+V694KdBULqkaj5RWniUHVEJfNqfjtWQIET6jBWw4Z0Wtz6kc
	 IcH0QkMzHfOIRgKsbo9W9IhUPtHH45prqGENUcFrm5v9Gs61PLtmPpd1WcOqgWG0V6mPk
	 Bxkuq7wT65Q3GYs+NYdBD8oujmHPpP8kLhmuMu/FQ+qf8iVnYTMHWoy40GRcwAwqHU3OF
	 zGL1HHUGO/QukBHtyzys+OnA18+zZXSQx4LGSLFxhN9KfLSjHz3Wrde5ObaB6QS4dUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=ew3TCzEE;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64578606A326
	for <patches@lists.linux.dev>; Wed,  4 Nov 2026 09:21:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64578606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=ew3TCzEE
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c4649b35bso373325f8f.3
        for <patches@lists.linux.dev>; Wed, 04 Nov 2026 01:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793784067; x=1794388867; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qP1P0URjAjWUED6GlzWcoQ/XZcfq40q7E+n+HZe0Uyo=;
        b=ew3TCzEE3r2eaD2VK6K8Xq1atAutPgiaH0dKkqX3jEJHzumUQErqKWu5D/xnohwk7z
         ZP8SJAFMLnTaVzqAUwAjGn1tNwJGkxFWm/cg2xcUwTd74WsNFg3VGlm+aSw6BQk4rig9
         lY0UjEcWbRfR2X/Y4398BKjOQnk04nA/XrH+YIM4ORsoFAx97H35awr/Cuq490Ac8C2t
         AYVulvRMqfiIYYQDsHFi1YspvEaGw2UGtIGudgPWr1ewGm2Sk7WsMnN5dVtDNWMjr5TG
         sV3GCRpARnjMp2nJ31WuS1ch8HOpgEr/u3IFdNQDvtbUCrGWx5bmCqHaOc3/+jBPSCEU
         Dj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793784067; x=1794388867;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qP1P0URjAjWUED6GlzWcoQ/XZcfq40q7E+n+HZe0Uyo=;
        b=EuL5hN7Sn34vzs5xgObo8ZqV/sNhzBcaOU+2aKaK/x5VsGyivNyQ+m26CBTQwtk38q
         37vvGXq27kXrL0Xye0uGfp18YCcalxysxhxqOZKd2Q7S/QOlaGbm1jaeGgXbk8HUXji0
         CJz6CA80PPZmlucLek2D1wZNla50aKr23h4Ifo8kc7f0od8lE9v6s+OZ3vFFeBkF2sMy
         UrE9ETbECS4knVT808qJWtx1wItkTCB/jJ0D8CxkVnEbOJFQcuqHTIRB8/UqSrzRyMOP
         2NKaw3BqQszO+V3Vs9rT8lC738lBsZApOjC/xjK1ubA5NcxsIiKk3mBHrOSap2kM1Ib0
         mOdA==
X-Forwarded-Encrypted: i=1; AKwUvBz83/c/gCnEUXmrshYxa+G7pSSSOGVscUhhxibU0podo0vdyVfMATR1Bf+4bmPX0ChQNG4gfz5v@lists.linux.dev
X-Gm-Message-State: APuU4Z8JLv1LwGt/h3Lzip4Si4U3z1e/Daj+q99W1W0+6GqyNuJFok97
	v0l4xreatgBM2HmuWozV7j4vpIW/nqCNJAIOrL2FPSZFfyPU8GfbrnGYrdUOgnZdXM0=
X-Gm-Gg: AYBFou0l1qn9IQtzhrY43URWImJyyb5HJWELNpKjEvP2r63UGgt0TH/mgr67BC50lCB
	fKXnBKvLCZ6I6QdZsujqx5BycqCI1PR1HlfAMEEXU+gnYL0FAD/WXlayTnDZFWejW8AT2U6/qjj
	Xpc4OJS97b7j4ew/HZhQsut92VjHi5cw511AWUEDLLiVRmTgPvgOKiHXb+9A/qqLE4Od6tzUJpN
	r+7sfMzkJw1n2OsefiIoHnWx7fnk0foPEHlyOy8wAlGNtMi3GSe1Q1BzHZF7QBh9FVDOzBegv2A
	bEc+KMO/AkL/YQUHembI0LoqFR/xdU+R3gppX6dT3xOX1FjHHOQqKm4HgHDScIdVe4CWdGzQFvp
	ddeLxjDsYsnIiIR1YSUAmlhHJuruM9u6/jXLM9cCBtqEmxQIxWQdz3Uak9j4QEqohZq5upy1ASs
	bEPcjROIqJdusPegF6IMfGBGgXaIPlhFSzc6nru9R9VVXVGdrazhLWC8Ai7n+cj7A0F/Vvsvqvr
	YE5dcQ0z1+z6P0otLkOOtRPBoqHbtv0sUa60RHescXuJjOmiI3YQNiLtcBsTgXZu6bxgpTeaNKh
	SFqmzD2UmqQ+kB1RCJsqnt7mjdF8+pvWmTmvAg==
X-Received: by 2002:a5d:64c9:0:b0:48e:4e00:b737 with SMTP id ffacd0b85a97d-48e6e515ff2mr39310935f8f.54.1793784067410;
        Wed, 04 Nov 2026 01:21:07 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fece99b33sm2621714f8f.23.2026.11.04.01.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 01:21:06 -0800 (PST)
Date: Wed, 4 Nov 2026 10:21:02 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, 
	linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev, Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
Message-ID: <aur3SrC49Z7FW6c7@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <20261030154353.GN3734323@nvidia.com>
 <auh_GGpJ0ngQTETS@FV6GYCPJ69>
 <20261103154539.GM274202@nvidia.com>
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
In-Reply-To: <20261103154539.GM274202@nvidia.com>

Tue, Nov 03, 2026 at 04:45:39PM +0100, jgg@nvidia.com wrote:
>On Mon, Nov 02, 2026 at 01:45:19PM +0100, Jiri Pirko wrote:
>> Fri, Oct 30, 2026 at 04:43:53PM +0100, jgg@nvidia.com wrote:
>> >On Fri, Oct 30, 2026 at 03:01:29PM +0100, Jiri Pirko wrote:
>> >> Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:
>> >> >+    type: action
>> >> >+    fd-access: read-write
>> >> >+    availability: dynamic
>> >> >+    optional: true
>> >> >+    request:
>> >> >+      attrs: refresh-request
>> >> >+    reply:
>> >> >+      attrs: change-reply
>> >> 
>> >> This differs from what I had in mind: a transport-neutral
>> >> ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.
>> >
>> >Yes, we should try very hard to keep all the SPDM stuff as transport
>> >neutral as possible.
>> >
>> >> SPDM_GET would report discovery BaseHash, discovered slots and their
>> >> certificate digests, authentication state, and the effective
>> >> authentication slot. SPDM_AUTHENTICATE would take device-generation and
>> >> the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
>> >> blob-instance=slot without selecting the authentication slot.
>> >
>> >Do you have a mapping to ARM RMM operations already you can share with
>> >Aneesh?
>> 
>> Yes. For SPDM-capable PCIe endpoints, this is the mapping I figured out
>> with LLM, using the existing RMM 2.0-bet3 interface:
>
>Lets talk about this in this thread:
>
>https://lore.kernel.org/all/20261103151643.GI274202@nvidia.com/
>
>> sysfs connect (PCI/TSM and kernel SPDM requester):
>>   Perform preliminary negotiation and GET_DIGESTS/GET_CERTIFICATE.
>>   Retain the discovery snapshot and destroy the temporary requester.
>>   Do not create the endpoint PDEV yet.
>
>If we want to do what I called option a, with user space repeat, then
>we need a CTLV command to start the flow, not sysfs.
>
>I have been thinking sysfs should only create the attestation end
>point and not do any RMM operations

Okay, sysfs connect can just associate the TSM and create the
attestation instance. Starting/restarting the protocol would be driven
through CTLV, Is SPDM_GET op the one you have in mind, or something
additional done before it?


> 
>> SPDM_GET (attestation provider):
>>   Return the retained discovery information and connection state.
>>   There is no corresponding RMI discovery command.
>
>> EVIDENCE_GET(CERT_CHAIN, blob-instance=N):
>>   Return the retained DER certificate chain for slot N.
>
>I think these two are my #2
> 
>> SPDM_AUTHENTICATE(device-generation, slot):
>>   Validate the generation and selected slot.
>>   RMI_PDEV_CREATE(id_index=slot)
>
>Maybe PDEV_CREATE is in my #1?

For current RMM, PDEV_CREATE fixes the certificate slot through
id_index. For option (a), I would therefore leave it in #3:
START is a no-op; FINISH(slot) creates the PDEV and runs to PDEV_READY.


>
>>   RMI_PDEV_COMMUNICATE until PDEV_NEEDS_KEY
>>     -> RMM performs fresh negotiation and retrieves the selected chain
>>     -> CCA host driver relays requests over DOE and caches the chain
>>   Compare its DER certificates with the selected discovery identity.
>>     -> reject a mismatch before supplying the key
>>   Extract the leaf key; RMI_PDEV_SET_PUBKEY -> PDEV_HAS_KEY
>>   RMI_PDEV_COMMUNICATE until PDEV_READY
>
>This is my #3
>
>>   Prepare the root-port PDEV to READY and configure PCI IDE resources.
>>   RMI_PDEV_STREAM_CONNECT
>>   RMI_PDEV_COMMUNICATE on both PDEVs, honoring STREAM_WAIT
>>   RMI_PDEV_STREAM_COMPLETE
>>   Enable the endpoint IDE stream.
>>   Only then publish authenticated state and the new device-generation.
>
>Oh is IDE under the control of the OS for RMM? I hadn't read that far
>ahead. Then it should be done as part of the "ACCEPT" step #5

Yes, the host drives IDE setup through the RMI stream operations;
RMM handles key management. We can move that setup to host
EVIDENCE_ACCEPT, after appraising the session identity.


>
>ie the same place we would do RUN
>
>Jason
