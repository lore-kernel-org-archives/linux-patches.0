Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EC0394470;
	Sat, 17 Oct 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255578; cv=none; b=F1V6XBhM18/QWRG/ZLE3ln9pV0oZwSGa6Pod2JYngEC1levY3WzQY8FIhzkOyYbZL7O2+9pjA4ZYeQ85THCeFqvI/dr3mb060NdKkqnE/hWJ1003v/tALigrIGTIRigQr2EmTS2B12NKr3THZBwog42XhnL8aTVVoWU+lotltEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255578; c=relaxed/simple;
	bh=F5gnLQLjeZgPLMnXNWyidRnNSCJ4qCfCX25Qchs2JIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYfK7DbTchMpxgl1d3D32hFSulCq2RvhnAEO0v7THVAoPKkZi9/eqi8LxCF6+Zq7nc1aU2joc6klJHIgcSKTQ93s3XixUTbypyxWOelcqdM69bCsUmGFiCBqnen925rdwibLqgd7856lZFfgW5ATTdnEyIi9ui360msJlvePVEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkGTTdnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkGTTdnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5AF1F000C4;
	Sat, 17 Oct 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255577;
	bh=oTX3gUcphNM/odScRLMwGA3SrlSlO/aOH8lxa2u0EIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkGTTdnLJkPE/xrC4yQJ+ekQMSBX9ZBdRNpalM0oGwo0r3poTKFgY+MbWa7iLzdUm
	 Z9KAM9LG+Ckhl5b7DA8oqkI/MjACsKLw4DDAoR2hC49YNk+afwgpZcf9VyxeegIMwc
	 OhuF9k919RdwBuz5VOQDdbG9zEd7yCB7ue4u0MEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 821/869] s390/kvm: Initialize uninitialized flags variable
Date: Sat, 17 Oct 2026 18:01:02 +0200
Message-ID: <20261017160057.935324728@linuxfoundation.org>
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

[ Upstream commit 64844729a608d308089510fc3bb23abf602f4e47 ]

The flags variable was being used uninitialized.
Initialize it to 0 as expected.

For some reason neither gcc nor clang reported a warning.

Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241030161906.85476-1-imbrenda@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 5f9df945d4e8 ("KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 885eedfc0af63..768d3a6f69597 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4737,8 +4737,8 @@ static int vcpu_post_run_addressing_exception(struct kvm_vcpu *vcpu)
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
+	unsigned int flags = 0;
 	unsigned long gaddr;
-	unsigned int flags;
 	int rc = 0;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
-- 
2.53.0



