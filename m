Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022833;
	b=0r68Uyk/NV7dYm8j13U0I7UALcA+57xxyMF+M5rYDnGP/9oguFJNhAzt2URmt6Cgyhyb
	 uRzQuhRD7ta2A4KuZ8qy6Q6lXlOcXg9MWwxojpec9Ov/EV3R/nhImWWi0N1xrWy+j8GjP
	 WBYz7I84PUMr66/5pBy5Nuc81phcoyWAR+INOJGbygacxmGs7X/6KJ8unQ3IBme/0ANEs
	 QxX1q6r7mPYJBitxZu8rq+2YhAvEf5tMriOR8RLj1Qi9ZqgwGKeTfMTBXrV0LBybuC7mJ
	 Xt/G+/td/kixtLmflTJOcC/5zqqFebsehC0ua/bWSSVqQyVyL+b7ObTLA0EdsKO6N8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmLo71J50XO7ZjH5kginOquoGxFdJQUzmPdQgMTif/Q=;
	b=Beg8Hu7ej/ew1q67yNO/Mok7AIAWDqU0zE1GNiU9tOA/ounIhQNzcAxkPBRq8Q31kP2X
	 zVIikSm3DLZ9L0eWWH3xHqKLNSdIJ8031bJqF0XbGXKD31cIFNWwNp387djbCP6Ic7CLi
	 th2lJGiHtfDvrJx8fF/puxFDFpb6/TfWkyjVtx5hVQZwCAUlHHNAyHcad7bCbNRapTnYw
	 kN2fRxQmTS5MH+QJlNf/7uOxFnUXvE1NE8wKOySaM1EZGJRZzfQm/ENEkuPWKCtNXjoDX
	 N9Zi221ygg1Sa61WF88jcT9IzzlLk3BZxdGNkfBmpGFBOseoIIlziTE3ZJpQAF8q4ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uC3azxWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88223606A765;
	Wed, 18 Nov 2026 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uC3azxWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A004B1F000C7;
	Wed, 18 Nov 2026 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022833;
	bh=jmLo71J50XO7ZjH5kginOquoGxFdJQUzmPdQgMTif/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uC3azxWQLrHpZmKGWhfAk4MQRSyOUQAU5Im6XebkX3O6ojH+YL+w3jRO6njIPzrz7
	 GL3c7nR3CNGgK+n6YM18yyaJKlwhtY6u2484vpf52vySZblw1pT3696q3LSZPWkvES
	 IX2UHn0GDU4DkkAyX35l1hXMTdq40rlRk0JjAgGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0137/2151] bpf: Return partial progress from bpf_stream_read on fault
Date: Wed, 18 Nov 2026 15:31:12 +0100
Message-ID: <20261118150126.777734499@linuxfoundation.org>
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

From: Jianlin Shi <shijianlin11@foxmail.com>

[ Upstream commit 16790357a50baae10de1f619b608a85145d54bc2 ]

bpf_stream_read() pops and frees stream elements after a successful
copy_to_user(). If a later copy_to_user() fails, it currently restores
only the current element's consumed_len and returns -EFAULT, hiding
bytes already delivered to userspace and making the consumed data
unrecoverable on retry.

On a short copy, keep the successfully copied prefix of the current
element and return the number of bytes copied. Return -EFAULT only when
no bytes were copied for the call.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Link: https://lore.kernel.org/r/7668c5838c6beafeea719df8d55319e2fe08cfef.1787492521.git.shijianlin11@foxmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stream.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 612f4a7954f4d..62af66d6ee391 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -310,6 +310,7 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 
 	while (rem_len) {
 		int pos = len - rem_len;
+		int chunk, n;
 		bool cont;
 
 		node = bpf_stream_backlog_peek(stream);
@@ -323,13 +324,14 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 
 		cons_len = elem->consumed_len;
 		cont = bpf_stream_consume_elem(elem, &rem_len) == false;
-
-		ret = copy_to_user(buf + pos, elem->str + cons_len,
-				   elem->consumed_len - cons_len);
-		/* Restore in case of error. */
-		if (ret) {
-			ret = -EFAULT;
-			elem->consumed_len = cons_len;
+		chunk = elem->consumed_len - cons_len;
+
+		n = copy_to_user(buf + pos, elem->str + cons_len, chunk);
+		if (n) {
+			/* Keep any successfully copied bytes; -EFAULT only if none. */
+			elem->consumed_len -= n;
+			rem_len += n;
+			ret = (len == rem_len) ? -EFAULT : 0;
 			break;
 		}
 
-- 
2.53.0



