Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663A5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4D7C433C0;
	Mon, 19 Jun 2023 10:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171336;
	bh=/K29tUpEeOqoyifzLgxFADlJxC/GKBllo6iwsLSdQW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2KboBAwHe9JOoucsqBzvX7cd3JdXBZKTEm6ycvDwwuV87KYgHvEmhojqcwUcPIjs
	 yLRLbV7181DpS4cNOzaVNuZpyyTIO2iiNMF0T3Bnnxuf2GSFvk90DYdH12QJJFgGph
	 xQprerYwBaX1RX9Fx0ou0+QgmG4PtgOz0UiUeO7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 44/49] neighbour: Remove unused inline function neigh_key_eq16()
Date: Mon, 19 Jun 2023 12:30:22 +0200
Message-ID: <20230619102132.230621862@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
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
@@ -251,11 +251,6 @@ static inline void *neighbour_priv(const
 #define NEIGH_UPDATE_F_ADMIN			0x80000000
 
 
-static inline bool neigh_key_eq16(const struct neighbour *n, const void *pkey)
-{
-	return *(const u16 *)n->primary_key == *(const u16 *)pkey;
-}
-
 static inline bool neigh_key_eq32(const struct neighbour *n, const void *pkey)
 {
 	return *(const u32 *)n->primary_key == *(const u32 *)pkey;


