Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793427898;
	b=riIIk29WhBLLZPI2nKCTEn8Ggz/SOCgceGN1JjjDaKHFYuJNT6/tWGBd1GDXFHLWLJlh
	 eAR5InKGErcJwUmSUFQpvAtjdL06NNnsqHttit6zUkqCtp3zda1P+jFaPzewd+8f6GOYw
	 PnaH21BOg+vp2ZLWrIdEZN8yDcSsIIN7rAdyBpz2LyUD538oDLb/HTAoML7KAoKevF5+Q
	 pnhDqdzI3T+r/H0vhnqZS4OsHUeyNQAigB46HosObxTXe9zYiTiGbF5TBex3zqSMuY21N
	 huU2TQfVsxVATnz1HXwnhkyfkjUXDoSP+WQf8SMVPd69o8rU51v1ABmkfwdHCk7vcfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793427898;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=HqKPasDyHVzgQf6STvy+cgNCVVhZ8yNZrvR7X75yp+0=;
	b=DAPK5ahUYwva5PFsfe6uCrc88GV7z4O7j9n4M6mEkzse3oz+UCv77S5Y/r/CaBHdWKdV
	 souJTQtOO2fBaLMgH2OtFIp7fvSVvI2HwNRB9g2Hh7vgdkA8WXLmYHtKpsAO4vMlLIP/c
	 KHnAENYBJB/VzN7mt8qw3/cyerq6tpgaC6SntlYzaPxlUapN77Q1jcXwEf37MMpXVsVW1
	 R+qlQMb389ieZKNGUJsWzgwHIt7KMbfO7Yhd1fZ6qGPJs3t3k2VX5JnUNNQRM8mC0nS8N
	 G0AEUA+WaUq68crpKEOzbg5JlPsgiFFdFgE2BmMZcpDEgQA6fIKXlDaDJpLcbgivYnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmqv8eKA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB86606A31A;
	Sat, 31 Oct 2026 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmqv8eKA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87AE1F000C1;
	Sat, 31 Oct 2026 06:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793427897;
	bh=HqKPasDyHVzgQf6STvy+cgNCVVhZ8yNZrvR7X75yp+0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=nmqv8eKAdIp60xqNWfQ2JKRLItA/s39epbi/y2PtHLL3Ps4M3pJAlOKfjFfgBXKuo
	 pCRVwOvbLF1RxQqS+VfhRgKTtpaA/jgd1ZGNTngUBKstrzK9xFo/RCnuKv5/qAtls1
	 6T4qBzSDW6ASEmMNVGpM2Vj5CcKa+VeufHs7B/a8QhqKEJ2HUZg8DmD7xH5QiCv6dm
	 TVOGtlJKELZFUJcB3+FXTcA30N3HHmA7fzuO34bjgl5TatKOySGb3gyzGhYeUul3L6
	 glShjySBZpIbw06ZEbr0zCDP/qSNBw3lkjRDh0sjArn/AjmR7fF2g7jfCUSzLHqXtK
	 s3+BMsGy+Bw+w==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 02/11] attestation: Filter evidence objects per
 instance
In-Reply-To: <auSe3YzgKX-lu27G@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-3-aneesh.kumar@kernel.org>
 <auSe3YzgKX-lu27G@FV6GYCPJ69>
Date: Sat, 31 Oct 2026 11:54:47 +0530
Message-ID: <yq5aecd69ykw.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jiri Pirko <jiri@resnulli.us> writes:

> Wed, Oct 28, 2026 at 04:26:09PM +0100, aneesh.kumar@kernel.org wrote:
>>Allow an attestation instance to expose only the evidence objects its
>>device supports. Add an optional evidence_object_supported() callback
>>and use it both when building DEVICE_GET capabilities and when checking
>>EVIDENCE_GET requests.
>>
>>The following PCI/TSM patch uses one attestation implementation for
>>devices that support different evidence objects. Its list includes
>>certificate slots 0-7, SPDM VCA, measurements, and a TDISP interface
>>report. Each device must expose only the objects it supports, for
>>example:
>>
>>  Instance                  Supported evidence objects
>>  ------------------------  ------------------------------------------
>>  Host link using slot zero Certificate slot 0
>>  CCA guest device          Certificate slot 0, VCA, measurements,
>>                            TDISP interface report
>>  Host PF0 after discovery  Certificate slots reported populated by SPDM
>>
>>PCI/TSM checks the TSM driver's evidence_types bitmap or, after SPDM
>>discovery on a host PF0, the populated-slot bitmap. The preceding patch
>>controls whether EVIDENCE_GET is enabled; this patch controls which
>>objects that operation can retrieve.
>
> For SPDM slots, I think it would make sense to distinguish supported
> slot addresses from discovered population. DEVICE_GET describes fixed
> object tuples, formats and limits; SPDM_GET reports the populated
> slots and their certificate digests. An empty supported slot
> returns -ENOENT.
>
> Fixed differences between backend instances can be selected before
> publication. Please do not make the capability set follow a
> populated-slot bitmap that can change during the instance lifetime.
>
> [..]


We still need to filter objects such as measurements and the interface
report based on the backend instance. Are you suggesting that we do this
in attestation_evidence_object_find()? 

supported = attestation_evidence_object_find(att, blob_class, has_instance,
					     instance, format);
if (!supported || !attestation_representation_in(supported, representation)) {
	kfree(objects);
	return -EOPNOTSUPP;
}

So the backend will have some way to indicate which objects it supports,
such as the TSM driver's evidence_types bitmap, with the host setting it
to indicate support for only CERT_CHAIN[0-7]?

-aneesh
