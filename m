Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208158;
	b=0/7FLifD0o8oImPWVaH41SJZMQWpvbTLsNSkomAH9Yy/rf9t99Q8LSesYQRLDtfQg9gh
	 6Zu6oeGZUIkovBF63Ff3gJsS24mtpd19aLnZtr10rS9RGa0/OJkrD9adreYaSA/LFwewv
	 B8seJ3wZr0LglpWX924szhaL7W4UrrQzyKf6crcRSkZ9zszbbySSxF7S9DbNmWT4UzH3h
	 XFm6stce42AETGItKa/IvbF4mIeHF4NfWIKxDwBrdOxKzaxlYXsRTmFnPS9EHleUBP6u3
	 9CN7TO4BqnN49HjshBOjX2wVn8sQ1zN8+5qluSDBXEXxyAax/+Clvcnz4l3ha9lx4+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FlOwLe75JZNoBRfOIgHuRHqX2mmrWMsq7VoDnUooZcA=;
	b=fIagfL4wO+tZ0lHKEXisNVNGM5NzU5RKsyBzyXvRBVK+0jk0IyEi7ip3XWIgHDfNwN9D
	 8LAkGnjsJ9Ox+JoptzuoWpdues/qgnzE5v7Pym7J6XYNutuPX9+dVCV6WYdn4moQCSN/Q
	 +FSyVuAo5ZNvKnYvNpKJHN+wW+x22q0RsZqFJvQ00n6M5o7Fjo3b649nca+FLDHDTIywQ
	 ObJmDh8F6pxLfi8mjSxQ+ViV9GYBuMXARogtfDzR8DVO3iOZPeQACsN4z0Y0M8fuHCYlr
	 j2WSxizlMuWuYoJspx3MLhO+onHrKjpuNwc4o1QcoeW1XNMZt6RmExpLSvv8ozvH1fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COfFIILe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E618C606A31D;
	Wed, 28 Oct 2026 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COfFIILe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4377C1F01825;
	Wed, 28 Oct 2026 17:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208157;
	bh=FlOwLe75JZNoBRfOIgHuRHqX2mmrWMsq7VoDnUooZcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COfFIILeabkZ0PB2GHHlW5bdL64S6u/TJcUShP7z8r6iee1LtZTW4JOdkpRAB5rBS
	 3sou6rZhAF7n5L7mRoNC9irfElik11li8MXsqWLAqJ98R7qJ1lYzRKdKCy2w/NcIa4
	 SARBth5uiJXsVGXgyyamrz3FEFl2xo03lOX0AQhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/516] KVM: s390: Zero initialize data structures for inject_pfault_token
Date: Wed, 28 Oct 2026 17:52:54 +0100
Message-ID: <20261028170004.053572631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit 4e2c7f7cbc27418f9a290399b986c1b85ff93b90 ]

__kvm_inject_pfault_token() only sets .type and .u.ext.ext_params2 of
the on-stack struct kvm_s390_irq but the full ext substructure is copied
into the cpu local variable on inject. ext_params and pad contain stale
stack values.

Interrupt delivery only uses ext_params2, so nothing leaks to the guest,
but a host user can use the migration ioctls to get to the data.

Fix by zero-initializing the irq struct.
Do the same for the inti data structure.

Fixes: 383d0b050106 ("KVM: s390: handle pending local interrupts via bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-3-borntraeger@linux.ibm.com>
[ Adjusted context for missing inti_mem and ret declarations in __kvm_inject_pfault_token(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 87efa46657e3c..7d9623f4df68a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3933,8 +3933,8 @@ long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
 static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 				      unsigned long token)
 {
-	struct kvm_s390_interrupt inti;
-	struct kvm_s390_irq irq;
+	struct kvm_s390_interrupt inti = {};
+	struct kvm_s390_irq irq = {};
 
 	if (start_token) {
 		irq.u.ext.ext_params2 = token;
-- 
2.53.0



