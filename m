Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590719;
	b=rkHa13a4pBjNbPJXq5iXpRxzPqLvYlRCxZ9uC90QhDCMlISvh/jG0E9xb4GdxICygkWh
	 XzTaKvnYSAuFgP11pQfperXXBXfL6STMIKkUod1KX4dQcwCu2OaW3cPtygoySIWRTLwJB
	 DW5/Ynlwq1Q+YZTVi1gcupii8dVpGGO6ysMgybAKZSIZgEuiuH7EewRc8jU9YHY1dOsfN
	 GAChRdwlAp3P+Odl24LgABwq5yDc3PUr1OiTq9tNrLGY9KYJKGvhK2dHBh39wcMOGY3vd
	 XReFjLJKHiAnac+Xv6pw7fisnQGKB0/wYhGcfxhNDVIjAUXLmAHXE4G8zVPoZdV3mJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iearYVedxj7PKxonXBz8pOZwTac/PdXvPsPk/RNWY3k=;
	b=y7f9ajfQlnRnP/7SlMSzNrv1dmOLsP40rHx5o9ZGCYQtNclfB7fR9qFJxIGD+quku643
	 8OVCJln003N2tB4kCGN10bnQ3vnDbvpbW4G1f2XLuubkd/c/D4Y+PzLekC1Kn0thZxFjz
	 Og4z04ZlzsGFh6ILuwQtApjNmRa2ZVMlKwVsr3zqputK/iIvIcJkuFPZNMYqU3gILVaH7
	 g8o5UKu9lMIO5MOGlJvORJO6DtMRp88GsPtfPiYpu6C6/iqS3pmXKekXT4EJAPQMAcjqx
	 FOMdn8Hx8iOywLgZU+KytregIohtcHYwsbOuzXkLKRSsIflze0bS7xFTmlfT5gJw38A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGaZcLuX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAE2606B23A;
	Fri, 13 Nov 2026 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGaZcLuX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1A31F000C4;
	Fri, 13 Nov 2026 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590719;
	bh=iearYVedxj7PKxonXBz8pOZwTac/PdXvPsPk/RNWY3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGaZcLuXYL4+XN4D+TLpm/F+kCr0LUfpID6sW/3Yf+82aDL3uPQw25203uwIo0pvW
	 JIZhi7zfryFYAk6oSCvuzrGLnQCTCEI8HUx6SHns7uywjSXC8NmHVunXqS3evBL2DE
	 UyBE+/iDW4d6ZpZYsWmwpcCXRXYDcmnXEDOKNPQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 626/686] fs: add missing fences to I_NEW handling
Date: Fri, 13 Nov 2026 10:52:39 -0500
Message-ID: <20261113153843.062834922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 31e332b911fca54df467d264d7e2a2ef9317f3ca ]

Suppose there are 2 CPUs racing inode hash lookup func (say ilookup5())
and unlock_new_inode().

In principle the latter can clear the I_NEW flag before prior stores
into the inode were made visible.

The former can in turn observe I_NEW is cleared and proceed to use the
inode, while possibly reading from not-yet-published areas.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 8ee09f597763 ("fs: rotate inodes whose page cache could not be dropped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c               | 4 ++++
 fs/inode.c                | 8 ++++++++
 include/linux/writeback.h | 4 ++++
 3 files changed, 16 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3ad74a3abf9ad..84952f6bbf406 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1995,6 +1995,10 @@ void d_instantiate_new(struct dentry *entry, struct inode *inode)
 	spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
 	WARN_ON(!(inode->i_state & I_NEW));
+	/*
+	 * Pairs with smp_rmb in wait_on_inode().
+	 */
+	smp_wmb();
 	inode->i_state &= ~I_NEW & ~I_CREATING;
 	/*
 	 * Pairs with the barrier in prepare_to_wait_event() to make sure
diff --git a/fs/inode.c b/fs/inode.c
index acf09822535ed..7adfc787e934a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1177,6 +1177,10 @@ void unlock_new_inode(struct inode *inode)
 	lockdep_annotate_inode_mutex_key(inode);
 	spin_lock(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
+	/*
+	 * Pairs with smp_rmb in wait_on_inode().
+	 */
+	smp_wmb();
 	inode->i_state &= ~I_NEW & ~I_CREATING;
 	/*
 	 * Pairs with the barrier in prepare_to_wait_event() to make sure
@@ -1194,6 +1198,10 @@ void discard_new_inode(struct inode *inode)
 	lockdep_annotate_inode_mutex_key(inode);
 	spin_lock(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
+	/*
+	 * Pairs with smp_rmb in wait_on_inode().
+	 */
+	smp_wmb();
 	inode->i_state &= ~I_NEW;
 	/*
 	 * Pairs with the barrier in prepare_to_wait_event() to make sure
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 22dd4adc5667d..e1e1231a68303 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -194,6 +194,10 @@ static inline void wait_on_inode(struct inode *inode)
 {
 	wait_var_event(inode_state_wait_address(inode, __I_NEW),
 		       !(READ_ONCE(inode->i_state) & I_NEW));
+	/*
+	 * Pairs with routines clearing I_NEW.
+	 */
+	smp_rmb();
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-- 
2.53.0



