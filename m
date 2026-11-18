Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045605;
	b=lRV6xH1KUWrAn8s5yRR3rlvJBNmlcNIYk1XT5PB4Rq8t6TBAk4Knbf+V4zVmuz0IdKtt
	 YtoPkLiz0xuuU/1gtNbXW/F7z9vZN76VHZUUdNhnwOUQAd6SrKHH0OMFJEhQFFiQxN7J6
	 YhSJX3u1rzRjsVXUG1Y6QpfMB+RalvtY4HIJIbrmDSjTzjY399Z7lv8LMH+BpXkiE1WQn
	 QygYByO+XaLXsgQWMF1Zp3LPlPN0P/zAWEOqnBggLqMQp42AvEpwh+Cj2Jv2m0SXgRGnZ
	 ImiJHKCxK9LwSsQREKFeoGBTllCgcGGbzeasR9DMTqibW07nHVyDfdj+HTeYySldZdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VJzbZzYDC0mr/IDIf0KX6T77ggAt/EwaSNYsivSqTfA=;
	b=C2d6sh0WXovRlnalGeJ2+/XfIMsVz7AQt5bPpmwjcK/trAFBLL1QZLKtEStC+tPOc98C
	 247S6fqfW2gKfcmLLhZiIn2tNdkh3X0kPlBU3OUGrKPTEHPxksPQAwOja+0nrdlLwbSa/
	 yPX2bRhC0RT1fAFgPQm28JJxTuuFOcwE5BvMWS7dEfLvZorQNdcO7pYLqfhYosSep7/oh
	 9b/R6CLFXUTiZqM3gqomE4Pb38Ef1Hca9RfGMApY4B6w6sO9yH+PaX1XVj7zgFMxt3WG+
	 2IJXG1vgFiWiZJaF0rwk7jE3Lzq5kENDWwL9LYEWgJnwihWwQrm1EokMlaLmcYMRpvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ag1bx9Qs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E37606A320;
	Wed, 18 Nov 2026 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ag1bx9Qs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97201F000C4;
	Wed, 18 Nov 2026 23:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045605;
	bh=VJzbZzYDC0mr/IDIf0KX6T77ggAt/EwaSNYsivSqTfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ag1bx9QsIkwgozWHXtNQ2PtXi5tiWLHw9G6QPyhfOHhGGHL7fBC7UiOICEbcJX4TL
	 N2/O8fA5XKr8JUItrkptyG1H5Mcx/fZ5wZ5xHrBD2xIz5ObuSiS0Ntv8JCe0P6Rz5S
	 5Kv2pNYVnAknOYLnpUSHKTP3S/wgRGO6Z0dUqoQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0981/2857] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Wed, 18 Nov 2026 15:33:35 +0100
Message-ID: <20261118150236.927157271@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c825bf802a7a43fd302c879ef25c975e067a2e94 ]

The uniprocessor flush_tlb_page() in asm/tlbflush.h has the same wrong
test as the SMP one: a targeted tbi() is only guaranteed to invalidate
the intended translations when the target mm's context is loaded, but
the gate is current->active_mm, which a lazily borrowed mm also
satisfies.

Test current->mm instead. The else branch it falls to already exists
here, so unlike the SMP side this is the whole fix.
arch/alpha/kernel/smp.c is not built with CONFIG_SMP=n, so this is how
the same defect reaches a uniprocessor, where the flusher kworker
necessarily shares the only CPU with the writer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-7-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/tlbflush.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/tlbflush.h b/arch/alpha/include/asm/tlbflush.h
index e78de2456ffae..d79d225da6c76 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -120,7 +120,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (mm == current->active_mm)
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm)
 		flush_tlb_current_page(mm, vma, addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



