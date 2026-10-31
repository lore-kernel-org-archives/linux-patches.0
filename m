Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793419536;
	b=hgjD9tTPgMOMPT1HJSkHiTjmRwrVCFpHHcWjKMFO5Ivl2x5DGwA84Utw8Mo6DkxwgySu
	 QZNlMOpq6er3MMtTYmQMVQMGBlVPvODxV5X4gvWA+GvQN7GVWjcVmrU/Vo4JFlDx3V/zU
	 RAak0k0KuTIc3KEjxtqjD1LD/z3MzODi+3nncgI/t9jb/YEKib3GmO+Ssb19b3WD/Hvb5
	 HK3akUj4+VaUEdzIJY9RI1HDBYN7uKqMnZjPkmwv2KeVRsO8yfW/SwmumctMUKOFGlomL
	 GJQkqas6eCgMhDXs2WyPhre0qU/Zw3T9pnLHBN+91fNzO7lP6h6S7wb9menJ+LQNYsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793419536;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=dFnZPgvflLjsrwu/FDjqzm0I9a4+jjDoB6+AUQ7O/rw=;
	b=J4nqXUfy2vUjCUbTymiugpUDlAp2AHNDHot26mNnIeo1nVVQbSPHpATM6UK85nNq33v/
	 J2GtFYiiB6WvjHRB9+XtCy5mrN+qtWQAjFcyKw41Vh95/xxhgtXW1eTK3JBCZN5YDkLjd
	 0q+lJI9Eq8RgeL3DP8Hpk0/bpuxf9CVWwd7qa+ejbF8bSG3uKDPcPdiqkDqMhQf0bCjdD
	 B8sFTLuvbDk08UudHe2Nrh4ULIY6V8Z9kCa31inl46JuKVIhpuYN8k+3fVEPnKKRpDDQR
	 vzl8zs/oAwcI9GGdqZE6Vd/m0z377rD/U4fITPHrQZxM2e5WtxoP/OeZ2C1dA1xHA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQ1+eoL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A5606A31A;
	Sat, 31 Oct 2026 04:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQ1+eoL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD951F000C1;
	Sat, 31 Oct 2026 04:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793419535;
	bh=dFnZPgvflLjsrwu/FDjqzm0I9a4+jjDoB6+AUQ7O/rw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BQ1+eoL3qAyujN8BGDsy5syVs82lurL5jewSrUYVdu9xVp4RyzEZVqXSBcGBRvZBR
	 xqgoq1q4FnYgGQHDCWatxIPYxmzuDIX7KZN8X98C3ZMBMWH5mBjSMb/ZtX9iX0/b/r
	 B1JSp8k7btstRwjEpP5u0o5ZHyi3KR4FWbie2plVjJ/nlkxLlTEIL7tPUmvLI9tk34
	 KdskqUPgt5L0bep49O01Yzu9Gq6w0Uc059tNdBOz4kcDkhAPBZxRR8rdYFi2H7IWRx
	 PM66F/1T4AKhHqfQqVSAGC8zGSitw/oT0bHlaRjUv5Fztp8SmhTIinzEQlzHDs3yr7
	 0qhRSvVlMs8dg==
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
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
In-Reply-To: <auShvL2m00S70H3d@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
Date: Sat, 31 Oct 2026 09:35:26 +0530
Message-ID: <yq5amrrua515.fsf@kernel.org>
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

> Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:
>
>
> [..]
>
>
>>diff --git a/Documentation/ctlv/specs/ctlv-attestation-pci.yaml b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>>new file mode 100644
>>index 000000000000..edb35cede0c2
>>--- /dev/null
>>+++ b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>>@@ -0,0 +1,79 @@
>>+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>>+%YAML 1.2
>>+---
>>+family:
>>+  name: ctlv-attestation-pci
>>+  inherits: ctlv-attestation
>>+  pre-init: true
>>+
>>+attr-groups:
>>+  - name: pci
>>+    attrs:
>>+      - name: name
>>+        type: string
>>+        min-length: 1
>>+        max-length: 31
>>+      - name: generation
>>+        type: uint
>>+        max: 4294967295
>>+      - name: tsm-id
>>+        type: uint
>>+        max: 2147483647
>>+      - name: connected
>>+        type: uint
>>+        max: 1
>>+      - name: locked
>>+        type: uint
>>+        max: 1
>>+      - name: accepted
>>+        type: uint
>>+        max: 1
>>+      - name: dsm
>>+        type: string
>>+        min-length: 1
>>+        max-length: 31
>>+
>>+      - name: object
>>+        enum: evidence-blob-class
>>+      - name: challenge
>>+        type: binary
>>+        min-length: 32
>>+        max-length: 32
>>+
>>+attr-sets:
>>+  - name: device-info
>>+    attrs: pci.name
>>+  - name: change-reply
>>+    attrs: pci.generation
>>+  - name: state-reply
>>+    attrs:
>>+      - pci.generation
>>+      - pci.connected
>>+      - pci.locked
>>+      - pci.accepted
>>+    optional-attrs:
>>+      - pci.tsm-id
>>+      - pci.dsm
>>+
>>+  - name: refresh-request
>>+    attrs:
>>+      - pci.generation
>>+      - pci.object
>>+    optional-attrs:
>>+      - pci.challenge
>>+
>>+ops:
>>+  - name: state-get
>>+    type: action
>>+    fd-access: read
>>+    reply:
>>+      attrs: state-reply
>>+  - name: evidence-refresh
>
> I'm missing why exactly you need this op. Can't you do whatever is
> needed in the provider evidence_get implementation? Why it needs to be 2
> step.
>
> Also, why do you think this is provider-specific op?
>
>
>
>>+    type: action
>>+    fd-access: read-write
>>+    availability: dynamic
>>+    optional: true
>>+    request:
>>+      attrs: refresh-request
>>+    reply:
>>+      attrs: change-reply
>
>
> This differs from what I had in mind: a transport-neutral
> ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.
>
> SPDM_GET would report discovery BaseHash, discovered slots and their
> certificate digests, authentication state, and the effective
> authentication slot. SPDM_AUTHENTICATE would take device-generation and
> the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
> blob-instance=slot without selecting the authentication slot.
>
> That discovery view is not present in the posted schema; STATE_GET does
> not provide it.
>
> Would this split work here? It would also allow non-PCI SPDM adapters to
> share the contract. I understand that multi-slot discovery is deferred,
> but a slot-zero implementation could still use this family and operation
> layout.
>

The only point that remains unclear to me is the distinction between
EVIDENCE_ACCEPT and SPDM_AUTHENTICATE. Also, would EVIDENCE_GET retrieve
fresh evidence on every call? If so, we do not need evidence-refresh.

-aneesh
