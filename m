Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618742;
	b=bcp7a4XhIsDWax5qBYWmi/+/TWM37z93ZxJtjmkdBZpiLWjWqLg+4cSbBnTfYF4kR108
	 skMPy/Pz5gtHUFxP3lf6JxXscT7yNpHpbi+Rv78OYbacs3THwZdZVZhahLxWU6X2LqghU
	 hl202oicy6MhiPY/yZuIn2NbjUJtsOdd7PlYmz9QG4KdBTcSDVN7Tvrn3S0qJ5yuH/VbF
	 Xo0L+3obZBnGoCojQUixLU01zo+N/paQIoI12plkB+NWW5CENQmt362jfhPrBnxo2pHCI
	 2q0+bUeY5zEj5G8UZxUlc62ZF7WSDQ3iy6bTiXROFNHkshxWw4JP/6CDDjFNCUiyC9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OUFU8oyPy6ReyOvenb3rpMHfDRNFmOSWouRunWDpY0M=;
	b=MGUhIh+GVSK2lwUp0QaovT2m0uPbtQCtjBUZlB8Fx6k6Vjuc1TlFfMPilb1NlxkQC/JM
	 fITjacwLH0Uor11z6xhbwzCcLM5BwQHFbc0s+jVqSJM6ffu0yU5WPoLJZzYJtvdoW6/HR
	 8lGSkPDR/Jt3Y6KEvQ0RduMdOME8StvIBkW1g1GOdcZRV4SOBI+Wd6hC9JU0rv7jCfbfJ
	 lqY1JCRUeikTtXFDalROJVPzshw3LVYyMLkuoBzrGOG69Ge4Ud5esyX3ynM2qNzUboDJW
	 DSb2ox79KkVvuxPOY9aqS8V3IedYHEAejSBog6JCXbIDFEIsvhh1fVdTL+8AMr/xCMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/6fQiuz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD4606A32A;
	Wed, 25 Nov 2026 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/6fQiuz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC60F1F000C0;
	Wed, 25 Nov 2026 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618741;
	bh=OUFU8oyPy6ReyOvenb3rpMHfDRNFmOSWouRunWDpY0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/6fQiuzItMI8T6lK9M0aglaiPPEG1ieaX9b4Y5Lkcdbb1EsSo+qE28WJfAyVRbVA
	 FC/WvFY2YVDDp+DdrhjzNlIS7MJJvq8fKKxLDNu7Y1UGngtenrDoaGnIhMgl1jcS2T
	 Aihgmz4RuWAeSw9QBkB3y/lvt9hyL2PwESiuL/yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0376/1005] tracing/probes: bound symstr stores to reserved length
Date: Wed, 25 Nov 2026 15:28:34 +0100
Message-ID: <20261125143830.544913973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

[ Upstream commit 2fc0b3070d6d5dcecfed43cd0e62aa0fd4b4315c ]

Traceprobe calculates dynamic string sizes before storing the values.  A
probed pointer can change between those passes, so
fetch_store_symstrlen() can reserve space for a short symbol while
fetch_store_symstring() observes a longer one.  The store path then
overwrites the trace record.

Format the symbol into a temporary KSYM_SYMBOL_LEN buffer and copy only
the bytes that fit in the reserved field, including a trailing NUL.
Update __data_loc with the length actually stored so consumers do not
read beyond the truncated value.

Link: https://lore.kernel.org/all/179378621331.55520.2052332247156241151@stu.pku.edu.cn/

Fixes: b26a124cbfa8 ("tracing/probes: Add symstr type for dynamic events")
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe_tmpl.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
index 8db12f758fdae..8acc0f0ebd7a6 100644
--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -87,15 +87,27 @@ fetch_store_symstrlen(unsigned long addr)
 static nokprobe_inline int
 fetch_store_symstring(unsigned long addr, void *dest, void *base)
 {
+	char namebuf[KSYM_SYMBOL_LEN];
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
+	int len;
 
 	if (unlikely(!maxlen))
 		return -ENOMEM;
 
 	__dest = get_loc_data(dest, base);
+	len = sprint_symbol(namebuf, addr);
+	if (len < 0) {
+		*(u32 *)dest = make_data_loc(0, __dest - base);
+		return 0;
+	}
+
+	len = min(len, maxlen - 1);
+	memcpy(__dest, namebuf, len);
+	((char *)__dest)[len] = '\0';
+	*(u32 *)dest = make_data_loc(len + 1, __dest - base);
 
-	return sprint_symbol(__dest, addr);
+	return len + 1;
 }
 
 /* common part of process_fetch_insn*/
-- 
2.53.0



