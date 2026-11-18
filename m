Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022082;
	b=cbnJkhT4qjKm7mELjXhTOkjRpJHrE978HB5F9l/5fpZI9sRZcnYL/6wDE+J56ySKyTdl
	 SPc5PC8/O3RQrdQx48UVkXXEE59K2b4Kpe5ktex634cHRETrWryFTn9Mlfh132gZVgX0A
	 FxvquOmKtvQlmsxU4MU2VktFZk0T9o0K5JXcVRGgUG6KtBYfGbgOMkejxd5JPTZoiWy8t
	 H2C4v1SA9vGf29kLnjmH0FbiDSDhs5syNn3fWWKuWHkUpmKVPvpFMr1wwzUz6nyeq/x1K
	 j3rcMV0NK0LY8OkPcJkLh4Hxtbkqln/dIHrebUqCAhNTe9Uf9aC7TyNIMZkjfaUUUNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TFwFdo0TecpC7S5u1/R+P6YGgPqOiaHdeNBeUlA9IK4=;
	b=pJ4fgHT9OhBBWVJxuyduCpAG4Q36ZvnwgcLFPi3K+cAag4Q7Ow6qAM/I5ngbwUBAJGVT
	 X6KBZEzLGJ/knYNj17PUa+CyxlELEMrLRdTqp1N1Ct3y4NG6hMN/LZ8KwaUlXkxeXqBkB
	 k98kD0iqz66MUoqz9QdJso1rG1Ssjz3UD20K1Ese+YvJ2Hy3TM3HlYF7DaJcPr222EkIJ
	 7bfw3GL9gI82UfitfI3dfB3bERsZi92WHga45ZhatwtNDLp+nc8fenM5/QBNUS7njxnqV
	 t4b6SvYKtBksUOvOVArYWLU9wUA+qD5KdG1qpJhzilmbuLxiIPSIJcfMJ8vtlsNuZpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jt9AcO7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40D606A320;
	Wed, 18 Nov 2026 17:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jt9AcO7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2C61F000C4;
	Wed, 18 Nov 2026 17:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022081;
	bh=TFwFdo0TecpC7S5u1/R+P6YGgPqOiaHdeNBeUlA9IK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jt9AcO7tpNN9gFM5NkwQGSxPvjU95SqVuwzfhZ7kVCcw8zveT9mpA7D6UVCpfzpnO
	 1vPUonzzT8Tc28AK4kW/APPXUPUPl1cgemEhde+UycLbwduG+Hu6sNV8ANbbTpNzvG
	 Yomcz8UYUaiW7HGNThO1SEnRdpwt2e9MKcDZmCeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2533/2651] kdb: unify CMD_BUFLEN definition into kdb_private.h
Date: Wed, 18 Nov 2026 16:02:53 +0100
Message-ID: <20261118150415.796763954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index c399f11740ef3..f5b1b7d4c9c87 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -22,7 +22,6 @@
 #include <linux/kallsyms.h>
 #include "kdb_private.h"
 
-#define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 31abaea5454e6..40c332d2179d8 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -784,8 +784,6 @@ static int kdb_exec_defcmd(int argc, const char **argv)
 
 /* Command history */
 #define KDB_CMD_HISTORY_COUNT	32
-#define CMD_BUFLEN		200	/* kdb_printf: max printline
-					 * size == 256 */
 static unsigned int cmd_head, cmd_tail;
 static unsigned int cmdptr;
 static char cmd_hist[KDB_CMD_HISTORY_COUNT][CMD_BUFLEN];
@@ -1266,8 +1264,8 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 
 do_full_getstr:
 		/* PROMPT can only be set if we have MEM_READ permission. */
-		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
-			 raw_smp_processor_id());
+		snprintf(kdb_prompt_str, CMD_BUFLEN,
+			 kdbgetenv("PROMPT"), raw_smp_processor_id());
 
 		/*
 		 * Fetch command from keyboard
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 92a28b8ab604e..722e8aa50724b 100644
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



