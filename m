Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793368899;
	b=tldhYoginP7652EmYyrbhMls5pzLwcgwQBskH2l2vxTA1vN1TuTDtCe6YAfUWM8iVhnG
	 0zNN2ppjmTwwAN6ekMpbdTMBp9l1cD3l3Pvt3azg4pQ8pUhpNHAQgIy0EWVGywpr6RChQ
	 VXUkK1nxPreuoPWMHkZTf8IJNClZzc2FcReF0Ro0v2DoN0T9sqw14uWP2tT7VOLGvMbsA
	 jwNHYsPyohXCiXqAJUQG4WDd3T+dAD+6gjQpL4cKz3xu/HQEX5HcJU7rPf+yiEOjyw+fX
	 AGsqoZs7HnVjIzqlMzHT59EeNN+mlDbf7G9qErwho/OKk2x2ExSh06foRrd44EiI6iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793368899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=VIxu9J0Ou0VxsHPF6RPn2lCybCMRa3vaXu29ngS0ZFA=;
	b=dZwZSy0KtH443gVv4RyXtoMYclaqr/3NDoVWN65+Ed/s4+Kx0OYNrnVoL542F6/v24XA
	 55YPSkcWrWCLfGLICL9XFk5iExsJhGAKMQI0J2ZMFYjDOStFrWmojK2cewjtSkcJjIM96
	 dSjMIeJuG0wcoBBwUsXGRxHY+gLku7NAOOH4D5MoBg7tPkqdrREo98XycDg0tZLAyl7g/
	 zj8SxLZLU6LX0pZZHUcnkl5olsWmFbeWHqYJtIJMDM/ZsnrcQ1kmhiETZAmJn1lnvRD6v
	 TpHsrFfJL1HV96fMNT4w0FqO4zkCsd+3IYEThaP8r7d+qfK20tWudzDfzuY9/207Z6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=VK3Nij67;
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDFA606A31D
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 14:01:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DDFA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=VK3Nij67
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b1aa4d71e7so701472a12.0
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 07:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793368897; x=1793973697; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VIxu9J0Ou0VxsHPF6RPn2lCybCMRa3vaXu29ngS0ZFA=;
        b=VK3Nij67sk2576WdiqkapkFxPLoMAm4S7CpCX6rOnTOvs4rYUagU1YHFm6d92Z1aGy
         meguJ29334j9Rd9YOGPEonYq+AOYud4F9TmGThiUHsvkLcohq14JwKgr7mpOVrzpXvLx
         P8WcmOwVmIugNORCDTnKDM8+6dn97/Ck9u9m00tKYB8TwA+7+Ks9eLpOdTZ3EaSgXRog
         9I/x4PhQLhHvrGYzVhSHwkdzWx4r+oD5JPFgZ4hSFc3/B6kklY/0mm8MKNKqUEhD/AGd
         a+X1G8N2nSa9uqJ+ybGpLzdPphm3gTaqXueUCtCQPkPJw6pnEbkfSOX7ZWtZ6ksh/vqF
         y/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793368897; x=1793973697;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VIxu9J0Ou0VxsHPF6RPn2lCybCMRa3vaXu29ngS0ZFA=;
        b=qyvCb72j9PoD1wOVYIsVVTW+sTGCAGB550fNnW+DH9jKEu+mDTJs2t1VGM8zhzO18y
         +z9AjPMrIEhbcCk0IArKEkqkp5cbt/s14dlGmrhyu6hePKG+SDn1USB22czsQXqEF3Lp
         ZnxTLPnSmo28LOZ0DH1R4OpqpZad4qPGOgqTAnyp2fNRKWnf9cm3MCNhB7ITIibshgcX
         rrdEwFFbbZyOjwbJr3UVk77vpWD0omW9LP8+ychiAY2nYhYpYGBZk6XQ9h9RhxCztERE
         1Kd246+JVSMbeJoyrjxDbymVZV1+SIGcz/XD5tknL1oQKjQotqZwqypbq3Zsgw79pe7F
         7zxw==
X-Forwarded-Encrypted: i=1; AKwUvBy9yXF1Ec9L3z2UHUtwwtXv1pyukRPAgB2lEiXvVb72yK9SWRKMJOriBCYdoORGW32COM6USBdT@lists.linux.dev
X-Gm-Message-State: AFq9FYJuNer5I5/76Z/ICnFbidumHCLWfXw4gQl9NoeMph0Fxcq5SJli
	HlcgHOMYoptkVatF6VmWGRk5uguc5lebmsZetZk15iENlwTRL8I4cqwr3lRiTIDnC0A=
X-Gm-Gg: AYBFou0HlbAKQEdjNuhkvnbdsDH86lsn8BWTVxzvEJgNEShGQ+nNxv6F79n9AG4BWJS
	jc75eIdDvZzr8tP/cKhQ98uiVGizKuvyfA7SO635+4YX6nNf4odkKQ748Falr3p/knAS0SD7egk
	cu9RNm4VzBOBE98ACHNIKK4yXsBVo2n2YvRClbVwF1rBhSVN2fWyTZTeQNvT8veoBzaujODyz9V
	+x9EUIdZB9WQc6FgnculU0v6yVtNkDMWRwuURyly5sbz625ezKZl1DHt5ZUjOeUSjpwbalqCi2j
	BrwOPT+psXv5NDMnIeUDu32GXwfzz/9mdIHpJdY7Ko8llezc75bcii+doQG5ZxzwCmC9BNvTriC
	O6SMrLDOHDowQqJNF2hTF4azLlyrqQdq1G9Wkv8ZdOYgYhDEMg4AXA7qM72CRkp1Jb9zZNQMQAc
	1NPSOtOWNO+xLU8uJ6zuTkJQtA19gwjT4AFmNkRtVYUhOPmVHfZN2OnKkl30+JpKsEdAHgg0itp
	l7xoCwJP8XVlybwa09iqfYt0oyMFnbNJSgeMsmpAH7QuI0ZghKaU4DxTIDD/Mgp5qFNbQgCUFxs
	mAhiCx/VTzapDjUErdpT4Qm0czJahnJDNgG1hA==
X-Received: by 2002:a05:6402:6c3:b0:6b4:203:a182 with SMTP id 4fb4d7f45d1cf-6b4d337b289mr1379091a12.3.1793368896453;
        Fri, 30 Oct 2026 07:01:36 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4d7b4d4d3sm609308a12.36.2026.10.30.07.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:01:35 -0700 (PDT)
Date: Fri, 30 Oct 2026 15:01:29 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
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
Message-ID: <auShvL2m00S70H3d@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261028152618.1356860-7-aneesh.kumar@kernel.org>

Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:


[..]


>diff --git a/Documentation/ctlv/specs/ctlv-attestation-pci.yaml b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>new file mode 100644
>index 000000000000..edb35cede0c2
>--- /dev/null
>+++ b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>@@ -0,0 +1,79 @@
>+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>+%YAML 1.2
>+---
>+family:
>+  name: ctlv-attestation-pci
>+  inherits: ctlv-attestation
>+  pre-init: true
>+
>+attr-groups:
>+  - name: pci
>+    attrs:
>+      - name: name
>+        type: string
>+        min-length: 1
>+        max-length: 31
>+      - name: generation
>+        type: uint
>+        max: 4294967295
>+      - name: tsm-id
>+        type: uint
>+        max: 2147483647
>+      - name: connected
>+        type: uint
>+        max: 1
>+      - name: locked
>+        type: uint
>+        max: 1
>+      - name: accepted
>+        type: uint
>+        max: 1
>+      - name: dsm
>+        type: string
>+        min-length: 1
>+        max-length: 31
>+
>+      - name: object
>+        enum: evidence-blob-class
>+      - name: challenge
>+        type: binary
>+        min-length: 32
>+        max-length: 32
>+
>+attr-sets:
>+  - name: device-info
>+    attrs: pci.name
>+  - name: change-reply
>+    attrs: pci.generation
>+  - name: state-reply
>+    attrs:
>+      - pci.generation
>+      - pci.connected
>+      - pci.locked
>+      - pci.accepted
>+    optional-attrs:
>+      - pci.tsm-id
>+      - pci.dsm
>+
>+  - name: refresh-request
>+    attrs:
>+      - pci.generation
>+      - pci.object
>+    optional-attrs:
>+      - pci.challenge
>+
>+ops:
>+  - name: state-get
>+    type: action
>+    fd-access: read
>+    reply:
>+      attrs: state-reply
>+  - name: evidence-refresh

I'm missing why exactly you need this op. Can't you do whatever is
needed in the provider evidence_get implementation? Why it needs to be 2
step.

Also, why do you think this is provider-specific op?



>+    type: action
>+    fd-access: read-write
>+    availability: dynamic
>+    optional: true
>+    request:
>+      attrs: refresh-request
>+    reply:
>+      attrs: change-reply


This differs from what I had in mind: a transport-neutral
ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.

SPDM_GET would report discovery BaseHash, discovered slots and their
certificate digests, authentication state, and the effective
authentication slot. SPDM_AUTHENTICATE would take device-generation and
the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
blob-instance=slot without selecting the authentication slot.

That discovery view is not present in the posted schema; STATE_GET does
not provide it.

Would this split work here? It would also allow non-PCI SPDM adapters to
share the contract. I understand that multi-slot discovery is deferred,
but a slot-zero implementation could still use this family and operation
layout.

[..]
