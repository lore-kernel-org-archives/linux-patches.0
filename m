Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059977;
	b=Q/30uAHAQasDvFajzLyBjcMTV1KBeyzGCOEkRddu2jHyOyiGIXkxpKPQNoPS1DzhFOyR
	 CHYGqjOAbedoqxmRoj2ZEDJfW4tXNWihApkdZatSm5G5l7YwpvKKyFon6TDCaAST1UrED
	 LQxHDDMYwRfar87Ky+GMr3QzXWx/UEJXosrH7FR75bjOmJm4Od4moaBOi/Slp+jXbH7dg
	 XJilVuRWgqDY8X7ibpjGKZONxCtGmxgbg4Kmqhe0MmXWO1r/QWQjWGvWI3RJWFufz/RhV
	 8HaaEWyPrv1JHpiYm8CDcEJLkkErbW0213TcRKAIAaI16vH4VgkRSscycg4i9oAAOuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MvUkig/edSre8zQB+W38ot5ZDTqjnJzk+GB4dkNrZf4=;
	b=jrpxYhS5aSkK6Y35ptgYAGYvud1eethJicAbH4CHtdzydOz+TM2nV2l0tHyDsi5fO/n9
	 8haSPrEmypCxCuA6pK/QXKEIF9RQRdy0aZP++wxvVJ0IdmY+PpD8Bw8XroOUkE9QzLuOC
	 9Lv+P8FRX4KZK5r3oEl8hXIn6gvHwwOLvOYBmHrRumk7WOnU+2hnrvbPvEyLXg7L8TmtU
	 5siAszgVxgukhEVDXEkRyT51hCRwUt1lpcZq4iXkm2s/dxbOXK919yMUdqNFNajvsomrB
	 Pm9Vu4bjivgut+fAGnlTyaG/FxTDkwRY9SqJyVlVme7tjWbo8jyxdNK4RHRpjo50ZNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s6ZJW5Xh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8068606A32A;
	Thu, 19 Nov 2026 03:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s6ZJW5Xh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BDD1F000C5;
	Thu, 19 Nov 2026 03:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059977;
	bh=MvUkig/edSre8zQB+W38ot5ZDTqjnJzk+GB4dkNrZf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6ZJW5Xh5l197DAcT4yX1hTk+btV0VeQ1hOxaGUwqQgH9sOxIZ99vvdRnrnrtCsMk
	 ilXt5wPpuFRaneLAq5bj2aY68y6Vh2KtX/Yp23WI73nRxwN6B7kzEFKzdbr371wFns
	 O48DQ0Vch4Wz80LjNRC1z6sY71mJRM2ONxrp2xcU=
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
Subject: [PATCH 5.10 1035/1848] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:51:13 +0100
Message-ID: <20261118150000.693067060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
[ sashal: replaced unavailable __VM_UFFD_FLAGS with VM_UFFD_MISSING | VM_UFFD_WP ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 6773227fbe889..21c32d941f4a9 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1394,6 +1394,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 	ret = 0;
 	do {
+		const bool any_mode_removed = vma->vm_flags &
+			(VM_UFFD_MISSING | VM_UFFD_WP) & ~vm_flags;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1442,6 +1445,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-- 
2.53.0



