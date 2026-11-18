Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027224;
	b=WJ0Peer0AkE3vpW3jgMJ+1pH8jEJLO+sp8nrq32OQb36a9EFF9O93wFucB5Bbe2uGP03
	 vG78DrxhoigkN6n1Pkfu6oXf9biLA/TViBMjgayJ2kwyQAK4ulr3il6oXSo4lykB+jB6T
	 //qJVfjjhpYrldynOL1ToTxikPXNR+t+pFZNIBSAs61APXTpp+HdllAXM3RpMluDy64Rq
	 +SlzO1GvrQAnYjKNpWlVEdcrInY3j/xNt8Ov7YQnE3ik+tMTtN5085FlEhfRAid6H9VpE
	 TKB0s63OTKwDuRV6lViQcBRRXCndAs7vLRmWjLGtx0XQfbAiCTM6asF9v+yA7QYIc+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E5gwv/naOx2l+n9kwiTBtaRYuxQeX20MfkJ/LU7aRBY=;
	b=avl/4FGUckyYYcbU6oJwgdrvDCFSQpcXJNZk2JwszR8b92/qhsvotTBOA/eTS8Wi12Pw
	 DREVG6N7pZbnDtH6VPhsXLqv46jIptTYAX+yxQKTqXF92dy5+PEsfsrBRFgSroT1RGM1k
	 47sje7ertlXuV8mWisWS5eDgAteNVdpQknAo6zLrnFO+YqdG0RaIpz+wGtB1G3xWPheLQ
	 81WCDqFN5D2g/gVRA4X/3aVIEx2F3IVXCHdpXxf+81DSEwAEbm4i4dw9zggaPbcAu392z
	 77aVfPJaonqwAZyJRuVTKzgTQCJ0fFtifFOFAfobXEBXw5Q+CbJD3qJgT1EKTDLzJFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX9uJbA+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5876360A2603;
	Wed, 18 Nov 2026 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX9uJbA+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7922C1F000CE;
	Wed, 18 Nov 2026 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027224;
	bh=E5gwv/naOx2l+n9kwiTBtaRYuxQeX20MfkJ/LU7aRBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EX9uJbA+kf2xxEmt1Kwf4E38VRFYUxleLh0tvTW82dHrJvPUbC8U5MQFx1zSlTGBz
	 cwLqBQjfLPzKoxdC4DeBt/PhC+HlIadKeA/qW2FuUel7IBX2PnK0VDU9Q1jkyma1Fj
	 7fJ1El6rKyFnC9PH2oNme83yJPB0u52znbcJ6PrI=
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
Subject: [PATCH 6.18 1714/2151] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150224.257844540@linuxfoundation.org>
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
index 5c3c0939e2d20..ab49e7eb9d16b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7302,8 +7302,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
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



