Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021157;
	b=XsKmNMjCMaBFNMNe7JJqiuE3odVXhh2GI3ePUitXLlw7fO6Im85HrHUPm8XFXBEegqXY
	 tvikfjFmqH4DC1Jz4CnT6swNaTcepZxJ044YlyB+6qPdQbITy8/+i/bfCrZ0upqy7h5gn
	 4Tkb9FQCTcoy1VzKeA6yqnKc9vmEULHwUCgV0FdloCIfb0tVclgXX8XAf25DUfoIg5fpC
	 8gdHh/+gJwy5ImV9lpDidxS2j09lFQAOI/GwlZZkMZcf7VXL8XkwXrJDhWFF7Bp1Pl9Lk
	 Pw91RRPR0Mdk8UWs7hvkt0oZg4eMHULZBKKMi/7ij2uVUuV/usJ4ofakMOAOhGI5DlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/Mc4BJYcQRPsyU3BsZalOQXyauqVhO6nOyUxVsFst8=;
	b=ReGek1J9YvkJKMUS+RxaXvHc0rLZCQHJEGggK04UMkTrwCG52aizG6oaVbkdDtV2Z1md
	 O+EdPhxiQ9niUO6HG7eCOAdVsHHFclwD5z5NMRJKmusTGQWocmvPhiJkrXVRiGpxTNrl5
	 awZ8rtEk4akqDGj8TrV+1FHaj/VrGlNc//BmYTnqx00t+a+hVYfbSleFZwr8lNykZITBt
	 83x39g0mJZD6CtaqEol5Q7rAEiNVhCIR75jQqsWjPp1YUoSO1iHfawkOSblZDY1nQ1O2V
	 tcvHn30Io8BfHhUcT9W8Y5ok3rop2a9U2Q+EC3SJ7nD55a5riu26NLRWHj8YWRnI04Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKGFvkyc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6B5606A332;
	Wed, 18 Nov 2026 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKGFvkyc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8BC1F000C5;
	Wed, 18 Nov 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021157;
	bh=H/Mc4BJYcQRPsyU3BsZalOQXyauqVhO6nOyUxVsFst8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKGFvkyci2Y4tGOXvfyUy7OnqdqfHUs4iDS9RJ1OuvXkA+qwsBCXGERhpHQ6fRWhC
	 eA0SLtlpmirM9CfEZ+i5AgcMNuOY9kzIHoIV6+gjJ+BSWxJeceQfTAlO56Y3gE6NCM
	 TFcAru6iQVnH/gmBQxZecMYzY8WE+uupOgW+SDrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2207/2651] ntfs: propagate the ntfs_attr_iget() error in update_reparse_data()
Date: Wed, 18 Nov 2026 15:57:27 +0100
Message-ID: <20261118150405.128203138@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit acb8042c76cbbb8a8a54f4fa1e98aa4f569491c5 ]

update_reparse_data() replaces the ntfs_attr_iget() error with -EINVAL,
so an -ENOMEM from iget5_locked() or a read failure from
ntfs_read_locked_attr_inode() is reported to userspace as EINVAL.

The path is reached from __ntfs_create() via the three
ntfs_reparse_set_*() helpers, so symlink() and mknod() are affected.

Return PTR_ERR(rp_inode) instead.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/reparse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/reparse.c b/fs/ntfs/reparse.c
index 1a6073e22677c..2a6480211fe32 100644
--- a/fs/ntfs/reparse.c
+++ b/fs/ntfs/reparse.c
@@ -676,7 +676,7 @@ static int update_reparse_data(struct ntfs_inode *ni, struct ntfs_index_context
 
 	rp_inode = ntfs_attr_iget(VFS_I(ni), AT_REPARSE_POINT, AT_UNNAMED, 0);
 	if (IS_ERR(rp_inode))
-		return -EINVAL;
+		return PTR_ERR(rp_inode);
 	rp_ni = NTFS_I(rp_inode);
 
 	/* remove the existing reparse data */
-- 
2.53.0



