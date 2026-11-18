Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056583;
	b=S6IaK9ZIhCAD7i12CEWtLzpedMeMH1ib1/kTw239QYhP9MxETdj8OpW7ezZd+AfIjPdu
	 FUDPpMR0586JS9+ajiCjieCiIDPVcjK1QA/h8UnKKbjo9i7N/bBI9UEz8SQWA7QU00xb1
	 3EFTEUtgenDv8fx6zUc7OFvM8YcxyekKN22sXQOc7RGvpM6NZOCXYmx33JSuCwq+820QK
	 z23FaAiNece9dMbj/sKNnW/bzWoeDUHcIiaWW5MnFej4l0Kf0zIA9aJwswXQ+KyA0ZWPc
	 Bfa6mABeawrypR4fR60Z+/456tFgFsW9FnfsDwhwDpx8M0nP1naN5slg92Qu2ayAQ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3H4mV3qvBJ7Pnuc2NeUValQO0WNO+CU+QwFiHSfzDDg=;
	b=HB394IN7/yRpYlV9HdJTAvJzcMOetBMFaKYccusc7e+oIG00zMcjbZpZAmUVxAU8613q
	 +dl/mUojPuVfd79FPbhjfZYatUcd+/oy41M8wVsVYNNXQKwmEJsh2MW6dYLeuuUOB86aJ
	 MPMdVtwv8w/yJTH57qLdDfxSYO1E1b4zmdAXNgGvc6kYdpZzLJg/8nbpDLFBrDpQ646GC
	 OLkuTlPgDHxWclBY+FmBayf3jXpoEiBL93fKEXyNaDRH7enJohQzzUE09m3AYygZdpzSn
	 1p0wjl1i53WSL5cm6TpCBs30xM2KfO/0+qZTZP9QsxImPENCt1NKEFlAO0al0spSDjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKlkyiHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFA8606A32A;
	Thu, 19 Nov 2026 02:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKlkyiHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29BC1F000C4;
	Thu, 19 Nov 2026 02:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056583;
	bh=3H4mV3qvBJ7Pnuc2NeUValQO0WNO+CU+QwFiHSfzDDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKlkyiHrgzcZ8wDa/dNJ5nkHiOu178LS4FinNN4yROdDYFrcWEwKJVjYUqLVvWpfs
	 pk0UGA7hWcA7iQttAPqV03MmGt5i0ynFuqHuJAa6QrKcUdD17lUs1+Bfj4BxBi0Cxn
	 aOy2YKZkYEfLT/yjkBHgNvux02arAQW2DDeNS918=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1998/2214] tracing: Print the bucket size as unsigned
Date: Wed, 18 Nov 2026 16:01:14 +0100
Message-ID: <20261118150130.721255625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8e57b6e28fdb..78e53d5ccc868 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5269,7 +5269,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		}
 	}
 	if (hist_field->buckets)
-		seq_printf(m, "=%ld", hist_field->buckets);
+		seq_printf(m, "=%lu", hist_field->buckets);
 }
 
 static int event_hist_trigger_print(struct seq_file *m,
-- 
2.53.0



