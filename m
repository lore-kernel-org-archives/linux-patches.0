Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027047;
	b=Wl8HmwVHUukmfSyVxdfgIMEY/IQCeCw4jPN/1iGI3iL6pTugN5CvAlZdFhI9P6ksbNRc
	 bV7ihvha6hjEEdqVhVUwTQYcEIke3yuEbkkc4036qBbAxmFgjanxqBinsw9iBBRQAIeMb
	 bkvvxxAggkv5jdUsqV2HXSdVFyCLqK0BnSoE+64VrvgJ+iWxqDpGyi9N8rPc3WCvNKNY2
	 KDKR1reTynlA1ND0m+mBQhSyT9O36YNe1CVa0k2OpzYClaYnGlqpu8/GvUcvRHuC3MWOi
	 6WBtLNeAs6kf7W3BpskCyRvWz9vHpmnoafTAYODVDLFThAMXpLMd2bz2WYRglAIANfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Duk9n9gkX1Aa5/h4+hnT8A+YU6Crjha2nO8ECxw4rM=;
	b=x1k3A/gYwQ1rSInh0BTlotD+eZHmVdIoSxMpd3+Twlvo5n2keGCRM/688fLSqBFOahgo
	 /YEjKbx4oLIWPB1lYnlaDRIOVrar8r03uznR4sCWsh80e2dWOVdbezKjOLT39linr7IlJ
	 lyyBMDu+zMrXocKvqR6/SycLhWUT7MI67cHaNul6soyw9YL7INdd+89ilTcSOPt5xiesx
	 yh6XgD+xoSb/BuSAB3pR7G8INTpKCLvcFPvJvlRslnhNTF8htExczrP0e4d6X8YZFiWvc
	 aQlrGRivCavFMy802QoBOn5nGyV25icBdbOGuB2ASDnjuz/xjrZclAcjCAUfAyV2q9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRvLoGil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EA2606A31C;
	Wed, 18 Nov 2026 18:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRvLoGil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11791F000C4;
	Wed, 18 Nov 2026 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027047;
	bh=/Duk9n9gkX1Aa5/h4+hnT8A+YU6Crjha2nO8ECxw4rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRvLoGilEFoQ1Eskr9cHpnh6z8+LbN286QGVgRYOHSrwTAo9xkj4bkbahj4tiQol5
	 docKcJmC/XOwYjHnjO0oOsz6sFTi0Wo1z+bFbWWYiQ8wscraz1JqKHmg1wdROPIRMg
	 a2SZGDIU2tMsa6EHYmDBuyR38xaprwk2xYUt798U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1644/2151] tracing: Print the bucket size as unsigned
Date: Wed, 18 Nov 2026 15:56:19 +0100
Message-ID: <20261118150221.742374840@linuxfoundation.org>
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
index 93afc706e4029..53232c3076874 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6211,7 +6211,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		}
 	}
 	if (hist_field->buckets)
-		seq_printf(m, "=%ld", hist_field->buckets);
+		seq_printf(m, "=%lu", hist_field->buckets);
 }
 
 static int event_hist_trigger_print(struct seq_file *m,
-- 
2.53.0



