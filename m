Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060266;
	b=u6hPEne7XcGVjRnvh7kyYXPJj8BjFZCwdl/LqsA2wCtXlysxZhN2YzQ9WRIBphqP1F0m
	 T/yl041YqQFXXjip5jhkXI2it6uejEL9OwZVNxwe8BiURS8Mu4bUrsd6RcOE+tcvFSSsr
	 QAwprljTbs7RPcfQDEBNsNWZXvVpOd1psD2CCz3a3Ggv+NjpjAcHOd+C2qAbrjHruVyqq
	 3cxS5lPoJHcG3hQQOjSDK4IosYUKhkkXgolR624EyDqJEZoj9WYUhxi0vZOdQ3Z84Ly9E
	 d/Xd7GlmM4GALZHJznGglkGUaDfNp4koD7C6M8FhCj7bml4encrFrXwA3a3kQDEYSjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RxvnyCxdsIIjrplgP9YSWZAOiwUU5c2KNfXPYbqrD3E=;
	b=ibZ1fFzFDdgAi2JYen2bQ+P8ppBTDj1DNPiUI2H+VskjZzHJbwv7F+KrJ7mmEBLelRrN
	 ilLBnmYoBNyNzPyz8ptDgFMdUuAzz2GfGiYohA17oa7QLVZA3HR/otNOieBE8D+oQUL6Q
	 41TkKksfk2q8OnpeuNu/YBjgg1J4CQkje4VR43CRDWOQ8oaoLHGOAQva91FguBlZkB0uk
	 2vtYxRvh/ks7p1dSNqi3QC+FxFofnYeCiE92zLyuA1r7CpqV9dpmMzdCUKfLEgTtCz0Kg
	 8QyomTRhcNYaZVGDONd/clRJmdXbAYSunpm/pdiZqpE1od+cyNujNgJNcgwEfPCbk7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEmdHXFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C6606A320;
	Thu, 19 Nov 2026 03:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEmdHXFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62851F000C4;
	Thu, 19 Nov 2026 03:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060266;
	bh=RxvnyCxdsIIjrplgP9YSWZAOiwUU5c2KNfXPYbqrD3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEmdHXFc/oh+FWH1nrJC3/B26VNJYekEFbqGtT7xEE/x0w0P6IaBK0dZG4oBbknWp
	 sWvUVtSh1ExbjU6Y9f/uIttJ/qHYq2zb16yssvJimow2d+dsN8GJEGG3MoG46rO0kW
	 v7xo9sT7BzB+8UEjFDuZg+W5ZVay/VCSdlhWlb70=
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
Subject: [PATCH 5.10 1136/1848] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150007.104661869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f11499e3a1989..f3d284a6a1473 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -626,6 +626,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -654,6 +658,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



