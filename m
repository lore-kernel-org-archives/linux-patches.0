Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028101;
	b=M6rc9kvC9aoJf8aEUshJjKu45PSKGxT6PPs8SoA79rCIk6J+SGuGoI7Y7KcgYn3PFhjd
	 MtJVQ/LeAHk8mVCoLkzTtzyR8XF9G9lAG46kiuKaIkEcf5I8lT80GuGb4zXHkKHtCJ07/
	 KFgLt0BMNbnRXTqx6A2vAlrFOgRXQZQP+UG/sQogYWdD1chZi48iQrc7rZdsepLJzfJOQ
	 cNLaPl5H74PT9R76pOj2HlLtSBH8qjy9o3G02lMs2L4HcKIMLEMRtS3ZTz3U5JUxHDh36
	 a4sul0mRfzoD/XR17z9EoyP8u56WYZ6CYsEKLlMu8NfixRvCCEBXGPHoqlvwzMYu2bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZXZaZOQnN8hNdc4THMmxoGTFCzEX6NT+msaVjPgZGA=;
	b=yZmtQpVT5KtoUQ049n7pOxP9D1qZvsOOPIqGdw/QOI1yZXSZapILGJe4VBqc5HNfEmED
	 AFIsTrRKZ0c0x/k1XRab51YU28SKf55ujU2mzhUVvulncBj0Z2RgNSppyVOl6LyAP4xtU
	 3qlpM3TLepUFP1g69VlnsR1F58CFu6xVb1H/geExM+SHISJShPJ+eHRPU6xpA5d4w5rZd
	 /Z/1T6FeiJ+2vN5SSatjhhoGntv+ojhs4FPwVZ2zzVEfdn2Nrp/g72bjFtHQZXq4yvrFh
	 9XyZsfZdqFIM9SfpOHQiiEWBF/K1DNZe/nVcTNkIc2g5muwToysR9yPv7s8Tee9tfqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=inwmHctm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EC606A31C;
	Wed, 18 Nov 2026 18:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=inwmHctm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01231F000C4;
	Wed, 18 Nov 2026 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028101;
	bh=7ZXZaZOQnN8hNdc4THMmxoGTFCzEX6NT+msaVjPgZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inwmHctmbXRyzj6OBaPY/Sr3Jo7qlCOzI+iFMPV48aEE0+lx15LU9Il63vuql77st
	 N7JcOxhgZchDZqyUsuaYA16WDCRXCLpEUNnkb2oNB94BF3dp7Hzc15c86VgURoQ/Py
	 +YnUcXXdL6eKEPTxXFKOMxrK0xG024GoBuBh6arI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2025/2151] kdb: unify CMD_BUFLEN definition into kdb_private.h
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150235.501598102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b12b9db75c1d8..62532dd60aa3b 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -25,7 +25,6 @@
 #include <linux/kallsyms.h>
 #include "kdb_private.h"
 
-#define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index f989f23545657..af509a8f96404 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -787,8 +787,6 @@ static int kdb_exec_defcmd(int argc, const char **argv)
 
 /* Command history */
 #define KDB_CMD_HISTORY_COUNT	32
-#define CMD_BUFLEN		200	/* kdb_printf: max printline
-					 * size == 256 */
 static unsigned int cmd_head, cmd_tail;
 static unsigned int cmdptr;
 static char cmd_hist[KDB_CMD_HISTORY_COUNT][CMD_BUFLEN];
@@ -1269,8 +1267,8 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 
 do_full_getstr:
 		/* PROMPT can only be set if we have MEM_READ permission. */
-		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
-			 raw_smp_processor_id());
+		snprintf(kdb_prompt_str, CMD_BUFLEN,
+			 kdbgetenv("PROMPT"), raw_smp_processor_id());
 
 		/*
 		 * Fetch command from keyboard
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index a2fc7d2bc9fcc..e7b0b97f2b2a0 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -224,7 +224,8 @@ extern void kdb_kbd_cleanup_state(void);
 #define kdb_kbd_cleanup_state()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
-extern char kdb_prompt_str[];
+#define CMD_BUFLEN 256
+extern char kdb_prompt_str[CMD_BUFLEN];
 
 #define	KDB_WORD_SIZE	((int)sizeof(unsigned long))
 
-- 
2.53.0



