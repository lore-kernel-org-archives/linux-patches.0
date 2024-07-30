Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827691A6160;
	Tue, 30 Jul 2024 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356919; cv=none; b=RCiZZ/6GjBcdJmwdWfD68ZlMiRUfokYQuMRz9UKgQEB0fZnpjCIUC2kFjvH8wZc6soHaAbz2Vce7Ev1t+YmdVEaXhOgh5FjXYC8poxlmEW+giaihSoieH8y7yj8JBbDxTGfRALKDcdl8tAc8KcRffyEEunK79WREibxiCMdqUMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356919; c=relaxed/simple;
	bh=GNjvcEpaWGNUipVWt9MJ4uKhegnfMmfj2xGURZFNkPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9eLGBRd49NYh2FGH4Lz2jJO8YzFCjODBFtWIlTpwPuNouDJtXp+0VODoqOh9NNdOOm4k4JJnH4qG0gFPNVppLNAm0uJl+E7eUQlpVQ/02EYBNBMGcw3Zr9YTURNTZsQhqp3n4oQpEerFKIgFa6s1BHYInu9NSoFZBKv2A5GUnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zjtgqkz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zjtgqkz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD540C32782;
	Tue, 30 Jul 2024 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356919;
	bh=GNjvcEpaWGNUipVWt9MJ4uKhegnfMmfj2xGURZFNkPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zjtgqkz1SlThdR3IShDpTTzrhHElfuxuuXeJmO2tpwvXR9zhiWbwkWH0Wa/5tcj/U
	 /wLUfL+CGS9A7+kNm4ZIeKAzcs7K9RIqUXECiK0FkdQv0qUZFA5Co7ln3mrPvm4OKR
	 sUQT/W+MEIE/lp1KY4vjoKgidutXD1CbrHlK9cRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/440] fs/ntfs3: Missed NI_FLAG_UPDATE_PARENT setting
Date: Tue, 30 Jul 2024 17:47:54 +0200
Message-ID: <20240730151625.267547808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1c308ace1fd6de93bd0b7e1a5e8963ab27e2c016 ]

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index f39987f080ee1..94b26c951752e 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1640,6 +1640,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 	attr_b->nres.total_size = cpu_to_le64(total_size);
 	inode_set_bytes(&ni->vfs_inode, total_size);
+	ni->ni_flags |= NI_FLAG_UPDATE_PARENT;
 
 	mi_b->dirty = true;
 	mark_inode_dirty(&ni->vfs_inode);
-- 
2.43.0



