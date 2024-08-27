Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0553148302;
	Tue, 27 Aug 2024 15:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772324; cv=none; b=jMN4q2M0Nk54eL4TZ8uEBGstOod3vaj5CQTS4zKsQOEqr84aNaSikIDqu8cKRFfTsSSaNDLvZ4l3oKDV6QL2Db8nNqIFDNRdmT7yH22KhnP7Lgdvg73owkNtazNZyH3G2x4nJqFisTjNmsCksp+5w1GM+w8FQfaQGBU1tvQhThU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772324; c=relaxed/simple;
	bh=7rYXsGDGzcNODF/5X9uPRaXx5oz9Xj1wEAqOQZq9NDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bz9+h21lLZ1EJS2DFeJ4ff+iTBsX1lVjm4hQVT9Ox6bue9xDONL/yBL0OnKRW3l73FEXsZw1+8bipRJPnkw3Ccey3I2C2nfPHVtwsVxY48btayzB/lB7me3S7bDWabVD26/beHgm34CaQgkjA50HQsKhMWFBvvzUGpva3jHM0rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUpCKetp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUpCKetp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C52C61071;
	Tue, 27 Aug 2024 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772324;
	bh=7rYXsGDGzcNODF/5X9uPRaXx5oz9Xj1wEAqOQZq9NDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUpCKetpq4AW1R5TeUy89C7Si8r6CutDsEznUSqpKtakKaXlwnzphIGsfXnSttARi
	 n+shta2eDudzgMe5D0HEEO8Pi3knCkj3Ndn8ltUN/rNBGY1hXbjO4tjDMLMQfkjEfQ
	 VPAHxo8kv1XwQCH4aMDqqfQWI4gq23121NdH94kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/321] btrfs: change BUG_ON to assertion when checking for delayed_node root
Date: Tue, 27 Aug 2024 16:38:09 +0200
Message-ID: <20240827143845.119579615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit be73f4448b607e6b7ce41cd8ef2214fdf6e7986f ]

The pointer to root is initialized in btrfs_init_delayed_node(), no need
to check for it again. Change the BUG_ON to assertion.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 948104332b4da..052112d0daa74 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -968,7 +968,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 
 	if (delayed_node &&
 	    test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
-		BUG_ON(!delayed_node->root);
+		ASSERT(delayed_node->root);
 		clear_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags);
 		delayed_node->count--;
 
-- 
2.43.0



