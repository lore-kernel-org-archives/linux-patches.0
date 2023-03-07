Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D43BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6943AC433EF;
	Tue,  7 Mar 2023 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208935;
	bh=Mjdf752hvvrpcsvLewRZ6J4YOE+VYzE7LGfUN4ZhSgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuKEO+CxiXHn6eVtskTvRVP+GGTogkemcoA1F1iXDXrqh3QUY7y5YS/N4+kt0wANI
	 CBiXwCmdenABZk0wzX8vAlHmhItYzI7ku6CXdB9hZS04zwS+F3j8z3VXlyGR96DveR
	 mBTRWToVoL1GV89jqazbdEEpQkSmMKndFt8pBWTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0027/1001] fs: dlm: fix return value check in dlm_memory_init()
Date: Tue,  7 Mar 2023 17:46:39 +0100
Message-Id: <20230307170023.321852273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8113aa91360a013ebe00763bb0823b5a41b11c4d ]

It should check 'cb_cache', after calling kmem_cache_create("dlm_cb").

Fixes: 61bed0baa4db ("fs: dlm: use a non-static queue for callbacks")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index eb7a08641fcf5..cdbaa452fc05a 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -51,7 +51,7 @@ int __init dlm_memory_init(void)
 	cb_cache = kmem_cache_create("dlm_cb", sizeof(struct dlm_callback),
 				     __alignof__(struct dlm_callback), 0,
 				     NULL);
-	if (!rsb_cache)
+	if (!cb_cache)
 		goto cb;
 
 	return 0;
-- 
2.39.2



