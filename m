Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAF013C684;
	Tue, 14 May 2024 10:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683222; cv=none; b=Bq7IeAVDDmDQSIrLO+Bg71k5fZ1aPIRpEup8OvStJSHhp4Aoqit7zwiwK6YYJRpYSDsA68KkIyPpHz0uTbr3ODf77zl4u/YodOFzNbwcLtE5Ah0fZUoMs6bQXAiOV8xo7toTqiJjmavDCqtWGIhKE4NhmvAAmRR6ZFdseZeVlJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683222; c=relaxed/simple;
	bh=lnBoh8UnJTPDYi+I6A1D9l79a0x5a5YOngcpH76iDhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZcgda717zBI2r/vP8PCHzG2G1av2Wr14CkrAuuZ5A7dP+owlHqdYjpAh6pq6yvmHHOvimwOC5C/3wQKobtH3K/k84YS8XvGjwtGMAuXY8AJu4f7BZb/TMC7GPoaNQ0aqrVqXBQnkydP3ewcnM5adfr+0bS4Q+MMOSirGM7tOLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzNZGV4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzNZGV4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CCFC2BD10;
	Tue, 14 May 2024 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683221;
	bh=lnBoh8UnJTPDYi+I6A1D9l79a0x5a5YOngcpH76iDhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzNZGV4PQ/AKI4jmSXfqshMgNiikuCOgu8jNkqbN9zEOnWaCboZBihWOnXxwXPcqc
	 k6ifLsoppp38p156XAcxkxEdND9iUjoNGGo19BsmIjQQnVpSE3IJyh03//0El/0/Ke
	 9+a75/stvtktXbFDFNwMFlS1gXJNT6xX28R+ah3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 186/336] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:16:30 +0200
Message-ID: <20240514101045.623505873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 7fd524b9bd1be210fe79035800f4bd78a41b349f ]

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 941f7d0e0bfa2..23cc67f29af20 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -310,6 +310,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.free_inode = v9fs_free_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



