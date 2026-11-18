Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041858;
	b=zZq1+e99Kq2BNApxGPvh6h45axf0qbeUXH13b6MnUgHSVKiPFHHc4qo9gDMQbLk04eM2
	 6SuYilN4eTclRMEquo8ywkxFOe7lvUiEAoveeWs2lBH2yW4itAKLUQfxAoye2Y4j99AS+
	 /06iJBSW+12rdNT+RHy/Brt2awvTCCA9h9Ai0Sg3nqp9lHHBUR35N+Z5ss8bO2cKRBd3L
	 tnjTLhGBDJyJP8qBKeGELb+DlaasRtErKYd+jEwPW4dveZBMNcY8cVrhMsxJgPxYq2kA8
	 rVA0ONxc7QscW281DKF3kJatTCYtbtvkauqog1MhMPZJSpxN24xwP7D5SpAuiQ1BV9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+MpyO9n1kn1oyXIv7FbGzNwuz+3HTNSKcTnYAnTUz0=;
	b=qG6xyhgRxUUFNCQtWKclBfMC3r4n8rX+OTIbZTasvFpaKjVr5tn78l4Q8TiQWopeWnEZ
	 uICasmY1yNAfK6U/T4BPiqejsEmWQTWN1LRcyZeokk7NQjMlopBnxn8U3Bw+fDhCXhX6q
	 ZQgh+BE8m9WCms7dVa0O2EbJ/Nknz2DfflYzeZz7Etuc5CZMvZ1FOi8TBGufj05Rjn5YT
	 NfxoDYgaStsZ5mTSkhqNvIzX2CszpO3ngJtCJhhddheXqsGjOSFvLzjCQrL2PDlEYV4NQ
	 qFXM22YdVPwhOTqYS0G8V3w0GXe9OlKN8SMtSBsIwaNNMxpX3nMYfmj3LrxcN6hCMdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7jZ9z0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C5160A2604;
	Wed, 18 Nov 2026 22:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7jZ9z0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5491F000C4;
	Wed, 18 Nov 2026 22:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041857;
	bh=z+MpyO9n1kn1oyXIv7FbGzNwuz+3HTNSKcTnYAnTUz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7jZ9z0NKoX5usrejqQ12htS5H4NtmdIHH+nBpXcm73AAotXQMlmf0l1PSc10G3fo
	 YvxIn6p/WPILpeixliJAHzIcJlsz9kg5nqrDIhZLYfLhvlNesnwKp7YyNDdaKaw9MG
	 eWG6BQKBUNVX6MD/8aN30TPR5NYeWkYTtSJ1C8uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2963/3318] tracing: Print the bucket size as unsigned
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118150449.184053841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8c2bc07154f77..e6259e04ea663 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6184,7 +6184,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		}
 	}
 	if (hist_field->buckets)
-		seq_printf(m, "=%ld", hist_field->buckets);
+		seq_printf(m, "=%lu", hist_field->buckets);
 }
 
 static int event_hist_trigger_print(struct seq_file *m,
-- 
2.53.0



