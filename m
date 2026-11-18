Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017455;
	b=J9RE0XLyBLvvemTg4nfzYsrrMd+2n9DrQOC1tayOFgJKKirW5xCPuJoUHdiB6LKyvsbu
	 sfxc/3UizCNBpl1rvOXgf9CNplPEVgFrq7TjLzoMSz24gF93ower6CxIiArXScgV55VWC
	 tHulQsE6411BGZnzOHaUk0Cw91p9gtHJrg/aBm50orNDDHw/IZwWm0NSsQQyFY7r1ohq+
	 EeA906VscP2NJ5B3otjJQ0sWtwrZ/0w/K++vxk0hAglz81ygVJgcsWhjIUM7yl8S4giGQ
	 yDK74rR1GXyVb4J3dxDZmDazV5UFkSOVQ2EjaLyp688nTd6VKoPSkIRKcuBGUEnCIXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OLa6B36Rz3Gnrj/yNeplMdhH2WRXzPyuxjmhOug3FNY=;
	b=V6X677lPQwzk+74zCT3gdYhVlgOM2m3Yo6c/kzhgixNt4d1YQKRiC/z0B4RPMV+y0xrJ
	 imeo71tlqCYfasUeyKXk22nYTPNBPFoltZdZE/1qNsrdhKv8tJqmrKNm4EqzzoJS1P5R1
	 mnG7fSiOt7m2FgwkgC0RjwEm1w2DMTrSl+DRV3KVLjedTe1OEW86hAoRUxd907ZmToAJZ
	 YI+MYtGE1OLJmalcCDPSMSjwTVpOWle4CEx016G49RMq5xZGOkAGm3kPu3ZWRA48j5qc4
	 wTNQoOl5Lb9nyZwKrKbQFyMPEugc3Ig0Px/FspJcm8LB3lMmR+jdVwjC+OZEjzuPiqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5zItV9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025AF606A320;
	Wed, 18 Nov 2026 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5zItV9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F451F000C5;
	Wed, 18 Nov 2026 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017454;
	bh=OLa6B36Rz3Gnrj/yNeplMdhH2WRXzPyuxjmhOug3FNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5zItV9j18RJhAFwjNpQDP74CeplQbGfODimEdVQszVt3xs+MN5eIaOZYlarO/O5T
	 2iu5p1ovEbFuJ8zCKZfW3AtOOxHTYWVPqI2A4//ff8Ve5EsZsGUMv5tkWQTLQV577G
	 O8J7ZAPr9CwvQCr0Jh+O2h3z7+xfwzdasvrLex7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0890/2651] bpf: Skip zero-length stream writes
Date: Wed, 18 Nov 2026 15:35:30 +0100
Message-ID: <20261118150319.906107736@linuxfoundation.org>
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
index 2b80a0599865e..9829d1ebce70a 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -75,8 +75,13 @@ static void bpf_stream_release_capacity(struct bpf_stream *stream, int len)
 
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
 
@@ -333,8 +338,8 @@ int bpf_stream_stage_printk(struct bpf_stream_stage *ss, const char *fmt, ...)
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



