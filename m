Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704338;
	b=p6s8TViusEdRyMyMiq4j3dgH0E8CNNP5uLTr1jHjnF1kHJ7iAmJB0wnmlYzq+arg/nsF
	 AgoQXBqYPdv6gXHyNvmAHRwun/GTx8p0Yjy5DRt+XY1LGJXi4CJHb+0pdKUBkD0wrUo6T
	 H7iZeAdVepxUrwVnCehTL0PgAsdVq0HNEidBDgbiIaeHB+jhcMHbTZAqX5c70bxxs7qqp
	 QK6p1bjCPLOk1KOqm84QPCb6Nx831ooEpI7P4I302aaVX/eW2EwDQ9AeXliB+0lKcEVCq
	 WuGJTve/JvQ70G0rmuV+9bYfuc7PpzZiAmOpzE9E6sj51ngxOCZJS3LZpJyUm3uZF2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PizTSMDcpjCta4WVLlqwd+dQaQ3VR6fFQ+gmsyTUpQg=;
	b=AemUFsfcBV8+sR4bA+kPiNuU4ecbHhOnMCbpvZ0XlRG3Sb9oXy6GHN6UhHkm9ne6jehC
	 sTZm9gje8lQRbjWenMvjphj43TcEIn6zWeGJZXT0JPmCcwdkZBwJMpobsAiOS8/tWQjcK
	 XQ9dfWggPH7VVATekYT2qzKDrMOyc0FosWDipL3fa8K0FIMzve1DDAPI2pAazVhO8SzSg
	 pZAAQ9aY9+KJbuWezQZXGSQdXUPx1TR1lD+gJktFlcLeOHkSC9JOoZfkrp0dOnXn86uy7
	 RBchjZkT5icWJ2KiIF4if9El3Rotx+bv+YhvhnXQvbbh54B+Z+kNcMy7NOmypigCCMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XmwJb/Yd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC617606A321;
	Thu, 26 Nov 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmwJb/Yd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3F31F000C6;
	Thu, 26 Nov 2026 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704338;
	bh=PizTSMDcpjCta4WVLlqwd+dQaQ3VR6fFQ+gmsyTUpQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmwJb/YdlXWgXWmdsf0i3ZMWbL7UsUqXeU5Nc09PEYe6+ynMCGLTBT3XZ/Y7Xa1aB
	 Ynwrw8riQ1F+KSv69zqxI1ePAYVD3/aJKPr5XV7t9HJXrBgY0diTpHMAsrb/+pZeFQ
	 +PDgC6G4d7uZsK6V/WH7JM1UyebW3RvA/8CfFCQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/265] netfilter: x_tables: check target name before accessing verdict
Date: Thu, 26 Nov 2026 15:36:57 +0100
Message-ID: <20261126143611.097832660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 364b200285bb2cc518e3c5efe6591951c05b8e01 ]

Non-standard targets may contain only struct xt_entry_target.
mark_source_chains() nevertheless reads the target as an
xt_standard_target before checking its name, potentially reading four
bytes beyond a header-only target.

Check that the target is standard before reading its verdict.
Non-standard targets remain handled as fallthrough rules.

See the following KASAN trace:

BUG: KASAN: slab-out-of-bounds in translate_table+0x1660/0x1a40 [ip6_tables]
Read of size 4 at addr ffff88800ed56ff8 by task rep/432

Call Trace:
 kasan_report+0xfa/0x120
 translate_table+0x1660/0x1a40 [ip6_tables]
 do_ip6t_set_ctl+0x667/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 432:
 kasan_save_stack+0x2f/0x50
 __kasan_kmalloc+0x7f/0x90
 __kvmalloc_node_noprof+0x1b1/0x5c0
 xt_alloc_table_info+0x3c/0xa0
 do_ip6t_set_ctl+0x5ee/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 5 +++--
 net/ipv4/netfilter/ip_tables.c  | 5 +++--
 net/ipv6/netfilter/ip6_tables.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index bc8a5b6eccc33..b8319e8f85025 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -371,11 +371,12 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 55798e12fb374..94618e604fccb 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -423,11 +423,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9d5a2b4c6e2a2..b805bcbfda00b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -442,11 +442,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
-- 
2.53.0



