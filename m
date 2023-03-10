Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEB7848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01F2C433EF;
	Fri, 10 Mar 2023 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458548;
	bh=XTvg2v1iJmFUf19wsU5tZNxfrmm1ZL8B5nCO3q+GHBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p4JIsFmeauIA+TTlel/p+V0FjgDbFnissAtpR4XI+Xme2Y17c73XHF+JC+nw3/3O
	 JOjdnVEniBRD3sS8JNyAbvkuyLfqNhiWee5GxoiQlDN4REN5unj3PnT41Q/0o0FIvU
	 TnJuVR3vR3Mgcc75dVN5WoCTRCmUU8ozZ2e18nEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Wandun <chenwandun@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/357] crypto: essiv - remove redundant null pointer check before kfree
Date: Fri, 10 Mar 2023 14:35:53 +0100
Message-Id: <20230310133736.802371985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Wandun <chenwandun@huawei.com>

[ Upstream commit e18036da5c23530994faf7243b592e581f1efed2 ]

kfree has taken null pointer check into account. so it is safe to
remove the unnecessary check.

Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: b5a772adf45a ("crypto: essiv - Handle EBUSY correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/essiv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index a8befc8fb06ed..3d3f9d7f607ca 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -188,8 +188,7 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
 	struct aead_request *req = areq->data;
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 
-	if (rctx->assoc)
-		kfree(rctx->assoc);
+	kfree(rctx->assoc);
 	aead_request_complete(req, err);
 }
 
-- 
2.39.2



