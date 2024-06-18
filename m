Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE041AB910;
	Tue, 18 Jun 2024 13:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716614; cv=none; b=J8JpHz3dd0vEy2h3rjkfVx+fxHtgsa76tMsWc0pUdUdJ02SPwCU+7fEVUczNaTQpHMfoTqXbq8F8Yd4ha9icstJR0tbw2wO1xJoW6Fk634IJ/LcWDIBpsc6c+RVPdEF2jpzY+eV4kP9UYrE7IB+wsMf0chejGGwtGTIpxk/cERs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716614; c=relaxed/simple;
	bh=Y1Hf2Vjfw5cULe4z3aPMfPDHo62tamlBYa669sJLVbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijZa7t4ZyBKOyGD1rluQKk+8oliR+IGkgDf8TMwPkINeSZZAIe64gcMdbulazdWovrsad1yAXu94xMF0slSUhh6FK9p392Ib1bpATgsyQMWV028iA9biB8FezDK7RWapGGjd/gq0x+YsJdFjOYSuxJST8OjZ5oEnEav/GKXu+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnkfEJXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnkfEJXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DADC3277B;
	Tue, 18 Jun 2024 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716613;
	bh=Y1Hf2Vjfw5cULe4z3aPMfPDHo62tamlBYa669sJLVbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnkfEJXRjcqZwBG1R0v+MxrivtZIaX6Ho7jsr6AlsG+qcRZMZqPp5v1WQq59SDJ2T
	 7B3T53YOLnMdtwjISdgVBAKV6q1L5utxO/FW5mMSRJhQtI3nRwml/afU9RVxoatXpd
	 6DpWQULjJdYg/l0swps+xed4/EHV5mzLUDbH6kJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 704/770] NFSD: Fix licensing header in filecache.c
Date: Tue, 18 Jun 2024 14:39:17 +0200
Message-ID: <20240618123434.446666841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3f054211b29c0fa06dfdcab402c795fd7e906be1 ]

Add a missing SPDX header.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d681faf48cf85..b43d2d7ac5957 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1,5 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
- * Open file cache.
+ * The NFSD open file cache.
  *
  * (c) 2015 - Jeff Layton <jeff.layton@primarydata.com>
  *
-- 
2.43.0



