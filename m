Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024539;
	b=CdmYcaPBpYt1uH8oO3uWleIlkqJcZ15DK0CFoDHv7bfeeKZDi/KJYO0JR3iiyAm542QW
	 tI71JkP0MSmLRGmYaLGw2XjAgFgnWfeI1wsPE2USi2LZno6Jkiygc386L5Wtj98v04+wS
	 W1x6q3RP1R/cthPPL0Yn8swjeXloZmDAfUtimq1Yac3EmR2mYbrfJsPSghzxT+VIvkI4E
	 Ps3FMdNFRj1VzWSo0lWk4qO8smu3Ct4AfvqSubp8UXKuDhqYA4O3JQlA6440EbPIbCDYh
	 PmR4i/UrJ4j190Z4Bg8A0668C4lkH1kcRBIY2x2Sdrm5PAEK/8GUC3AVz5VwQmynGTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h9AcB7RZJtRZcKWpRoW2pqV6wFb772Wm8VaGadumwuQ=;
	b=tPMrL60zKxborr5YAGmwrhztOsZy1NnLF+O54xkDsrBfmhNe9bEqoYpI5AT1v1JPSSTd
	 0ZtavEUCaWXZboTrh/iGVbQbtaMUSaoz4yaNfqd8XxqU3uqbLAAwFtz0h+XP1gkiBPLPC
	 Ny9qu7kkocItkTMrO/pqeOLtPoiOaBANq/eLX+Ft7FkscV7SsUi1F8rZ4COBqzfXShKHZ
	 V5GFEoIawpjQf/6JHujOv/RvTJbYn7q1STJaSFZbx6TtGSmQwnyGoMykXnpV+VAYVEIvw
	 MA6xXCutcBU1q4rmuc6QOymFXykYbV7QGMWYjPiB24C4udI9AruCB4oo+Ms0iEB57dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjNrLICK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61687606A320;
	Wed, 18 Nov 2026 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjNrLICK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15E91F000C5;
	Wed, 18 Nov 2026 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024539;
	bh=h9AcB7RZJtRZcKWpRoW2pqV6wFb772Wm8VaGadumwuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjNrLICKq/QzCAccywDVEfN3eV3bZGJMAnKUXE7SMA38BBuPag7+NZxZEXgdYV963
	 8T2zjDTBurNHBKRqh+Z8gyTj972e+ts7R5CfB7Uh1zI9eobfZSPhratgZ7dYXDnBAt
	 pkp9HwwsfHw6fxaqM7S5DVkl6cm6sK9BLCLKsst0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0761/2151] bpf: Skip zero-length stream writes
Date: Wed, 18 Nov 2026 15:41:36 +0100
Message-ID: <20261118150149.754989446@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit f17bedcd29517739a6491c1c51cc6a593f6a0332 ]

A stream write whose formatted output is empty still allocates a stream
element and links it into the stream log. Capacity accounting only counts
payload bytes, so such elements never count against the stream limit, and a
program that keeps producing empty output allocates elements without bound
until a reader drains them.

Return success without allocating anything when there is nothing to write,
for both bpf_stream_vprintk() and staged writes. Every element in a stream
log then carries at least one byte, which later changes rely on when they
derive read readiness from published byte counts.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Suggested-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260925045536.1480933-2-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stream.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 31ee75cba52df..688b10a79ba69 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -215,8 +215,13 @@ static void bpf_stream_release_capacity(struct bpf_stream *stream, int len)
 
 static int bpf_stream_push_str(struct bpf_stream *stream, const char *str, int len)
 {
-	int ret = bpf_stream_consume_capacity(stream, len);
+	int ret;
+
+	/* Nothing to publish; do not allocate an element for it. */
+	if (!len)
+		return 0;
 
+	ret = bpf_stream_consume_capacity(stream, len);
 	if (ret)
 		return ret;
 
@@ -458,8 +463,8 @@ int bpf_stream_stage_printk(struct bpf_stream_stage *ss, const char *fmt, ...)
 	va_start(args, fmt);
 	len = vscnprintf(buf->buf, ARRAY_SIZE(buf->buf), fmt, args);
 	va_end(args);
-	/* Exclude NULL byte during push. */
-	ret = __bpf_stream_push_str(&ss->log, buf->buf, len);
+	/* Exclude NULL byte during push; skip empty output entirely. */
+	ret = len ? __bpf_stream_push_str(&ss->log, buf->buf, len) : 0;
 	if (!ret)
 		ss->len += len;
 	bpf_put_buffers();
-- 
2.53.0



