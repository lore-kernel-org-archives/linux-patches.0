Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046167;
	b=f4zkAUx6atfDzR2/k++7wNNN/asnRtD6YvN6joleXR4ocSFfv07G2+q3bWiHDheQsDRj
	 sp5Lz+EweAwYMW9IBhEa1o3h1+o+OlPeBfoL2Fv+msHxQX1Pu9Ze43A8DEQXKnRaKQzXB
	 fgLnPO4vuo6ehvZ5lAFossMEBEYpmJmLyWqsgLpClxbe3u+p6RQw5gWMaFw1Ew1Mc1YFq
	 41V5imGT9PW4AsHub1Y2A9vGyw7IqRSABho3XZ776CbvQTdSzyGpIfO2ICjFSO2T3BjKT
	 2G+yS4dMV9pcU8njxlcE1zazEiH2Bn/hfcWK4iloXPf5C3jAfLERo934w/rcFu86rRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OQmoptmUwNIMaKbmMo9BdO4+AFuNf2omylZFYaZ/hPA=;
	b=EmoZzmElgvPp/0ecnLzP7oonZGppSYzmooxxphfKZQmC6dUCY9banEP1zGK+Cu2FTUKr
	 dCHzj+vZPcIJ32tFFZKktn6MHkkL9AHjWUjpoBwNzrFPGRN1CbHL3CCWYLsRYMu1OVyz9
	 pcJJQGzovAyz4+Rsel3BxRIIf1AeL1oDiTFzKkCavIwdd6CjjK/FEzKQbItOaBd9emZdj
	 Loplc+arOdmUmiUfWWWDstn4LIJAQSYW77YKKS9gQvtbQe1igu0+keC+r1ExlPXoPDjdI
	 yNWy+ReJSgjwh4OzVFjYymCKiVs2RcEO8JNBvzLQALFi2HVt+70eAvkM8EZVcxE9GXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm0O8me8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6E1606A31C;
	Wed, 18 Nov 2026 23:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm0O8me8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B871F000C4;
	Wed, 18 Nov 2026 23:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046167;
	bh=OQmoptmUwNIMaKbmMo9BdO4+AFuNf2omylZFYaZ/hPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm0O8me89rohj2iDEJSDbM6EJBgcOfR5NXitqNQ/r6CULeJEhdz+/CosIdYVEm9Tj
	 PO+LeDK0O3LG9cum5oHgw5tCmtrfNKT/UxPRR5qzwujKVUHNrNHtRVkVZwjMTenVl9
	 wik2/uybqGlNqSZ9WXAdx8yLbQkxvCMcPyckF8pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1184/2857] tracing: Add the bucket size to expr_field_str()
Date: Wed, 18 Nov 2026 15:36:58 +0100
Message-ID: <20261118150244.235103945@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit c027ed03bc03a0e82fc368eaad657584a4480c7a ]

expr_field_str() renders a HIST_FIELD_FL_BUCKET field as "pid.buckets",
dropping the count, and parse_field() rejects that spelling.

get_hist_field_flags() returns the bare string "buckets" and keeps the
count in hist_field->buckets. hist_field_print() appends it,
expr_field_str() never did. Nothing reaches it today, since .buckets is
refused on a value and no expression can carry one, but the next patch
renders histogram keys with expr_field_str(), where a .buckets key is
legal.

Append the count, as hist_field_print() does.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914053443.981201-3-donggeunyoo.kernel@gmail.com
Fixes: de9a48a360b7 ("tracing: Add linear buckets to histogram logic")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index cd3be7eff31b5..e97f7249d12f9 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1732,6 +1732,9 @@ static bool expr_field_str(struct hist_field *field, struct seq_buf *s)
 			seq_buf_printf(s, ".%s", flags_str);
 	}
 
+	if (field->buckets)
+		seq_buf_printf(s, "=%lu", field->buckets);
+
 	return !seq_buf_has_overflowed(s);
 }
 
-- 
2.53.0



