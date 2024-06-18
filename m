Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BAB1AB37C;
	Tue, 18 Jun 2024 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716514; cv=none; b=Ae92AVSRUyM0ezgVDDlBSED7w5uxS+4FEV/DkoV6b8ehlYIahOqiQSzPYUody+KYI9XaoT8Nghbqc2bXuKa/CAjZ+qh3Uk/qGJGY0TBpQHqZWp6q9mM9saSZ8z8Zfw/giP0A5QEanmtd+2Kd4OheEz0lEB4nP5+7jCoquMgPd1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716514; c=relaxed/simple;
	bh=ZFdXYiQzU2+4fEp2mYOsTRU5Ni+w77MD7BxyJnuwCDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlrqKrJuKM5d6UKFVjotnTBN8A4q7IGCTOqrDw03H/GwBYmvf/5N/ch/hrvnkTZPu4nKNTgHYZM16GJN6ADgqM30Ack7UmDDDAE9fcg3Y27ge25GBTFAg2zfgushY59u1GMV+cqFqaGETB/2j+4NICQyy2nZO9hR81WaiCcwmBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6FwHVx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6FwHVx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C73C3277B;
	Tue, 18 Jun 2024 13:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716513;
	bh=ZFdXYiQzU2+4fEp2mYOsTRU5Ni+w77MD7BxyJnuwCDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6FwHVx0etOQUtKtbWOSRERSt0X/vLxExlfQOYAK1c4c+u1eAxdIzsXy/rj2G4mXP
	 yoJvWEgqZYiYYv2wU4nECyQasW2C3uvjC/XAuTzRbnN2wgkkhKvtefTb4kelIcpsjs
	 R1cab0dvmxKpzpJ4wgwOISr5A6Wfvg778FkEOUS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 670/770] fsnotify: remove unused declaration
Date: Tue, 18 Jun 2024 14:38:43 +0200
Message-ID: <20240618123433.143851791@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit f847c74d6e89f10926db58649a05b99237258691 ]

fsnotify_alloc_event_holder() and fsnotify_destroy_event_holder()
has been removed since commit 7053aee26a35 ("fsnotify: do not share
events between notification groups"), so remove it.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



