Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050028;
	b=WXrHJfLwXW+hFmhY+G9UirDTAJXK3BJ3mlJ02XqCIUqaj6oJUHEIPqt8KmA6iDbM+QUr
	 CqPZht1+Wn6V4a3C4OL9KdMjTzRyTuBYMdKjxCDaaJ2nWjGLfU1SYbwFNmeBQtMOKgmsq
	 P1uvgqO9dC6aJxsgyQcSNQPn2SeVCQJOTYJ6gTLGqj4c3v32BSXPDNQJQvk9WuTSb0bNX
	 Hrxk4baFGM3wy1u+rvSX/9ACTjjjQ6a/i/YdorL8c+vf4Z5wldEV75dhinaCOEC61x6Ty
	 pgxFE0cnbqjgUEmNa9H2Oi0sIo3OPLLRtTyRYsPXyfi1paXyU7A7tqcxLKgWuUcyytw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgEeW1tXSFAcfLoVlrjI3bGx7BJhsDjSL5UqbRJ5SQI=;
	b=NoQ25Zg2bWUgxTxsuyXBmXVLpTjzhhKrRGJrWekB6QXnJaF0dhA7wfWcps2kPAg9Q6+j
	 B7ud3hejN19RpGxQAOGwEFhcWLjls6HG3t/DoujUrF/nxvjPbnIRhK8qVQUBLyTu4VuxV
	 2cK5Ymm1Rn+QuNZqj0Qs6lZr71In7GyonBsWlIlW0erOzDnPHiEcWOtSEqvIJxH9ao/bW
	 Jkh5Ake46jU6V8NF+qgNwEUUVvVgYEHchT9hTrbxLdsWviKJB4x2eh8ue+ZzTgjJwQkjg
	 hCQV6Yr5/spE08WXhS3SeO5bJ0kwQyCJQkGUmHN7KUW24jikgOqaCy0MqWhUAGOfJOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSMers5q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D52606A330;
	Thu, 19 Nov 2026 01:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSMers5q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3741F000C4;
	Thu, 19 Nov 2026 01:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050028;
	bh=RgEeW1tXSFAcfLoVlrjI3bGx7BJhsDjSL5UqbRJ5SQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSMers5qNjJupXUjGyFTHyM2ryt19SUh6r3sgNsWmANHe1Tseytn475qT+xZpsGg5
	 7Q2rOXltLGJBHGjGY4KwPIWRBW5C3fAVcWO2bVEErt4Vvj4ivypcsmNRe8ftXh4XNk
	 5u9IJ+1K/ffTwHO+pSSVZYs/RvlAlX0kqwx1laL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2562/2857] tracing: Clamp the printed end of a histogram bucket at U64_MAX
Date: Wed, 18 Nov 2026 15:59:56 +0100
Message-ID: <20261118150333.743536087@linuxfoundation.org>
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

[ Upstream commit 289e2a775de434ccab2d107076bc78362ce288bd ]

A key with the ".buckets=N" modifier is stored as the start of its bucket,
and hist_trigger_print_key() prints the range it covers as start to
start + N - 1. That addition overflows once the start is within N of
U64_MAX:

  # echo 'hist:keys=offset.buckets=10' >> \
      events/syscalls/sys_enter_lseek/trigger
  # ./seeker 5 -1                      # lseek(0, 5) and lseek(0, -1)
  # cat events/syscalls/sys_enter_lseek/hist
  ...
  { offset: ~ 18446744073709551610-3 } hitcount:          1
  { offset: ~ 0-9 } hitcount:          1
  ...

18446744073709551610 + 10 - 1 does not fit in 64 bits, so the range ends
below where it starts.

The bucket does end at U64_MAX: it holds every value hist_field_bucket()
maps onto its start, and there is no value above U64_MAX. Clamp the printed
end there. Printed honestly the group is shorter than the size asked for,
which histogram.rst does not mention, so say it there.

Link: https://patch.msgid.link/20260914132346.2234731-1-donggeunyoo.kernel@gmail.com
Fixes: de9a48a360b7 ("tracing: Add linear buckets to histogram logic")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram.rst | 3 +++
 kernel/trace/trace_events_hist.c  | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index 5c391328b9bb4..5bfa0b1aeafbd 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -1943,6 +1943,9 @@ the ".buckets" modifier and specify a size (in this case groups of 10).
       Entries: 16
       Dropped: 0
 
+Keys are 64-bit, so the group holding the largest values is truncated where
+that range ends and can be smaller than the size asked for.
+
 To save stacktraces, create a synthetic event with a field of type "unsigned long[]"
 or even just "long[]". For example, to see how long a task is blocked in an
 uninterruptible state:
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index c2bde12ee54f6..cdd0281ba6657 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5340,9 +5340,14 @@ static void hist_trigger_print_key(struct seq_file *m,
 				   *(u64 *)(key + key_field->offset));
 		} else if (key_field->flags & HIST_FIELD_FL_BUCKET) {
 			unsigned long buckets = key_field->buckets;
+			u64 end;
+
 			uval = *(u64 *)(key + key_field->offset);
+			end = uval + buckets - 1;
+			if (end < uval)
+				end = U64_MAX;
 			seq_printf(m, "%s: ~ %llu-%llu", field_name,
-				   uval, uval + buckets -1);
+				   uval, end);
 		} else if (key_field->flags & HIST_FIELD_FL_STRING) {
 			seq_printf(m, "%s: %-50s", field_name,
 				   (char *)(key + key_field->offset));
-- 
2.53.0



