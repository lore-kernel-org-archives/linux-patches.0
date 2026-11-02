Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793620217;
	b=UNkYActCion2PSYtJ67pzZxR//XR1DJ3vYAOxqEy1QZpFJAchIGXysFdR1MKl1sYGs8c
	 yUmx0WbXs7lXKMACNVssTtt9eWD6Q22oi1jb0SJT1cY6dJlQ4fiSQxbN0xFTmaDzbVc0a
	 6kFgYAnBVRIcgJ5J4DD/v2ufSdmpMFyAxzvGB+vqEQDRgz5BegJRlGl16Iegp2RIz+VwL
	 CH82HuoNzxytNZ4tvFCVHVt+XaoLAHnFOUu7W3o1kS5Bi2ehlyXNpFpu4WJr2fIYic0AU
	 NiGBMfJ1dUgopHdNiCgde5EVSFZdv2sEE0sGVudUNAs1QgTG09KOs33PGk8+UfZdaIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620217;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hXNwpOfasnHwc6KjgQ/k2VCbhXUjdGHEhgqik3iZ3MI=;
	b=OrPlbWBVx2v/+msI/nGidTWiJ2F5U6aWdsoiX7W9rYBuGKPlRtE834+Ocdc8KMZAkNKS
	 TP/5dVSAwaoXjdu0WVk2TvyP4m0ZOD4cLBhM3AdaNfrGQPd33IvijYfPYI9O4BGL5L7Qa
	 XsJdvGnJcZAw3N5GIa38UjUvx1Jo+SAzSJEioRNtVvkQNXq3T+nj7WtdD7pE8kWW48PB0
	 BRjTlgMQfnKlHGhWQF1/GRjGQIVOpm8nfErROkTmxUOSPPsxrpGoABVC6sse2cDH9hxSg
	 53EYXelnYG2m4x5SP+JeQZ3lnHrE50HcKspJVGPwk+XOn9nWOo53VIzBPAoTSnZpivQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=aS7T4DIR;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC48606A326
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 11:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FC48606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=aS7T4DIR
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1417949f8f.0
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 03:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793620208; x=1794225008; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hXNwpOfasnHwc6KjgQ/k2VCbhXUjdGHEhgqik3iZ3MI=;
        b=aS7T4DIRLv7rVHRPWXbIR8op9gsfLZJ049XKkz82KRTstjJ0mvv6qOzoxtCojQOsJT
         d33H2wKAoXlwHQh1DUbFXXHFwcYyk56gwCMjbUfEiSxVFhVlMflfz5MgB2UG04Pq6Iz7
         et54ERJOwfyYLeInTUY3d2bjoAhS6mTyd6v36w90gV6Orh2fOGcs6lLGhwmMuCMIxpOB
         BAE89tgfUgdIUy96PbtXsZXEHMLcqHcAfK5HA7phEP0Fswfl9tBSpU1L3OG4m6dts6wQ
         YCUfkT2CwhPdoee+o7W0MZ+12Ks5uxoRuQ8QWJLerBa4y/tipghzcQjJFL4S0BXiZDOU
         Lm2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793620208; x=1794225008;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hXNwpOfasnHwc6KjgQ/k2VCbhXUjdGHEhgqik3iZ3MI=;
        b=EsVrxMPdT7mFXqE7dNlIx0yo8mUzNqvA+ogXh+o6BZnod/PLjzLbDzOXbQUYYp2+wS
         lfck+G9WchUuyTachtzAoShJiOhynp1ebxSh/N6W92KOtFOZ5606XQPwUESoSKK7oVZh
         b4Zsu08MNVKjiy8wVv4vXJQCHiiDQ1Lij7X9cJa1RKKisPbxj7OrPyYitOqTcHfVw4ZQ
         pP8kpVYa56sl5Q+LxFI7ruVB5GPLr8ev/EnZfko09bY9LLuPk2mBL0rx3IcS1+M1WLNd
         U03tQqelDSrlG5B52b6E6SF/mZ7rV+AXhldeepCSCHwA88Pzu6RdkHt8RM01YEFBJKo6
         lSVw==
X-Forwarded-Encrypted: i=1; AKwUvBzQILkx5Loz1Z05Buv9Ai3diocGZ43H6Ep30nxTncNqrGPCgT8fyFljOU18afKmltKbU92Zk1QD@lists.linux.dev
X-Gm-Message-State: APuU4Z/sy4nCgh9cIuUzVwptHhvpDro16JgXmzNNx94SLVwfoEpT+AAz
	GvruQAH+NWU2bMCobpIEn1MmqoO7Ot7zc/jKH1n6tgAO49ToLwTaMt6oSgFHTbqamNM=
X-Gm-Gg: AYBFou3LWYSXBc6FsoTLVFyOJjoSP6uswrFmXPl9saN8oqTs73Xy5rL6agKSBAtsHAg
	OZehH2ddX/nD6c8xrD3gLrrt4UjthRxNKqicYUkLEkA2Ih0nNGP4HzR8jATxwr0ySNL36mTJrRz
	1jVV+niTNztEEcH5imU7fEHCeGkEkJBai8bCyhzxRmT0r2HoV/ocOn14t2UnM04Nvn/QjHiUF7e
	Ct1kAb/WRgQcXK1P9KhbgO4DDFFIyp+wcPchhPfpjvgt7rAaZusiIu9QG8KzcYdzDXecSJQ1fK1
	5ZEA6YD3ojGotQBuvVvHJGzIo46KoQsgieySAMEtaNwt9YTfVPgrcc9J0bSroLAKe8ETKFS8ud6
	KCT/Of7aQF9x2P92YegltOrWuIzVWz8QOYS4miKrQJDuytwMaXwByQAuL9EpnDEikGuPQBR7KG3
	uojM1fiz3oQOclHseqTF1h+RZsNgMk5kcMukMlFdWdWGXPzkgKfj9IWVCzn8GeWeVi+LITuiyLC
	qyPBpeq7JsbK1/oLV20UgVDA3xIsuewPnT5qbgeOsrU7SZRTukNnpCgZhEzYxhv4XpEkIb7nULu
	aTblbScSxGRKod+0TCGgYGyGPMY+kAkKsCZh9rVL
X-Received: by 2002:a05:6000:4b1b:b0:48e:4300:c6d4 with SMTP id ffacd0b85a97d-48e6e503820mr24938548f8f.53.1793620207733;
        Mon, 02 Nov 2026 03:50:07 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba4ac6sm20885304f8f.52.2026.11.02.03.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:50:07 -0800 (PST)
Date: Mon, 2 Nov 2026 12:50:03 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev, Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
Message-ID: <auh3H5zQwkzx96kg@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <yq5amrrua515.fsf@kernel.org>
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
In-Reply-To: <yq5amrrua515.fsf@kernel.org>

Sat, Oct 31, 2026 at 05:05:26AM +0100, aneesh.kumar@kernel.org wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:
>>
>>
>> [..]
>>
>>
>>>diff --git a/Documentation/ctlv/specs/ctlv-attestation-pci.yaml b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>>>new file mode 100644
>>>index 000000000000..edb35cede0c2
>>>--- /dev/null
>>>+++ b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>>>@@ -0,0 +1,79 @@
>>>+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>>>+%YAML 1.2
>>>+---
>>>+family:
>>>+  name: ctlv-attestation-pci
>>>+  inherits: ctlv-attestation
>>>+  pre-init: true
>>>+
>>>+attr-groups:
>>>+  - name: pci
>>>+    attrs:
>>>+      - name: name
>>>+        type: string
>>>+        min-length: 1
>>>+        max-length: 31
>>>+      - name: generation
>>>+        type: uint
>>>+        max: 4294967295
>>>+      - name: tsm-id
>>>+        type: uint
>>>+        max: 2147483647
>>>+      - name: connected
>>>+        type: uint
>>>+        max: 1
>>>+      - name: locked
>>>+        type: uint
>>>+        max: 1
>>>+      - name: accepted
>>>+        type: uint
>>>+        max: 1
>>>+      - name: dsm
>>>+        type: string
>>>+        min-length: 1
>>>+        max-length: 31
>>>+
>>>+      - name: object
>>>+        enum: evidence-blob-class
>>>+      - name: challenge
>>>+        type: binary
>>>+        min-length: 32
>>>+        max-length: 32
>>>+
>>>+attr-sets:
>>>+  - name: device-info
>>>+    attrs: pci.name
>>>+  - name: change-reply
>>>+    attrs: pci.generation
>>>+  - name: state-reply
>>>+    attrs:
>>>+      - pci.generation
>>>+      - pci.connected
>>>+      - pci.locked
>>>+      - pci.accepted
>>>+    optional-attrs:
>>>+      - pci.tsm-id
>>>+      - pci.dsm
>>>+
>>>+  - name: refresh-request
>>>+    attrs:
>>>+      - pci.generation
>>>+      - pci.object
>>>+    optional-attrs:
>>>+      - pci.challenge
>>>+
>>>+ops:
>>>+  - name: state-get
>>>+    type: action
>>>+    fd-access: read
>>>+    reply:
>>>+      attrs: state-reply
>>>+  - name: evidence-refresh
>>
>> I'm missing why exactly you need this op. Can't you do whatever is
>> needed in the provider evidence_get implementation? Why it needs to be 2
>> step.
>>
>> Also, why do you think this is provider-specific op?
>>
>>
>>
>>>+    type: action
>>>+    fd-access: read-write
>>>+    availability: dynamic
>>>+    optional: true
>>>+    request:
>>>+      attrs: refresh-request
>>>+    reply:
>>>+      attrs: change-reply
>>
>>
>> This differs from what I had in mind: a transport-neutral
>> ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.
>>
>> SPDM_GET would report discovery BaseHash, discovered slots and their
>> certificate digests, authentication state, and the effective
>> authentication slot. SPDM_AUTHENTICATE would take device-generation and
>> the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
>> blob-instance=slot without selecting the authentication slot.
>>
>> That discovery view is not present in the posted schema; STATE_GET does
>> not provide it.
>>
>> Would this split work here? It would also allow non-PCI SPDM adapters to
>> share the contract. I understand that multi-slot discovery is deferred,
>> but a slot-zero implementation could still use this family and operation
>> layout.
>>
>
>The only point that remains unclear to me is the distinction between
>EVIDENCE_ACCEPT and SPDM_AUTHENTICATE. Also, would EVIDENCE_GET retrieve
>fresh evidence on every call? If so, we do not need evidence-refresh.

The distinction I had in mind is between authenticating the connection
and approving evidence before allowing device use.

SPDM_AUTHENTICATE would select the certificate slot, authenticate that
identity, and complete the required SPDM/session/IDE setup. It would not
authorize TDISP RUN. A preceding EVIDENCE_GET would be optional, for
example if userspace already knows which slot it wants.

EVIDENCE_ACCEPT would reference an exact EVIDENCE_GET result. After
userspace appraises it, acceptance would perform the native transition
allowing device use, such as moving a locked guest TDI into RUN.

Typically:

  Host:  connect -> discover/select slot -> SPDM_AUTHENTICATE
  Host: connect -> SPDM_GET -> [EVIDENCE_GET/appraise chains]
      -> select slot -> SPDM_AUTHENTICATE

  Guest: lock -> EVIDENCE_GET -> appraise -> EVIDENCE_ACCEPT -> RUN

This is an API design choice, not a protocol requirement. Using
EVIDENCE_ACCEPT for both is an alternative, but then generic acceptance
would also to carry the SPDM-specific identity selection. Better keep
that separate.

