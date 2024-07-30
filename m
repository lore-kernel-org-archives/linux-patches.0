Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883BA187FEC;
	Tue, 30 Jul 2024 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355333; cv=none; b=QsDiRy8cyebm2M4xYrnCUdyZZyBjQDehAmPUBr3ea2rU3i9Yp8H88m1tKNp1uWhAYbXOC0zwaNkA9yXKJDuW+8MgmBkj+A51UqrxJGWThyvrxAQnoLNA1dkdeP8sbs5GhKX2dU1atyTxcSdaF3eX2mfgkF1t2/a2alSAbzhdL3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355333; c=relaxed/simple;
	bh=MdZViQBFv2l9bmAH26x7kRk901pl8mRRWPFHBOOoUGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK3sF8lqxjapK/IuXiPSG9vnWqWGXT2DcOIOIyBjLHT8qlWO2Fi8DtJ6fhr/ScQjQp843N46s2BR1v+4nJz+r5fFEVRp0Xckl/w50JopwNGWZRSOKo5L0EK6JUWtwkoqpGYDHeoKY0jxnjWyuJnXs2upVz6hPszmDSX/P9WKz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBitkGXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBitkGXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB7CC32782;
	Tue, 30 Jul 2024 16:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355333;
	bh=MdZViQBFv2l9bmAH26x7kRk901pl8mRRWPFHBOOoUGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBitkGXMAH6Z+GIOfhNVwDiZfhfUyxstjCjYK9IH6KOcYUTTA4olcJHoNxjEvbrlS
	 5GErDFCmOiKaMFI6apjzXdjBjgOko4pgHN5293AgLyclpzivngK4b0COTidUZGNOOS
	 I1JuQfHYUpS/zfhIGYsVX0GrwdQQR7DVz7x4DReo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/440] selftests/bpf: Fix prog numbers in test_sockmap
Date: Tue, 30 Jul 2024 17:45:17 +0200
Message-ID: <20240730151619.041182233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d56f521b8aaa2..2417300abf36c 100644
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
@@ -1775,8 +1775,6 @@ int prog_attach_type[] = {
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
-	BPF_SK_MSG_VERDICT,
-	BPF_SK_MSG_VERDICT,
 };
 
 int prog_type[] = {
@@ -1789,8 +1787,6 @@ int prog_type[] = {
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
-	BPF_PROG_TYPE_SK_MSG,
-	BPF_PROG_TYPE_SK_MSG,
 };
 
 static int populate_progs(char *bpf_file)
-- 
2.43.0



