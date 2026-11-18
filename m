Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020489;
	b=EmOp/lm3Luq/eoG3q686jF/PUX9dYiEaIzxWiaurYE5x15DXP3xFRmM54XnV5F+DKNzi
	 lJclqfBShOhmHtnTOUPXVayyjl33QiilJkY0sAQC5ETqDcfIfXM9SPiSmvppwl1CbuOVN
	 nhRvRL6crGOKgfT1oe4vzViJ8sMIj+SNEwCNBrPSPslGaDsID4zrQx2F+YuyDGiAPPvrb
	 QbFwHteZnxqr0lXisGIZ+4N+aVtJq5VSlSqEkvSUgmdMOAXTZHuEao3a3gy+07snOdBZn
	 gpeEfOgFoF/9vFaVqUsiRnCiFyKKIAmSXD2LQCE1Cbo/8sajm3vgvXcs/p69Xhtk5Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Pq3dnIL2BM4yqxIu32IiR6S+Z4hPHdXaTALO637SOI0=;
	b=UNEPeQmNs7BI1CIdE1SMdtpNxHKlKnc2QCMrrQaRz98pc/nz9xPBszrE/N5l+iHEB/XP
	 unjdAQ/gl9oH73aOI37iufDbtX4nE8WvqRvs+6MyYwtNDiufsP9uyGBNHb3Ep6imG0OLP
	 yPV3D6ZVX2xpvyvmGhEX1vPRa8blG2axCZGFm1lraL7taqr7JhlCROI6PsoXo/UFmwqfp
	 XQmGTUV1IEivTVIfYaybUxg6UquGQHit3vjKXKtccsgnuQgLZzMLelnhfbcG1wuvzbPI+
	 BtmubxJf4Ppz0x8Hq8+BV9eZeMYKR5FOePzeCgsn7A+gnYnVUqnaTC9ey5wNXhHfVcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubzSUfF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94827606A31C;
	Wed, 18 Nov 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubzSUfF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74351F000C5;
	Wed, 18 Nov 2026 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020489;
	bh=Pq3dnIL2BM4yqxIu32IiR6S+Z4hPHdXaTALO637SOI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubzSUfF08DhMaBqRW6HfXZKJ0HRor1IRGpR8O6a8imGQpg4oE2f8iiHzEtFcIE3oh
	 X+9FbIclTZH+kWbBHovjEwqjYDETuM297pD/9BhpIhZJuIKjVlpe21KM+KSzCp2j6f
	 R4StVdeGBOH84wa2OYcSExg9rdRe4MoY+9R1MVBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1929/2651] selftests/bpf: Use its own netns in flow_dissector_skb_less_direct_attach
Date: Wed, 18 Nov 2026 15:52:49 +0100
Message-ID: <20261118150356.140378654@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 76c1913f311f32971dc2c3e106e285bd63c1804d ]

test_flow_dissector_skb_less_direct_attach() and
test_flow_dissector_skb_less_indirect_attach() each create a netns to
run in, and test_progs may run the two at the same time.

Both name their netns flow_dissector_skb_less_indirect_attach_ns. When
the two tests overlap, one of them fails to create or open the netns,
or loses it to the cleanup of the other one.

Name the netns of the direct attach test after that test.

Fixes: 2b044dd186f0 ("selftests/bpf: re-split main function into dedicated tests")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://lore.kernel.org/bpf/20261008-selftests-bpf-flow-dissector-netns-v1-1-5d9889aaad84@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index fb48926814647..f6fefb14cda3c 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -706,7 +706,7 @@ void test_flow_dissector_skb_less_direct_attach(void)
 	struct bpf_flow *skel;
 	struct netns_obj *ns;
 
-	ns = netns_new("flow_dissector_skb_less_indirect_attach_ns", true);
+	ns = netns_new("flow_dissector_skb_less_direct_attach_ns", true);
 	if (!ASSERT_OK_PTR(ns, "create and open netns"))
 		return;
 
-- 
2.53.0



