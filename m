Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026830;
	b=LJF62VBX2rtzgLFHHk0AKVQy3K2BiOemZHwMBTwM9jBSW6fPwDkaRvMmkpw0G2adwQt/
	 BB5pzUsKaKkFYbqb7Dh2gFjhuGbD+8Ysj3+U56RSRbyAj9m12gfgnrkHEm7wahHODZjiw
	 Uzt7pjh5ortaHu4fgmLZ3CKkiZE/86LZHHG1mVxGIszdDcwKXOom9ClFJeKeoZQ4Ngp8p
	 5ePUHVo7rBxlGKTQ5j3MOa35VRgo5xsVZytr5m4TZeum+94sD6Wqy+b4RxDYiYsPX3SqH
	 TBqXoWidGUexKU94UmlSGgnQk3wkP2XE98hZSOn3dXo0a9y5rq2x88v2fcdHane+ouw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d63Tq0K1C3d+iMWLPToLbvtwLPxcnK5dmklKCpnNUfI=;
	b=H9L4CPjuLPWRosQP95oWeXm/ekzekPWENImYbtMRyN9df+H1uy4RiUJRVwHOQFMqt8rs
	 BAUTPrnzTJltyXsvc9/pbxFJWyQhk6ElDH1TV55LgAA/dHPPMKb1KjetDfSvMBwcHnJOc
	 wxZpjRLjJNDBvsWeMybc122EauWUkSr/EAHg779UVDuVdohurLEETriOQurYa+6Tf8wyH
	 wPSpYfB/SYBilk4W1O+Fz44/TGM39rDd3LDQG2SCboJC870eSt2lzerTT05tW6NjXjKLz
	 PX5PBXFXJB0shBf7GEhyYivNf8wmsqfKnaYElLO9N0S/GANJ8URdnHXHAZ3miPr5txw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YShGeKxm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F51606A325;
	Wed, 18 Nov 2026 18:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YShGeKxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782FB1F000CA;
	Wed, 18 Nov 2026 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026830;
	bh=d63Tq0K1C3d+iMWLPToLbvtwLPxcnK5dmklKCpnNUfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YShGeKxmjfucuiZFEedpeh03/4Ji0uUO7P0o5N6BM6bx7nZkMfxB+UpaEkV1LvfuW
	 7ZHrzOMx4awHPn2CP+nEsCsqbbToxzlAybGPRYHd7CMfqa8AfO9y9NDQg4CxfdDdBN
	 9ESvT2rG8HnABCAoJ8/4Oak/ixnwHZvW6LvRv+hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1574/2151] selftests/bpf: Use its own netns in flow_dissector_skb_less_direct_attach
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150219.219867784@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08bae13248c4a..ec688b68a50fe 100644
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



