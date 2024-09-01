Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56E1C68C;
	Sun,  1 Sep 2024 16:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208932; cv=none; b=K51ssjKPni34ErMza9PI2i0Deg48hYo9m7YUcpwIVUUCFQ+rhpSk59ZVQVbgB6Vx6OmBiFS2wPo3z43EgTUu3pnqZe/WaQdZ5bkYxS+ImbIS4tIbHnPQYP1AbSM9GkUQ6ii3qMQv8Z3pBYH5os5zzj52fzkTgy1sSR0Hh7P90aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208932; c=relaxed/simple;
	bh=+qHS1nlXbcOrEnF4MAwa9OTICgREQvMvWLoQieS8/Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIA4vAKfbB7NsUk0ZXcg4rascsgPIBKjD174HF+9+Cv/7TvQ5FR+sDNPI1+qSblptJRC9/JoLbenHsR4vMR5sFoU/9B9eN71eaLI+n+lBe+aI1rxSyJcyQKlIY0H7h/lRyZuUHvRgwyNSBYsXeMLkiXvUo8VYSLU/LS84BevAkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2E9cnOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2E9cnOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A4CC4CEC3;
	Sun,  1 Sep 2024 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208931;
	bh=+qHS1nlXbcOrEnF4MAwa9OTICgREQvMvWLoQieS8/Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2E9cnObmoCuluNhTZAxiYRR3nzcDQZwOAxyEUHwzChuAA9UjPPFujcKTCgZam0Hh
	 WLrt7AOWa07RoYQKGAirjhXzTs8xB0Ff8iG1+9nr+SP/E5QL/B957mkZ4X9N6PMpEh
	 gaiKnKeT5IfwL0MG9+5bZMfQ817+bZRyCOvzJs/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/134] btrfs: change BUG_ON to assertion when checking for delayed_node root
Date: Sun,  1 Sep 2024 18:16:42 +0200
Message-ID: <20240901160812.215347646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 95afe5ef7500c..e3a43bf63f06c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -988,7 +988,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 
 	if (delayed_node &&
 	    test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
-		BUG_ON(!delayed_node->root);
+		ASSERT(delayed_node->root);
 		clear_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags);
 		delayed_node->count--;
 
-- 
2.43.0



