Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045594;
	b=wFUoN5VMsT/weffI1N6dwvHtXw1Wv9bhwyLUmdH4PMXhgEN1nJnWskGNahbXb/kCBoR2
	 RNsHEkYvY8qN8vXjtVp00h5cm6+DcKM5LqMBKJ0gR0pKSqAk920ZhA56YjZ5zrwAm4BtW
	 5SqfWsTW1IVshPQLk3XnCsjBXvPabHByrJQrH7s7nz0ua994rDLCMzZbu7RvKytuk9IXv
	 oeZni+vPCg+Pwp6vQBL3F5fkXAYWe22iwPTHtVSSDVi1dTpcvOdghVTSR4VrNkxngHC06
	 F6yfoTbn4cnClMPRzdKgNKd3ReWhYrs+wPNlJW87ihT/P97gnsrySshXNaqXfDXXq/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F3ahPbKKy0clIx++q0v8yRkQ0VhxsLTil4gAU2ruibU=;
	b=M8by4VnvWBTM8Kd+O0i6Fjhcn3Dvs0Kr3EIdPygd9g8lu/6InU6bzx6W99GhC0net41s
	 5B7ESTXtnW5eqHbl9HD/gkoO+y9sOPFEBKgekEgETYxteke8VTb0Zr2m7sZwD4l7+ST5f
	 5z8fw7+qL16U7XFoG684wFAaIcT1XqxvaY8IpfcHfmLL3OAb8QfhaK7d2h9M5jUei71bf
	 GQrDMFNs0g9SB8GQDOD03pUMCzVIzGpZL/yvOXCVgi31RNdKjxftHW0T0ISIljG+9x1eN
	 aAveKr/6tygMe7zKriCoIlssHpOrEYjw4rcbLjsLw8cZZm8OK4Ntx51S+wfAUggDcCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXBhGOaj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAF2606A33B;
	Wed, 18 Nov 2026 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXBhGOaj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0241F000C4;
	Wed, 18 Nov 2026 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045594;
	bh=F3ahPbKKy0clIx++q0v8yRkQ0VhxsLTil4gAU2ruibU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXBhGOajSEJATkysVcBkOAGIPRybxJZQbntZnRbHgfy7StpAasRSKYRIXeDX1t2cD
	 e2X9PuW6tF86u4p6upclkc/1cSrnwkqYDyvL+K7nyppwrlG642cAEOZnrYV0rRd2XH
	 E6/d/PADa0/3WSf17HWYcsD4WjifceecUwYvkUmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0978/2857] alpha: only use a targeted tbi() when the target mm is really current
Date: Wed, 18 Nov 2026 15:33:32 +0100
Message-ID: <20261118150236.817562474@linuxfoundation.org>
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
index f4e20f75438f8..a4bc77f2fa8b4 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -673,7 +673,8 @@ ipi_flush_tlb_page(void *x)
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



