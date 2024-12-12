Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A186F2FE;
	Thu, 12 Dec 2024 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019244; cv=none; b=W2vq7b83B3hf+KovxX56JQEsCdpI9Lu2eO4/dw1H6arsU5Js3PXg6Bdy2VquRADJRCGiWmE7KB0qJuFJ1r0zFDZe0tB28GJT4wAuXnouodKqtDlTOxqRy/xZVXnMYvILdOMYgZmZ8jXDnFv37HLbVbmn+ci9/z3o2zfxKVn9DZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019244; c=relaxed/simple;
	bh=dEgNwH7NbbAIjC5lHq7Gi83Pf43uhRJOH7eUkeMqQz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDMscAElw6z/AXTbVN1qUOXO2dGdM0Kc0SMW+yqmt9zUWFCPWW7tq01vU/tMsKDTRhcmIOwTc9x76Q+Bbpy/rDA0875X6Wus6EmOCojiwgAAyfs61Yyy7vTgEweA6rz0lpOFPv0tRX9aMhI8DsFfDstqHRG3Kh4zKxCJ3aXJsYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdRSJu5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdRSJu5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467C3C4CED3;
	Thu, 12 Dec 2024 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019243;
	bh=dEgNwH7NbbAIjC5lHq7Gi83Pf43uhRJOH7eUkeMqQz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdRSJu5KqVcyPYSBh65OEzztUHewTJweyFQbfUm1wzQP8tkv32HHL33L9pBWIcdiO
	 GrbWw+p8IimNwdIINyiI5DipmdTudZq6nWV1Q9hMSlZknD1KIqxNGy1UHZBcONbOHs
	 wmqMdf/paNHrjU7JBaWi7R2EkgSqzTy6dOBif/xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/772] selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap
Date: Thu, 12 Dec 2024 15:51:40 +0100
Message-ID: <20241212144356.336840772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 72023e1b894db..1954c2aeb7a9c 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1609,7 +1609,7 @@ static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 	test_send_large(opt, cgrp);
 
 	/* Test pull + redirect */
-	txmsg_redir = 0;
+	txmsg_redir = 1;
 	txmsg_start = 1;
 	txmsg_end = 2;
 	test_send(opt, cgrp);
-- 
2.43.0



