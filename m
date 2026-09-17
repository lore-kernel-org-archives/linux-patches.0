Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D93D3D1B;
	Thu, 17 Sep 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667460; cv=none; b=XMJL6Epd45AmhlVFG58rzxPUVfF/CmKIFDpO3nI0h7yVo8XW+dbjnq061Pw2/23BkZjiWk8FjTgHECLal/h4iJ0FdbvxBnFPZ75qcnguuYNJ3y9ikOGFWud8CUgBC0MT2cvhN/Cf1erJtIFTWg/sZuurceBIqGdyWfPUj8PjuPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667460; c=relaxed/simple;
	bh=1xKVDS9Pu6HTZjEMFFZxpTrTjSP8T2S+Va5x2mPpjQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpMSV1O/JwqBpZbiP82f7zz8hsWSOfqQ5zF2/DmrAqeiNIjZ7xhBHzrNzKz9RWDDSl7+PonwHPCRn05B1wYwBmTyr8VqQpxeMXxe5TDj3SGc+PwoFFfTDTKeY9jTv2qNQHMZ5J+LHeloIVo9hwNDrSKnnoD/36qfRuTXCqk7VP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WezowzBT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WezowzBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6231F000FF;
	Thu, 17 Sep 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667459;
	bh=3wqFkauibAtyRyg7WDv8fKPay1MyhJKn0eDjuUkyZnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WezowzBTHd68hTFEvnpEtItWT5XFB2K1eIP7dXufsGpLXVbdAU1i4alhx96FAC54x
	 zJXWRRNOvmhLxD4MdyUwDNKVq9fDRmaQRL4DPLbD9/5P/RzL9NlFM6YjSqdfhSi0mA
	 nncxYGnAVlLO8oUbcrm/ki445Yt9CC7fCEoL58vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0101/1102] arm64/daifflags: Make local_daif_*() helpers __always_inline
Date: Thu, 17 Sep 2026 16:00:44 +0100
Message-ID: <20260917151542.033241737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonardo Bras <leo.bras@arm.com>

[ Upstream commit 827ce94e0897a70241abf810b1d3d7d083053a39 ]

Make sure those helpers are always inlined and instrumentation safe.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/daifflags.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 55f57dfa8e2fe..e2ad84c2f32bc 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -19,7 +19,7 @@
 
 
 /* mask/save/unmask/restore all exceptions, including interrupts. */
-static inline void local_daif_mask(void)
+static __always_inline void local_daif_mask(void)
 {
 	WARN_ON(system_has_prio_mask_debugging() &&
 		(read_sysreg_s(SYS_ICC_PMR_EL1) == (GIC_PRIO_IRQOFF |
@@ -38,7 +38,7 @@ static inline void local_daif_mask(void)
 	trace_hardirqs_off();
 }
 
-static inline unsigned long local_daif_save_flags(void)
+static __always_inline unsigned long local_daif_save_flags(void)
 {
 	unsigned long flags;
 
@@ -53,7 +53,7 @@ static inline unsigned long local_daif_save_flags(void)
 	return flags;
 }
 
-static inline unsigned long local_daif_save(void)
+static __always_inline unsigned long local_daif_save(void)
 {
 	unsigned long flags;
 
@@ -64,7 +64,7 @@ static inline unsigned long local_daif_save(void)
 	return flags;
 }
 
-static inline void local_daif_restore(unsigned long flags)
+static __always_inline void local_daif_restore(unsigned long flags)
 {
 	bool irq_disabled = flags & PSR_I_BIT;
 
@@ -124,7 +124,7 @@ static inline void local_daif_restore(unsigned long flags)
  * Called by synchronous exception handlers to restore the DAIF bits that were
  * modified by taking an exception.
  */
-static inline void local_daif_inherit(struct pt_regs *regs)
+static __always_inline void local_daif_inherit(struct pt_regs *regs)
 {
 	unsigned long flags = regs->pstate & DAIF_MASK;
 
-- 
2.53.0



