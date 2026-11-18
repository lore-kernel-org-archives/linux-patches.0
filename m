Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050020;
	b=M1qPRb0r+MteTBh+1gJITUL5OKilZvWFbSzL8pmToQuSp0cJjsw/q3dQBVYB0ogxnYS8
	 OFOR5dkZxGP2hcSKbHHzxZKaskd4d2VHr5ctMQG17gQaNIos/zQtkSM3gz6A6Asvm0H8u
	 VufpRzcsSnJPpVK2ttR4oMKekdbQSGSNflCVPdJwutlgDF7g8QTYwskn1bkkhy/EfjY6S
	 TOoYkqGEDfLkqyatdWRxoQtCpZx2tfUjtz/kn7dt7AQhJyGP8xi1GrJTMBtS1i59IR5w/
	 EGJtuqN6cifdNuvX6ew3gTCjI2x0UJrHMuGBx/Ks1Y13JZEbdq4vSrr33gk0OiKOj+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7YJdNUtOytcWxKzzCZksLpmKzNMgVnEmtXKreEoLfuo=;
	b=u3uVtXnoIVFtgYRWVLhRvJVaCi4F/yOUl1UTvuyvurUTlghdlstrdjb38usQFvp7+PsE
	 Aao2jmy99LAq4op6LV0ZShTOptCBHMAwlaZcwCvbElK6Ys50OXiE2/Jy4z3xtgAokad+y
	 abcGR5TVgRQmb9Lg6MQJZSwvAn3k3kt9QnkQAcyt9X7irRqFqPf90+K9B/N1wMrOXA8/Q
	 UcLF/Q6olBAcw2w5oxa+HG9imusvRLXeIvtsBGCDsSqzDnfsFD5HwKW2rmYekka7YPzBj
	 dGHknjh6bBU0WVAe4r0hSm/cQA5aBNfLfxmPIJuZT+jmvq0zgUvfaUPwzX0URb+5t9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=li9TSI4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1E606A335;
	Thu, 19 Nov 2026 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=li9TSI4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E3F1F000C4;
	Thu, 19 Nov 2026 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050020;
	bh=7YJdNUtOytcWxKzzCZksLpmKzNMgVnEmtXKreEoLfuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li9TSI4nMBRy0W40XIQJ90oz2gh7otxgMV4Fvag+jOHHy5XJGYbcuJ+Xrl8MDF++Y
	 o0qUbHQXH+SaJTPxL39/rSeSdJEDljZATxJTq+DKLNNV2HYX8NdG+47QcBKkUid/5i
	 t6peivlTuWC2BHt+SKcjyF+zf2fvhiYuYJQtkhxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2559/2857] tracing: Print the bucket size as unsigned
Date: Wed, 18 Nov 2026 15:59:53 +0100
Message-ID: <20261118150333.641565270@linuxfoundation.org>
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
index e97f7249d12f9..c2bde12ee54f6 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5890,7 +5890,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		}
 	}
 	if (hist_field->buckets)
-		seq_printf(m, "=%ld", hist_field->buckets);
+		seq_printf(m, "=%lu", hist_field->buckets);
 }
 
 static int event_hist_trigger_print(struct seq_file *m,
-- 
2.53.0



