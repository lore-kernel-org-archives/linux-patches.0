Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064990;
	b=2AxhpZn9gdobMrVawxSbvEVd9YXGGOihQtFGJ+G9bnnk0v5I183CNolDCcS9nHWuAHjq
	 mdw7PakaquYn5t3l6QiJpuc/MXfx3PPXa03ZTfvZ2Hoee/ihIFolKoicdlfNFOQbwYtBI
	 NDwlXcwsitfOl8v4uDdSQI7QPABv+qzHfTN2XCTodCQytuu8oy+167opIBcW5dAJhG9dm
	 9IzHmxi8ps2i8hf3rl8kMMDg/MrLhfMrd4Xttqtzv5AEb6jefOI0sRqPibfBtqaHMMnDd
	 QaAZpVi3/b+AlyXqHIpAJitWSKwdtAp8Os5Yt44qUf9dZmAwB4rqt9NJc1denQo45kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jyfntxAtsh9g6MUJ0ELy6GEqTqqLr4Z2lvL8rGmIjE=;
	b=MT3Tw5h0P5wW6S0Bulv923T3LCjYFb8L81xcr5E4UzQ725YTXkBhiGfwZRgEwrq0RzMz
	 ozVab4+7oKHXRl3n77p7Z3mLerhTP5nQjY8GfHTz4/86cqAPz7hDJuven/VEv8TTIrzmM
	 pQOsWOryjKclMvi7MJ0ykX1ZeqBILvW3olcBil32AAMUZKRl6e0y3Qw2C6AJJceH8uGnR
	 ego9pSZuwv5JcrSv7EgGD8Cy7upcogjJgpAkYnQITy5x6Uc7I5lEQiel3ghkuPL6hkbWW
	 u3Ls9rU73fqpqIyixMjK2pIlohFtrNWDHOEpLOhBEyiDLeASQ+bFhP40ZfdMcNsje5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/ypErL1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BFB606B885;
	Sat,  7 Nov 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/ypErL1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E071F008A1;
	Sat,  7 Nov 2026 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064989;
	bh=+jyfntxAtsh9g6MUJ0ELy6GEqTqqLr4Z2lvL8rGmIjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/ypErL1Lm/Qs8GmtfMQaz6JIqiKD8BXi9g4wTDvVh+8JqeM+EYR05+VgjLM0EaGZ
	 uNMV8FMT6o/cSKH2zzAaulOoIbfA0SxrjrROZ5uxZClEt9SojVUXRi1RWZTnpbq+sa
	 nvBqh7juLeDoOr9BSzl94bSPHGv2xRCHqfOiaReo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0862/1257] alpha: fix the local TLB invalidate in flush_tlb_page()
Date: Sat,  7 Nov 2026 08:52:38 -0500
Message-ID: <20261107135003.136546555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e4ba0aab8a669..a5a42ae4a7d80 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -684,7 +684,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 
 	preempt_disable();
 
-	if (mm == current->active_mm) {
+	/* As in ipi_flush_tlb_page(): a targeted tbi() needs MM current.  */
+	if (mm == current->mm) {
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-- 
2.53.0



