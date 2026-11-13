Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590977;
	b=HIWZXXnEgZxKB4m+b0M31P2aarfgqb2huPI0bnHN8BxQlJQ+Wp+pwWxTy3PgR2/Ypxxe
	 e/YkkPkvxSq8nlkL/RnF1PZ6Q0QYh+vPB8os66+yYnJV31iWa+gI6j/AwWURQabBEDAFr
	 Azq72MyNUbAHKLk/GXNTFq9yVkJflm3tDTKnueCdddBg1fIOOJ4KkvAg00vJUfFHLg9fr
	 FsA+Q026BnGXHA9whoS8mvafhdnqRz/OY4LNFkT3sMdsZghWJs/HIjVxxQBZdXhKpswsJ
	 uU15Qh8xaglzxn6C7xDmOA5ZePiJwnpkjfwnVkfoTGvjtldKgnx/42E2edSdP5uB/CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y8JJmPfTrOpoVWY7g7TPjrqFAFN9eFfoF4R6Rrl2fYA=;
	b=zC6aIh7RSGZwllw5wow1x903yTXTBVCgwRMLQGhegMXPGYZd4xDRGHxIJH4C2GUlLp2I
	 NbhmXXTauzsgk+WVb/iq7v1KIprhJrE93HABP/WVYfpRN4vC2ZJnYqeB8hrjdwL4YK0Vu
	 lty/3AFdMjhL1htHl3mVl6piupZFSuknxq5REuB0KLVjSrzYL1v+tNQSQjY5pz8yqZ82E
	 JgRs2L4gj6p/cxuTjWkTn71V3BCEOY4v60Wg3EGeGO1oT0Cxs/UdWgFpwfYsjkBq+eA/L
	 MuK9T9yY9NLnCOjMB6E2kVLYMRXbJKgRxkvkmhuHkugnpmXM3wOVezNIKH9hC26e5Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBJpj8AV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84E060703C4;
	Fri, 13 Nov 2026 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBJpj8AV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549CF1F000C4;
	Fri, 13 Nov 2026 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590977;
	bh=y8JJmPfTrOpoVWY7g7TPjrqFAFN9eFfoF4R6Rrl2fYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBJpj8AVyZhPvzPJWGwJahl0ibAfNdePo9EqsWDTiQtRozQW2/K2MH+TTF7R+wwWy
	 2sr3/t4rWhjdE1DmH8rT1B1KXpsAJxffTvSduhm+foyFb6G8Y89O/ShvBBmjViXQbq
	 a25L0Ci3P7sJIHtQYIQMJAxdIe4LcEe3kT/UkWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/670] tracing: Add the bucket size to expr_field_str()
Date: Fri, 13 Nov 2026 10:45:19 -0500
Message-ID: <20261113153817.401522445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 171f3a13cd6b0..aa9aca76e76e0 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1747,6 +1747,9 @@ static bool expr_field_str(struct hist_field *field, struct seq_buf *s)
 			seq_buf_printf(s, ".%s", flags_str);
 	}
 
+	if (field->buckets)
+		seq_buf_printf(s, "=%lu", field->buckets);
+
 	return !seq_buf_has_overflowed(s);
 }
 
-- 
2.53.0



