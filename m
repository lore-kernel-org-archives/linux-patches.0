Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC2F3CDBDD;
	Tue, 12 May 2026 17:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607838; cv=none; b=LnS4LAs1yAjDOzWf7tOrwgOs9qTwJVF3t+e6aiTA7qjsshfNjRqvEoIrLqP7kRhc5PwiZ8c+G+yBEjOVjmNyXfMqbp2BRFM4WGeeXDU69V9xqtv9HCR05LbF3FwUWzhmCtxLUb84Hb3lvQz2VdVKNOFrw+y3iyFT5hjKIF26oOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607838; c=relaxed/simple;
	bh=epf33vq+e3xD4WR8TOL+pL1wltqnuKg8EXFyWXpbbAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMz89/xhMaGgW7JcbT+w5wkSYRSO6i77B7b35JZ00yAgowKDMHscyUD+V1VPIjWDcuUPGt/S6ejAsnK1wva5Vpk8BfNQRO+MnzIu23y33aISo0mbZ9lVqFOnQwS347V0xER2+wj1qwTtNqR6eFpbFBLcyNi/nnr4WET5RCtmtYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRndWoae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRndWoae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749D7C2BCB0;
	Tue, 12 May 2026 17:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607838;
	bh=epf33vq+e3xD4WR8TOL+pL1wltqnuKg8EXFyWXpbbAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRndWoae9PLhCdoDhCuezupAsH71Ze9aU60BFh68UYWEfGz+pM144FqiLfPGYAwRf
	 EMvjPhVlYylPKIdgEFDkEhrtEEIFbejI+SjXNlPVGW34euJ3rLHgl86gASTl2PRpxv
	 I+55YxEHZGvDWcicPorLmV/gu+pW4TYsIML/zspI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruijie Li <ruijieli51@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 053/206] xfrm: provide message size for XFRM_MSG_MAPPING
Date: Tue, 12 May 2026 19:38:25 +0200
Message-ID: <20260512173933.960595128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruijie Li <ruijieli51@gmail.com>

commit 28465227c80fe417b4013c432be1f3737cb9f9a3 upstream.

The compat 64=>32 translation path handles XFRM_MSG_MAPPING, but
xfrm_msg_min[] does not provide the native payload size for this
message type.

Add the missing XFRM_MSG_MAPPING entry so compat translation can size
and translate mapping notifications correctly.

Fixes: 5461fc0c8d9f ("xfrm/compat: Add 64=>32-bit messages translator")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3235,6 +3235,7 @@ const int xfrm_msg_min[XFRM_NR_MSGTYPES]
 	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_NEWSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_mapping),
 	[XFRM_MSG_SETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 	[XFRM_MSG_GETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 };


