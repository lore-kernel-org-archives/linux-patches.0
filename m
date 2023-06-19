Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0F6BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44778C433C0;
	Mon, 19 Jun 2023 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171984;
	bh=Z1MDPGD8h0l+5PvCEaKDbpNbwF186cXdaQ/77C4BQrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMDun07Sz+7hP475jx5RreyS1mEAPYDzeji47sgV0BMJa19BkDAImfhSDEypcbCBp
	 8sNTOxwD/5dAv3NUHQpCSWILCzbOhLRPc5EupTtTQKS29KjeM5mRPckqIGSqtrqeYG
	 WA96MjW/K2tbpTaS1ckgvlEWm/jw4M8EEMmWl68M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 60/64] neighbour: Remove unused inline function neigh_key_eq16()
Date: Mon, 19 Jun 2023 12:30:56 +0200
Message-ID: <20230619102135.924996592@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit c8f01a4a54473f88f8cc0d9046ec9eb5a99815d5 upstream.

All uses of neigh_key_eq16() have
been removed since commit 1202cdd66531 ("Remove DECnet support
from kernel"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/neighbour.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -260,11 +260,6 @@ static inline void *neighbour_priv(const
 
 extern const struct nla_policy nda_policy[];
 
-static inline bool neigh_key_eq16(const struct neighbour *n, const void *pkey)
-{
-	return *(const u16 *)n->primary_key == *(const u16 *)pkey;
-}
-
 static inline bool neigh_key_eq32(const struct neighbour *n, const void *pkey)
 {
 	return *(const u32 *)n->primary_key == *(const u32 *)pkey;


