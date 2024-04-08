Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42F9768F0;
	Mon,  8 Apr 2024 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584592; cv=none; b=aRYva9SpJ7K2eu8XPitrsnwB8ykrhThdaiPAfB95V4MgtyKDzLYd3OrIQtMPpIhSFSaAfs5w0iQbibAxXlxuPeY2SPy3M9mDhakT9pCiOPef83lfWNZl7TZK11+x83uyvX/JPluNZQhII1rsthSpQULnjcvscwYmk+O57lspPLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584592; c=relaxed/simple;
	bh=4momn2rn7vJLEiSSx8J5g5cARBUWlSjOON6TrdK/Ujc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNMgTQOySJLzeB1Wtp6U6R4Dl+ljlBqzgzFxFA5SJA/ZMox9AkAUIqttNPCD7NCpK2KB/QfCdazcOi6w8G0yd43IMtxTvtgtMuvP3A8xl05J2D9oDswjsFQnMj39iKsuEeTTO7YSam85ZmZ7AGmys5tqSityFpuR8OW/mywgDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vMu4A6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vMu4A6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB32C433F1;
	Mon,  8 Apr 2024 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584591;
	bh=4momn2rn7vJLEiSSx8J5g5cARBUWlSjOON6TrdK/Ujc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vMu4A6zywtv0fERjuO40gIcW0Cxuc1qDnx0GrkUCucCzv+Kgv8t6XT+lGzUDyIuT
	 MG17OVmFIabuFPkGo9o7iEaJcFlZ7evVXvQYLwDwtO5dlfu6bJKUJ3xp4FtcB8zCQi
	 bCeLYzjxDvUN0IXeIlwMihPM/GgQZLV5/I/4erRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 491/690] NFSD: Fix licensing header in filecache.c
Date: Mon,  8 Apr 2024 14:55:57 +0200
Message-ID: <20240408125417.419781012@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3f054211b29c0fa06dfdcab402c795fd7e906be1 ]

Add a missing SPDX header.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



