Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CD6188003;
	Tue, 30 Jul 2024 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359465; cv=none; b=Ke6tDUiCFnh1CAgRQL8ANvAhvb3zNwKU8a+2ZvalWm4PdVNv/icw3JqBcbAUYb+rvi43aFLH5tmAXrWdAapdVJG4ljQ5QGknBbtJbrM5C4PC3jyDmgWNfIEevCPPl5I+Clna4EpjTe7ovPk/32zQMXabnjg2chp/s50lc21Neak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359465; c=relaxed/simple;
	bh=pTkxb4xPxIAmr2PAH4e7sjKNtI7BHYgJCOjBg8/BCZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af9gFBdNeOgEPTZy1NdnYZcsOdgjJ02v7xk+m0ETyWEmKbLgyti3AUkRO/Ol3Lb8ujoDbm8qWIHOGnsHXQl/ez//YtpN0i4zBGQ9qgT7OT0O1LjUBxDd4BUertmIyI0/2ubiqoBMEavK5xXxqBK+8FUVi67QOe3HLNiUq8E8yOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2Q9gfAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2Q9gfAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A505C4AF0F;
	Tue, 30 Jul 2024 17:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359465;
	bh=pTkxb4xPxIAmr2PAH4e7sjKNtI7BHYgJCOjBg8/BCZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2Q9gfALSUhuc9AnUuVoF8YCV8TkaMJzBL6iO6WCDJQyE7yCp4NR2BmvTTwbCYzF2
	 Mpe9KBEOxVLcSfltthiHTcRkwfBWwsbwEbNwuMNVDiSU6VKUudoEIm72fMbCgYxqQS
	 HCyt6xj/NnFfgkkJos9tij+2DWhMrR4VOjNz2k5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 487/809] fs/ntfs3: Missed NI_FLAG_UPDATE_PARENT setting
Date: Tue, 30 Jul 2024 17:46:03 +0200
Message-ID: <20240730151743.973931194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1c308ace1fd6de93bd0b7e1a5e8963ab27e2c016 ]

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 7918ab1a3f354..0d13da5523b1a 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1738,6 +1738,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 	attr_b->nres.total_size = cpu_to_le64(total_size);
 	inode_set_bytes(&ni->vfs_inode, total_size);
+	ni->ni_flags |= NI_FLAG_UPDATE_PARENT;
 
 	mi_b->dirty = true;
 	mark_inode_dirty(&ni->vfs_inode);
-- 
2.43.0



