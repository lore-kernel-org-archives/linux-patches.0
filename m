Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020597;
	b=fEiX5TxQj7MMUWayfNjhXXVYoQVw/cfgbosXomE91/KfKNwgtE0sB0JqfY6AhyngBF9E
	 MEkqXgwerQSl42LDBd5+hTIdNQ86Cbk9swA4yXUZxH0zWzomu6aI5EsiV8lA6kVb2jG16
	 ABgTwa51EDkZeD5pWCOUTpM1hqemmGzLcA/vNvt1oyad6QptN3bWREVOreHnlCNDnqy7C
	 0LuQyA759et4Wm3hN4KS8m4oqo/4pYwl+8Z/k0Uetc3gzoiWTSzARCLI8NZXb9PTjAp83
	 ft9Qr+0rFYNwMdM3Hokyi9DpL17RJYah1CjPIiOGY4xG2qUA0SMXY54dyYDz+Ws5Jhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eVovAxt0nV/lNI90vJsBH7quBcWLz/fmZEnfD3a3YwY=;
	b=5Uph/N+YyK16HeP3g6xvgqRCSOw7eqrYhE6sqeGVYIq55SrUIqWQu0tDhECkJK4eUbLy
	 zWnc+zd2Heww1lnGCmMLa4dbtt2y4WPfVaculwSDIa+uUqvnQD5XS2dwPHyMkHXyuAvEA
	 QmRXo9B4UrhTotclyAt5psf2SeH8etfkx/ZeiQ74KubuuAX2t89pbIeyVOIIWCR2qBnIe
	 YjdbMc8BN5OH3zWHJJH5jUdBDTlQT8Bs4snO0vaRn9ztOpKK3SpludWIEZOBDobfPks7n
	 d7uyliyIeQgU0J3+NWadgUfTP7sh3QvqYXC2zhWHnsQOF6ZlxI23apnUKytg77A5OtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bsx03X/Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4D1606A31C;
	Wed, 18 Nov 2026 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsx03X/Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981251F000C5;
	Wed, 18 Nov 2026 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020597;
	bh=eVovAxt0nV/lNI90vJsBH7quBcWLz/fmZEnfD3a3YwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsx03X/Q2MBQwDn6lK+WSui566b1o+KoiwU0EgJ6G3QX7dcPlDhZO46zFBi+HEZKp
	 6aHQdfCnSzngYPeXfcW40cS6Mn5Y0VS6iaQxTqJEU6oyk7GA+GifGmImKfCkFoGq1G
	 8PLLGRXAcB7TyEX60lX/zLHvd3IzeSeA5USrvn30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2006/2651] tracing: Print the bucket size as unsigned
Date: Wed, 18 Nov 2026 15:54:06 +0100
Message-ID: <20261118150358.502180213@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 387945e8d2f29fa8a28d219af5416e6d3bedc314 ]

A key's bucket size reads back negative once it exceeds LONG_MAX:

  # echo 'hist:keys=next_pid.buckets=18446744073709551615' > trigger
  # cat trigger
  hist:keys=next_pid.buckets=-1:vals=hitcount:...

parse_field() takes the size with kstrtoul() and rejects only zero, so the
whole unsigned long range is accepted and stored, but hist_field_print()
renders it with %ld.

Print it with %lu.

Link: https://patch.msgid.link/20260914053443.981201-2-donggeunyoo.kernel@gmail.com
Fixes: de9a48a360b7 ("tracing: Add linear buckets to histogram logic")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 3915159b12360..1cd3d0552db83 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6208,7 +6208,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		}
 	}
 	if (hist_field->buckets)
-		seq_printf(m, "=%ld", hist_field->buckets);
+		seq_printf(m, "=%lu", hist_field->buckets);
 }
 
 static int event_hist_trigger_print(struct seq_file *m,
-- 
2.53.0



