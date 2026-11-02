Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623527;
	b=LasoJ0iGAGCOpmf/Q0kx0aY7A/2HkiwqAmNOXCu5qcppl8IlMlX8tk0rdCj/pBwDc/C0
	 4hV/JUAN+PN9bZBIEPq5ZnwpBMBGfoDkS5jJjGtbU95BO4NEDIADW3g5q7xCXv4qhxXDK
	 bqO5aEKYNU9NCciVMg6q5NXM5qT+jv297mXi48nKLQzh8REJGs4DMV8DISQVAr2EajOfk
	 KwzSOivwnyNxaSrGPLit80VlNvJ8oeAskDeGpzDuF33Ce5vvzORonK0l7K0z4ECymLCNA
	 vn8i7rp7f1jbKvsPjnXGI0se+uxQ4nIpTWgZJECjnOPBlxxHDHuvn5FMJd90pbCk+iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623527;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=PT7CWHpvNKeQzTrBYKakMU7LWZDvbAJYzwpyQwagUfU=;
	b=dePzIAAa7nh1gM8wiRPZ9/uiSJmfRvBYlBbSwO3J+FXL4ICET64fuy1GsUX/wODZ06Kc
	 v9TklI9BP0SwIetPbmaAxQzREa3e41J7SpDPAo6Lcp50boobN9WoIvVZIztdic9P59jpt
	 Fp6xbwCGQqkFQ12XZMTAddpRWCzrXDtJQFf6kZZteOtev4HSw9eC2LyFRiuRQyV9ZiJIV
	 BYcW0BUHHFhm/mKRkzSnbNAAnvLDya64QUoghFKeqiCn41qWb/e0qHeoEL2f03ZoeeP9e
	 orSbUsBvv6thHVqicp2eMIyhWN28GZNZn2k/UGTOpEufDWE7w31zYZWFuZw6iv7TUwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=dN6fVMrA;
	arc=none smtp.remote-ip=209.85.208.182
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96896606A339
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 12:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96896606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=dN6fVMrA
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3ab3b29a1d4so23437061fa.1
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 04:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793623523; x=1794228323; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PT7CWHpvNKeQzTrBYKakMU7LWZDvbAJYzwpyQwagUfU=;
        b=dN6fVMrADnnOq9gAZ8X0cwHOCy/Yxe6sjLHs9Pi7OzMOBLrOBTFlyo/4WwDrKcaEF+
         EMeBfgKn2wA3qQNU4cO8OYTsWSF00QV3ZsnzE4oBry75vJWJLPhAw6RQyanHE18ljhci
         TmENhoiVZuTBXQU6+e4GzYZe8v3CZtIHrmr4nZJ3DMLqIMz4nW8qEreEZMWpXiR2KdOp
         vjtIezSW6pCjSb7TIDPSO+R+Tyz7IYbr7o6jO6B/9Uwu5ubAWXdIqKTDh6lyVVhGQBvL
         //lMH5YpavS5vO1aEPId8My7BcXsj0QfI0E6QeZbhKnQTrBcw2ktdKx0ilxsxNUGP7CC
         HMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793623523; x=1794228323;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PT7CWHpvNKeQzTrBYKakMU7LWZDvbAJYzwpyQwagUfU=;
        b=eUvx6M6+YAD3NY0aqaKbiYXf04ioZIHKIjHXaMrO8YUfVbqjGeMh+Yn9uuqbIlP2/E
         la57gzGsMVlWraotUX+c4oM36XfSFVlQgrXQAe8+C47UKZjoS1dcWy2P+jfKJkKuQBja
         FnzFsvPC7lvTCNIw4slryesc55ZRrfj5Q3jfbC9+U0l+DBpARw0v1iL8dcGtJ51YuH72
         EZWk1vWkAGfzqYKFHw0tlxd+Gqspes+YZZTpPVQoNzzcFKESeyVWtBObGhukS0eSwjjj
         AElez+VVWKHv5bLMZCS7tfmGrMPbyTTQsr/a3eqgN4XWhlLPCkSMgU8H1kl/B9E1xPeu
         ebqg==
X-Forwarded-Encrypted: i=1; AKwUvBw/jevOA9IPhfeJSZQmApaZd1SisGW7irgpx5FyI4cWuB9Sw9onoXLWaSb2Y9G0i7ui2NgBk2Iu@lists.linux.dev
X-Gm-Message-State: APuU4Z9l01AChGYMD4EqyrttRZV3nRwRcSfutWciGSUrbE7K48EYV66F
	GHqLVv/vAb37wIsJlDoL612lSXN7xASAEwOn31cZ+38WGe4IH+U/bHOlquFWwbAUgqw=
X-Gm-Gg: AYBFou3nG5Mr9wQbDS3GkhaXnxqZDiJihs4p4Ty2QZSeVulXAFM/WcKqZDFN3a6UOTQ
	lWHbo2JerzQrIT98HevYopL//RT3VXFxMb/5pLklk8BO1oCPCDHQB6qvHWa/ig9dprTJFw9q+4e
	EjVrQAegJQxOUH5xSwWbMoa52tS4EM2T9LbeiEdMcCiZrlzUDIA5T1tTHituwvm0QRMkv+srhYk
	vBKQKwFZlqVdAQfvnpXwhr6fwBZmn8ShpQF6EbesM7wUOfH1CFNhbr5uRnHEgIT1H9eJkB9SqzS
	IBtp0xPL5v0ET9lqbXWQqRR8z/SFtDv9Js2sZPMu18LeeI9+bwX8EE8kMAywWwXfAimn2YnIuES
	FblcJdjnq8q34/N68vJlh4uE6LbHJ73v9wc44zLdpXG2y3OwUOH6QI47/+9Ua3f6SfXQ4kghIH7
	ZKErjqjUaz5bPxWExn3s0oY8oKPEfzAj+tXsnJBK1bL/Io+/giGPrvJx3ZMoA9yqsZpcFnurq8K
	sTjRXPGO+n+eDgM2UppHGyGFZLVfvXgv6smWUXixuf0QQSoaMtSmsMqYkhrQTgOS6LKzSzsvpHV
	xcypR6N7LaWqmvpTPlshCYXmA2OZfPOOcfakDLg=
X-Received: by 2002:a2e:9fc6:0:b0:3aa:ee9b:cf2c with SMTP id 38308e7fff4ca-3acb7aa8400mr22439851fa.14.1793623523562;
        Mon, 02 Nov 2026 04:45:23 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acbbf458c6sm20091341fa.40.2026.11.02.04.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:45:23 -0800 (PST)
Date: Mon, 2 Nov 2026 13:45:19 +0100
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
Message-ID: <auh_GGpJ0ngQTETS@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <20261030154353.GN3734323@nvidia.com>
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
In-Reply-To: <20261030154353.GN3734323@nvidia.com>

Fri, Oct 30, 2026 at 04:43:53PM +0100, jgg@nvidia.com wrote:
>On Fri, Oct 30, 2026 at 03:01:29PM +0100, Jiri Pirko wrote:
>> Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:
>> >+    type: action
>> >+    fd-access: read-write
>> >+    availability: dynamic
>> >+    optional: true
>> >+    request:
>> >+      attrs: refresh-request
>> >+    reply:
>> >+      attrs: change-reply
>> 
>> This differs from what I had in mind: a transport-neutral
>> ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.
>
>Yes, we should try very hard to keep all the SPDM stuff as transport
>neutral as possible.
>
>> SPDM_GET would report discovery BaseHash, discovered slots and their
>> certificate digests, authentication state, and the effective
>> authentication slot. SPDM_AUTHENTICATE would take device-generation and
>> the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
>> blob-instance=slot without selecting the authentication slot.
>
>Do you have a mapping to ARM RMM operations already you can share with
>Aneesh?

Yes. For SPDM-capable PCIe endpoints, this is the mapping I figured out
with LLM, using the existing RMM 2.0-bet3 interface:

sysfs connect (PCI/TSM and kernel SPDM requester):
  Perform preliminary negotiation and GET_DIGESTS/GET_CERTIFICATE.
  Retain the discovery snapshot and destroy the temporary requester.
  Do not create the endpoint PDEV yet.

SPDM_GET (attestation provider):
  Return the retained discovery information and connection state.
  There is no corresponding RMI discovery command.

EVIDENCE_GET(CERT_CHAIN, blob-instance=N):
  Return the retained DER certificate chain for slot N.

SPDM_AUTHENTICATE(device-generation, slot):
  Validate the generation and selected slot.
  RMI_PDEV_CREATE(id_index=slot)
  RMI_PDEV_COMMUNICATE until PDEV_NEEDS_KEY
    -> RMM performs fresh negotiation and retrieves the selected chain
    -> CCA host driver relays requests over DOE and caches the chain
  Compare its DER certificates with the selected discovery identity.
    -> reject a mismatch before supplying the key
  Extract the leaf key; RMI_PDEV_SET_PUBKEY -> PDEV_HAS_KEY
  RMI_PDEV_COMMUNICATE until PDEV_READY

  Prepare the root-port PDEV to READY and configure PCI IDE resources.
  RMI_PDEV_STREAM_CONNECT
  RMI_PDEV_COMMUNICATE on both PDEVs, honoring STREAM_WAIT
  RMI_PDEV_STREAM_COMPLETE
  Enable the endpoint IDE stream.
  Only then publish authenticated state and the new device-generation.

[..]
