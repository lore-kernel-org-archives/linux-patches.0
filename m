Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619560;
	b=KUgSVWLqnS+SEDDiWLFyEl/zUso+OdHKLwIIREs+A3tl78BysR0lXzxHnr3RxRfda5Cx
	 DrYvbDOCfuVVGEI7HonbzZN9XZNg+r1PAuN5FvxcIpXCEvYoI3rBHDZSIZCXRYt6vdJ9/
	 kr7k/bPYf40g0nHEjkyxHxaB/eizn4pCNX6N0LCTBHFZ2NqSUO1qDqjYV7zP7YyJPfp6D
	 rIym2lHdIfU9hDPi/HZJ2FMqkcwq5ZKFMO8IGce6iDcV0Va1XC3TZrI6nwbqLjM/Qmfws
	 c5usRF9Oo1h7RSgrXOBVTZilOOAeNEuYeBhu02q41HR1/4Fqz8xEj+iOyyxivdgOQXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=28Q2OeDYvh5BdAvuMHFG6u4gznVfxsUMlmW9qzzh1hI=;
	b=Ztbxnf6cKJyhC8Bi2KNC42ZtK1v/YW0jOAbxWYkTeI6LEMHjmVxLDS7V3k9i5EQkbOi/
	 oddmLz4JaoJIF4VB+hTywxODs5FLmp86ym2OL/lGiplsCpn/tkq+7ukYbvhudxQULDrTd
	 E6fuDfxHZ5JS5MgEh6NuY2PbiIe+zO+qG1siUedIi4sLz3RA4KNl4nnHxbpjIOKSbZUXJ
	 QaMF5z04SlmNKfN3LchI3K950ZGBx0gmnhLVahAbCcu3JCQq24V1Bp4CuNiZWuRXN0bkY
	 f+nF2IMz3g6cOqEC8H+Yusjw+7TUXo1tVyK5dbHpfnRVJ4YW5bqq3tfiRGLwkWd+EYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9Xx61hS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7DF606A330;
	Wed, 25 Nov 2026 15:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9Xx61hS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CD51F0093C;
	Wed, 25 Nov 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619560;
	bh=28Q2OeDYvh5BdAvuMHFG6u4gznVfxsUMlmW9qzzh1hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9Xx61hSBPcYnsdx6VBiyxU9IWtElVmf40OZKD7YltaR5aSf/7sxSvO9KJWc0N9KE
	 T8QdXlwvcvmjU4WnYLhzLIl1rLGQLJuN4NS2JAxWnH1CvMRGR/TCqqh59TbAPXr/oU
	 8OplFHKQWvw/5/s2+iM6g1H65iByKVV/zJ2GbUwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0635/1005] udf: dont allocate the inode block in udf_sync_inode_metadata()
Date: Wed, 25 Nov 2026 15:32:53 +0100
Message-ID: <20261125143836.628954899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 05ad4c91fe2852a19d04311883420ffefb02300d upstream.

udf_sync_inode_metadata() looks the block that holds the inode up with
sb_getblk() which allocates a buffer for it if it isn't cached. But a
block that isn't cached is neither dirty nor under writeback, so there's
nothing to write or to wait for and the buffer just gets thrown away
again.

That allocation is also something we can't afford once inode eviction
calls ->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-7-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1735,25 +1735,24 @@ void udf_update_extra_perms(struct inode
 int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh;
+	unsigned long block;
 	int err = 0;
 
-	bh = sb_getblk(inode->i_sb,
-			udf_get_lb_pblock(inode->i_sb,
-					  &UDF_I(inode)->i_location, 0));
-	if (!bh)
-		return -EIO;
-
-	sync_dirty_buffer(bh);
-	if (buffer_write_io_error(bh)) {
-		udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
-			 inode->i_ino);
-		err = -EIO;
-		goto out;
+	block = udf_get_lb_pblock(inode->i_sb, &UDF_I(inode)->i_location, 0);
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (bh) {
+		sync_dirty_buffer(bh);
+		if (buffer_write_io_error(bh)) {
+			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
+				 inode->i_ino);
+			err = -EIO;
+		}
+		brelse(bh);
+		if (err)
+			return err;
 	}
-	err = mmb_sync(&UDF_I(inode)->i_metadata_bhs);
-out:
-	brelse(bh);
-	return err;
+	return mmb_sync(&UDF_I(inode)->i_metadata_bhs);
 }
 
 static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)


