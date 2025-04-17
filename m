Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3105256C6E;
	Thu, 17 Apr 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914270; cv=none; b=YGyIm2HQZg6JycMcogkr0FbiRVh3GZCcprzZpmF0/yn83mwa7wyIj9Q1Sf3E3/kYnZTnjMvVrb82Xhjtd7Fb5K4ogPWsAyg4Z35NTd5cct1n+uLiClV1/A9LHz0hpounXBRMMLickFOtMpZMlmdzn9aQxP/ICIlF6fnmRBzxd+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914270; c=relaxed/simple;
	bh=SldVQfKUNdt6LzkwTcyQ1PrlaOki6YRyvbBvTNieYl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZ8Zv6nljdWTlSBAEnLJM77UuxmpJQYHE5pnc9iYCrdFPhZPCkPzMvWzMn2LEilrdQXNkQNx9wFi8+dojzVnaI+g7j7l8ktEVTsq8OUJge2r7Q80j6BVeVXhyBs9dX1U8bJWNLVM+nyVKYBH2vHU8odJwbq/wmDCbSkMs0qdDoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ly+5nfYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ly+5nfYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285F9C4CEE4;
	Thu, 17 Apr 2025 18:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914270;
	bh=SldVQfKUNdt6LzkwTcyQ1PrlaOki6YRyvbBvTNieYl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ly+5nfYfuv58vL7e6Sqja04xWQO4B+vXyaC1Qghvj8tE9r6CGbRcQuZibl6NKnTby
	 t4JhiTeMAPMkcCt7/BdyXLE4eWW92m4oh5j8BCzcRfMevOO7p2P/FQPceUaLqiudSh
	 XT1xnBawtNiE3YVC9fQECQhenx/t0qa8ZJKC4iZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 162/414] tracing: probe-events: Add comments about entry data storing code
Date: Thu, 17 Apr 2025 19:48:40 +0200
Message-ID: <20250417175117.955507754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit bb9c6020f4c3a07a90dc36826cb5fbe83f09efd5 ]

Add comments about entry data storing code to __store_entry_arg() and
traceprobe_get_entry_data_size(). These are a bit complicated because of
building the entry data storing code and scanning it.

This just add comments, no behavior change.

Link: https://lore.kernel.org/all/174061715004.501424.333819546601401102.stgit@devnote2/

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250226102223.586d7119@gandalf.local.home/
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 16a5e368e7b77..578919962e5df 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -770,6 +770,10 @@ static int check_prepare_btf_string_fetch(char *typename,
 
 #ifdef CONFIG_HAVE_FUNCTION_ARG_ACCESS_API
 
+/*
+ * Add the entry code to store the 'argnum'th parameter and return the offset
+ * in the entry data buffer where the data will be stored.
+ */
 static int __store_entry_arg(struct trace_probe *tp, int argnum)
 {
 	struct probe_entry_arg *earg = tp->entry_arg;
@@ -793,6 +797,20 @@ static int __store_entry_arg(struct trace_probe *tp, int argnum)
 		tp->entry_arg = earg;
 	}
 
+	/*
+	 * The entry code array is repeating the pair of
+	 * [FETCH_OP_ARG(argnum)][FETCH_OP_ST_EDATA(offset of entry data buffer)]
+	 * and the rest of entries are filled with [FETCH_OP_END].
+	 *
+	 * To reduce the redundant function parameter fetching, we scan the entry
+	 * code array to find the FETCH_OP_ARG which already fetches the 'argnum'
+	 * parameter. If it doesn't match, update 'offset' to find the last
+	 * offset.
+	 * If we find the FETCH_OP_END without matching FETCH_OP_ARG entry, we
+	 * will save the entry with FETCH_OP_ARG and FETCH_OP_ST_EDATA, and
+	 * return data offset so that caller can find the data offset in the entry
+	 * data buffer.
+	 */
 	offset = 0;
 	for (i = 0; i < earg->size - 1; i++) {
 		switch (earg->code[i].op) {
@@ -826,6 +844,16 @@ int traceprobe_get_entry_data_size(struct trace_probe *tp)
 	if (!earg)
 		return 0;
 
+	/*
+	 * earg->code[] array has an operation sequence which is run in
+	 * the entry handler.
+	 * The sequence stopped by FETCH_OP_END and each data stored in
+	 * the entry data buffer by FETCH_OP_ST_EDATA. The FETCH_OP_ST_EDATA
+	 * stores the data at the data buffer + its offset, and all data are
+	 * "unsigned long" size. The offset must be increased when a data is
+	 * stored. Thus we need to find the last FETCH_OP_ST_EDATA in the
+	 * code array.
+	 */
 	for (i = 0; i < earg->size; i++) {
 		switch (earg->code[i].op) {
 		case FETCH_OP_END:
-- 
2.39.5



