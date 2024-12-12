Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3822165EA;
	Thu, 12 Dec 2024 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022194; cv=none; b=hDU2ymuvDglBN3ONz944zijlPIpuV0oXg6qDodcSVKGLh/F5YGeJKu1xhnRB2oO3ZqzkiuO5cl4sjF40gV3KTiiEAkQX4URr6g4boKRA6aj37Yco7WQLSzcD9g1LSzVxVwxvTA3OtD2crT8ny68eRfFpAPlEh1Gm8jhWyM8f404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022194; c=relaxed/simple;
	bh=SSm+2oAxNi0gzIG/X0rk7560Pl5IKoCMbnIDJM0B2lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTl9k61ONwYgidZlmDgaAb6jPNm+allLEtbhGdFbrqdMPXYnKLMNGkzNodns8RoK7uUg0VHjlo4ojcmHjYIgHJ8CW6JqmLHf0iJrcOI+sK53R+ZnAZpityrXyTtNqxW2Fw+xZ78UIuq/IMG+sw59z3pOuKAxcg1LHMFtl+awPNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0wNW21G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0wNW21G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6366FC4CED4;
	Thu, 12 Dec 2024 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022193;
	bh=SSm+2oAxNi0gzIG/X0rk7560Pl5IKoCMbnIDJM0B2lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0wNW21GEBMqKSK2cpdFp5jxnv2Eg85oenxOQ3A1zwnTZt38nU/80bqhwuoOVHJrJ
	 HkaTktmVw/eGm0RLJJ/U2R4U0Evj2niJieNcchH4oGdXYAtGCOc5eOPpsdL1DvBIIO
	 u+ajwDm0MCkp1BWUu/15FXcgX6vlMDzT9SWsTNK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/565] selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap
Date: Thu, 12 Dec 2024 15:56:08 +0100
Message-ID: <20241212144318.312723288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8404f09cb1e35..b17250c41d691 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1557,7 +1557,7 @@ static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 	test_send_large(opt, cgrp);
 
 	/* Test pull + redirect */
-	txmsg_redir = 0;
+	txmsg_redir = 1;
 	txmsg_start = 1;
 	txmsg_end = 2;
 	test_send(opt, cgrp);
-- 
2.43.0



