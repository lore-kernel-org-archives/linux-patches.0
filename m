Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E1346A5FD;
	Tue, 21 Jul 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649306; cv=none; b=YccdNsTxisf47v1ty83ieYYwYCQLvFqx4bGqD4bPV5JkS4opwze0bqNPiox9ex0PCfVpCzPSbFE16fWxJAOXRjTTouYyYX+7Gf3QZevVZvwXrWJQEwNWo3VJcwaTmVPWvcIpowolTOuC0Mchx6A82eW7UcP1d5WH7epWbHL5GEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649306; c=relaxed/simple;
	bh=r0Nnv9jCO6mi/P9iOVEmNybziBEfcook9qq0KYjQ/6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQckkq1flKBTspAnYK5XRKc12E7kGNZ0q7aP/HPeSCkncg63AzWJ1m6O4UbcZaD/FfB+kGHlmNPGNOoTKFLmXw5RHT40qoj6+k4E2DM0SRX2yPvytUBW18ve9D52Y5QcdHI5SG+IQEpjUrSEgtaUmMgqmlamQA0P7EUzOq98MXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR/inazd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR/inazd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46FA1F000E9;
	Tue, 21 Jul 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649305;
	bh=HlI7ACFgkRkCW6qAeCxgrGYk4JnzVlnlKq/NwsyAJGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR/inazd1I/ZZAKfZdlTDJkifcYr1N8aNnTtPsRQTH01RDMQyORY3NqbxV48SZ+ww
	 +xhJEmQvMFGBSCyO+okdefg77jDkyIEy4cM+vOIBYYCQxa9ebQFuFz0C+U+YI5HZT9
	 iyNd3obDbm6cBD6imPGtPIdLQY1Q2vD76VOpw1XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0528/2077] riscv: alternative: Use IS_ENABLED() over ifdeffery for apply_vdso_alternatives()
Date: Tue, 21 Jul 2026 17:03:21 +0200
Message-ID: <20260721152605.259651131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 4fd6505f189d447abbed1f1f6fe6b82649f27a46 ]

IS_ENABLED() allows better compilation coverage while still optimizing
away all the dead code. Also it will make some upcoming changes easier.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260504-riscv-cfi-vdso-alternative-v1-2-bcdf3d37f62e@linutronix.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Stable-dep-of: d3e0634787a2 ("riscv: alternative: Also patch the CFI vDSO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/alternative.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 7642704c7f1841..59991922a5dca5 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -173,7 +173,6 @@ static void __init_or_module _apply_alternatives(struct alt_entry *begin,
 				stage);
 }
 
-#ifdef CONFIG_MMU
 static void __init apply_vdso_alternatives(void)
 {
 	const Elf_Ehdr *hdr;
@@ -194,9 +193,6 @@ static void __init apply_vdso_alternatives(void)
 			    (struct alt_entry *)end,
 			    RISCV_ALTERNATIVES_BOOT);
 }
-#else
-static void __init apply_vdso_alternatives(void) { }
-#endif
 
 void __init apply_boot_alternatives(void)
 {
@@ -207,7 +203,8 @@ void __init apply_boot_alternatives(void)
 			    (struct alt_entry *)__alt_end,
 			    RISCV_ALTERNATIVES_BOOT);
 
-	apply_vdso_alternatives();
+	if (IS_ENABLED(CONFIG_MMU))
+		apply_vdso_alternatives();
 }
 
 /*
-- 
2.53.0



