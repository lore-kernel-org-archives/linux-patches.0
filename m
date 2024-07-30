Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F73B18C938;
	Tue, 30 Jul 2024 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356101; cv=none; b=tKi+7fR9MdortfpHed091aT/s37jGuaEoUYZSXpCr3AxK76i+si+HXnhbsjjzSAqZOWnsh3EQJ018ivetfBcxgFh+bzuNwLnABuP5gnGumLY+vUkqsVA8rzeLb6+cVIEylV2aVMy5y59kotbDzTBTVnvGBWSZd4M8CktUIGIiCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356101; c=relaxed/simple;
	bh=VW32CNkkh6ajWDwoiFIfyqiwB4YIol/62vqWIGLR9dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdhBOgA5wJXcq6/PFHUQNi/aXfbOzUZaymda4p3A16TlWVs0LA2+G9gVjo5cz04gydlix5GUjSNAzbmjDpfaIdMRPPwnAwAbuYzwVl+hT/PDFiPS3/dEkWj58txQsqmskG3WnU5EIS/eiEtPNOTwq8FFT9hAW1anHST/nbnbUmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1awzDeOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1awzDeOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C135C32782;
	Tue, 30 Jul 2024 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356101;
	bh=VW32CNkkh6ajWDwoiFIfyqiwB4YIol/62vqWIGLR9dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1awzDeOXHfj687uK9AD1mEDFCrBQEVD1Wou6zYiCNwik40jxENsWQWAXK21rwBSxY
	 hcedDyq2XMNaln3sfvJaFQrcbLjpElC7Y8qJSLbh4IPqIPAQ9Q+ooQMJpOvnOn9qkk
	 0SCnJJ1QByxwT1W9kBcbP+w94QmIpYI+hEqAG420=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/568] selftests/bpf: Fix prog numbers in test_sockmap
Date: Tue, 30 Jul 2024 17:43:41 +0200
Message-ID: <20240730151644.330357071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 6c8d7598dfed759bf1d9d0322b4c2b42eb7252d8 ]

bpf_prog5 and bpf_prog7 are removed from progs/test_sockmap_kern.h in
commit d79a32129b21 ("bpf: Selftests, remove prints from sockmap tests"),
now there are only 9 progs in it, not 11:

	SEC("sk_skb1")
	int bpf_prog1(struct __sk_buff *skb)
	SEC("sk_skb2")
	int bpf_prog2(struct __sk_buff *skb)
	SEC("sk_skb3")
	int bpf_prog3(struct __sk_buff *skb)
	SEC("sockops")
	int bpf_sockmap(struct bpf_sock_ops *skops)
	SEC("sk_msg1")
	int bpf_prog4(struct sk_msg_md *msg)
	SEC("sk_msg2")
	int bpf_prog6(struct sk_msg_md *msg)
	SEC("sk_msg3")
	int bpf_prog8(struct sk_msg_md *msg)
	SEC("sk_msg4")
	int bpf_prog9(struct sk_msg_md *msg)
	SEC("sk_msg5")
	int bpf_prog10(struct sk_msg_md *msg)

This patch updates the array sizes of prog_fd[], prog_attach_type[] and
prog_type[] from 11 to 9 accordingly.

Fixes: d79a32129b21 ("bpf: Selftests, remove prints from sockmap tests")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/9c10d9f974f07fcb354a43a8eca67acb2fafc587.1715926605.git.tanggeliang@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 43612de44fbf5..e32e49a3eec2c 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -63,7 +63,7 @@ int passed;
 int failed;
 int map_fd[9];
 struct bpf_map *maps[9];
-int prog_fd[11];
+int prog_fd[9];
 
 int txmsg_pass;
 int txmsg_redir;
@@ -1793,8 +1793,6 @@ int prog_attach_type[] = {
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
-	BPF_SK_MSG_VERDICT,
-	BPF_SK_MSG_VERDICT,
 };
 
 int prog_type[] = {
@@ -1807,8 +1805,6 @@ int prog_type[] = {
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
-	BPF_PROG_TYPE_SK_MSG,
-	BPF_PROG_TYPE_SK_MSG,
 };
 
 static int populate_progs(char *bpf_file)
-- 
2.43.0



