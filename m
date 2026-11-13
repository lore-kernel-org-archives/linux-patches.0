Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590150;
	b=YOR+xrVzLv/U9UYW3X5DAlzMSU2yxH+TzNBNcUcbr8RT8GTQQ5DJeT5MG1ARfPIQOJrM
	 R7e5bq9xiKLiDNfhhPeGbKs1oi1CVODSz66LqgfCOJ+iSRCjCop23XfhID5VPN+HWz8dm
	 oQESgzRR7njGqapPhIzKficPNeLNJD1/JpvAeH+XzOTRgfMpCeLep13BOWEaCSImbuJHN
	 LN/p+0p8GiajPor2+3pqfw7pmqzkc22eYlx3aTXxBhTd9EDGW2hDB55SdEPXdQ0kiECTo
	 0VsPP4WYg8aF/HA8bsi7FukxKZRSW1QZeVL9wBe42ZOF4GxwUo/LYAU32/QAQZDnU3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R76Xl3z8sxJ7ff1gjj8Vy1iw2985m8fmU7JbdnfQB1g=;
	b=1t0V/Mk3WQUt7Iw+TqZlE0iJm9bH1gIp1u+N6M0foLqZpEvA3IRe7/9ixyh314AAIE6S
	 MKvb19Ho2oMZwibjfM8S2chiiXqbi3S/u/q/hEGElYF0mjIbTMftjbOHOOVGZZdKIYT0J
	 KSRfgdqU3hBH5ECs7QwDjYpfmg+fukkvwCFoopuB5F6YGsNROw67Lc8rYy4rw6vPoJH/S
	 etinQIi6b/pvcw6ORuoUZvHnkeGyA9jmRFWbmt5UKnLZqNab3H5sya68Yop8Xml0H5iqi
	 QMMnRu7Z/wJYeFuoGIYv7/YCfJZB8pkkXAXNoD7lmUX6SO4SsgLXXY+3BMYnohQo1fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rroU5Qwv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78488606A899;
	Fri, 13 Nov 2026 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rroU5Qwv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247421F000C4;
	Fri, 13 Nov 2026 17:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590150;
	bh=R76Xl3z8sxJ7ff1gjj8Vy1iw2985m8fmU7JbdnfQB1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rroU5QwvchwW/giuNhU604uB+FiRkptFlHelhjd3WH/IM94aDaAgtUCQrR5pQQzRm
	 dtiaPGx6bUxYWaK1SyokBh2fjTdOS/Nd5s0KrAyUNOvpKMosxbqSadaymn3LW/4vzM
	 2ETCVg+aX4BD9JLD2ISQV4iatRASgqclK6pakizo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/686] tracing: Add the bucket size to expr_field_str()
Date: Fri, 13 Nov 2026 10:44:58 -0500
Message-ID: <20261113153826.379079658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 882e10e776fe4..93afc706e4029 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1757,6 +1757,9 @@ static bool expr_field_str(struct hist_field *field, struct seq_buf *s)
 			seq_buf_printf(s, ".%s", flags_str);
 	}
 
+	if (field->buckets)
+		seq_buf_printf(s, "=%lu", field->buckets);
+
 	return !seq_buf_has_overflowed(s);
 }
 
-- 
2.53.0



