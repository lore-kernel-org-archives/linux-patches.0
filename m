Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6D91DF981;
	Tue,  3 Dec 2024 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240838; cv=none; b=QQepW3RILVIwyVgRIv3PON+ASR/3R6IQFNyEtaTbhrNBgaKvrxGuztynMngOFvcBxBc46JJE1OYOfM0j3aLqTEgO9vEa7UFElHETuzYrdLVMoQG5UpQzRRGGGHXQ9rRSb9prNuMmBW0A4O0tkIIUC4IMGU/ck0DVXDlaefFD3Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240838; c=relaxed/simple;
	bh=mK1K5mMtjPoOXS9Cb1YW56pd7UsIxzBdNMFUVPfZ0pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AR9dpW0gN3Q8u+tSlr4ex8V53q2lXXcWQWIbhjEBI0fHdDqC64mA3BkGjjZ+Y3z8PC9W3JkIkB2EokqWQLnZpV5/f1ahzhUX2jsvAYSrceF7yQCw7rjpgfUntEKBdzFQPuNzUkPkf20lKXyMC+s0Tdm3/GHqG8s2/BrxG8KyVCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgMU4SdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgMU4SdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69462C4CECF;
	Tue,  3 Dec 2024 15:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240837;
	bh=mK1K5mMtjPoOXS9Cb1YW56pd7UsIxzBdNMFUVPfZ0pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgMU4SdIe14gJFXRfitee01bZcyIeU05myXUn1jfvAJLb0JGj+P8jltDGIAKWwjNe
	 WaeQW5QNnzYOjyxJI99AflGxxpsP6P9wNSULNUI12gx7zsnTw9r2XiCtbU9krVluOe
	 oBiR6cX+chwxiUD4M/a0N1Z2Cb4Xc7dOxNty5NIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/826] selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap
Date: Tue,  3 Dec 2024 15:39:37 +0100
Message-ID: <20241203144753.518220468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit b29e231d66303c12b7b8ac3ac2a057df06b161e8 ]

txmsg_redir in "Test pull + redirect" case of test_txmsg_pull should be
1 instead of 0.

Fixes: 328aa08a081b ("bpf: Selftests, break down test_sockmap into subtests")
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Link: https://lore.kernel.org/r/20241012203731.1248619-3-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 8249f3c1fbd65..075c93ed143e6 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1606,7 +1606,7 @@ static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 	test_send_large(opt, cgrp);
 
 	/* Test pull + redirect */
-	txmsg_redir = 0;
+	txmsg_redir = 1;
 	txmsg_start = 1;
 	txmsg_end = 2;
 	test_send(opt, cgrp);
-- 
2.43.0



