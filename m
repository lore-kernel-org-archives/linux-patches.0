Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93474DEC07;
	Thu, 17 Sep 2026 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661289; cv=none; b=PRUf9JIYWTYNo4Cw7A0OwvBan/Sse9zcCqNinrQWXD+ZqXEnbY4rHWMixSgrRGD4Qi4q3rNCBJDmw/mhZpdvpWMl3CICgt//p2PnGqBcMa1nVqh6SjsKqSwkjixetmFcOjtSKhlwA4DTqro4Xqy2ZXA/0Y+YSLyyI0bmKT4m+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661289; c=relaxed/simple;
	bh=OuXEXBp4Db/YSUUUc1+xicdknBWVxpVg7fC9ZeE5Cj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Wa2E0AshGhb3n1ckGxqbfkTj9WaW769CRjriQ67yMxSCpfqXSUEhB9ptfe2TIyN8nmcYsEPZZsKfiR9KagMVFSgTs8v0xrKhduF+JWU1CvSZBA+Y8cwk4HEV8PkCky2l9bIiwOR6eBRA4VYspmLJoNusP5Hb0nRiqKR1B+H0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+8oDqKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+8oDqKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C791F00893;
	Thu, 17 Sep 2026 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661288;
	bh=TMzELx8OezYOLo/txZ6rYcCRu0QpO7+YQas4YKeesvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+8oDqKxkavFAfRsVFVP0Z1SbRYuD4wYWexqXLl9BQk0RdS3jn+g6PemhztKYKfRw
	 tG+3w0EoFBy9aTLsM9JonJrQWJC6uwb9gjyAg4oegSJDmzO5k1ZahajfhS76Ruf7ah
	 rQ38CnZ2UpDukTGfW7dtg6m14fXI/pDH1dtngBJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0146/1250] arm64/daifflags: Make local_daif_*() helpers __always_inline
Date: Thu, 17 Sep 2026 15:59:01 +0100
Message-ID: <20260917151556.016618115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5fca480090434..795b351284673 100644
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



