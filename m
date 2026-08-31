Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2049C4A4;
	Mon, 31 Aug 2026 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183593; cv=none; b=Adj8XxIq0tpv+jQrRyGdOnqFtqhklR9GVKwLnFPj1KXD5uAUEjBJKjRFhvg+ZZgkr3ZPvfH6MiOhMyqnf2mL2+YjZiM557LYAFsXViMTqu0HakNauOVcHlrYIe7FpfQMsx42cA00Y5OW4dTvaKr7poFwv/jvRY4bn2lM7XvhkTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183593; c=relaxed/simple;
	bh=UWE3/x+BwZ8oc5bBCLk8y333X/YVAIFJfVhZ7lMAFwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+cgbz+uGeNcb9KXKs2FrC16qWJnWh8cJj2zblfANhSntTO9DBPFCoA0yCeDbdv/ICDFwSSgUHEORwWY4oJO6lFVlFp4kqLfPrGy3M27SR/YU6DLq8YnK7QpcO4qvITgtieFwEo05WjmYK5iq9xcGcXsQAz6bMYWIC+6GDPHjaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdc1WjYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdc1WjYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3101F00ACF;
	Mon, 31 Aug 2026 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183591;
	bh=PUf6ryr4k5wygbciAqCC4GJMVIQgnWiFUIM3Fc8zmc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pdc1WjYK/l89/5siC59YAL1Sr7s3V49zW+hckkNRh7rdSjYtnTe9q5LBfPZl68Nae
	 F4FG334q27j6QqmOluURmITGmJF0oE0oi4P2Qj/tsO4a6wNI8+jlwhq8RTeAUzX2NI
	 08fmRhb31nfE1RSuEGJ9yVBAL3kh6Xt0NHDf2166aStYCSJEQCaBpW8tBA0KV9xcZ7
	 3f8saAwGcTDh4KA8ctSibvOP7JBEmUejLvW8rCS7eeNJBW47GZMSEAL7fLugAGOzZk
	 zISA6xCEXLuXWX//G6JqlOMSn4qzElRiaTSrTyiox7NyvfOItDT4gyk4+7YGJPq09T
	 s4RABvadMpbAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leonardo Bras <leo.bras@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] arm64/daifflags: Make local_daif_*() helpers __always_inline
Date: Mon, 31 Aug 2026 09:23:34 -0400
Message-ID: <20260831133314.4125787-186-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Leonardo Bras <leo.bras@arm.com>

[ Upstream commit 827ce94e0897a70241abf810b1d3d7d083053a39 ]

Make sure those helpers are always inlined and instrumentation safe.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

That check also confirms the fix is **not** in this tree: the latest
`daifflags`-related commit is `8cb7eff32cc00` (PMR restore operations),
and the `-S'__always_inline void local_daif'` search found no matches.
Backport recommendation remains **YES**.

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

