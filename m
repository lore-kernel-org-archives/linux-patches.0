Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058698;
	b=tqS62RO4TCSkQqs5R4wBjmuoUfg+6p8tg9RySQQnAoSQMCUTXgvWkUlXxJDvp6kZg7Cs
	 pJrg8RbSj+UJ1Csj1nUJ8GcTU94eb0ZKNjDv9LThT9HFjM92/zJyw1Ku+ozc7QBJDu3IG
	 tqXPoJvw75FR2HW52yiN/YU3p8R07CT4JsXINl5Gltp4x1pQoILV+y7fNyFMMo1i3QD87
	 N4K87AiicHKMgEhQ71ya6iB1WajCOssDVWkxnp2+ISHOuT5yaXzV0mAt592T5DDpTpeho
	 fpJx3hF1qBjKy3UBotkyz9XGmisa2joZwHNsSG3EEo9/ePnl9GEULhnse8HNWNr48Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8+050KLH3CRnbk7lPJW3NKs23klP+1UVM0+gXZCCek=;
	b=f0OrVa7o71p+F3bYmMkijw4V/htG7Iym/PhrAsQaq29fuD5ZAX9fqNW1riEGL2R5O5H2
	 n7bXwWJo/HpexMsxsLlzKrnq0jsj1HaZP6x7UxhpYUUp0QphiWAEmIxz/cWFiq7Nsd27r
	 wsRilLUH8xyRXJc0fhW6pGTbQ576/mN1EMkIuNpjHx7O3SDzxnyJ23D58knSEKHBqIDHM
	 +QFGMLqejTikrsjzPlx7+fWPIny6TG2K4om4sCWgxAaP3lkdMgFRvxhSns1hyAChwtiZa
	 7F/FHRfSEkApW3OuzoFXBfZyPpsqRSsAXiDFFCLQ8eYJ/+z2EpJ9xVVSuknn1wc9lnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mOLu+f/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A84606A32C;
	Thu, 19 Nov 2026 03:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOLu+f/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1523A1F000C4;
	Thu, 19 Nov 2026 03:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058697;
	bh=R8+050KLH3CRnbk7lPJW3NKs23klP+1UVM0+gXZCCek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOLu+f/tEv4KWGyaqAW8f/wytiKWgXJnncNu/06mz3g8L+Iak0m30WopGTnwx4WnF
	 LQnf3xbAXQsgkAd7p3Fbu+HYvJXdI/jPWP8WbK95ji7q5zT/Ue81PNzydP7I2yXhs2
	 yZZJZardX+XZyw4EbheT7Vp8NptxKZfgYquDb5fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0537/1848] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Wed, 18 Nov 2026 15:42:55 +0100
Message-ID: <20261118145937.468094284@linuxfoundation.org>
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
index 94dc37cf873a7..64ea0f130cd57 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -118,7 +118,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
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



