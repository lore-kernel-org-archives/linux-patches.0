Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027078;
	b=JbYh0VA/MxRIpHaqUsPydQbu9kYmbd2nDlCham2GXl/gp5q7TAo7jpJdasXMo913pNSH
	 QKcto3+tqH/tf/QjGdiT7aev04KQKIOcE0gm/k0Q76upn0gSu0sTEMAhLKJ5lNxfQjvNU
	 3Jc/2DD0cPczEIyIcz7M1RTi4ZgEo4H2WsaJDx/u+sGaGFllR8X5xd88Q/74F2nCwiNHl
	 UoUYl6empxUosotG6AZJ9VDMNZunh+TQ2vznwQQGqIkXepnvf2CgF3ERf77sIFr74GE5t
	 dvgZYJ3DsXt9rfUdGiYznxqXjOoStz8i9zXhuDG2gS4VzBONjOj9HEb5YeCCH5aZCLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85NWaPllFlf0u5SMkVuoJm2kxtTIpvWZSc/WQEVOqic=;
	b=Dx0Ry+Pfh66VSWYxdZCqTHIb4YUS+guvEzxpEUEeEEoOmPxwPWlAty3AYKHNikt/R8Ck
	 1L7fL6aKwEFu3I3zkVnQ6rXuYEHuENOAXtd8+UfYwzK7Vn5HYqNQXa/ZtfU9hIFGZgo1j
	 jRQXLhlS+EpqWH5yLm9fgjSQHidLjAp0+q4QqK/oiOVpWBKk/9B1aucBc4+UlgNlA/E6Y
	 zphEHD1ThM0gidLCu4aySMBTIpgJiGfv/FR5UbY01wBa+1duYY5GDeFlZMa6A4BlleRS3
	 VWamZ/zBRskQAu/XsAfUCTSzUGbr4Ps+tPaqMXWGTdyscHiZTzqWRo4Oe7rv4q2Gfgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zu38K17W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EC0606A320;
	Wed, 18 Nov 2026 18:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zu38K17W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DFF1F000C4;
	Wed, 18 Nov 2026 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027078;
	bh=85NWaPllFlf0u5SMkVuoJm2kxtTIpvWZSc/WQEVOqic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zu38K17Wqz0UBDpahpMaoyN9kNZ78MlIwzfvsl5qwVrVp40wI1E7N//TVuGgGP2Ki
	 tfh7kLnc3lmUQHhq2FamW+qoCktzYb25OT7OJuyD9x/uIYgLuGb7IqI/wJfVvKzm6E
	 LR8HwhpXv9J6vddokJG1gQldxbis2FNCR6fNqhDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1645/2151] tracing: Only report the stacktrace modifier on a real field
Date: Wed, 18 Nov 2026 15:56:20 +0100
Message-ID: <20261118150221.776447488@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 18bb005845b78e0c0eb44b7f231c29d138552438 ]

get_hist_field_flags() returns "stacktrace" for any field carrying
HIST_FIELD_FL_STACKTRACE, including the common_stacktrace pseudo-field,
which has no ftrace_event_field behind it. parse_field() no longer takes
the modifier there:

	if (stack_modifier &&
	    (!field || field->filter_type != FILTER_STACKTRACE)) {
		hist_err(tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));

so expr_field_str() renders "common_stacktrace.stacktrace", a spelling
that cannot be parsed back.

Report the modifier only when there is a field to report it for.

hist_field_print(), the other caller of get_hist_field_flags(), excludes
HIST_FIELD_FL_STACKTRACE before it calls, so this is confined to
expr_field_str(), whose only key renderer arrives in the next patch.

Link: https://patch.msgid.link/20260914053443.981201-4-donggeunyoo.kernel@gmail.com
Fixes: a5e70ba87ca8 ("tracing: Fix memory corruption from the histogram stacktrace modifier")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 53232c3076874..707ff75930cd1 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1728,7 +1728,7 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 		flags_str = "percent";
 	else if (hist_field->flags & HIST_FIELD_FL_GRAPH)
 		flags_str = "graph";
-	else if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
+	else if (hist_field->flags & HIST_FIELD_FL_STACKTRACE && hist_field->field)
 		flags_str = "stacktrace";
 
 	return flags_str;
-- 
2.53.0



