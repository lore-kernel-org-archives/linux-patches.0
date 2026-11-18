Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015260;
	b=SQVA4dFJuWhFHvGo89hAryOrm+IQ5nHisqgwSHvJbr5zKDmghovSy2ti06I3ZxBHbpR3
	 zm3JWjMJqww2ywCk0cYSXPydtXYES6ydWQL35hZH+/rVj3ZLG+u3q+b/NtcBincG0nLp7
	 L+WcX0kviYtNAelVgES3bfWHWHNsw8XPf7p2COMTjIubxFawMLSUGKOc73USdnlC+xfhR
	 I0IaOhlrLIUWThEujXUbwTKdDvvhrw2sK1mt05LqFzrYGgDTrOFwjoheshbgflj5FXvyQ
	 zMHm5Yv+4oKdkcdyDhCmVJ7zMxVd62bXehsXQ0Uhp3yXWY2twSC9C9yRQ/0UxMCAuEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LrBVvP+483ZbyriPPezpNGeGHdYTE0R7SATAGdSjX4=;
	b=QVNr7gAYYmej+GkIA/cGLem2c6CV32mxniru54JPyOkFlKKhDT8ntyOwrUUWM8HxmIFY
	 iwiqaaH4mpDgIBgAzxzMi8pZNCE7YbaD88RsVvvOsnAUREDGnTaIdtOzNo+BXB78go/Qh
	 rck0eXk8qJYWRp5X8FytmBSMNgMQ2FRqU4D29w8KAromqcNrLsEDtIbwayNgqgLWaPdAw
	 fIzOAEG6UQWcaXvRZ5gtbPwGvcS8Xjvysr/Vt2uz02Q7OqmrY2rZXPTpbG8pow1mbeTIf
	 gh7a+R13HBRf42q2OMiDWkPchOqJokAlhU5RsyN1Sfo3Wp2aAVrjAGDXn/gM1je1Zqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1rKjRNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F58606A31C;
	Wed, 18 Nov 2026 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1rKjRNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8123D1F000CD;
	Wed, 18 Nov 2026 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015260;
	bh=9LrBVvP+483ZbyriPPezpNGeGHdYTE0R7SATAGdSjX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1rKjRNHwuyZH0bSGc1Dj4ooGIMZxG24v/xkYjIASNE2huygy/r5FpqtpjhcSJUe1
	 2o+6CpKMuPu8not5PDLg0aZsFF1wDROSQuTZPPg2WbTqTqhyJoGCnWchH2jGFHtfsg
	 Y2UjV8e0GSdxBb4m4GvWAwR6kbVIC7B56GInrlRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Stefano Sanfilippo <ssanfilippo@chromium.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0109/2651] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:22:29 +0100
Message-ID: <20261118150251.808536481@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit dfe8fe96efca3c32979dc0859f88e15b677d25f1 ]

jit_repipe_debug_info() and jit_repipe_unwinding_info() compute payload
sizes by subtracting the fixed header size from total_size:

  sz = jr->prefix.total_size - sizeof(jr->info);

When total_size is smaller than the header struct (from a truncated or
corrupted jitdump record), the subtraction underflows to a massive
value, causing an oversized allocation followed by an OOB memcpy.

Validate that total_size covers at least the fixed header before the
subtraction in both functions.

Fixes: 598b7c6919c7 ("perf jit: add source line info support")
Fixes: 0284fecd13b6 ("perf jit: Add unwinding support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stefano Sanfilippo <ssanfilippo@chromium.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 14bd23c8d1963..f79e9420c6bd7 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -671,6 +671,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -699,6 +703,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->unwinding))
+		return -1;
+
 	unwinding_data_size  = jr->prefix.total_size - sizeof(jr->unwinding);
 	unwinding_data = malloc(unwinding_data_size);
 	if (!unwinding_data)
-- 
2.53.0



