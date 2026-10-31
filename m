Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793420580;
	b=O9xM8LaRtFBWQZKiFGFfXXfDNQ4uhFksBOqcGkEIeUkRh/q7sLWg01RRNS/+r3xUKV+l
	 RxW84u43zdmdlV4ulX1JKYvbAwAfk0/+viLtdx+m1f+BxK5plJBULvRzegdK7nBRnBhKf
	 RD1HeQfqLE8kP8/3Adq6Hk4uXkMr0Iy5oY6KoAzr0qd1jD0Xv3iu0d/3wwQl1XegIaNdX
	 0VqPRd/hYnhSUTuYDEFlo+V/LijBqFqjFChJFJPanR/ZrnG9X21DDaSoJ4Lg91NFol3hO
	 vHGr8tpjnNT1XJ8g6OKjJ8dbBSzqCwd9i0Ki0XwP4bvNT0nLWaLiv0chkvp50FVWyjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793420580;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=y17QqyZ0paSAAwIfU9VJ0tKNbNczajCrLLkqe8QM/Pc=;
	b=k946kY1lavqfZVUuZp7aUKiFe+7S2VaRKdfjd+UXLuY0tn5D6BFeBsaaMOp5ijwiUkzR
	 G91J3G8V3Q8Cl60eTNaienCd4gd4EB0qfW5WlMm+5jES04UnxfUC5RsIo+yybrUS+i+QV
	 Dvh44GAl7/GPyXVySFexQwqO2soUUJ85TTsZkStLN8FRzzUs+WuEpAkOWiwibJfVa1ouB
	 QHEoXuwwgDwGFejPDNIgCkNjhR0fFgpY59mSH/Z2nc+C42mS5XQsAorGh4laKMWqGR/Wf
	 aFixqZSJHUSNX6Ogu6lr4/Zqn+nLMGI59VkmFUSYTYqbeaFE4f5fG5BKy2MslDjClyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tzw1prkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC08606A31A;
	Sat, 31 Oct 2026 04:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tzw1prkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535E21F000C1;
	Sat, 31 Oct 2026 04:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420579;
	bh=y17QqyZ0paSAAwIfU9VJ0tKNbNczajCrLLkqe8QM/Pc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Tzw1prkG5Pe1czYFf4Tq17pVkdWFhJdX3z0gOgZyLLPIFRAW6Ptak3qZnqKBV25LS
	 dvovvDkTVSkOSlufzW0o1T5miGSJ9n0cOa9leoxxUiOXOVyiPaCbNfj0Uuh8Bq3kIC
	 VuXHZLnDJXghbqoaqApP3IGImMgkMPi8iuC6/M3xM5nCKJukUEXcY5+pY+gPIy7bst
	 IzIAQWMqY+IWOZABaGL4UQkpphOt5SI3ka82Ie909cL149K7HPboJQdWznHwniuCzL
	 RwUasQjzu6YbZVkeA0/2u0JuO9WarfGL1HF/VOnG8H7Fk/PbLHKX7dyvJ0lU5mvH03
	 A3w3WZWtNLYag==
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
Date: Sat, 31 Oct 2026 09:52:48 +0530
Message-ID: <yq5ah5i2a487.fsf@kernel.org>
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

I was considering evidence-get to return the evidence generated by
evidence-refresh. Without an explicit refresh, evidence-get would return
the previously fetched evidence. There is no particular reason for this
two-step approach; evidence-get could always fetch fresh evidence,
making evidence-refresh redundant.

-aneesh
