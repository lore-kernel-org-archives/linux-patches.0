Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED3213AD22;
	Wed,  5 Feb 2025 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763385; cv=none; b=IgGVcr/BC6bC2UpHwiGiMXN3lkZZEV9tQU7U38DHnDSTIpWU7bK70IYirA5HgFeNd7Rtsa9q/KHWgY8TBxcN5DXXyaIW5l5+8o3dxYiVlbqlBhLSn4QbyLqGbGAAjjG21qnlaJDBbzcxX754Ji/+3nbfrEItVwPVNHNzjzxWIJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763385; c=relaxed/simple;
	bh=T2F25rtmkt0pJc9CzsMHyoiEXnvUx8dhrd4qDjF1Eto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1SCvIKllHfmR6ULTpwpPNGpixmr9j/pALaNoY9ZZYqYKB9pu4ZVD0kNoIAh2P1O/AGFOciZSgP5RjBCEYZ/goBSIYTumLqxXCWYlfIIuJuqN47HBc4oOgmk4K3pD7d47ro/oMnDx5MJHvXjPPmLruoL05GLvuPVnDuHmNCQwqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tqt0BnRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tqt0BnRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC1BC4CED1;
	Wed,  5 Feb 2025 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763385;
	bh=T2F25rtmkt0pJc9CzsMHyoiEXnvUx8dhrd4qDjF1Eto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tqt0BnRDk4Ze8ODfC5eZWPDJqeFdmvQFcdrgUPCDmG//lkfARao4klrNDhVPYSI9E
	 WRjg0NfPigmTylhtXElgqOFyE5mQccvlQJx6vW/jYJL9d7+lBgWc/+jgK7rFX6m1+u
	 JeGYTiegWCPp8FFR6OGeiNdGprLHO59V/cxHZHQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/590] afs: Fix directory format encoding struct
Date: Wed,  5 Feb 2025 14:36:01 +0100
Message-ID: <20250205134455.473930606@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 07a10767853adcbdbf436dc91393b729b52c4e81 ]

The AFS directory format structure, union afs_xdr_dir_block::meta, has too
many alloc counter slots declared and so pushes the hash table along and
over the data.  This doesn't cause a problem at the moment because I'm
currently ignoring the hash table and only using the correct number of
alloc_ctrs in the code anyway.  In future, however, I should start using
the hash table to try and speed up afs_lookup().

Fix this by using the correct constant to declare the counter array.

Fixes: 4ea219a839bf ("afs: Split the directory content defs into a header")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-14-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xdr_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/xdr_fs.h b/fs/afs/xdr_fs.h
index 8ca8681645077..cc5f143d21a34 100644
--- a/fs/afs/xdr_fs.h
+++ b/fs/afs/xdr_fs.h
@@ -88,7 +88,7 @@ union afs_xdr_dir_block {
 
 	struct {
 		struct afs_xdr_dir_hdr	hdr;
-		u8			alloc_ctrs[AFS_DIR_MAX_BLOCKS];
+		u8			alloc_ctrs[AFS_DIR_BLOCKS_WITH_CTR];
 		__be16			hashtable[AFS_DIR_HASHTBL_SIZE];
 	} meta;
 
-- 
2.39.5



