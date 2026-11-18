Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041499;
	b=BKbf3+j9ujSeHlafIlUMQJQOiD4GjGSLY9cdOBd1Ga9yZyi2EOW3tO80a9qNlx6lkQ5+
	 Zc1OFj5JhNpzuqxaGHc0+QLjQ6W2VOpu7HhFc1jcYVfzcjqeRjsxyjOfK77yMpV1ZurXE
	 Dhyn9tOSdwFQ6WDmwxXCzlEIVluZ7kHbfqKjIEwUuooWM6oB6cK6GJ8eQTd05T3O/yfIn
	 02s4hpJlIxtFMtZdeudpZq80Ms4wXmziB4roMZqxlMW2pxwRpFaLYK4IWa1c7eFYGfLVS
	 RM5UyFlDHpAqe0ZXqBEFY/lWCuWDM6MFdiIBUj1BDhOyqHhNigsnGjhpeL69q0CsQ5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdGJTH5Rj2HUMAVoDRgctNMGupnWjvQ7IRWk37390m8=;
	b=z0I7uJH9K4/9C3Cf6UdYgysNvioZfZuoHL2mkZ1Bw+Y2NeG9f1GNYLZ/+9HrFZ2mnpeR
	 F7IHwHEpO1bEISEHxZAIPerdqt0Pvk4i/k9evLzLF6ra74GejusC3cVK7idOHp4mwEztu
	 JGRiq0HS79x1NoyLl3UlxMVvO8k3kErHvTT+0oyfgpsdukrrXSyBhh8hPuXIdHF6ieoiW
	 FpmQk7GmlvyKBHckmMOvFYtae6h3O6y1PaXe78Ta/X6kTQcTiVb9Kd7BV5UixwLcjirga
	 pzA/Di7QwqKyeShrpfJxbducLFB7OTEA4QygPKOKpM/nlPjmNWmECG0tVEeHRAda5Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLIKkujn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B522606A335;
	Wed, 18 Nov 2026 22:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLIKkujn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8E31F000C5;
	Wed, 18 Nov 2026 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041499;
	bh=jdGJTH5Rj2HUMAVoDRgctNMGupnWjvQ7IRWk37390m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLIKkujnEDLY2YW0siFw42n5xOZr+KA0mjrCYUl2EqrP9iKEG2XAbUWUufDN1O39K
	 3APpSD8759ysX3ntkI41BRi3Ji8Squ7nRsP3+NvbxfJcL7+PS26At08B5JUJybcURN
	 m7WNR+dIWS1anHt+zftgFHaZC2aU75JhcDX3uQ+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	VEGA <vega@nebusec.ai>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2834/3318] lib: validate in-memory LZ4 chunk length
Date: Wed, 18 Nov 2026 15:57:36 +0100
Message-ID: <20261118150445.647658555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 138a84817df01eda67bb23032ab49c23fe2ffc16 ]

We found and validated an issue in lib/decompress_unlz4.c.  The bug is
reachable by a root user through kexec_file_load() with a crafted external
initrd.

unlz4() reads the compressed chunk length from an in-memory initrd and
passes it to LZ4_decompress_safe().  It only checks the chunk length
against the allocation size when the input is filled by a callback.

Reject an in-memory chunk that extends past the remaining input before
calling the LZ4 decoder.  This prevents malformed initrds from making
the decoder read past the mapped archive.

Link: https://lore.kernel.org/59c6555c27aa7ba18ee227f9f02c78d15a37605f.1789219453.git.zhilinz@nebusec.ai
Fixes: e76e1fdfa8f8 ("lib: add support for LZ4-compressed kernel")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_unlz4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index e6327391b6b66..80bd4ea40f95b 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -139,6 +139,10 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		if (!fill) {
 			inp += 4;
 			size -= 4;
+			if (chunksize > size) {
+				error("data corrupted");
+				goto exit_2;
+			}
 		} else {
 			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
-- 
2.53.0



