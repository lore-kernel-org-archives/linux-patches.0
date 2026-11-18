Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027417;
	b=r0PSjc16Ypu55xtGjXwGFwZoJrbjFbgyyN6FJUIk4/n29ihF/gDx9Xto1YGuQSV896Cm
	 fNWWGpKL9lBTc1ttSIihrOos05YdaMpM5/XthSgorZ4AKzvv+iITekw/+wTb8jrqSqYZu
	 E/78oVaDMuy5faLAZ1a2la3oy/J77kFxeSG7bJn5pjP18PvI/anD75xFeHDTYbFQGsrcO
	 u35MGxMY0oqySDsuAu4oe8RlI0jhdwThBlXbhYkj2tlreU+XrxOjom6GG7PgZT761X0lE
	 fg9P4+qrpzeJmcQmY0YOFc2cSRyEqn4Jz4CybCUofs7n9+O1sn1xg5NpG+8BdOZahnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5rHCzPUwYFZbMjQB5S9LxV7wRwfGc/3jjJ2k48SyBw=;
	b=zrDgtvhfq+44FtBsVagd+j2K2dv9LypcvoXC1GoqZP9jFJoRqdLpZle+8yg41vSLw/7i
	 PEACawmVo+rglzgTkkb1i6syZc6fk5k68PPHpMPOhenTzX3kpU2u9ku+8/N63wxKpqgog
	 vv1nN1k3tnaps7z9MklNwi7LIKdqfUEK2EPlCcUgfOvJqOUWH+hWAnWUpxBW2y/5kYivw
	 e2LEt0cdXzQDrJTucd6nneAKPTSS/EbU+nMWZ7R4HwB/GaMdt6EPMVQi0VukJSB+/EbQN
	 k31XCNS1MUQIQiev7VD6rR3Wie4HJQYRC01+SQd38lqA4UUJ+O5MQkIQamXhTOjjjPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lX/22XDA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B27606A325;
	Wed, 18 Nov 2026 18:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX/22XDA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A68B1F000C4;
	Wed, 18 Nov 2026 18:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027417;
	bh=u5rHCzPUwYFZbMjQB5S9LxV7wRwfGc/3jjJ2k48SyBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX/22XDALd/bHm94rJ8Y+Li/vpOrbB1lDSQ9CAmnjxThPq/4XPa9TbRZUQQwxACmk
	 n84pVVoc1NBNyvKGI0yOLhRzikfOCbphP0cZMD3wr5kpD3OIa6EE2JdC4KFhfnkHGX
	 e5gkWpbwkhQMcjPJtBNlDmvSFdfcJdj3yvcqgxbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1740/2151] bpf: Reorder bpf_prog_test_run_skb initialization
Date: Wed, 18 Nov 2026 15:57:55 +0100
Message-ID: <20261118150225.245953754@linuxfoundation.org>
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
index ad95b37743959..41fbf4b0a36ab 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -998,19 +998,6 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -1026,6 +1013,19 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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



