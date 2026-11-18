Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033042;
	b=rdzjSbzeY36coh1IP/ac2w/WAgH5CuIjptIajueEDaqEJlmPQjuKX5AeRp9m7ene/4NN
	 C2p+QbQNCWdW94Dy6lpWv6PCnQTfbBzX1ZQeL1Fsm+6FJ7stnzxsQ7IYsx/pcy8c2QXQh
	 X797hxvEhEYCwQGy2kZT21+EslERrTiov7jkdUQmVpLlIDrA2RPorgz5fZzGbK33ki+lL
	 DUca+9Y0SEGHP0W0AfbOS/hWILSx6ynyuyq8ePsIK4CPjbiR7oiaCpXkEZ91DwxpJeFsX
	 ft4yOExc+xa4issoPmZ5j+ivNxk1Sp7HnugWqmnVmQs1sHOfOg6+FYyL0etpoo225Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NxJlxPBEJkvx6LGGCqM3aS4G3IxbP9AFyhCE6himHg8=;
	b=xFVAiaF8NiwbbifR4tbS7zqWhNBVNw56ha/Wxz2fcUnOVmL5ngfHxNM5tIEs8ncDrPzk
	 MKbeJlhgJZ0G4Chj0Iicq0eaoIjk9Z4UKfSPdQhlQwOT9P+RHeFw9cjj9Fr5DfvvtZeDV
	 tQi0Cf+qpnBeUjKI75NNwDgCwO2s4cQtX3q1rUheukKbSsdWC4rdov8mgc8VkdrPEOr91
	 e68Fr9/hGEV4uEJWK4z1umjwBhQEJcr1xCJGwa+NtqfcAA5lOaxWyJTqICrmxuvbKmkLV
	 2rYMvaqtFmvE17OVqj/2DA6fT0omqHU5hwExBagzx790cPerS9NnfOaiJTKF64mnrjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl2No4Yu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586C5606A320;
	Wed, 18 Nov 2026 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl2No4Yu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AA11F000C4;
	Wed, 18 Nov 2026 20:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033042;
	bh=NxJlxPBEJkvx6LGGCqM3aS4G3IxbP9AFyhCE6himHg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl2No4Yu7Z9UFv8V0vllXbzUsVV+Rj/Q+inZiL2fZEHxsa1fdX736LBzKyh3q1jH1
	 +RCjkDXEcW/x/clXOTkGAYAnThpC5MJw+RKVehGbn1NVayHsJwc8+16BW6BQosSCbs
	 5/1o1pgWdrPTeCPqOX4je+q0QbLt+JIjeA6zbIWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1627/1756] kdb: unify CMD_BUFLEN definition into kdb_private.h
Date: Wed, 18 Nov 2026 16:02:34 +0100
Message-ID: <20261118150114.576393961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6a77f1c779c4c..a84517f48cd68 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -25,7 +25,6 @@
 #include <linux/kallsyms.h>
 #include "kdb_private.h"
 
-#define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index f5f7d7fb5936f..c4dbbd2d04ef6 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -854,8 +854,6 @@ static int kdb_exec_defcmd(int argc, const char **argv)
 
 /* Command history */
 #define KDB_CMD_HISTORY_COUNT	32
-#define CMD_BUFLEN		200	/* kdb_printf: max printline
-					 * size == 256 */
 static unsigned int cmd_head, cmd_tail;
 static unsigned int cmdptr;
 static char cmd_hist[KDB_CMD_HISTORY_COUNT][CMD_BUFLEN];
@@ -1336,8 +1334,8 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 
 do_full_getstr:
 		/* PROMPT can only be set if we have MEM_READ permission. */
-		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
-			 raw_smp_processor_id());
+		snprintf(kdb_prompt_str, CMD_BUFLEN,
+			 kdbgetenv("PROMPT"), raw_smp_processor_id());
 
 		/*
 		 * Fetch command from keyboard
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index d2520d72b1f56..483ebb9a62cdd 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -223,7 +223,8 @@ extern void kdb_kbd_cleanup_state(void);
 #define kdb_kbd_cleanup_state()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
-extern char kdb_prompt_str[];
+#define CMD_BUFLEN 256
+extern char kdb_prompt_str[CMD_BUFLEN];
 
 #define	KDB_WORD_SIZE	((int)sizeof(unsigned long))
 
-- 
2.53.0



