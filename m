Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216041;
	b=buhZ/vDDSnSzdL2bGy5T19OzaT9Mt7yG5N0ED+yTJFIoSL3W9XHgLkvRSeLQK4qvDh0D
	 q1RXi5GW/3G1f1v5C0qLORg01zUaM7tfvz9wL5smwbV7vWHKYE5ImW2RCBPsfR7S+Ms2i
	 uvFUvJXeCTtJ2ByAMpQp/O1+GHAfjbGMrkiby6lHqKmjjxpFPsXlr++Rli30S5IOBkpXS
	 /VRAvYvPTYNlr5dvoiQOmAbRxIY6SmEId/aYipqjAWxhunmisqtnB1krsD8iMufo/ptgX
	 +Tp8FPYxHhTFK+yR8+P8x3gdwbxKN8hEn/A9WbZ8YAmFY7KXF1BRA4efNYzGNFCmlMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7z8jRNshBPMVE77248zoQk3KhicJ4I1qcWU4xNNiIGs=;
	b=cdUwhmOjfdxjWW7DJuxbyAmSdPhr7Co+3z/vHMpR+04piTVLUsY1u7GeDdfMfTMQBX6E
	 1yLrG6ZkXfuIh1UhRpri9cVMjnScTcXvECTNnfHLH9stjAu4Ez5Sqg+rcm3szkMyfsgW3
	 Tqo1kcVRgzHZ4MJVccHyxJc9430TtZXnzOein6/DriKHpfACMN6bwCpcx79wM2JU+usla
	 vyOr7kMd9fHBToOsVlRwhAMFeevy8NEGm98XxyCvvm8EZRvOnwleVZTGahApj22BO0LkE
	 PQET2mx1FCyGQcaOeTOZO3QKL3SP3k85/Iu91oEd8fs7Ql8RgDX+jcvssIWZSoaxxsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2b65afRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C105C606A31C;
	Wed, 28 Oct 2026 19:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2b65afRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5B31F01825;
	Wed, 28 Oct 2026 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216040;
	bh=7z8jRNshBPMVE77248zoQk3KhicJ4I1qcWU4xNNiIGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2b65afRUlUAP4MQlEpfk31S3LfAb90M0S1RjWeI0Pt0jTKm422qUZzr5SSvCzukvE
	 FCQf+T+Ty9sgtD8XF5Fx2Zu/b0C0MY1sCTifi+darYbT+aY5q3Qh9jmuiywDawaHTx
	 HC+51vMfm43PNlJ/bxFaCSmJqFFujHibybI4X4n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1421/1887] btrfs: rename ret to err in btrfs_recover_relocation()
Date: Wed, 28 Oct 2026 17:58:37 +0100
Message-ID: <20261028170531.795040941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit ba69f42af2a568f30904a11dc257eb892c5e8c0e ]

In the function btrfs_recover_relocation(), currently the variable 'err'
carries the return value and 'ret' holds the intermediary return value.
However, in some lines, we don't need this two-step approach; we can
directly use 'err'. So, optimize them, which requires reinitializing 'err'
to zero at two locations.

This is a preparatory patch to fix the code style by renaming 'err'
to 'ret'.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 6d8ba4572922 ("btrfs: drop recovered reloc root refs on recovery failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 84b153eb9d6b8..616e103fb5a9f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4257,17 +4257,16 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	key.offset = (u64)-1;
 
 	while (1) {
-		ret = btrfs_search_slot(NULL, fs_info->tree_root, &key,
+		err = btrfs_search_slot(NULL, fs_info->tree_root, &key,
 					path, 0, 0);
-		if (ret < 0) {
-			err = ret;
+		if (err < 0)
 			goto out;
-		}
-		if (ret > 0) {
+		if (err > 0) {
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
 		}
+		err = 0;
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		btrfs_release_path(path);
@@ -4289,16 +4288,13 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 			fs_root = btrfs_get_fs_root(fs_info,
 					reloc_root->root_key.offset, false);
 			if (IS_ERR(fs_root)) {
-				ret = PTR_ERR(fs_root);
-				if (ret != -ENOENT) {
-					err = ret;
+				err = PTR_ERR(fs_root);
+				if (err != -ENOENT)
 					goto out;
-				}
-				ret = mark_garbage_root(reloc_root);
-				if (ret < 0) {
-					err = ret;
+				err = mark_garbage_root(reloc_root);
+				if (err < 0)
 					goto out;
-				}
+				err = 0;
 			} else {
 				btrfs_put_root(fs_root);
 			}
@@ -4320,11 +4316,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 		goto out;
 	}
 
-	ret = reloc_chunk_start(fs_info);
-	if (ret < 0) {
-		err = ret;
+	err = reloc_chunk_start(fs_info);
+	if (err < 0)
 		goto out_end;
-	}
 
 	rc->extent_root = btrfs_extent_root(fs_info, 0);
 
-- 
2.53.0



