Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015232;
	b=TZ00opH3EoWSr2OpViYf0aNHIhl3n02b2WR3QpTqGeVEQ2P/f4Rx/5rCUKYhv8zZ21qi
	 HUX9elhehzn4RqOkuBX+TbEExr+GFUNEnuDitPjBrAPR/sEzf1QP/rk7H9RymKHy8iC1l
	 oW+tjhjyUKSbU9bfWKKbBl5whJuBbYXZ4e45H4LoP6nzYi5daPRvOjBZJYBUchtE9ydLi
	 tsztDMlFoW7cCeeeBMsioB7cEgVLL7FplQ7f9CW8z8UxHaFL5W/j7eL9X5uZwg5C7qc0n
	 k2GFs5BCqovXP3zPePXLONAL1TPkxpyxUGOZ4P/wM+tdviyF59gfo2uQYMjLGz/OCbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hvw1EV7mm68RF4Kl6Z95NjVUB/WH+M+OApZu1SXwA90=;
	b=pC5vMmgIma4RtgKqvA72svr2S2Sm5aN4veio4BxPmLWhUYo0+tVhtXprZMJf+QeZ4e3S
	 syH++Cxt/hxywpLqy/qlthlVals/KrgitAQy35j5xVnBL984d3w72CHs/4tBR+21Hv8vV
	 xZPbZ3kyCoroY7FNq2doV+bMIUgh1iEn7xFKeu4CLsRwy4gs/Egxyt/xfCQ2zOo6LyPXY
	 h0RNL03wDwOw+rF0xLom5khuo8QlW4rJdQ9MsEH0rN+jYbyHwM1T7d/zszD3tV9LU4csW
	 wUGwLmUqMYqNfGLHXf+tYJ0R4bNKbwXJA95Vln+Ovdmn1B+JRcc66ny7P/0uIZ1VUPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8tzI6ml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE32B606A31C;
	Wed, 18 Nov 2026 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8tzI6ml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78161F000C4;
	Wed, 18 Nov 2026 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015232;
	bh=hvw1EV7mm68RF4Kl6Z95NjVUB/WH+M+OApZu1SXwA90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8tzI6ml3RGXkYRzsSyMlU8MfzazhzMLVAOR5gSWtRX9t3bW3SeXB8YnxdXaZPoc2
	 hT8fFD8SpQopKvtUI5rRA8iKvc8CPTNhGRTZNLBSBX7kTbQKzxydGKHq5e+hcX7mgp
	 jgUU2KloUR6VzofZlsfXa7PvRAVTrHBPLz2x8XP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0073/2651] bpf: Return partial progress from bpf_stream_read on fault
Date: Wed, 18 Nov 2026 15:21:53 +0100
Message-ID: <20261118150250.563065044@linuxfoundation.org>
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
index a36fc93389677..09471a6052682 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -167,6 +167,7 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 
 	while (rem_len) {
 		int pos = len - rem_len;
+		int chunk, n;
 		bool cont;
 
 		node = bpf_stream_backlog_peek(stream);
@@ -180,13 +181,14 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 
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



