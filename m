Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E1F7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB7DC43470;
	Wed,  2 Nov 2022 02:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357818;
	bh=ZgoYFHppnwlavsrLCCZOr11z0yH40CKt/CouioHNACc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opeUToBeX8VFfEJ1BdxFx2zCPysRf1leE8ohjBTjHHOLDkAh3X0M4+Lp3TmqftYFD
	 FYiXepg9goAlgaUdcJy3zeEa54QlEhC6NczuNXllyD3K73BN8h1SRPZSDPo7FhajV1
	 Mj0F+iLLBE8gxnXz8v5hx0uUUcJgjyguuQ/bu0fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 234/240] kcm: do not sense pfmemalloc status in kcm_sendpage()
Date: Wed,  2 Nov 2022 03:33:29 +0100
Message-Id: <20221102022116.696335569@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
index 90e0aeae9ff2..befc62606cdf 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -839,7 +839,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 	}
 
 	get_page(page);
-	skb_fill_page_desc(skb, i, page, offset, size);
+	skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 coalesced:
-- 
2.35.1



