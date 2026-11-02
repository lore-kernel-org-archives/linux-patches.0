Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619054;
	b=clBZpGqSD/ib7PDy26Wm1928yVm+CG1+8RwpPceTWbMZiamPhLwFsV5nyrcfOeY2B6Z9
	 /uL48h0Z/vPc3gEw6R9dl4i6/f+Xd+tSntX8XYG/cSMxD4CDA6YwsPbvwW6ruvOCIOmy8
	 ZKfFEyNiLrWjkgyQK7Gb1tv+uNGS0m1SXmlohGuGHPzbWEubebSyYi+Yna5O6VJwTPMM3
	 rlSNNQzzWSIkQrKNgh8VjlGxPGb3xJEHMdtqnbk204V08yRvhUadTLFb+MoCWTD4rOsSC
	 3UQIGODea+vWvV2EBG7kMD3EzywZKpAIG8JMrwsVlkSdJ8oQxqXk4/8WLQy/PXJhSzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619054;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=RopkjFnH/L5NMVxm+y2n/4o6xw3wiVYjMxy6v3/2wg0=;
	b=zVOcT9lbbimIWLrwCmqp8UiNIzhYqjlYGFXmqFMYuyDVmGtNhQIgXYdwNmQFqwVkOeGc
	 1BnutkqTrKSd+fUieVgaI0qpD/acBEOg84v89cdiAkhjEFMqiELIwchpbd6t9GZQ6SqiV
	 035JPveV2D81vs2Qlb+4khNmQwJtaxvd/i+HqahHNFTLJmkM1vqDEHlBfwDjIOX7nkwPe
	 +TwDUsdu9gtODVNM3SdSd+VhxcYEwCFsWgKEM3U7C/rNCycGLcW0mYQ0V0KhKC7FnaZpU
	 +vEM7qCOYyCyxRWdUHJ+hRS8thkot7LZo36s14Hd1FOujBRAdN5CDqeLpC/7xAUBDvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=sXcK2Nov;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0CA606A330
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 11:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B0CA606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=sXcK2Nov
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso23797385e9.1
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 03:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793619052; x=1794223852; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RopkjFnH/L5NMVxm+y2n/4o6xw3wiVYjMxy6v3/2wg0=;
        b=sXcK2NovY48hvg6EmE/3bDf0R+rJ1ekz0ZuwCMBacIZcM4799MC/bChBWbPygg9Cpl
         iid8HHBLBy5fqkbz5IW717cFpYAuSHx8fNXOT2y/uWKu6O/iS2hzCZ+bvjJqSx0zu2LT
         PNgoGwKuLsteM846rklP0uPCryza2LyjJ86qASd+ceFKGfTI4Isdp3wa9kkrSOIpx+6o
         vipQziJM5ADO44mHjsTNfElAoLDNLulZ6BOtPJqtzUxk6TxeHIGY0rc9b9s+qfZIq/Zl
         8vfXenAkG58I9lOD9rIxJ+KZFmW/cVSCxwoCOX6NEeZHcO9krVhg6XlYY+ODOaOB4ulc
         LdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793619052; x=1794223852;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RopkjFnH/L5NMVxm+y2n/4o6xw3wiVYjMxy6v3/2wg0=;
        b=iNhZo3ppthsJTohg/0hiEyTzBbnK/TiwnBblv1A2kM/9XeuVwIV/XxgE4lqAMUIiQ9
         +GD231RcZQ8MDVJJ3T5ezA0o3SruoO8WfEookb4hzvsl8hqfvPMsTQEEznvaO04SDXfd
         LVjpNDgiV2ACQ9rbhqx8784QCtE5gfFx8Gr3m6z9dBa9m4g6tg/LIrqP5dvncjxw0z4J
         vI0HgID9Dw9GlMWxakrneIrVrA4o9QvJiCEqO8NPgrvNebM1EimE8hkW+P32Nh+K3aSz
         XhlzlANWm3X5yDZ71zM6Tm7CbThy5D2PEFrQ/epLfecAoNTa9VeXPD4lQWY4/0/1EV8f
         XuEw==
X-Forwarded-Encrypted: i=1; AKwUvBwfmoX08O1Pc40LDXIVbuvSDO0dXvcBIUx9Wzb11uWMrPYdTX9wPV4OxpvdGA5jIKHulSgk3ZHl@lists.linux.dev
X-Gm-Message-State: AFq9FYKMry8XwqjsbqpiZTYBQ/UWZqjt7VYFbvV72hC5fTjfZ3NO9Sch
	yan4P04ZwwZ35oj9L5BJyLqbPYbvPPsRonToySZA5bmcDb5WumtV1a1ub2Sz/+3rLcg=
X-Gm-Gg: AYBFou2FHrzrLjFtiq0g6JNqF7OiIpmJI4FO6y8oVvAyXAvW8U+mxH9/jE0OyKh0HCT
	dxhhCHjZpP5Nc1STfAivdMY2BZg5e4amRuPAre6VncNWEBzzMeeWZvlxCSIej8m9bzkotbI8zpw
	cL4Ze9zIJzgVsvmnhCJlAwpDpwzmqQDIn2OP9nNAqdCwvN6AzUrCyeOD+zhzY/GHfC6H7S6dL29
	WOcGVsRIcFbO3J3fHYWV8euU3Xm6HHohicZleJb8QtziAfHDP5yQe6apxeYrefSAr7DnCfZqyfV
	cCtvIUdFQ8psdSWmWWOGboJcs8dHwIbc+++gYyqazefBvoW6oGpSHI4PTmnkEec4Gw0w+L5Ki1t
	hhnn7/ckN/9OKv4haXbtGKAb8ly2Uj52eRxAs7JRoZnDhEhY0gmS3R4VztJbfnb/oE9gNu+k/HO
	44Y6j4bMhq28KVXwzeDi43TqDFKhTKBtXZqMCfMKn6TsBOaPhBhLMA92TTEN4XsRI+3xJrKfHu4
	4n1KV1pf9WxQuXlELOGJmOMIeKf4nxq4/g1/avOWBKw1I1X0k3RhU6hduxtOnZY0M0V9kAqs1uE
	BypHBr6rESw/h05R/lg7YJ8oXzii0iPM/OclWYvznwQi16+C9OUVXwD6p0BM
X-Received: by 2002:a05:600c:1f93:b0:4a5:75d2:c104 with SMTP id 5b1f17b1804b1-4ac17ffa050mr233942805e9.22.1793619051662;
        Mon, 02 Nov 2026 03:30:51 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09bcc967sm199946425e9.3.2026.11.02.03.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:30:51 -0800 (PST)
Date: Mon, 2 Nov 2026 12:30:48 +0100
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
Message-ID: <auh0MBdHJw0cqKa8@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <yq5ah5i2a487.fsf@kernel.org>
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
In-Reply-To: <yq5ah5i2a487.fsf@kernel.org>

Sat, Oct 31, 2026 at 05:22:48AM +0100, aneesh.kumar@kernel.org wrote:
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
>
>I was considering evidence-get to return the evidence generated by
>evidence-refresh. Without an explicit refresh, evidence-get would return
>the previously fetched evidence. There is no particular reason for this
>two-step approach; evidence-get could always fetch fresh evidence,
>making evidence-refresh redundant.

Okay. The aim of evidence-get is to do get fresh evidence upon each
call. I will document this more clearly.
