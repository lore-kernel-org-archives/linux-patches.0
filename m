Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052710;
	b=l9Pv5mfzuciLz/5FN5utA2SdTlFKY5S3PAOgM+KrxSSX1J5yWo3YKCF/oRzSj4sGVYhH
	 vvGvYELtJ8PDHVV5wbpWxc2OWPPUGiXFLpEFYi84VpehNHP7tpNiwd+NU0jGL5G7tQF/w
	 txpCfCOQdn4vzfqC7Fr/0CL9yPib71x3LwNJTfgjLg8eEje65KeNQkYiOF68v9S/C5j+X
	 vZpW881TEp0BEke6TJOzg0Or8aDJbC1qAMsIbNB/MkLrT8Er7vCmIeRjt1wXRjgGs9QtS
	 HZ7Ap6dNBgAEl+bjCzioXlXTkqBePDJJvuhiyOhRb/OZ1UaeKOQemYHYHEjuy4ciUcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QMP2wi4XumhfG5dwhvzZcMfhZDYNdbbFcQCOwAxD+Dw=;
	b=ziilKhJ23iBSfvNiIAWxHuxZXs7oVhe85TRHGsubbZwRRgWop5LJlTHSx2QIQlGHbwTn
	 gDBJSPerGd1uodjN02ofw6dDvqIPNjzuOjfL4wBOg8B4uC1iFk4NqWtmFu0s/ddQjpjrv
	 KV5sJBxXj5mUHwoQiw3TlRFA3spEpG+dK5rZj2X30Yc+CEc1uEEoD4SzHpoAAV+SbS3/w
	 g57Fhu9fyr1Cq91oXjZv7mcpsV+yBeuNDjZj6PqpR8DNwg70zf/DKEbb5BVnE8GFBn7KZ
	 AWvShPmJoBMA90q2VA1O3wz+TV90bpG4pvO+4MIhwykE4kSmxQHbb5TVhCEyhjeR0KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBgN3r9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC940606A336;
	Thu, 19 Nov 2026 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBgN3r9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9BD1F000C4;
	Thu, 19 Nov 2026 01:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052710;
	bh=QMP2wi4XumhfG5dwhvzZcMfhZDYNdbbFcQCOwAxD+Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBgN3r9e7sK36XLWrCdfqmaSAVCzJLQleNuZYRwbUXn1KIxK6v+6JYS7psLbB0ToQ
	 yDQJYP42TJ2yzsRBHTLXjwiE+NnhHENUuzbPKLhr0/2m1WHZxpHfgkkEQLQ4hL5itm
	 ZLHasCpWc2WirhInAOvLU/HrntjJIcpmZP4HSYX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0660/2214] alpha: fix the local TLB invalidate in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:38:56 +0100
Message-ID: <20261118150038.106321803@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 32f4dd420d626f96128fcfeea2ab24760b4f21a6 ]

flush_tlb_page() invalidates the calling CPU itself before asking the
others, and gates that on current->active_mm. For a non-executable vma
that means a targeted tbi(2, addr), which acts on the context currently
loaded and is only guaranteed to invalidate the intended translations
when the target mm's context is the loaded one. A lazy active_mm does
not establish that, so as in ipi_flush_tlb_page() the target mm's stale
translations can survive, and nothing forces the old ASN to be retired
afterwards.

Test current->mm instead. A lazy caller then takes the flush_tlb_other()
branch added by the previous patch, retiring its local context. Adding
that branch first preserves the local invalidate at every step, including
on EV7 where a targeted tbi() against a foreign ASN appeared to work.

Which callers reach here with a foreign mm depends on the configuration.
folio_mkclean(), from the writeback flusher kworker that has no mm of its
own, accounted for about half the calls during writeback of a shared
mapping and none at all on anonymous memory. Those counts were measured
with CONFIG_COMPACTION=n: with COMPACTION=y, asm/pgtable.h overrides
ptep_clear_flush() to call migrate_flush_tlb_page(), which rendezvouses
with every CPU and handles the context itself, so folio_mkclean() does
not reach this function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-6-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 6c63b0d956e16..3e25329d5d124 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -694,7 +694,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 
 	preempt_disable();
 
-	if (mm == current->active_mm) {
+	/* As in ipi_flush_tlb_page(): a targeted tbi() needs MM current.  */
+	if (mm == current->mm) {
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-- 
2.53.0



