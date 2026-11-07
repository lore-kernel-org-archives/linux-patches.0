Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065098;
	b=VnvZVzSiKmjw25GJKnRnDic1+rlKHjXAW3BfY1DzdVzhmlYn28WfN+vjMKf7RabjvNnV
	 gTCr0mhnDOfKW25vqHO4raeSi9NLPpc04vTV9tXlPHVfsOAMRVhM3Zd6JVQNA5/jiiLxu
	 Q3si7M/FKbFraGIqxfHieg6l8bcwOnJSxr7Wzwjlm2WRVDVrLVXK27TeLpzZgTYh+V6a3
	 hHxdMiRVM4by+vYFSSCLnS6eXMjUgdgjU8+YreY3C0aIBadM1Yt3nA29PSrhJCTBot4Td
	 9p4JMgO1SVFijsSZQ3nSm5XFbWJM22sXFZDImkYeTdSlDqYtz+y29IxipfykyPdCb1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxqXP5k+TxrFGKLiwXmAPftyZlML4daAHWs3z+5BJ9E=;
	b=vaIT5yLbFUb2+I08NuvpzCb3IUyE98VurkTryacT9b4v8GmXRDtQ6ohrko85Z7ebfsHr
	 F4WWa8JtFk2YW5VF0vDX3Ln3Le+PM7uLysz3GoslhyyfEX7XR3qiz7A+h9Em07O0ouoTQ
	 aoSU16Cxy0GoqfMqRbLft8D6vjF1GHQUXHeQDLuHZEwTZ9nytIW+eO/t9NgEpW/CnJEzN
	 lVOwohR58yaXbs9Vgys4HBuAOHnNRJgsSjPUUnk/Z4uhKtcj15DfjcdxDNJRWv6Tc1hfS
	 nWwDCT6yBD3sv0R0EOapRDpJVmBnjTZbSfMg0AYHIZP1vHsCId9MCMW517ZkPaYoIkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RW0VyNrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C27606A32C;
	Sat,  7 Nov 2026 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RW0VyNrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B541F0089F;
	Sat,  7 Nov 2026 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065097;
	bh=LxqXP5k+TxrFGKLiwXmAPftyZlML4daAHWs3z+5BJ9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW0VyNrwztXxgsd6v9WsB8bJhxhdJqVpinMor3KlNEhVhSenp8N6jGE0YnojGUERz
	 +A3X0uc/8c0qoEm/qkxC0EZvdB3YQYBcoXFpwPhr9vuok5jbDim4oP6+XYOYXQr+a1
	 U4xGiezomn08ZgqAF0z+6NJFJIfNQ6b9duyKHsaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0931/1257] ntfs: do not map a vcn as a hole when its runlist lookup failed
Date: Sat,  7 Nov 2026 08:53:47 -0500
Message-ID: <20261107135005.069049315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit e727ea7fc4e36b3d14b7bb304e82918aa6e2024a ]

ntfs_attr_vcn_to_rl() retries ntfs_map_runlist_nolock() for any lcn up
to LCN_RL_NOT_MAPPED, which includes LCN_ENOENT, but turns a failed
retry into an error only for LCN_RL_NOT_MAPPED.  For LCN_ENOENT the
error is dropped and the read path maps the range as a hole.

An LCN_ENOENT below allocated_size comes from a base extent with a
highest_vcn of 0, which ntfs_mapping_pairs_decompress() takes to map the
whole attribute, so the runlist ends after its last mapping pair.  If
the pairs end early, the retry finds the same extent and fails with
-ENOENT.  On a crafted volume with 4 KiB clusters, a 64-cluster file
whose mapping pairs stop after 16 clusters reads 48 clusters of zeros,
with no error.

The same layout gets a crafted $MFT past the check from "ntfs: fail the
mount when $MFT needs its own extent records".  With 512-byte clusters
and $MFT's mapping pairs ending at vcn 4, an unpatched kernel hangs on
the folio lock reading records 0-3.  With the check alone, the -EIO is
dropped, records 2 and 3 read as zeros and the mount carries on until
check_mft_mirror() finds the zeroed record 2.

Fail the lookup whenever the retry leaves @vcn unmapped below
allocated_size, -ENOENT included.  At or beyond allocated_size the end
of the runlist is still returned as it is.

A failed expansion in ntfs_non_resident_attr_expand() or
ntfs_attrlist_repack() truncates the runlist under the runlist lock but
restores allocated_size only after dropping it.  A lookup in between
would now fail, so restore allocated_size before dropping the lock in
both, under size_lock, which ntfs_attr_vcn_to_rl() takes to read it.

The crafted file now fails from vcn 16 on with -EIO, and the crafted
volume fails to mount with the check's message.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c   | 30 ++++++++++++++++++++----------
 fs/ntfs/attrlist.c |  8 ++++++--
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index f8eecdcf57858..c5df913d3cbad 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -354,14 +354,16 @@ struct runlist_element *ntfs_attr_vcn_to_rl(struct ntfs_inode *ni, s64 vcn, s64
 	}
 
 	/*
-	 * The runlist fragment containing @vcn could not be mapped, e.g.
-	 * because the extent mft record holding it is corrupt.  Do not hand
-	 * LCN_RL_NOT_MAPPED back to callers, which would treat it as a hole.
-	 * At or beyond the allocated size nothing is mapped, and the runlist
-	 * ends there with LCN_RL_NOT_MAPPED if only a later extent has been
-	 * mapped, so return that end as it is.
+	 * Neither the runlist nor the retry mapped @vcn, e.g. because the
+	 * extent mft record holding it is corrupt or because the mapping
+	 * pairs end too soon.  ntfs_map_runlist_nolock() reports the latter
+	 * as -ENOENT, as @vcn lies past the extent it found.  Below the
+	 * allocated size, callers would treat LCN_RL_NOT_MAPPED or LCN_ENOENT
+	 * as a hole, so fail instead.  At or beyond it nothing is mapped: the
+	 * runlist ends there with LCN_ENOENT, or with LCN_RL_NOT_MAPPED if
+	 * only a later extent has been mapped, so return that end as it is.
 	 */
-	if (*lcn == LCN_RL_NOT_MAPPED) {
+	if (*lcn <= LCN_RL_NOT_MAPPED) {
 		unsigned long flags;
 		s64 allocated_size;
 
@@ -4484,6 +4486,7 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	struct ntfs_inode *base_ni;
 	struct super_block *sb = ni->vol->sb;
 	size_t new_rl_count;
+	unsigned long flags;
 
 	ntfs_debug("Inode 0x%llx, attr 0x%x, new size %lld old size %lld\n",
 			(unsigned long long)ni->mft_no, ni->type,
@@ -4714,11 +4717,20 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	if (err2)
 		ntfs_debug("Leaking clusters");
 
-	/* Now, truncate the runlist itself. */
+	/*
+	 * Now, truncate the runlist itself.  Restore allocated_size before
+	 * dropping the lock: ntfs_attr_vcn_to_rl() fails a lookup below the
+	 * allocated size that falls past the end of the runlist.
+	 */
 	if (ni != locked_ni)
 		down_write(&ni->runlist.lock);
 	err2 = ntfs_rl_truncate_nolock(vol, &ni->runlist,
 			ntfs_bytes_to_cluster(vol, org_alloc_size));
+	if (!err2) {
+		write_lock_irqsave(&ni->size_lock, flags);
+		ni->allocated_size = org_alloc_size;
+		write_unlock_irqrestore(&ni->size_lock, flags);
+	}
 	if (ni != locked_ni)
 		up_write(&ni->runlist.lock);
 	if (err2) {
@@ -4730,8 +4742,6 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 		ni->runlist.rl = NULL;
 		ntfs_error(sb, "Couldn't truncate runlist. Rollback failed");
 	} else {
-		/* Prepare to mapping pairs update. */
-		ni->allocated_size = org_alloc_size;
 		/* Restore mapping pairs. */
 		if (ni != locked_ni)
 			down_read(&ni->runlist.lock);
diff --git a/fs/ntfs/attrlist.c b/fs/ntfs/attrlist.c
index 1abe0ec2a398a..78e9a1dc79251 100644
--- a/fs/ntfs/attrlist.c
+++ b/fs/ntfs/attrlist.c
@@ -168,14 +168,18 @@ static int ntfs_attrlist_repack(struct inode *attr_vi,
 	return 0;
 
 restore_old_runlist:
+	/*
+	 * Restore allocated_size before dropping the runlist lock:
+	 * ntfs_attr_vcn_to_rl() fails a lookup below the allocated size that
+	 * falls past the end of the runlist.
+	 */
 	down_write(&attr_ni->runlist.lock);
 	attr_ni->runlist.rl = old_rl;
 	attr_ni->runlist.count = old_rl_count;
-	up_write(&attr_ni->runlist.lock);
-
 	write_lock_irqsave(&attr_ni->size_lock, flags);
 	attr_ni->allocated_size = old_alloc_size;
 	write_unlock_irqrestore(&attr_ni->size_lock, flags);
+	up_write(&attr_ni->runlist.lock);
 
 	restore_err = ntfs_attr_update_mapping_pairs_locked(
 			attr_ni, 0, locked_ni);
-- 
2.53.0



