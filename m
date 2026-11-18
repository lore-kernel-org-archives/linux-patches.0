Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021197;
	b=J+11AZp1eVaCgWz9jtC28GEpqG18Sqh0z00iEIscbvDIRureDE6EYW8DKzSBi6XUkETV
	 xm72kTgKEeWHc30YmrwpfmF6j12hexRPOZr8io/3OsugndBoypORkULBYST9RPVJ4wJ3B
	 iMnqtW7rgB8dO9fxTDTvJrazcupVckuLdhnz35VXcGVUEL+nxz8MqudCR0YDrx712fh10
	 MZfMblVVDH4y9a4uMmKmifALVCrMO6WQb/cPcHfX/L3vVFICmxjXusExUMlDIiCGrDG/e
	 KpPN2czvLW3WhziBnYkbNdEaSzd9uo/ufcWWXUBtXv2ZCDwwhrNn49sv7qQPHdfhCFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBb08LxYQxvUodDA62iENYs5c5ujYcx/133Ss+S4QJI=;
	b=ApgVsGHHUDdWscn/c6SlZscWEv8t+l8BrISjkwXaQ99PyUmN/mchoNz5Z8A5ca6z6f6z
	 fRMJtZiw4BHyy9q+CRUc1uGIFPVfJGs+1SxypvlJnVNRyIrWGTggRenDV35IMXzkWxA5e
	 e5vp/XEVrVdUdtBtxpZL9l4xzJNykZXXbweSwN4BjNWCDM/5ZWUo9SBu9XiyO6em3Mse9
	 oOL6SLT+RvGSfRO7D4OHt+dZAnRZIBDznWm6wxEkVEjE22DXmRrPs6kLpGMxoZUwoGETZ
	 Ee8YdnUqP4N7qSYAeSHsOGEDf0SUKxrAbx+89xWvJRL4YWN3JYL+OSWtx8o2ykmgSHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8o2qoGs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA74460A260E;
	Wed, 18 Nov 2026 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8o2qoGs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1699F1F000C4;
	Wed, 18 Nov 2026 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021196;
	bh=bBb08LxYQxvUodDA62iENYs5c5ujYcx/133Ss+S4QJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8o2qoGsMcUUJQFVNiYVpqVxo1Aa8GlS+doOUE1zO9u3fUnazHqaZIbjGtEzMnOzY
	 ElFmElERZdm+hiCCa6PcNqfvm9N8Iru8wKfu/P+JomxiiL0WGy2Z3dxm35pMR5lM9z
	 O+/nIqYcK7F5lboT+mgoZdF9RIOpTP2X0zRqFiRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2220/2651] ntfs: only require compressed size on first extent
Date: Wed, 18 Nov 2026 15:57:40 +0100
Message-ID: <20261118150405.511764344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 8deea344965f44d2ccde3e6153f8272196242501 ]

The attribute validator required the compressed_size field for
every sparse or compressed extent. Continuation extents omit that field,
so their valid mapping_pairs_offset of 64 was rejected and compressed
reads failed.

Fixes: ffc755828de1 ("ntfs: Fix min_len for compressed/sparse attributes in ntfs_non_resident_attr_value_is_valid()")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c |  8 ++++++--
 fs/ntfs/inode.c  | 18 +++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 1f64680d5c8fe..22afc03cbf6fc 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -733,8 +733,12 @@ static bool ntfs_non_resident_attr_value_is_valid(const struct attr_record *a)
 	min_len = offsetof(struct attr_record, data.non_resident.initialized_size) +
 		  sizeof(a->data.non_resident.initialized_size);
 
-	/* Sparse and compressed attributes have the extra compressed_size field */
-	if (a->flags & (ATTR_IS_SPARSE | ATTR_COMPRESSION_MASK))
+	/*
+	 * Only the first extent of sparse and compressed attributes has the
+	 * extra compressed_size field.
+	 */
+	if ((a->flags & (ATTR_IS_SPARSE | ATTR_COMPRESSION_MASK)) &&
+	    !a->data.non_resident.lowest_vcn)
 		min_len += sizeof(a->data.non_resident.compressed_size);
 
 	if (attr_len < min_len)
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index f3e42ec65bdc7..3acb20c9bd226 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1157,6 +1157,11 @@ static int ntfs_read_locked_inode(struct inode *vi)
 		}
 		if (a->non_resident) {
 			NInoSetNonResident(ni);
+			if (a->data.non_resident.lowest_vcn) {
+				ntfs_error(vi->i_sb,
+					   "First extent of $DATA attribute has non zero lowest_vcn.");
+				goto unm_err_out;
+			}
 			if (NInoCompressed(ni) || (NInoSparse(ni) && !NInoWofCompressed(ni))) {
 				if (NInoCompressed(ni) &&
 				    a->data.non_resident.compression_unit != 4) {
@@ -1205,11 +1210,6 @@ static int ntfs_read_locked_inode(struct inode *vi)
 				ni->itype.compressed.size = le64_to_cpu(
 						a->data.non_resident.compressed_size);
 			}
-			if (a->data.non_resident.lowest_vcn) {
-				ntfs_error(vi->i_sb,
-					"First extent of $DATA attribute has non zero lowest_vcn.");
-				goto unm_err_out;
-			}
 			if (ntfs_non_resident_sizes_inconsistent(vi, a))
 				goto unm_err_out;
 			vi->i_size = ni->data_size = le64_to_cpu(a->data.non_resident.data_size);
@@ -1435,6 +1435,10 @@ static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi)
 		}
 	} else {
 		NInoSetNonResident(ni);
+		if (a->data.non_resident.lowest_vcn) {
+			ntfs_error(vi->i_sb, "First extent of attribute has non-zero lowest_vcn.");
+			goto unm_err_out;
+		}
 		/*
 		 * Ensure the attribute name is placed before the mapping pairs
 		 * array.
@@ -1470,10 +1474,6 @@ static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi)
 			ni->itype.compressed.size = le64_to_cpu(
 					a->data.non_resident.compressed_size);
 		}
-		if (a->data.non_resident.lowest_vcn) {
-			ntfs_error(vi->i_sb, "First extent of attribute has non-zero lowest_vcn.");
-			goto unm_err_out;
-		}
 		if (ntfs_non_resident_sizes_inconsistent(vi, a))
 			goto unm_err_out;
 		vi->i_size = ni->data_size = le64_to_cpu(a->data.non_resident.data_size);
-- 
2.53.0



