Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831502;
	b=XA6hHHAFByAtuqd0UfRHvM8CMCIn6j0RNYq42Se1d8TcSP3UmxVe1nynLtYr+y6CFXjz
	 QdDahv8W2KfFTckT6xUMM+uyuj1c2HoJyuSSoKpaVVlR0YaKcIcA7m5oW01ptFhVuZnwU
	 /34xWO1/kpIBN8hYp5lFmA3/y1U9B+7h4u+lhXTauc5+KuImCTsXeuK46+fIj2aD/tswa
	 bz+UWYDp3worY/ixlAN4pO7acWHYGFaeMJC63Dd0lq5dfvtDnp7mCV8f7J0Qwin1JJK0h
	 gm2IxR04CJ4+9LEUZvf6k5Ecktq5ZxPZQADI2pm1V3Gpf1ciuCFHFtIQahSk86PlZFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rffJZYYLtaekB22ztaROzK6SGWG2H1KbpvfSfuIgQbo=;
	b=UWYsZOAnblViTiEebZh995Ggws8C9KpvOyVdQlxWIG//IRRAVcE0HXT6W3uMQIAdeSGm
	 99a2Q7mufzYQq6bp0cwNVNSqwmWGmLXLTyagPYHJCGNvkoibP9MnBUtaTSgoehpk6nR18
	 7PYR6mma7aWye8W2NTiL2AKC9CsZkFvttj33yyy3FWdyrvNEROfsqkMmgPfB98YH3HCI3
	 ZNg/7Q0JoM6GdQaeQK5k/ir+ePVx7TylyfdxQPzDMBKYV7NSSJJjGttZf5URaj6o6smLz
	 Q1TM6yxS81Qr5M8gz0QxN/or3C7oHi3dwGJ95g5GtP1UQIthd3GGk1RvzvFdchTj7XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oG/Zydn0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AE4606B2D7;
	Wed,  4 Nov 2026 22:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oG/Zydn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D121D1F00919;
	Wed,  4 Nov 2026 22:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831502;
	bh=rffJZYYLtaekB22ztaROzK6SGWG2H1KbpvfSfuIgQbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oG/Zydn02fJF50gE1RIiPShmkIslvHgFcG0WjF5fI+u56eUwo0HVoLvZ/3Xn13YpK
	 vw9l1Op/kSTipK8IkLY0J13UjGB6SQOvlwAc2+/NUXb9gCk7zer/1EapL5mS2asjn1
	 bShHVaVdvFeqeOhWAQ9ngW+9733Go8J0t92KEFAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Sinyavin <sinyavin@gmail.com>,
	Janne Grunau <j@jannau.net>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 0742/1005] nvmem: core: Fix OOB read for bit offsets of more than one byte
Date: Wed,  4 Nov 2026 16:07:55 -0500
Message-ID: <20261104211104.256355255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

commit 24530401e8001aaa637dd5007fcdc6fbc00300be upstream.

When the bit offset is BITS_PER_BYTE or larger the read position is
advanced by `bytes_offset`. This is not taken into account in the
per-byte read loop which still reads `cell->bytes` resulting in an out of
bounds read of `bytes_offset` bytes. The information read OOB does not
leak directly as the erroneously read bits are cleared.

Detected by KASAN while looking for a use-after-free in simplefb.c.

Cc: stable@vger.kernel.org
Fixes: 7a06ef751077 ("nvmem: core: fix bit offsets of more than one byte")
Tested-by: Dmitry Sinyavin <sinyavin@gmail.com>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1597,12 +1597,14 @@ static void nvmem_shift_read_buffer_in_p
 		*p = *b++ >> bit_offset;
 
 		/* setup rest of the bytes if any */
-		for (i = 1; i < cell->bytes; i++) {
+		for (i = 1; i < (cell->bytes - bytes_offset); i++) {
 			/* Get bits from next byte and shift them towards msb */
 			*p++ |= *b << (BITS_PER_BYTE - bit_offset);
 
 			*p = *b++ >> bit_offset;
 		}
+		/* point to end of the buffer unused bits will be cleared */
+		p = buf + cell->bytes - 1;
 	} else if (p != b) {
 		memmove(p, b, cell->bytes - bytes_offset);
 		p += cell->bytes - 1;


