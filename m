Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041933;
	b=1pA1UXyoZNPX78XArIR+GP9B/NZcOPchmAtCyfMKMh77WCjdJwfaIl5DZB+dLE06snpn
	 3d6HtVG6MLA+BoRa8FxySwJfYq9iBu2onfinWnStrdAEtS7+woxstJf6/de+/AjHUCTCn
	 rgWFxrLKgseLCdSJy3EOIFeTIojBs2l7iJinjBGqlxdoX+6yBSGyi70HuCKCiw7rcWXTZ
	 rX1tEh5pMvqqJl0zOHwq/B4vZhgpkhpfG8m6BtBiRJN8+UGvfTGS9Abv5Hm78O1NlV0Jz
	 +aCxlnn5zsLXGvXcVZxlP9RkntAKIHy+pjrMkW+bwv2EGkLyNi+uSF8XfU4ol4lIxcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3vmf5w2qDP+4D9LfUIAFAFWo8Wv4UyiKcU7XJk1NUvU=;
	b=5trUP05aaieVtRZSKaKRaSU6e5DtjYYPt4g0hujv60vUqoophrJHDb9/soLq7/+X0b3N
	 GKeiwG45oxpZwzoWlJgz9ufNO1FYuF9ou/Zt3rmXW23haQJu7aJWj8nsLWaADtmHFUTEf
	 5BQngJ5CZhKtWXm8fDBKdm/NyU9qZspNhaeYK3ch8nKpK4Dv3pBkMRxENweF9iI4Lzz7v
	 4b0Ol36xCEJtQMB0cpowuYtxFXNsidMxWEUmMy9/BG+5syZENW4BMi3r94+xEX0usUTqL
	 oTYFHiU7vXHraGQcfPabwi0hoFPqL3ghugNVlcAYRc9uOCx9fv77KpLKeGYXL/F4/JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHTi0SqM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1333606A325;
	Wed, 18 Nov 2026 22:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHTi0SqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545D31F000C4;
	Wed, 18 Nov 2026 22:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041932;
	bh=3vmf5w2qDP+4D9LfUIAFAFWo8Wv4UyiKcU7XJk1NUvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHTi0SqMk7M0VIXgR9Rw4DQ3cxcmjzzIiwOgAIbqFyKFNUrQAGKXeQ8hqTWp4HswN
	 gKVbduWBr4+wkdHeJ3OTHKLCA1jjUvFjEf2yPt7Y3g0S2uH93/ofN0f6qSoH+uKR54
	 F3q4O5GTlzfVcyvC5genZdojGPHKQ+TdLPM59LiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2991/3318] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 16:00:13 +0100
Message-ID: <20261118150450.000638089@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit af873495cbcb066ab029f7f63b94410d4db47628 ]

A BPF program can read the middle of a u64 field in struct bpf_tcp_sock:

	tp = bpf_tcp_sock(listener);
	/* +0x54 is in the middle of the u64 bytes_received */
	unsigned hi = *(unsigned *)((char *)tp + 0x54);

bpf_tcp_sock_is_valid_access() allows this 4-byte read (the default case
only checks size == 4), but bpf_tcp_sock_convert_ctx_access() only knows
the field starts and has no idea how to handle such an offset. It emits
no instruction, cnt stays 0 and the fixup pass trips verifier_bug():

	verifier bug: error during ctx access conversion (0)

Just disallow the narrower access by matching the whole u64 range of the
two fields, so it is turned down at check time:

	invalid tcp_sock access off=84 size=4

Fixes: 655a51e536c0 ("bpf: Add struct bpf_tcp_sock and BPF_FUNC_tcp_sock")
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017143819.209510-1-jiayuan.chen@linux.dev
Closes: https://lore.kernel.org/bpf/7a8ff335.1024c.1a14395f3e5.Coremail.kaiyanm@hust.edu.cn/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 89984a086b41d..fc2b34a453ea9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7172,8 +7172,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_tcp_sock, bytes_received):
-	case offsetof(struct bpf_tcp_sock, bytes_acked):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_received):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_acked):
 		return size == sizeof(__u64);
 	default:
 		return size == sizeof(__u32);
-- 
2.53.0



