Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3DE4F218;
	Thu, 12 Dec 2024 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023987; cv=none; b=DYx8ryhsptigVnJwF8YsTaseEJIOynLXyDDIruvRkkRWDZewURMQ/5SBuhhflWAkb9Ux47zijnr0QhiNOxqNqcGBjdpmFXYHBLjhQpFvc/SJYf63Rl7vOvwNsy5a+xigOn5kXBC0UI+74Ek0c3rKC5vqiGCM9WQXsTjSuO1vizc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023987; c=relaxed/simple;
	bh=97YbupvImvM3N1vgzToJbRzxWsqD+2j+g/Qxtq/kn30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am4F1lBnQi9kVZbVsbyJ4BMsW7b/UTXEOjz68mWf3NWU09BMPOE+QNJOAh740HqgMEQ0hTaT10eSciXQKoM7w5ulbnSOd8SndEEYgDrGyEr7n6dSDcNa2kf5nkfLZzgiIO2iFm1S/wgXrSI7k35hoW9Lspffd3K6vE44RdL4Scc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OFU0F8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OFU0F8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C67C4CECE;
	Thu, 12 Dec 2024 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023987;
	bh=97YbupvImvM3N1vgzToJbRzxWsqD+2j+g/Qxtq/kn30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OFU0F8PmxwWYis4aLgpJ5yC/RSIneD5Wft5mY0CWkAS+4QtonMQhPa6nYeML2jB5
	 xKxKOnIF8xmFpBknmZyGIVz2zORVVyIho5e4PL7eg3deIOurSIc6quEtqIDeHz5g+3
	 v0ONPSlAfIEXaQdMERSKNroMhRnYAiPeyePYPYoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/459] selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap
Date: Thu, 12 Dec 2024 15:57:39 +0100
Message-ID: <20241212144258.290330377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index 48c8f24cf9964..157a3c7b735e2 100644
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



