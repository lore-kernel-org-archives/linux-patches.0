Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D87E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D87C433C1;
	Wed,  2 Nov 2022 03:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358590;
	bh=HzTcrTZuM4ipViQLLbBRUzgq3nTz5Z4KEmac670ZfQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZHTd+Cr5qjcNmlj95bQYrkZC1hF+ntvrGnLk95B8vZZp+pZEjERD0xll9sNjObEu
	 ViZ1XJ28KlguuUNk+EPLVLDoS7eT4wluQ2Anr4rdrB/B/lx6InNaW/89wHP5mqL0Qn
	 WenzJsfYfa31NqMTew39bKqeTvtJfMlGbxiUQsOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/132] kcm: do not sense pfmemalloc status in kcm_sendpage()
Date: Wed,  2 Nov 2022 03:33:50 +0100
Message-Id: <20221102022102.930968110@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee15e1f38dc201fa7d63c13aa258b728dce27f4d ]

Similar to changes done in TCP in blamed commit.
We should not sense pfmemalloc status in sendpage() methods.

Fixes: 326140063946 ("tcp: TX zerocopy should not sense pfmemalloc status")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221027040637.1107703-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index ff6dd2619f22..a1478ad393f9 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -838,7 +838,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 	}
 
 	get_page(page);
-	skb_fill_page_desc(skb, i, page, offset, size);
+	skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 coalesced:
-- 
2.35.1



