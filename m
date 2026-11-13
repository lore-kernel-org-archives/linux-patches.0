Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590722;
	b=W6m9iH97HrJGg0+c3SW4sC0trfUmmNPIV183mjdstZwkyfcigEXRlHpmlVpxGT4H5Ca6
	 qQvaAJ92euKK38jm+1m8+mY9MIKaqT4Wf0C3Vey0cblw/HLHVfRvapEOS8V/elCK7O3lp
	 K0+1bVN0szfAOuudg845aqPZkrdVKIJUJp/oWRaj9C6OQFE8dXIRrC0V4/gm7ivgz42aX
	 f//tMFadoorxp7713K4L1Xl6KITx5yJfin/DuJgrr1uLL54oiqPNEt6wS4iOZapukRQoA
	 yImMrFT3bXbIuvwzBRvqCrSiD5UDbyQWp/3PwAXMniJN3Uy27HYpOaxuWhwH2zIQjLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qMAlxh/9rVKztju8R63Ik4mr2bMf8OnV3Z9CuTnnOZ8=;
	b=DIs1nlmsfFfdc+joENHSwLgtmFyRc2quhcoMLJw5CasYYAUzHfItBp9VziDPdWz7e8dp
	 wx0lDfdFNtcDa18gTaNeygl1tcXjpp8dM+HOpc8gIaXJ3NUdF6FgXxyJGrZF5DYfi5mOO
	 rbHekYN95aypI3qWVvUqJ0wv3o/MpaRrQvGGP9SdGYgUlI0kGqA8luQnffY8a5dP+Ruop
	 irWmIt6D3iTABvWRjC86RWIXhw/7wceHCZGsTkQlVlUpwqyTCCN4oZtUdogjON6RDCI/k
	 qnFnfF2S1L6OM8/gfKzms4ZZlzEMhhbkXsMDJ30Lw6krzRVlyMrkg1faNvnLHzRp3dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNcWiO+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20012607A5F1;
	Fri, 13 Nov 2026 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNcWiO+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEB21F000C5;
	Fri, 13 Nov 2026 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590722;
	bh=qMAlxh/9rVKztju8R63Ik4mr2bMf8OnV3Z9CuTnnOZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNcWiO+UJwb2e89cnxJiOYhp9j1EsWabeNMdxKb9EyM3BZsrZXBvtkl/hBjIWe0Xx
	 tOeBhsCTU96BHCIRUnUmKXcC2KTLfbQJNaryxCae5bTtlHqXUe4YTxrZPpq7CECx0v
	 DEfQe62Tj3HKRBNsFnuTP8ad9Tyrs2Ho9S5yyhfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 628/686] fs: provide accessors for ->i_state
Date: Fri, 13 Nov 2026 10:52:41 -0500
Message-ID: <20261113153843.122929697@linuxfoundation.org>
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

[ Upstream commit d8753f788ab4916341d9fab81795be9f2f49c264 ]

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

In order to keep things manageable this patchset merely gets the thing
off the ground with only lockdep checks baked in.

Current consumers can be trivially converted.

Suppose flags I_A and I_B are to be handled.

If ->i_lock is held, then:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state  	=> state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign_raw(inode, I_A | I_B)

The "_once" vs "_raw" discrepancy stems from the read variant differing
by READ_ONCE as opposed to just lockdep checks.

Finally, if you want to atomically clear flags and set new ones, the
following:

state = inode->i_state;
state &= ~I_A;
state |= I_B;
inode->i_state = state;

turns into:

inode_state_replace(inode, I_A, I_B);

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 8ee09f597763 ("fs: rotate inodes whose page cache could not be dropped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs.h | 78 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 349b7fc57db36..09cbcfbf295f6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -759,7 +759,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -843,7 +843,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -904,6 +904,80 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	lockdep_assert_held(&inode->i_lock);
+	return inode->i_state;
+}
+
+static inline void inode_state_set_raw(struct inode *inode,
+				       enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum flags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_set_raw(inode, flags);
+}
+
+static inline void inode_state_clear_raw(struct inode *inode,
+					 enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+}
+
+static inline void inode_state_clear(struct inode *inode,
+				     enum inode_state_flags_enum flags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_clear_raw(inode, flags);
+}
+
+static inline void inode_state_assign_raw(struct inode *inode,
+					  enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, flags);
+}
+
+static inline void inode_state_assign(struct inode *inode,
+				      enum inode_state_flags_enum flags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_assign_raw(inode, flags);
+}
+
+static inline void inode_state_replace_raw(struct inode *inode,
+					   enum inode_state_flags_enum clearflags,
+					   enum inode_state_flags_enum setflags)
+{
+	enum inode_state_flags_enum flags;
+	flags = inode->i_state;
+	flags &= ~clearflags;
+	flags |= setflags;
+	inode_state_assign_raw(inode, flags);
+}
+
+static inline void inode_state_replace(struct inode *inode,
+				       enum inode_state_flags_enum clearflags,
+				       enum inode_state_flags_enum setflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_replace_raw(inode, clearflags, setflags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.53.0



