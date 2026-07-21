Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BD6403E9B;
	Tue, 21 Jul 2026 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658101; cv=none; b=VAnC4PnAkGSiG4eUyc4jj/p7rFAk6PuNgVKD/+zdKoMbqFyRKMlEPGhspWSuOLoJAeSo299EndUax05mGbjeiN9Uilo+XceMe9QK8j1BNeY5XSn1qmz6TNulJHtwBXCMGYRk4k0PdDfuss5lvbor19QeGokIBwJSNV44Mnfp3DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658101; c=relaxed/simple;
	bh=b018cOMnmvkCElkVgxBoqgSw8tFKzhHnSwqsu8r7yqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCJAGWfTCsVSh7wk2Ut/U8Hp5HIHWxHCJOaAPkreEXrRBUPVZV3q61hDNCG2LSrxvpRs3h61NVG3sXEaaFmLY7D0KDZrXAFGFq5Hp6vlsjl/pfuGGrNLBc5o2Nnu732Gz7/a7mcywzKS7QIOhAH6MQoXD6Hye4lF2/t2U+dT718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvM+CdSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvM+CdSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2B61F00A3A;
	Tue, 21 Jul 2026 18:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658100;
	bh=U39qQrU4L7yOkSczUaA1/ztuBjKFCBx+4gmkZHUcsHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvM+CdSa4wCuepYrppRk7VX9j0Yy7CCqmFmsAgE/+Tnq7fNxWBEe76IoSzuLRrmtc
	 H6TdD9dr1sICguDR5HuOjUOjeYqs5/2Uv+/QUWPrWG47Qw+SzPgnAltL7q4iNMxG4L
	 cPFmrbukUXik8WNCB/HQ3tPvdcZNJnlzzmlLoD/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1014/1611] ovl: fix comment about locking order
Date: Tue, 21 Jul 2026 17:18:50 +0200
Message-ID: <20260721152538.202353064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e11f310ce092ad..1cc1b60fc70fb1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -800,8 +800,8 @@ static const struct address_space_operations ovl_aops = {
  *
  * This chain is valid:
  * - inode->i_rwsem			(inode_lock[2])
- * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(inode)->lock			(ovl_inode_lock[2])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  * - OVL_I(lowerinode)->lock		(ovl_inode_lock[1])
  *
  * And this chain is valid:
@@ -814,8 +814,8 @@ static const struct address_space_operations ovl_aops = {
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



