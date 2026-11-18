Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054306;
	b=iZXgclM4I04U1J68f7PZYe2d5MaKyDRrMOE+slfNPPqkxVaE/K0gBPxUyyyrvTmbKSF1
	 qeP0G3lm4dK9d1QsvSfNSnJM2NYIJ5I+LYAoxBWoglzyeWv2ZoyEai8vMjFy6+1jEC3RE
	 63RYLP7u6mu1J3lawccKWnm+qgjPLUbrVs4DVSd9x6gKTKwARiILnpmerW02FZ3ArwyA/
	 LyBbvzx/freiAAbRR1VArVw6xx++rSdTDrUYITpcK3bYw+qqCMIwE+gqSNTAZ86VZhVnC
	 BrFiIijhL3HQZjn2KRpOJmm/XfzcdG1ZellNnoOR4Kwk/QU4orjFFNyQ2q8zYUfROOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HrxtyFFivg8jHKdI5eaboPPUMbYrS6KT8TmV+DLeyng=;
	b=kEeDP5a/e9+Cfm/DoK0IfbnmwUE87hRaIo88iQlWYkHYWGd+8j+1IoB66skLrrJCPBEy
	 9V2szJck5omCyGSFVjnnQMdQpFpLyaocgu7gJAsLQhsQParfUucqptxvNZ6Qdyl8KIYkG
	 Z7/ocmfoYgi6qrHERGBjusMRVPHfAsP6TNivBGMK6z9e6/UI5kZN1UHclkRlaAzwPDPGS
	 fLRMLZBOS21BfcQ8dWrl0S1YQvNsWj7LZ0+6BbWeZjxibEZtF0lapADnq+EdUR+LFOo2p
	 L0Txg4oFbxiGJkuLbs5wUulIeyPnFfGEo6CYSzuwNkMcmUSp5jJNNqUAWbmzKp0Ew+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPLCivvG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51BE606A32A;
	Thu, 19 Nov 2026 02:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPLCivvG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE9A1F000C4;
	Thu, 19 Nov 2026 02:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054305;
	bh=HrxtyFFivg8jHKdI5eaboPPUMbYrS6KT8TmV+DLeyng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPLCivvGdTJO8Z9qy6bZs/xfw1ckOIqM4v5y6NN4ZQyd1FX4pMCBCq3w3YCAc+jbb
	 9ypNsdyQb2qR/XoNo3F7GvqtoQeVo4pxEiP2xE7oAQC1h9fumotvtmrhHmsaFjCZ+t
	 tzNtljO7ziZit96IopOIznuMYiGdgsRKYGdMzIDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1228/2214] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118150100.884921304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 4eee9c389b072e161549d46dcb1ae10b0222717e ]

UFFDIO_REGISTER can replace MISSING or MINOR tracking without waking
faults that are already queued. For example, switching an anonymous
range from MISSING to WP leaves a missing-fault waiter asleep until
userspace explicitly wakes it.

When a registration change removes a UFFD mode, wake waiters in the
affected interval after updating the VMA. The VMA is write-locked at
this point, so no new faults can queue under the old modes and woken
threads cannot retry until mmap_write_unlock(). Waiters for retained
modes in the same interval may also wake and refault.

The hang reproduces for MISSING-to-WP and MINOR-to-MISSING transitions,
with both read and unread fault events.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-25-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: replaced wake_userfault_range() with a direct wake_userfault() call using a local userfaultfd_wake_range ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 271ce399f6b6f..ea7e9db135eb4 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1421,6 +1421,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 	ret = 0;
 	do {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1468,6 +1470,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx.ctx = ctx;
 
+		/* Retry faults for removed modes while the VMA is write-locked. */
+		if (any_mode_removed) {
+			struct userfaultfd_wake_range range = {
+				.start = start,
+				.len = vma_end - start,
+			};
+
+			wake_userfault(ctx, &range);
+		}
+
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
 
-- 
2.53.0



