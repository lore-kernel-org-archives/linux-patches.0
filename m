Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5DF1581F6;
	Tue, 18 Jun 2024 13:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716060; cv=none; b=s+HMUqi6xAEe3RS/BYyr341T3FZEfZw2gks9oKmCqWoUNiRHKmRyoM1hl2z4mx07YjPCGd1w8yKn1migJKzCc7zxxHKJzUKFaf28/OvNbNqyYVo4hfItSe3GoVaJR0S2O0pk5SlPq/5wbofJINUXhwdm8Q4ycp8xz5do78yOrFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716060; c=relaxed/simple;
	bh=PE6Y46RYDgEnTPxaobhcp6+XOGe1Kn2zrmWlRUK0aUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvDbbxZNC857U6AKAzoFR5HzJoaW/dU3M8L02vYU9lyoU2KbkG5JiyrX49Y8fmTNLiMM3yn9ydqFwK+40IvvfNc2lmSzF8Ixh++SR9Bj1IcuQkkIzrxhkDgVHj3dI8GsjiHuWtZJSskuv6mycixu+p8PGQJ5FAroMyD+dBZDeek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euy0trXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euy0trXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AFFC3277B;
	Tue, 18 Jun 2024 13:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716058;
	bh=PE6Y46RYDgEnTPxaobhcp6+XOGe1Kn2zrmWlRUK0aUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euy0trXiLU5KrjrSPKemhHYyH7wT5Ei7xvj5lk/Y9LbFiXjxIQo5P3w2ktXgWErSY
	 YSCF/DOf7xEX4GGMFisjM1Pb6y/dz1fb896m6speMTAjPhqFHO1XDMw/M1S9jBxZ99
	 648vf+ChaCkGmza+oxpEWHb6VRfmLMWlfvFBpSJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bang Li <libang.linuxer@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/770] fsnotify: remove redundant parameter judgment
Date: Tue, 18 Jun 2024 14:35:40 +0200
Message-ID: <20240618123426.115342619@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bang Li <libang.linuxer@gmail.com>

[ Upstream commit f92ca72b0263d601807bbd23ed25cbe6f4da89f4 ]

iput() has already judged the incoming parameter, so there is no need to
repeat the judgment here.

Link: https://lore.kernel.org/r/20220311151240.62045-1-libang.linuxer@gmail.com
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fsnotify.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 494f653efbc6e..70a8516b78bc5 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -70,8 +70,7 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inode_list_lock);
 
-		if (iput_inode)
-			iput(iput_inode);
+		iput(iput_inode);
 
 		/* for each watch, send FS_UNMOUNT and then remove it */
 		fsnotify_inode(inode, FS_UNMOUNT);
@@ -85,8 +84,7 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
-	if (iput_inode)
-		iput(iput_inode);
+	iput(iput_inode);
 }
 
 void fsnotify_sb_delete(struct super_block *sb)
-- 
2.43.0



