Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207054;
	b=1xAWQKkmmAPNkF81gjjwcoF6TtBaF4b6TAR8B2vHBrGf9QgodkNFmE9DJVK/RVD0i2qA
	 y/80JMmOO9CQI0H4yKs0I6FFf3FLZXUdM3UCJTi5tffqgRwosfZkyNlQs2cS+yY6V/TvI
	 z6ftvH1b8rnyVULX+sdH1NeRIyVxA4RV7AfHdN/tN9al+UcWNa5zv9ivDtAwjYB+rjIyn
	 xl009wXusUCX5fE6Ah59ueSCOlxtkc/80yeSWlYQcy8Gc9pN76Te4M94AKwP3UcTsKUEP
	 Xj1IMA3ku+/zc3wusNDgNOEvomgdcYXlbuZPXM+bbN2lrwm7IUfjuh/Dz3He40dxgkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3fBk51DmSnbw9Fa/kU6lKpF1eXaQSHzpdop3Bh2dCw=;
	b=aWXDriBCV19ZA/Yvx/sWKRF6Pi+UWZMX8xiKpv6zGPNierT2jxzN5jV/rhFCQAIPMmZ4
	 kk//XH2QgVFwuH7egFJdC7r/MohcthyoeU+iv5oIjUntvmuSbiOLBZmOfaXXcC8YnPJQd
	 /h7oF3z9KVTsPEvobCGHrbzkxhzJofpAWp8L/ucL8h9+HJdA4y+34GB3WnjE/wRrKxnGT
	 faKHrY3h+hTHE8D4AuDJVBw3s9ZCQ5cXdWMPu5HGYdmFZkf1NU1nQa7QQ4uTdvHV/9IYK
	 EGpvvdEXxRf9cbS/M/P3Yglvy1szY7nucav6Ohu+fa9RQ6vHm6cWDLHqyOMwAjB6pvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xp3myMvM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E122606A31A;
	Wed, 28 Oct 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xp3myMvM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A99D1F01825;
	Wed, 28 Oct 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207053;
	bh=Z3fBk51DmSnbw9Fa/kU6lKpF1eXaQSHzpdop3Bh2dCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xp3myMvMwLFPupEsm58BFB/56o5Na6+1cUx9wejtU3RC9OGla0tY2C8xoPhqm/D4s
	 Zs9Blc0WmL3ibsFVEp4ZK8kwbfzFyhiwKcTzUA+lvXJVBlwzEo5PDEm9qL4iMJVRmA
	 jYgVdw365qL6URPHzDuQT3EbgxelXmUL7mMD0X9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 10/38] tracing: Add the bucket size to expr_field_str()
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028165940.663254266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit c027ed03bc03a0e82fc368eaad657584a4480c7a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1754,6 +1754,9 @@ static bool expr_field_str(struct hist_f
 			seq_buf_printf(s, ".%s", flags_str);
 	}
 
+	if (field->buckets)
+		seq_buf_printf(s, "=%lu", field->buckets);
+
 	return !seq_buf_has_overflowed(s);
 }
 


