Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064985;
	b=w8ursrl7A+5bED7zKtnj+ipb9oBaWXRb16C6tZ12CZqLSg77fS3Ov6hLvHtC60doq6ja
	 ue0u6u7m9Gaf3Af/be2ZoiyQWbbJ4S+hbJcsKc8vIgRN/nx8KM1dhqijCL5mIbV/twRxr
	 8tH8786IMUnu1EzNzZewdu7sYM/er4OEr1EzqdtUANkShklnSRkBBdbBzwzppnb2Vgr7U
	 2ipU/cNhPJPF6KN/z4t51pEbj5tfeV+5V5izGKp82it7MnaCTRg3PVq6S1pjCtc00bUFv
	 I316AtwuHe5mqcrxW16+Lw/RcV4fZVodUmK4X+Vbkj3FxU/EuQHVtXbalpkeUCYfnAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J+wKQQOftvwthBPFbuTpM6TxVzWwFXV26hqrvnHGD7w=;
	b=FmXKBG3PXjlRU5XR4t50of8HYc5eSUylTgud9wLWAR786vgEPAUn22uG45iAjw7plWxL
	 SWaNrD8F9EmRi1ksJ9Jk3JZDrWwvzs1StrLBqoR/pn0lbaTPoesYMWNgtZ7yRvlRxwCNX
	 tiQnMs8qRHJ1VpukrRlOy7eQDbGsw9BDADKZ/39pOd55FYIiqWVQj+UMo0LU8Y6796KJS
	 vLvOWX/YGaVedO5vmvsC6xQSbtexcebdGkAS6i30GgWSiuHlI3rcvw+GoI3hDGYzr12Bb
	 8+kPHJtt4F5ExsmIoEK0VbMyPVNYU8HpoLkmjLloTeisifIB1TEJiGs7QDouI6NI/qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4NlFxQ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6B5606A9FC;
	Sat,  7 Nov 2026 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4NlFxQ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DC41F0089F;
	Sat,  7 Nov 2026 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064985;
	bh=J+wKQQOftvwthBPFbuTpM6TxVzWwFXV26hqrvnHGD7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4NlFxQ+V21YJvVyZjR+7FIJouq3vWt4iJHMd3m+q2Tr6+AvW5up3lanG44mlHWBm
	 nKy/mwVRg7qO2bEsk2KGpA8c5giZuBxBNWiqZxioalxjcGHAV3cpRk/2mKnHrRG84q
	 60mL6PobB+h/d8rgLnZl2AVJCujjQJQcdfu96XIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0860/1257] alpha: only use a targeted tbi() when the target mm is really current
Date: Sat,  7 Nov 2026 08:52:36 -0500
Message-ID: <20261107135003.082007630@linuxfoundation.org>
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
index ed06367ece574..1ad448105201f 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -669,7 +669,8 @@ ipi_flush_tlb_page(void *x)
 	struct flush_tlb_page_struct *data = x;
 	struct mm_struct * mm = data->mm;
 
-	if (mm == current->active_mm && !asn_locked())
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm && !asn_locked())
 		flush_tlb_current_page(mm, data->vma, data->addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



