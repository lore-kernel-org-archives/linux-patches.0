Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF07E16EB4B;
	Sun,  1 Sep 2024 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207648; cv=none; b=NiIWz21ZzfM+S/G3d9l0kvHhIHQr0BqqdQd2CP1i820njSh7rrQM3qe55RQFTe6Sk87DNKKJEGszdCVoH3hupTovBVxzAwYNU/KUilcIi8rn6oBetSZ9gFKEHruI1H7O8CoHEC+OFwyaPM4FAy5icKrAUYr23pAMZ8GPuhDAsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207648; c=relaxed/simple;
	bh=j/8+0egvX6+PC3XRTSZMWc/1f1RXNDJg7N2GTX+f1uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrsUWDPCaLy0zPnuSq5NGA3cpEl7VkI54k/0+zCyFkDZtg74Z2RoTXdPjC6kcJ3Zkset1RNFJkhxwAmZPsBb2ms3XqHscaE3whR1pFyU9sIz7DLnIdKGClokyqU1VfnRZy6TR176J2Nu/cUUw9fT/il8BM8RCPOnvb9kq5Xy2H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT6Fk2Ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT6Fk2Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E068CC4CEC3;
	Sun,  1 Sep 2024 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207648;
	bh=j/8+0egvX6+PC3XRTSZMWc/1f1RXNDJg7N2GTX+f1uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT6Fk2Efyis3UUYIfVMs+3kkvHxjqzlXVd5huBfc+E+5Mt94f5W2b9JHpPDMsCXJA
	 d/L+y4nc7KzLqBZ/mPwsUQrzltCNWX0iGP32j/hkt4N4xzBmAsmJb//cYQw7ZoqRd+
	 /do62TMfCFnMuJJW9AJ2S3kq3ZE5omaew5q8dYZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/98] btrfs: change BUG_ON to assertion when checking for delayed_node root
Date: Sun,  1 Sep 2024 18:16:06 +0200
Message-ID: <20240901160805.059838080@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index fec62782fc86c..fa8f359d89994 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -984,7 +984,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 
 	if (delayed_node &&
 	    test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
-		BUG_ON(!delayed_node->root);
+		ASSERT(delayed_node->root);
 		clear_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags);
 		delayed_node->count--;
 
-- 
2.43.0



