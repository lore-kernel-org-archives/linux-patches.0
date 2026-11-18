Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042557;
	b=Xudxf2SHiAxouGpT167tC0SeDHXOryj32QHvrHGiN8qNvngr5gJKKXjYpNF7dq8KZRHm
	 SPnXrcmZPW5TxizdU3G2i52DamUiithowTVCodYAAjLiZ9ySfSF1myew4jVumgB+MYdAC
	 WGwcKtpp7rqXV67cGcs4py09f+ePiD4qNW7fS654LdojNx7drdSA6BH1ls2MqHumbVhx1
	 0qh2Ilig7qA8oblWsZaEKR/25RqcvrT9TjTGxD8QTsLG4UxSO0hWpGd3gbkm2n7F/evg3
	 ezPrPnM54K9+CrcHbI7qsEOQxVEaRQAgLWRRoVu74wfa9tfXLwIkFUKL46WKxtvhDFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJjpW3z/22zauknlEVo2Y2x0hII5JqobKO4nvHx650Q=;
	b=eMhpBCp0G+2aCMfrFq6tzwG48Nza+IeXZjokyEmk+ge8RZ4RNdXNZf/SN69FwWNQVS0e
	 BgmDoTVwnxWlRHgKvceHfmZQzkwLI3q3sd5N1BnUSxqE55ucxs1zU1jSEGQDt9bDtTQAL
	 4fBy3Hmo1GPVg4+4tgZuz7my0/UNuEA1GiBSjwR8QnaFFMvjIyK4R2ZHfyIaIsgJIrbPC
	 SYNWEfTT8KSPw2uPsFiNcKdgSQNsiXYfEnnh4Em2K8SaKnbCLn/jePyeme/ZYbyNxzZAB
	 6vFsEp/4NMuFvYEQWJQCqo3FpI8uGXtyE/8i2c7uznWwGOnkvTICazAJtXta/ZH9zyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ol0Bn7ea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB2606A31C;
	Wed, 18 Nov 2026 22:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ol0Bn7ea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17E81F000C4;
	Wed, 18 Nov 2026 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042557;
	bh=jJjpW3z/22zauknlEVo2Y2x0hII5JqobKO4nvHx650Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol0Bn7ea04oRQ4d5LmQDOhraaJ9NKcd3a7+pt7IFw1Zb9axxyG91dYE712B5ITzz8
	 9ZvqYbQ2/mYYGaU7RMK51MsKUdbEhneWQCf2rTq30mS12uKoBDQesr6XXYqCWSp3+L
	 wMQawWi35XMHT0SP0AaYrXQJ8gg7sKP5/TQ45aQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3214/3318] kdb: unify CMD_BUFLEN definition into kdb_private.h
Date: Wed, 18 Nov 2026 16:03:56 +0100
Message-ID: <20261118150456.164792249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit 2a052074582d976bfa81e41a0337d8ae6dd1dc65 ]

CMD_BUFLEN was defined separately in kdb_io.c (256) and kdb_main.c
(200), causing kdb_main.c to use the wrong size when formatting the
prompt string into kdb_prompt_str (which is 256 bytes).

Move CMD_BUFLEN (256) into kdb_private.h so all users share a single
consistent definition, and remove the local definitions from both
files.

Fixes: 5d5314d6795f ("kdb: core for kgdb back end (1 of 2)")
Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Link: https://lore.kernel.org/r/l6b6bomrw3bvkehlv73fyghk6loz6jpdwqk5c4nthnhl7j7kzk@4jjhfpzv5zon
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c      | 1 -
 kernel/debug/kdb/kdb_main.c    | 6 ++----
 kernel/debug/kdb/kdb_private.h | 3 ++-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 4799f6250bb26..fcb68024adf1c 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -25,7 +25,6 @@
 #include <linux/kallsyms.h>
 #include "kdb_private.h"
 
-#define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 35aa2e98a92a9..bf03125fe9406 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -865,8 +865,6 @@ static int kdb_exec_defcmd(int argc, const char **argv)
 
 /* Command history */
 #define KDB_CMD_HISTORY_COUNT	32
-#define CMD_BUFLEN		200	/* kdb_printf: max printline
-					 * size == 256 */
 static unsigned int cmd_head, cmd_tail;
 static unsigned int cmdptr;
 static char cmd_hist[KDB_CMD_HISTORY_COUNT][CMD_BUFLEN];
@@ -1347,8 +1345,8 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 
 do_full_getstr:
 		/* PROMPT can only be set if we have MEM_READ permission. */
-		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
-			 raw_smp_processor_id());
+		snprintf(kdb_prompt_str, CMD_BUFLEN,
+			 kdbgetenv("PROMPT"), raw_smp_processor_id());
 
 		/*
 		 * Fetch command from keyboard
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 548fd4059bf9b..ce37e3caffa74 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -225,7 +225,8 @@ extern void kdb_kbd_cleanup_state(void);
 #define kdb_kbd_cleanup_state()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
-extern char kdb_prompt_str[];
+#define CMD_BUFLEN 256
+extern char kdb_prompt_str[CMD_BUFLEN];
 
 #define	KDB_WORD_SIZE	((int)sizeof(unsigned long))
 
-- 
2.53.0



