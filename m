Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC285A109;
	Tue, 14 May 2024 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687360; cv=none; b=DUoRKm+nAafy+UV3jogHP7w5GTNmbR3euH4FygRgP38Z1N3rvYc5GTn1LGXk+PbNO4MoSj72DVCJDfwUdds7yHvAwUF+EcIKH5U7B8MreXqiPEsAeHj6/Ekh92x03b+gwS7yvJVO018EFZJd+F1K2yfvMu/6+0DB5RVXdA6in/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687360; c=relaxed/simple;
	bh=jboB/+yQE/aAtnkQ8bd2eRgtXHlpkVPKuy5+tYIbZ+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXwWVPoJZ0j+UoZTq+o7XxFVCFRC2WrqpI+yjpAUdcapZOR4NX5+vjX6+4GisMHV8/MqdFfOT3MCb6gODUY6LmZuJeiASOf6VF27NI0oroAPs7jacOjH1AkohILo+//ObnJ9UADL/10KiRvxXHI1AwIOo1t90rXSAQfs42OgFr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5bMHyqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5bMHyqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ECAC2BD10;
	Tue, 14 May 2024 11:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687360;
	bh=jboB/+yQE/aAtnkQ8bd2eRgtXHlpkVPKuy5+tYIbZ+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5bMHyqeVS9eFZFaKIs0vJ+NCbyp5GR5yfnCpB0v7suUw4T6785gEE2Ys19nlHPgH
	 Ce3yv2txlc7xMHeBJz5Hmlq8rA1Oqd82f1XFxpkHtv8bA/ja6/CRURdNu1PF2jCSm8
	 abvg3YG/63gJiSnmJQEO1M0vfoZ0+PnPi6blyUL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/111] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:20:08 +0200
Message-ID: <20240514100959.795283856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 7fd524b9bd1be210fe79035800f4bd78a41b349f ]

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 9a21269b72347..69e7f88a21e7f 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -336,6 +336,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.free_inode = v9fs_free_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



