Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022856;
	b=dL7A2tpgksuUy3oSL8j19qrjiOZVn1oa57B22tbliI60hHXFA6JAvhrdRZdUfAeWGVwf
	 qtJHgbshAClMk9+4bOVCzo2WLdO3jN+nFbo87QxVYcig8cvGZdZms8pQvTZHT6Qmg6tjG
	 ErGHCBtzhlIoZNEVM5CdQZy1C3VTz/ev3mB480E/fJ1ZMqL+kbaOQSJrFnAY+3KzkKsU/
	 M+3gTtdvemvT9m7T1i+5LN2LhYeyEQfUo6B65bgcxlU+tR8kEcOlGhc9Hm84scGuUp1wW
	 8s6e1Jz2CyIUNGOkRKAxq5BNn245u8filMIy9GpY+zhOfjpewK+0O+liA/OE9OZUQxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Fo82vLjxRqLP7kpWh9jxiqxIZWhnf3/OkqCiCRUCVE=;
	b=P56O2Bj4xjXpbgJYGsKtVtuQh6bSvO/xZvFMCDI7phASyuZg83NbzMopmymtHiwn1qRy
	 nfCyfHP35Xxs17qy3pjoYPsG7nfZYLVxNkClrkztmkFhofBzwQdu053L0QjQPwfk7vXaM
	 fkJ6mJFddAVb4wNTBQhILznLFrmD9kv1ZF0cH5Ng+WMVotQGjsajyUG9LSEyxUnXLV0xe
	 xJHs3mOssXhNDMO/5Y0VerxOjblnQ5Fy9C2zQXL74H7haU/JGTPcybnqyzp4ptVnrBw3t
	 fgLNxo2XdBkHSAVrh1t66ahnE3IuCO3wGdaqlr2yM7UXw5m5U985eKD72iUQbfkInBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/mkril5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0D5606B3E5;
	Wed, 18 Nov 2026 17:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/mkril5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A9C1F000C4;
	Wed, 18 Nov 2026 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022856;
	bh=+Fo82vLjxRqLP7kpWh9jxiqxIZWhnf3/OkqCiCRUCVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/mkril52EGrGO42zWhOEjfQTY8cJ4l33Z/TddxM78Dv4kWu+tAJYBqpBXF4ma+cY
	 f0xaYjBoapQEA/VzwR9ClLM7qrFdYtJUF53cshJN2soCV0UDCCXF0QwelDUi4aCJJL
	 WcX7VNlJR1+DffNpXDKnYtybNbSHl03YOoT6oro4=
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
Subject: [PATCH 6.18 0162/2151] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:31:37 +0100
Message-ID: <20261118150127.648457749@linuxfoundation.org>
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
index dedbfec2ecf1f..e1f0e01b851b1 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -668,6 +668,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -696,6 +700,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



