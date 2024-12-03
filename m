Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EBB1F669E;
	Tue,  3 Dec 2024 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238531; cv=none; b=U3b9Q6DfTJ43BfnS/FkYfHchmM1EOepBQ1t5V0T+cHKqynbhZNsMsxTpWDhXyGJoW8sxsscm5vYKZ1RIukrZJeCSYF0BUvvIyXI+Wkyu/Xw+Jw71uJ7ELcZryP0Q0TUquTapvx/XLl6Gvnn38eQJIfj1mQnMjSaVNRIiwP8f2so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238531; c=relaxed/simple;
	bh=Ho6LJw+KVSO7LDP4gf9YU5JS3a7EDJNAEh04h757iV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqISFjG2KfrTZczWxpMIDMVKIVGSWqg1ML2qdgIIBR7KvCLHr1F1ilmWIdK0GK8nZfFF7XdpaRZ2VOu0CntfpobDxRa6jcGw+7g5ezeGOXlA6f7L8IKmYBZCdCQ/7AnzAa5DLGHduWLYJlbtlFrwcWj0Ojpxea6ErSIN3Vhue+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnD/vnOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnD/vnOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FAEC4CECF;
	Tue,  3 Dec 2024 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238531;
	bh=Ho6LJw+KVSO7LDP4gf9YU5JS3a7EDJNAEh04h757iV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnD/vnOEcs/MK7uA6OBAWdVxDHjsyWcSkoR9iPPrg5RlQOCQZAIjB+We1023v49Jd
	 O/HtuZ/5iCu+AinD7JM9b3JPRvXZNHTJ0C+t8ErlZ+/Y4Wh6f6K3dm7P4aPn7KXNKE
	 vOLdt5EZiVOpr1pTDI0T7OyXoA6FcZDV2aOt2GDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 278/817] selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap
Date: Tue,  3 Dec 2024 15:37:30 +0100
Message-ID: <20241203144006.658152272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



