Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058585;
	b=pvCDRS26fpw3AdPibn1dDzEtUrgZW3B+LaCSAbxv7wlpabRlbQEZMO3AevUTVUVv+Y6d
	 eUAZFdCz/qmGI+a+3xZ+sCpX/rZH1MmvVuAWUGwrYKvJSNdXzDaJZ5SkRro/L87ZIqwg/
	 RmDZCFjMSu0GCdzUl/51GS7Ew0d4gFRLe8eBqslh1rlA6sC76PAwqsr1H9DTJme4d2gNN
	 5Bk6WWKOa0VZ/ZO9VMzD4hr1jO2FAjdFAq0WtRZppK5evFCKvT4d0wbI+zjbS1usmDhHj
	 hovVDqq/oS1uKsmPSC1VT1CXrmV+r3P4vUclCdz6EGEsu2wjmZOV3HgDu0rXAfWRznQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GP4gVerJlBcS7eqMA2XRI1Y0dsUp17QnkoMa/iXYKKA=;
	b=BPZamU4YDntqtt0LPM7YvGlrU5at7PEYKaFUrXMHv9l1zTVO1zP8ld09Q2ou1MJPedIN
	 st/ubjYFR9r7KgS4s6iCoVMgru39Oe9Et31fHVzSOs3vGVvWiTd0GNi85XawjFxaHTUOt
	 NSsDlhs5kzpEYmOXToAVhgwq74bGDmt6WpfKKNCSqDAws7Mtg09oFqzcGmz1kuzadJbAf
	 aaiF6OIUj/tzRlrdPxtCLIkazKbs9af38Ev92kp7dVJ0dMeQe9Sy6wJpFMoxa+ZPwY5Cx
	 OfQj2AsIsM/RaFYE9qTB7R+u/GY6mblqe02QdRNB3kHFcGvtX8w2CEMDQfm4Nf/4TUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6imnC92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3CB606A32A;
	Thu, 19 Nov 2026 03:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6imnC92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026A81F000C4;
	Thu, 19 Nov 2026 03:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058585;
	bh=GP4gVerJlBcS7eqMA2XRI1Y0dsUp17QnkoMa/iXYKKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6imnC92UsaK2Drk8SPnYgCtVV4yo0CBtPj+PQT9EptCeDb1fDr4cuob90KNtfS/X
	 leoc8juTFfsfCIvzRE13XqGzCr1mS7S4tZBvYKJ45cGYHJThUVXNM349wJPIRjI0Td
	 cKfM1/mbMGSW73lFQYQnJ9q2krZPiZAHtXWS3XHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0539/1848] alpha: invalidate the local context in flush_icache_user_page()
Date: Wed, 18 Nov 2026 15:42:57 +0100
Message-ID: <20261118145937.531527752@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 4244c555ac440a445cc168f860b2677099d761f9 ]

flush_icache_user_page() has the same caller-CPU omission that the
previous patch fixed in flush_tlb_mm(): when the target mm is not the
calling CPU's active_mm nothing happens locally, and smp_call_function()
handles only the other CPUs, so this CPU may later reuse the old ASN
together with the translations it still holds.

This matters here in particular because the function exists for
operating on another process's mappings: the comment above it describes
setting breakpoints through ptrace, and access_remote_vm() reaches it
through copy_to_user_page(). The calling CPU is therefore often running
something other than the target mm.

As in flush_tlb_mm(), the uniprocessor implementation in
asm/cacheflush.h already has the missing case.

No imb() is needed, here or in ipi_flush_icache_page(). Alpha's
user-space I-cache flush works by allocating a new ASN rather than by
invalidating the I-cache: the entries stay, but they are tagged with the
old ASN and can no longer match. An imb() is only required when the ASN
space wraps and numbers are reused, and __get_new_mm_context() already
does one in that case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-9-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 8a72f6fa71388..8a712076436f0 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -768,6 +768,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_icache_page, mm, 1);
-- 
2.53.0



