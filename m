Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052705;
	b=V6ruAMJpRQh/b5e8+hB5TuR1rQy9I5ukPpH/ucajX55KQTeeyI5/qWrWLBDGsSDWAdIn
	 EB3AS2zxAuZH7h40LO3oiJBFEosIXw7pp9Na9jkdJC8sdjq5FIE4RCJMWtdYwWr3GBKSz
	 kuiuBIvwujvBIaGoMF9Yka6PdFEpY2YSfpLl0zUAD8a9lnu39Y5o39lBdL1P/OXenRmXX
	 SkpM2k5neWmA+G52j95akPdllG4cgEMD3JsT4asEEDy/KlOLJAqOF6BSRRO7//OzkS4Q9
	 eIV+XELv5ueI+IH5r33jKqpoCtevRaQLWjh9HPj/Ej4BD9U4ODQYpZ2HNi4Z62H2XcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pa/dUT8hPiAE+B89DB2s2PSK3VGWTCFRC5mNmuOnA4o=;
	b=YtAG7tw7UrN+qA3WOzZUhLYwzhQYPaJZ2dPr5wK9aPVUQHqBSGG+Ah1eGgiWK0r0YF6P
	 +6VkpSwtTCObwmmVp9V8E8y04oevUbD6iVKR4K4394hKTLL/IzEh2W1V2yTVloxL541yk
	 q3k9Ll3DrJ8kJ/BeAs3DRG8oCiCk8+dks6ptXy3f7Vv0dWpNgaFZG2HLvhezLVPia97jo
	 7Dz5wE7tr5IkTgKJSRqFWIp9sP+GT40ewh5wnDpCi4fzqdggEmF4jtQe9TBgQSZ+peTLx
	 wzsQ/z4q4BuVekegdVIZj9kZuKw81uKOO5S5bbkylpST9eazJcNB6MZARmbliTSCX7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mRClxFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226EF606A31C;
	Thu, 19 Nov 2026 01:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mRClxFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ABD1F000C4;
	Thu, 19 Nov 2026 01:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052705;
	bh=Pa/dUT8hPiAE+B89DB2s2PSK3VGWTCFRC5mNmuOnA4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mRClxFkcK75MzlqQ/AFMwj0lqvBzF8hsTWESCoLWb90VaW5aTDnooAJH5D67AX/E
	 XHACgSOTu0aZiPSlxrj5Hfxaqf0bjtf+et0aH4BIi+kDF0/wXHIwk8Qt0n6MMGbLGM
	 b5ByBALkymyvJc4p2pgXTWzgEgjtZx68pioIZO1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0658/2214] alpha: only use a targeted tbi() when the target mm is really current
Date: Wed, 18 Nov 2026 15:38:54 +0100
Message-ID: <20261118150037.994520663@linuxfoundation.org>
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

[ Upstream commit 0d92845ac5dbc79e4ac4810b33c673f4c1c227e3 ]

ipi_flush_tlb_page() gates a targeted tbi() on current->active_mm.
tbi() acts on the address space context currently loaded on the CPU, so
it is only guaranteed to reach an mm's translations when a thread of
that mm is running there. current->active_mm is not sufficient: under
lazy TLB an idle or kernel task keeps an mm as its active_mm while a
different ASN is loaded, so the invalidate is issued against the wrong
context and the stale entry can survive. Nothing retires the old ASN
afterwards either, mm->context[cpu] still being valid, so the resuming
thread can reuse it.

Test current->mm instead and otherwise fall back to flush_tlb_other(),
which clears mm->context[cpu] and forces a fresh ASN at the next switch
whatever is loaded now.

For an mm borrowed through kthread_use_mm(), patch 1 of this series
installs the context before the task can take a shootdown IPI. The
current->mm test therefore covers that case as well.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-4-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index cb64e4797d2a8..850974ed65cce 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -679,7 +679,8 @@ ipi_flush_tlb_page(void *x)
 	struct flush_tlb_page_struct *data = (struct flush_tlb_page_struct *)x;
 	struct mm_struct * mm = data->mm;
 
-	if (mm == current->active_mm && !asn_locked())
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm && !asn_locked())
 		flush_tlb_current_page(mm, data->vma, data->addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



