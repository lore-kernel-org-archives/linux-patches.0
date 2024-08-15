Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74A14AD0A;
	Thu, 15 Aug 2024 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731978; cv=none; b=oV3dsmFSsd4QKk+XAw8tlP/tYJYrj+7T7RmGPKBHRptUtSycC6go4MNBmfcv2hiEcxTcDsKDBOMitLGYmV2poIF8fDRaLa9mGQPG9X+BWhrt/zERtkqQn63Z2WDXW24LbJKdDUWhQkBI2n6yUDP0c/OLYdfTXyTLVuIPIjoBWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731978; c=relaxed/simple;
	bh=6sS59qUB2qkAMjGgaPn+XCxt7lnK9l1l+ZaUIHTbASg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb267Za2VuaQn7f+J8i6zD2sDbgc/Yx9DS9SyU5wGTC6ErtEwKTcLGfdN/imd9Ygld68nqbRGfBmnEhR5FcC9VNicL3OauQ3fHObNKao8cTMPGLtsnXUWIOWWfxWQtJ1EvJ+q6w8ruNUwrjZCgVFB6Ns2pbKsdNJDzKYvIwjngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sawoqe2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sawoqe2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1A7C32786;
	Thu, 15 Aug 2024 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731978;
	bh=6sS59qUB2qkAMjGgaPn+XCxt7lnK9l1l+ZaUIHTbASg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sawoqe2lWSMvHYDesvUKGBdUIM9XR5ltq+Dny7dkD2JPK4pzDxydDptn1QdbfBcPC
	 3gQU+QakyUAFhGiKOSb7nDZKuOJJFBWuUU4vufy4y2dF1BCLeePuZOeAtnpQfK5WQK
	 8ErIKwmmyVMJ96LLLmC3x2Y3wXykCOuiGJJ45cCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/352] selftests/bpf: Fix prog numbers in test_sockmap
Date: Thu, 15 Aug 2024 15:21:42 +0200
Message-ID: <20240815131920.624234118@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 85d57633c8b65..daf848258410e 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -65,7 +65,7 @@ int passed;
 int failed;
 int map_fd[9];
 struct bpf_map *maps[9];
-int prog_fd[11];
+int prog_fd[9];
 
 int txmsg_pass;
 int txmsg_redir;
@@ -1708,8 +1708,6 @@ int prog_attach_type[] = {
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
-	BPF_SK_MSG_VERDICT,
-	BPF_SK_MSG_VERDICT,
 };
 
 int prog_type[] = {
@@ -1722,8 +1720,6 @@ int prog_type[] = {
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
-	BPF_PROG_TYPE_SK_MSG,
-	BPF_PROG_TYPE_SK_MSG,
 };
 
 static int populate_progs(char *bpf_file)
-- 
2.43.0



