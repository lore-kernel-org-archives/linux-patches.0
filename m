Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8852E3D3337;
	Tue, 21 Jul 2026 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653606; cv=none; b=OXBeqI668MpcmfEEidRh1RxOIe+2cVAum2xx4UzCIanolv17I/xBYl62kcELTjsF1DDtcKgXSCc0jBPRhfGvLs6OZ5eO7+j7zN+/fbGyU09AaqtPJ+7x4kjJlXpzwL/KSD49+yk5k4bZGfrx6qf4IvLn/QSNtRe1crJ0vAKOTjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653606; c=relaxed/simple;
	bh=Fd2mAxdE3XQ2Nk0ZcKeoXC2P3TNSBQYlLgq6fdC9oMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNaMSPYW4vyfT4Kd+Q4ljG4aPtx28j/Bu9ehD+yVHzs/c5rCm7J3QkWptCm89dacbx2dFdRHuVfQif2SoK3n3DDCSUG3YlPpanj+FVLJU+OkaeKgjwEgNb4khjjd2Vnk0F7v0qRBFciv+AoHhBmdpbMF/cyG6PRQxEKaTqCq1jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiHTcAfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiHTcAfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D671F01558;
	Tue, 21 Jul 2026 17:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653605;
	bh=BPlA0eWqYmR31sQx2ffy16VpMsWtPFf7i2C/a5MTAyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiHTcAfpbqTVo0fTvlnqFCruGvPHmshKrh5wMvP8TAj9Frd47ekVCL8x5L3zklMPK
	 0fQG3gmhktJpZqTUpfP0gIBpWIcVVoGCUNYUjOrGX5QEVhoEPhQc4HBimYpRODUM5V
	 Y5Fz64LqsiNKq830HJG1KB35Uk1UuvKkB8N4k7uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1391/2077] ovl: fix comment about locking order
Date: Tue, 21 Jul 2026 17:17:44 +0200
Message-ID: <20260721152625.621949358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit fd5637a2fe6dd4448392738691d63e5559fafb12 ]

Forgot to update the comment when we changed the locking order.

Fixes: 162d06444070c ("ovl: reorder ovl_want_write() after ovl_inode_lock()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260609184656.1916631-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00c69707bda984..bc71231cad532e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -783,8 +783,8 @@ static const struct address_space_operations ovl_aops = {
  *
  * This chain is valid:
  * - inode->i_rwsem			(inode_lock[2])
- * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(inode)->lock			(ovl_inode_lock[2])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(lowerinode)->lock		(ovl_inode_lock[1])
  *
  * And this chain is valid:
@@ -797,8 +797,8 @@ static const struct address_space_operations ovl_aops = {
  * held, because it is in reverse order of the non-nested case using the same
  * upper fs:
  * - inode->i_rwsem			(inode_lock[1])
- * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(inode)->lock			(ovl_inode_lock[1])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  */
 #define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
 
-- 
2.53.0



