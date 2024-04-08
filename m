Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A6379955;
	Mon,  8 Apr 2024 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584582; cv=none; b=sQ4GLjO8G/4c+4/IZeM2iOjmxiyyl5yU20UAyyaUIfBOd/W5T4Ql0dRASO2mc/ldXmiFHzr5CFx8h1Kh8P3lmuTLqseVg6e0vv3nfKp2nHBQRx3dchVadEUV58AsCRZlZ0CgFvx+l+UHx7peUR7aMTTfccjODjoS2xprXKQ8QOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584582; c=relaxed/simple;
	bh=uFae4jTLDBWSijdfJzKgPhoopWZal7pXlfUnjPcYH5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0tl7EnTcNJgd4nuFiciEa3WzALE6kjlsqEgm90Ajo3kshjcyYH3tsJU3oScw9sJk3MAqbvzkIZYolXYOrnhKawzpldJuoOl3ExLmIZd3cGFzoSkZNC6DfFwF4nZZJ3z00s6zgJhpS2qDQ4LIhMMv52bxou6SVGPUc14Ap0maSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCtKhq8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCtKhq8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A758C433C7;
	Mon,  8 Apr 2024 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584582;
	bh=uFae4jTLDBWSijdfJzKgPhoopWZal7pXlfUnjPcYH5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCtKhq8j/1X5BgUAzT0g6XUkJPMtAKykeHPDXBs6uh2SpricZj0eQKrKqUe74sDsM
	 dyfvpxByg2FxpGIOS1PORs0sVbMdT0D74eI+Je7LynJySvNMVvqikal9HCmPkpoTEO
	 76kIJEu4jzmWFPrefXj/vvGynSGsNlNUoNae1hYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 457/690] fsnotify: remove unused declaration
Date: Mon,  8 Apr 2024 14:55:23 +0200
Message-ID: <20240408125416.192983292@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit f847c74d6e89f10926db58649a05b99237258691 ]

fsnotify_alloc_event_holder() and fsnotify_destroy_event_holder()
has been removed since commit 7053aee26a35 ("fsnotify: do not share
events between notification groups"), so remove it.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fsnotify.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 87d8a50ee8038..fde74eb333cc9 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -76,10 +76,6 @@ static inline void fsnotify_clear_marks_by_sb(struct super_block *sb)
  */
 extern void __fsnotify_update_child_dentry_flags(struct inode *inode);
 
-/* allocate and destroy and event holder to attach events to notification/access queues */
-extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
-extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
-
 extern struct kmem_cache *fsnotify_mark_connector_cachep;
 
 #endif	/* __FS_NOTIFY_FSNOTIFY_H_ */
-- 
2.43.0



