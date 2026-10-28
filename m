Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216609;
	b=xRSVeuChlrA5dNvDQr7cihcG3Ey+7Bm6/x8asLDZlT6qwlUtUYoyFzdGWIYHgkggvuvL
	 Q9W8tehxgC+eN2Gq0zyMb5X1fbY+4QNHVLHEDZCjrjsEENeoefhNmncgQ1PbMFtNPhCgi
	 bfLoiI3CB9noUs89Ejxk1m3bLfmbAWybb8JiKkYIo4x8Rzy8ewvuMjJsv0wJT7XhkgHzy
	 23BUyZGAWFydaS5DL91L2okcL/HEtu18xPXfus/TnhtYSyiiK7mQTixmDY0bhyL+bB7BZ
	 nvvCYtMowN9suDN3+DFPpRKDsCTYmsX30s/lDagHfaI/t2GZDnXPx/0IeDrPtWEiKZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dAr8GxYN/Y7yHG559iG4NluLDJc4SD7SajXhD8x8acE=;
	b=2BWt3ckn7XhFBivG+U42wQU58xCjay15zhLQsAiuws0p7hdY9leGuBnljEgfE+Ybg2vc
	 O/vcLjBKIQeJIAYsIN41ITjO+252094grC3heEGcvukljBVvMrsacH7riKQIYk4SmKWdC
	 IzUFN9c/eyjJmekpcyHFSenF8ap+vKguTXISqtByku00M2Fq2W13zfabYuwBoLmvL9X5B
	 0uRPihJ2zRemV6rGQWdZ9y6KqHpX+/0vr0lKbGGuZ/aqrXDTicC9t0xjyP8QmUamIYybO
	 fcWlMlxNumHKtZLJnvrJLjLBQyJr8G4kYgpiiER9gnfojTcdponH5h6kQOMtGJudaAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BM3v5wlo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F4606A31A;
	Wed, 28 Oct 2026 19:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BM3v5wlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EA21F01825;
	Wed, 28 Oct 2026 19:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216608;
	bh=dAr8GxYN/Y7yHG559iG4NluLDJc4SD7SajXhD8x8acE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BM3v5wlorY7qG2R4qPIvlXzNKChs+N9xOmURchx/3av0IgOONSpYuejnf5xekE4YJ
	 JX0nGOh/15SRO9ynNqM32zBlP2IVLCWs1wUzcPL0Gqxj9wP0t0zsdDnWLCKgdHKDUl
	 qIi3eX8T0SZK2Flh3/X1N3Wto8aVxAZ/DqJkJaxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1599/1887] x86/ftrace: Remove SYSTEM_BOOTING exceptions
Date: Wed, 28 Oct 2026 18:01:35 +0100
Message-ID: <20261028170535.858179920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit eb7d389d5b2b3c453332abc41c3eea73290cc006 ]

Now that text_poke is available before ftrace, remove the
SYSTEM_BOOTING exceptions.

Specifically, this cures a W+X case during boot.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221025201057.945960823@infradead.org
Stable-dep-of: 863f3ddd0b8a ("bpf: Fix potential UAF when reading bpf link info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/alternative.c | 10 ----------
 arch/x86/kernel/ftrace.c      |  3 +--
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3bc6be6404d23..af47ab50e7c1c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1976,11 +1976,6 @@ void __ref text_poke_queue(void *addr, const void *opcode, size_t len, const voi
 {
 	struct text_poke_loc *tp;
 
-	if (unlikely(system_state == SYSTEM_BOOTING)) {
-		text_poke_early(addr, opcode, len);
-		return;
-	}
-
 	text_poke_flush(addr);
 
 	tp = &tp_vec[tp_vec_nr++];
@@ -2002,11 +1997,6 @@ void __ref text_poke_bp(void *addr, const void *opcode, size_t len, const void *
 {
 	struct text_poke_loc tp;
 
-	if (unlikely(system_state == SYSTEM_BOOTING)) {
-		text_poke_early(addr, opcode, len);
-		return;
-	}
-
 	text_poke_loc_init(&tp, addr, opcode, len, emulate);
 	text_poke_bp_batch(&tp, 1);
 }
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 48cf91625a169..c20422367f82c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -415,8 +415,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
-	if (likely(system_state != SYSTEM_BOOTING))
-		set_memory_ro((unsigned long)trampoline, npages);
+	set_memory_ro((unsigned long)trampoline, npages);
 	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
-- 
2.53.0



