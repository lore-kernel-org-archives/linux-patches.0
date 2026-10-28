Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214700;
	b=wO3wPa+N3KPIblyH9IbP9TMMXchS7MEcNDMjBP2cb+UfwLvGmSyeM0O7EkByYRxBVrsu
	 y0GkTWImPjI4uHUaxOwzEaBsupoJHNhqkrzYWRKTwKHirpAQ8ufP4tOrhpphSdSd/VSvJ
	 KOxrckgEWDjQ7kmkld6JHD/DVMrM3ujEuFnj4YtBFs9ePmAc4BrQeJGvpWUljDK8nORca
	 ogqoG93l/W2MOTx6ZncN025Nh/BbGdOmqgJq71qROXipgNdVoqnYhfXpLPn3fIfs/RwS9
	 qhiIrCDIJf+SiRZiMdIzgbe0Sj94ix4xCpcFO7Z1yQxhr3gows6HqnzloaW+XXNYLvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wp3e3cNbBaccEPUrPNVoRY69mMbvHYz72yqs2PIewpQ=;
	b=dqxBTsfw0UCBJ1ewdHbjNc11KF6M8dG+u2UhRu2Rh+OFreqLr++Bu7WN/GPlwvw60yF7
	 8akxkf642XLXUiZ6tqE2VagGDr6HSNz8RwaXBbGc3vJVEJf2tnevacO0waJ6UjRJm7frM
	 GO/65EXyoGwep9oCY0ysnYZqmXvcKgT21z084fDsQr1f8cLy6mmkjrKFsScxayKusnBjc
	 M3/v5SM81B2kpkp74bMldhFzUVeggysnTPtQ7k+5Iuxf3FezR69fpX7YQtOCmg009lITN
	 iSnsLnaFrKRV8ARwDkQhEFQPDHyvFAGzS1ZjECGJjlesJhODLxr9BJokg89ExTiXojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UBt+/gu0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47931606BF8D;
	Wed, 28 Oct 2026 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBt+/gu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B461F01825;
	Wed, 28 Oct 2026 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214700;
	bh=Wp3e3cNbBaccEPUrPNVoRY69mMbvHYz72yqs2PIewpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBt+/gu0I272ZkwpONo1Frgv224AyWiHTUzE179nxw8mXpqeUkg1kwCBQ8OS/yWzX
	 xZHmxTLr0E9f+gWngC6+z2ncAGgfeMw/aoU1D11tJmWK+GEjL7JLUXiXqwSWYOaZTo
	 k5GHF4ze9oSEXE7reF6+f8L8SBYdg32rgJrfxFB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0907/1887] functionfs, gadgetfs: use simple_recursive_removal()
Date: Wed, 28 Oct 2026 17:50:03 +0100
Message-ID: <20261028170520.055361005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bad356bb50e64170f8af14a00797a04313846aeb ]

usual mount leaks if something had been bound on top of disappearing
files there.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: e5bf5ee26663 ("functionfs: fix the open/removal races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 3 +--
 drivers/usb/gadget/legacy/inode.c  | 7 +------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index e3a4d5819f004..42095e9b472fa 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1935,8 +1935,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
-			d_delete(epfile->dentry);
-			dput(epfile->dentry);
+			simple_recursive_removal(epfile->dentry, NULL);
 			epfile->dentry = NULL;
 		}
 	}
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 471f3f83753b0..9ef922c537b4b 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1547,7 +1547,6 @@ static void destroy_ep_files (struct dev_data *dev)
 	spin_lock_irq (&dev->lock);
 	while (!list_empty(&dev->epfiles)) {
 		struct ep_data	*ep;
-		struct inode	*parent;
 		struct dentry	*dentry;
 
 		/* break link to FS */
@@ -1557,7 +1556,6 @@ static void destroy_ep_files (struct dev_data *dev)
 
 		dentry = ep->dentry;
 		ep->dentry = NULL;
-		parent = d_inode(dentry->d_parent);
 
 		/* break link to controller */
 		mutex_lock(&ep->lock);
@@ -1572,10 +1570,7 @@ static void destroy_ep_files (struct dev_data *dev)
 		put_ep (ep);
 
 		/* break link to dcache */
-		inode_lock(parent);
-		d_delete (dentry);
-		dput (dentry);
-		inode_unlock(parent);
+		simple_recursive_removal(dentry, NULL);
 
 		spin_lock_irq (&dev->lock);
 	}
-- 
2.53.0



