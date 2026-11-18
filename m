Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047402;
	b=Ix77rBI2r2r6tN2ipgG9hZyK3Up+4d3nlgzE080Wp4zExEm8tASZX/4qVEyufQ1pbYy/
	 Zm6/lYEhKG4mVzaI22WmKEgkWkeOQXgEOhTDX3C9PQ2RaTmIe4HXZg+5R+RiyG/7kQhqD
	 1ccUS7EOtJrmkFvSzZttSrXpKqiiZ7MfYNKpqqtyrh2bsMWFonzgllg36Wm3trso+2pkr
	 TGfAH9pnyU+FGlR3MgUg7BwnCa2jq06eh+iWbutlbpgR7lLKyzj8rwUvWlvIoEKJqcRTN
	 dr3uAwNw+qDr8VW5AGr6y77kkReBDX7kaufjwA2X12E5lREDJDBT0dsKKA3ZaegnpQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fY7F4txAwPI8yFlikbUETFQ4WG1NOJufrijQuK9esaY=;
	b=RRm7FXbNlGCsvw7SUgeDReD8BPOwkb3ThCp2PnsHWev51MK8kmXsY4Irs2vNubwHi2Ig
	 I79CdrlLCQn/4sJG9m0VuWWUdBiq8Rv9WHzlEZOUS49vNfogJnkXbfmMfEqQ47r5m+JIo
	 dNpdAIR+TxYGaMlRnyjWyoPopMxWa2oz2BYt5CPJky5Q5Fba2mm2sRK9Mv/ZbPfHI8Nt8
	 QaoBLeVikE2rcCjBtucx9zqpuYHUzVUSKRAjXn7sbzrzL7saJby7v31jXYwhTsBcU+jYT
	 0hIBuc5t6s2+uRTSaCbJTkpg+jGysILtGzPfA2mO8ZjeDb9YM4qIuacM4wHZki/HY1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tH/A81iF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2AE606A325;
	Thu, 19 Nov 2026 00:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tH/A81iF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC43E1F000C4;
	Thu, 19 Nov 2026 00:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047402;
	bh=fY7F4txAwPI8yFlikbUETFQ4WG1NOJufrijQuK9esaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tH/A81iFHYWoRldscQYaz9XzL+/PKGQy/29fd6UK9QiNUc5lgRWLfSgf8u+cRKm40
	 4UNQ7mGvN+z9tVzwRxWoTkPc/EjODCiUOyL5Beh5hNeqJSh92LNvW1hutY9ha6+RuT
	 Skprv4vP4tYD2XqhQmtOy2l6ApQuYxnedMJ+TOwc=
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
Subject: [PATCH 6.1 1625/2857] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118150259.855136199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: inlined wake_userfault_range() into userfaultfd_register() using the existing wake_userfault() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 59c4fd41a35aa..7a23fa700ffd1 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1450,6 +1450,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 	ret = 0;
 	do {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1504,6 +1506,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		userfaultfd_set_vm_flags(vma, new_flags);
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



