Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043983;
	b=ni5s2B+y+o2vuP6WH5z207k9keWkllwl+8cz9wKJAYi3AgeocaB+uny7eOvMdM3j5Vxi
	 owGBm3DxST5k92UYD1HZrsVf07gXDnjc/15IbqOPfq1kOnuMw7XyyrdqLuR05rK78iPJG
	 /Xd9CkakreJzwOO3JkX4pBTbBTr8v+SOjXKxLdQmSoSnk8nbZ88FMZJiBHvteD9gzFTVc
	 SwRFIiNn3AJoWUpqsouRWYr6vomMxuwWIyk4df1spG7sFgzDbkwq1QdGzxO7UiFtCIXaU
	 GytRodxWGPkO9xHuQwj5TwNqVcQ3Hsdi+pm2d2BlNFXuam2ck88R13mXCeGwxK6FL6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IYYQJBCeWJYpxcXGHmnuWOQR35zjwkdDwfR5aNYyxP8=;
	b=L3l3kTQQvkAIMdzM1YBtOjXU+geTjvjOL/CLml2azCk+cdJNAbUKB2cgO5t5v1HCqGpt
	 77KnqRTR66OSOeU776t1m2PoazvPQE/0n+ErNK7TYJof75pPOg0b7X7eBWq/loqzS0zTC
	 te8xNMrSU+s3CerueV8Z+MJjtQqp8jJd7mNU7bDNEwq2jJKvsTt14fRNKekhSfMRn/wOa
	 he4FBd+69kyfhTLkdpdJHPot7LMISIBKqjDbF1CzGeHE6FKSusy6rHt1DOMUYGf/C1CBV
	 //fo5/1NX+jDDtiD9IgWQJ3aP8fh46dG2DFjqXSuh3fSdwYJY73G6aLEOZiD/46lFNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGvCPEdz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FA1606A31C;
	Wed, 18 Nov 2026 23:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGvCPEdz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98351F000C4;
	Wed, 18 Nov 2026 23:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043983;
	bh=IYYQJBCeWJYpxcXGHmnuWOQR35zjwkdDwfR5aNYyxP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGvCPEdzf28L+H1fb+HFdgfJG/fgOtlauMyp7UfPGBKsOhx73nUdMvH8sZ7fN2U76
	 SYw08ka/+HE+9W2Uyf4NMOp70up8PME+zZ1EJ2kVbgWc7Is52sQD9xoRU+zHt+tYdT
	 3JduLhePiPBnZ1tSI7mrvJZ1nU0NgN/Xx/AUYyQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0403/2857] xfs: strengthen the "is cow staging" helpers in scrub
Date: Wed, 18 Nov 2026 15:23:57 +0100
Message-ID: <20261118150215.900744577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 0d43368844a75ad13561a1198a3b027940730756 ]

LOLLM pointed out a bug in both of the refcount scrub predicates that
determine if a range of blocks is marked as CoW staging in the btree.
While it compares blockcount < len, this isn't enough to determine that
the CoW staging record is at least as large as the range passed into the
helper.  Fix both of them.

Cc: stable@vger.kernel.org # v4.16
Fixes: f6d5fc21fdc713 ("xfs: cross-reference refcount btree during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Dropped the rtrefcount.c hunk because that file doesn't exist in this tree; the refcount.c hunk applied unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/refcount.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index a26ee0f24ef2a..17db5f8bdcd7d 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -443,8 +443,12 @@ xchk_xref_is_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > agbno)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < agbno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 
-- 
2.53.0



