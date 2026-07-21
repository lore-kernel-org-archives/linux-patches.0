Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE58C3A4F4B;
	Tue, 21 Jul 2026 19:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663343; cv=none; b=SmzBs5oqsnKbh2U+TB11MUyCn+B9EhdaS7lBRcy3/hEH2iV2YWFZwatd5636DVYvbF4fcvp+gsIOvEuy71qpHgz+acX7y4bbqF7mrq3GEiJYg8X2YxkPm5TSd7EJdXcAxIO+PNMqHjX7Of5/ZnV7xTL555nYUfbiwQ+kOuNaALw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663343; c=relaxed/simple;
	bh=OBDHFUh8yNf+PCOzXRiBC3xqok7YOcTEGQ2CXiWp6M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYJy84OPq2tneVqKS3pM7E3290BDFmmGi4CjK0Qo5E0e3Zk0QLuacBSAItTf2iA7Peu1DM9a7RPU/1Z52ca5CdZAegt7+VgIkJpPTv+yQwYgnrAJnMeXpCIU0AwK7ZgQ/nCpEEeHlisB0BWlrrlpzFxp0KWuyrLF/olLfFIE2f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4b8RlA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4b8RlA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD211F000E9;
	Tue, 21 Jul 2026 19:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663342;
	bh=ROs6bN+h/oIHHiYEkpo8/Ze9hjSTUstHm4C1SCtRHuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4b8RlA8pw3MzGDuGueUpWrs3RcPlceGwsYgUIZ33Y6gc+wMsmeyfxd1gT+SSV433
	 yZJEL6aQZZi14qvFa9DZJAhU9p7tlVpCgAJSO7Ba1HByrZCEtseVsSA47XyR6eH6oW
	 8T3RUcbzd/2bRnsGdbWk1EL3bkVlykg+ssFguFfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0744/1276] ovl: fix comment about locking order
Date: Tue, 21 Jul 2026 17:19:47 +0200
Message-ID: <20260721152502.730956625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index baa54c718bd722..14b06060db4b03 100644
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



