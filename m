Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2AF8F5E;
	Tue,  8 Jul 2025 16:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993754; cv=none; b=HfooRXSlyrw70xnEznomo2f9RaFALf7o/+b9h6mdnNbcn1egsFwinJWmTbSzvzF3PFH7iTl3UMJOv2wIINZRWeDxK9jWKRSBy8G9EGMIRUZjpCTgYs47b0VFsA2HjfVd6gJHfPUS5wHLGRqy2BHcSGYLHynePFxcaR+jMAznnxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993754; c=relaxed/simple;
	bh=Nzh70/mlDp1qxqr/GnnH2nVxISXvFqcaxO7/xkj8ZFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj5l6bqH7bsmqc6DaiwZUSpf/2lzK9+/cXgFcmvbSdz42xvhfYK5JcqknM0ao10+oByB5SVfHACXR6AY/wP0pvXaPS6g7YQbXBraEbBpOdnJiD9+v1rkwTmfo5K4RXwKnysPLeg21mcVlSpHl1t5YISKMDw9G27nyvQlclZhezo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIYvh+4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIYvh+4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA663C4CEED;
	Tue,  8 Jul 2025 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993754;
	bh=Nzh70/mlDp1qxqr/GnnH2nVxISXvFqcaxO7/xkj8ZFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIYvh+4cXVkFf9HPGUukkbfpw1SK9IKpJHOAEQBy3Zyfi4hbfV9/aIjrC806CZ11N
	 xI4Do/el9KdhPHxV0vRH/Ct2qCaIC1XB70+FDskuKUu3wSYWtEphzNhZmhVkucuf6U
	 QuubI9QlLY1hEBX/WR2wro3bj2vK/KhdWG9+RUo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 175/178] KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly
Date: Tue,  8 Jul 2025 18:23:32 +0200
Message-ID: <20250708162241.018040438@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@alien8.de>

Commit 49c140d5af127ef4faf19f06a89a0714edf0316f upstream.

WRMSR_XX_BASE_NS is bit 1 so put it there, add some new bits as
comments only.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20250324160617.15379-1-bp@kernel.org
[sean: skip the FSRS/FSRC placeholders to avoid confusion]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1164,6 +1164,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP),
+		F(WRMSR_XX_BASE_NS),
 		/*
 		 * Synthesize "LFENCE is serializing" into the AMD-defined entry
 		 * in KVM's supported CPUID, i.e. if the feature is reported as
@@ -1177,10 +1178,12 @@ void kvm_set_cpu_caps(void)
 		SYNTHESIZED_F(LFENCE_RDTSC),
 		/* SmmPgCfgLock */
 		F(NULL_SEL_CLR_BASE),
+		/* UpperAddressIgnore */
 		F(AUTOIBRS),
 		EMULATED_F(NO_SMM_CTL_MSR),
 		/* PrefetchCtlMsr */
-		F(WRMSR_XX_BASE_NS),
+		/* GpOnUserCpuid */
+		/* EPSF */
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),


