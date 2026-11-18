Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050610;
	b=JyvMsFBERUw4WF98j86sibmrshICCjpnCpzbSKIOKYDhY6hBp+RxVm+QbUu2g8t+aHSJ
	 YJF+J5PglUuucJlwgJ89JGmIUOnXUYoz8JAUfHFHnqHNcW3Nh83u/+oxrKO7uTgJDHKMO
	 dd2nkDsg5wCO80nlX7zzGiFDigTEEwiGy9HGFN5Ao7r1D8xtG2c4yq6M4lVy1fumCJvR6
	 PipxvHS7DPpCBjNLgKngbrc/kFijuLmz7TMKu72GQ+RCT47nXZBLCv38iXur18JthpnlO
	 9/2/3LCuB3ILYkuuk7o/EeQJNQVuuT+F89GCNIDAiTVgbNM2ld08h8kOgToEV84rUqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q39RnxjqH8Xcm5Tc6me87PuI+avmaUxq3b5nqotRLCM=;
	b=oHeq2nMvL4BQOhJgLpMv8/jLMcr+2f5NN10oE0d7fFPsb6I6IwpI6kl41v0zd3Ns6Tbt
	 0eBddPLw96t0oKzwM/uYZydTKDQg6Bm3BYI/3IJZyKqdRqLoExUXSxdciDyYrdVEIIVsj
	 u9wTp0oB3lyoXxoN6PvqLvPrIwNME15BvAikgQZIisZUK0uI7ehHQxN9vIilkKj5cqhmH
	 xob+qimcs644UT8Z5T4wARpqExA335NJNd+sbU0cQmCOKoR45xuhrLzH55ltBZlAdux1p
	 Yf/QwCX9PonBSCnhe78i2EBRRe6mQvh8nf9eH56xkzwaSl9tOgQakmXHiYe19NbNpvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JMvMb/oO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5C7606A320;
	Thu, 19 Nov 2026 01:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMvMb/oO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094221F000C4;
	Thu, 19 Nov 2026 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050610;
	bh=q39RnxjqH8Xcm5Tc6me87PuI+avmaUxq3b5nqotRLCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMvMb/oOUg2I+KWS1CI9XsWSrWvxuWfas7iCP8FKMs/3FJEfH+t1Avc9bQoXHtt+a
	 lBvuO+BkGmSuL9qiqb8HWHuAvHeD0Bx7+Tdb5FDpFod3/hCKtDHP+SH+nsgAykNn/D
	 PGPF52QYMzhD8g34tjZAhmMliujd8k4SKqGHA+KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2770/2857] kdb: unify CMD_BUFLEN definition into kdb_private.h
Date: Wed, 18 Nov 2026 16:03:24 +0100
Message-ID: <20261118150341.339095178@linuxfoundation.org>
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
index 95bccbe3495cf..3be50493de7c5 100644
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
index 1f8c519a5f81c..e1d712e872cb7 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -226,7 +226,8 @@ extern void kdb_kbd_cleanup_state(void);
 #define kdb_kbd_cleanup_state()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
-extern char kdb_prompt_str[];
+#define CMD_BUFLEN 256
+extern char kdb_prompt_str[CMD_BUFLEN];
 
 #define	KDB_WORD_SIZE	((int)sizeof(unsigned long))
 
-- 
2.53.0



