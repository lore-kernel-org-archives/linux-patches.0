Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F0394470;
	Sat, 17 Oct 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255581; cv=none; b=Wq8nw84a9hAHB3ACOKhQ7jIVcBIc7giRG/eLTooUgxCTSrIvmTSBhGaRXHOo6vtTk9WFjtQAhnG7tS22mUhJmBPGCCqIthIlprgYGjyyidfU1HY4aNaybkcxqkxNvQsqJ3HX41a0dC3GpM7Lm/tAwrsI8BXReU/bVZXEeLEYv90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255581; c=relaxed/simple;
	bh=26QnkZ3go3qjaNXDr0Uo9b05OOgErBUsFrnwaMw/w04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIpz0DpjqfvgH2qhWd3BiMt8ZMO6BsjrYbnjVHG0kfyre5I9M08bkEFbRWkaJQKfii7a5qWeX9syLlo/EftvyAXlZSN1fqFDMPoe8yx34uThb+6q+7vZpX9Tp4Ic6qmsMnxuBfRxtBSwXGd5q5slMJz1+czMOzwrbqjXlfMgvkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWhY7swa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWhY7swa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1491F000C4;
	Sat, 17 Oct 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255580;
	bh=Oyq+GFu9FoTcPpJ0/WQKZuWjk4cCuPXOtqCfoWIGgO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWhY7swapGGF0DLyoMfygQVQBgK4TrfpUdi4YQZpDNkROoOoRzb5HvYLQs6+uv+q8
	 FbJulrmByirQI+7p+1Gue+JGEHYjK9m/Aon6J745CXHFKPjPSyHRJSEbx2flvX+KPN
	 LeGN0rUE8euFC7jiAhBqIY+YXrzdKxNGjqIXr4G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 822/869] KVM: s390: wrapper for KVM_BUG
Date: Sat, 17 Oct 2026 18:01:03 +0200
Message-ID: <20261017160057.960027469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit decff09adbeba4b75a1982b1dc3991761914e2df ]

Wrap the call to KVM_BUG; this reduces code duplication and improves
readability.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250123144627.312456-3-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-3-imbrenda@linux.ibm.com>
Stable-dep-of: 5f9df945d4e8 ("KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 768d3a6f69597..b15d7a0ac012a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4735,6 +4735,13 @@ static int vcpu_post_run_addressing_exception(struct kvm_vcpu *vcpu)
 	return kvm_s390_inject_prog_irq(vcpu, &pgm_info);
 }
 
+static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
+{
+	KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
+		"Unexpected program interrupt 0x%x, TEID 0x%016lx",
+		current->thread.gmap_int_code, current->thread.gmap_teid.val);
+}
+
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
@@ -4750,9 +4757,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		vcpu->stat.exit_null++;
 		break;
 	case PGM_NON_SECURE_STORAGE_ACCESS:
-		KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
-			"Unexpected program interrupt 0x%x, TEID 0x%016lx",
-			current->thread.gmap_int_code, current->thread.gmap_teid.val);
+		kvm_s390_assert_primary_as(vcpu);
 		/*
 		 * This is normal operation; a page belonging to a protected
 		 * guest has not been imported yet. Try to import the page into
@@ -4763,9 +4768,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		break;
 	case PGM_SECURE_STORAGE_ACCESS:
 	case PGM_SECURE_STORAGE_VIOLATION:
-		KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
-			"Unexpected program interrupt 0x%x, TEID 0x%016lx",
-			current->thread.gmap_int_code, current->thread.gmap_teid.val);
+		kvm_s390_assert_primary_as(vcpu);
 		/*
 		 * This can happen after a reboot with asynchronous teardown;
 		 * the new guest (normal or protected) will run on top of the
@@ -4794,9 +4797,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_FIRST_TRANS:
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
-		KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
-			"Unexpected program interrupt 0x%x, TEID 0x%016lx",
-			current->thread.gmap_int_code, current->thread.gmap_teid.val);
+		kvm_s390_assert_primary_as(vcpu);
 		if (vcpu->arch.gmap->pfault_enabled) {
 			rc = gmap_fault(vcpu->arch.gmap, gaddr, flags | FAULT_FLAG_RETRY_NOWAIT);
 			if (rc == -EFAULT)
-- 
2.53.0



