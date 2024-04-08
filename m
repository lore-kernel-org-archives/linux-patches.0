Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552588595F;
	Mon,  8 Apr 2024 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583792; cv=none; b=azsK3umEpiqRwNNukxTq2pn1olJlzTh+Y3k7iwXJ0jdu6m+ttYqSX3pCqXf5PeOHy4Y0Prl+o+DYmkB2vRC5eqxgE+KGdaa5nl1ye4L7/vB8AQKasfv4v5g93ejLg7SkA+Suq5heJ5YKlIlAd6xi4qKGJKYV4j1lRXDaujOsNTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583792; c=relaxed/simple;
	bh=pENROCP0L8hJt7flZbZQDhY7HlrCb/u2VWQP8WvYoEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHl0uMyF0lxbz0Jfkp5gE9PFFD9xGHl8sChm+cv5Kh4IZ6aS+zblx12nqDWJUVDaxubK/1ag7R9ap5QGN9cuL86G5tukaD7q5wBaLR8mArNj7r9kojkcLtapRz1yOZ8VnJEH1+vCWaqgErBIaNTDojaqbz1od6FPJmgYDyvCBhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sh0VxAFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sh0VxAFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06E8C433C7;
	Mon,  8 Apr 2024 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583792;
	bh=pENROCP0L8hJt7flZbZQDhY7HlrCb/u2VWQP8WvYoEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sh0VxAFKstSoQmUl7g/DiStqhKhR4yXSCrMjUkSRGbiyjbUY7QBdjYjILFARjrnSP
	 P57p3tq38fU1JCwwgwaRWlx1omKQ0iH0xwefmh/4/OEayntA9UML+lBxjSeQd8iaZa
	 ZeqKAovISLcTTj7MQthyTFQ20Z/QrElTnQ178rvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bang Li <libang.linuxer@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 285/690] fsnotify: remove redundant parameter judgment
Date: Mon,  8 Apr 2024 14:52:31 +0200
Message-ID: <20240408125409.945147360@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bang Li <libang.linuxer@gmail.com>

[ Upstream commit f92ca72b0263d601807bbd23ed25cbe6f4da89f4 ]

iput() has already judged the incoming parameter, so there is no need to
repeat the judgment here.

Link: https://lore.kernel.org/r/20220311151240.62045-1-libang.linuxer@gmail.com
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



