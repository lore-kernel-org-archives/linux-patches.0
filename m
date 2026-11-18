Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042008;
	b=eYg3e5HkD2nPzu5m+M/nYk73CgatoZMgnSeLQJwj3ytHiVPPOqxUDKtZCDASvFtfgt7v
	 hTmdGOdqgXoqMY39NSQSM0F9bNQUj2JXOmdyJ8/K1lrjypOK46FWQABjxeB3tLZHcnFNO
	 PhiSPVTcllOhFMcVS/jjjIjbVVnNpHZ6WYHDxYKKY38qAgRrFK6Z5h5bQRtm3fMJrtRU/
	 lW2Xz8K+BDN77CVMdUXvRZec+PkJXeJhiPjjfK5yCLS1L0TrivmDlZdHoilYkLYvpMIdT
	 O7kq58u6zWmLXWCdL0nifos0iZVkF5ALCl7+InPQQXrmiOzdzrQyIuV9IfzIyUOXDvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8QxxyM0DXH+qE5uSuSSso3od8PbrAwnEzx6OzAl8Fck=;
	b=DTspsC9S7TBSQwniGptaHPK2bNj0ByCSLdv1amvai9Ud+Gaw61VqLvoezZS9lO/ZzNgn
	 Qu3Z6q2E0IqWsdzGpGjCQUGdQwDiG/QZ744YgaH+8tt0Uhb1idBE169ECaTLcn4TY9lmi
	 mhdByzNiLPiIBt9ir/GfvyJzJZuG+QwA41W0onmsYT8KxuQFCaRTNJeiYK5Kx8QIT6OHn
	 nyjLvdyYc71n5YkIw3Wd4HD9XBHya6k5AE1FLKx5gNANBD3BmGXDw5GuQrnfoob4JiHsQ
	 u3GwiEAJPwloGCd39o+yOPNOSQF3eEvlpTnU4c/F/YM43Vng384vab2ExUWhjFTa5JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEo+jUXI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48014606A32A;
	Wed, 18 Nov 2026 22:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEo+jUXI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CF91F000C4;
	Wed, 18 Nov 2026 22:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042008;
	bh=8QxxyM0DXH+qE5uSuSSso3od8PbrAwnEzx6OzAl8Fck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEo+jUXIXqiSAc0PpPPKsiEtaTmkFmhyiYtNfeskSUpDUzfwBLMKIigi6HEWFBepI
	 f37AaPn0ephMqiqZqIbClrshoKtm8vVIA7d9G1OOFxVk/jcZvmzaeZbyZaLCrOZRjk
	 n3b0V7rD1CftBSq45u7Iir/j+LxshG+Fe9GchKp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3016/3318] bpf: Reorder bpf_prog_test_run_skb initialization
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150450.701036168@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 57bb2f6717930a5e670da179c316159719b724a2 ]

This patch reorders the initialization of bpf_prog_test_run_skb to
simplify the subsequent patch. Program types are checked first, followed
by the ctx init, and finally the data init. With the subsequent patch,
program types and the ctx init provide information that is used in the
data init. Thus, we need the data init to happen last.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/063475176f15828a882c07846017394baf72f682.1760037899.git.paul.chaignon@gmail.com
Stable-dep-of: 6aff0129f327 ("bpf: Use the socket of a sk_lookup test run under RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2522b0f79d15f..f677038cbb20f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -973,19 +973,6 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     size, NET_SKB_PAD + NET_IP_ALIGN,
-			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
-	if (IS_ERR(data))
-		return PTR_ERR(data);
-
-	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
-	if (IS_ERR(ctx)) {
-		ret = PTR_ERR(ctx);
-		ctx = NULL;
-		goto out;
-	}
-
 	switch (prog->type) {
 	case BPF_PROG_TYPE_SCHED_CLS:
 	case BPF_PROG_TYPE_SCHED_ACT:
@@ -1001,6 +988,19 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		break;
 	}
 
+	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
+			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
+		data = NULL;
+		goto out;
+	}
+
 	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
 	if (!sk) {
 		ret = -ENOMEM;
-- 
2.53.0



