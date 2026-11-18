Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032168;
	b=UwL/bTUfTWVGrdk+uzW5BkhbXZsI1uMS+CVuSKkVAcEUb7pm5cdnaq26kqYlZ7lobs8C
	 XGg7ck1ddv6zYAv1O9LpyB+4dKympTRItGoLPpMv5SmvVRngRFdPrhH9kboM4LVL3QH7u
	 omQBJl39eiVqZ5xsjN8GJ4BzVFZ038j/9KvfGjeqCfKBqUT8icwNmSTxuXg05mPiXxJXd
	 lW1DmkjKSkPepAOSqu6Ila17meiV7a2GeUCLFhP6jrwAk4vXeBb108LOJa+MWIerRDxUH
	 BzGDNr43UtFoLJMF+Rc/GDWDaMu5OTE/fa0wGQsuxJn7ye6eauMwchx7OqDA5n0LnUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9z3s6+2m/G+Oal0jyBjNQJK2gZy+RqDUUtu+R6t4pOs=;
	b=duxXkqPMtmLD/lnhhocxFqWm9xIAKuj5DJVxKibjT8sj+nOklVD9MSePfaMje1gUi01l
	 6J/dHXnffe29iZlBbCHpEJbnQr2Pep+HV9dBqv+8buutCTq4ADpsF5dpewNyq7sYNC2f1
	 acURERusFUnsR+uK/TWw/VVQkTLsTDrNXRQEuxfS1ZSq2hmP1skKjNWQ8ggVnQdlwCGGZ
	 AiHEVs6Y4n4yt5eMSp3BhcniUSnao3FoIGLOE6+bapBTIuCyvbC+UkCN/wssax1kgGTSi
	 sMtShe78uHSz0v0BU3t/m5tc/TYfu0i7vke10MmVfbPhsa3Wz6pNNQf17gA0ZxVJ/yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxqUDcks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8972E606A325;
	Wed, 18 Nov 2026 20:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxqUDcks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C901F000C4;
	Wed, 18 Nov 2026 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032168;
	bh=9z3s6+2m/G+Oal0jyBjNQJK2gZy+RqDUUtu+R6t4pOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxqUDcks/Ixms1QN6NKk+YMrXq1xdp0W1at0Fa1XARxJ+p7aeNRtxRw2YtC/5JxrV
	 yCkPFLYaS8j1IGo6uW9Ria0LMuwygWtBsrs4oWOdVHWmm7p8ombukwVyjsXzSS7NRZ
	 81DDN3p3O9MbV3cOc3RkdVbp5Cfpy7sZ0AdLad4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1315/1756] tracing: Print the bucket size as unsigned
Date: Wed, 18 Nov 2026 15:57:22 +0100
Message-ID: <20261118150101.806723744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index aa9aca76e76e0..9dcb8978d3d13 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6183,7 +6183,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		}
 	}
 	if (hist_field->buckets)
-		seq_printf(m, "=%ld", hist_field->buckets);
+		seq_printf(m, "=%lu", hist_field->buckets);
 }
 
 static int event_hist_trigger_print(struct seq_file *m,
-- 
2.53.0



