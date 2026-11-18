Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054289;
	b=fZu3pEcu6CrXdnVLLq7BoidxCtBUAsTTV9MBqSfTlRABf0kgFZ+ih0cFzWXSaqszNjTT
	 27f1QhMssSJgrioQ2H4YmNslDT/ZuEfO/sz4nEHGw8ckvUEmhhfbyJqmSjDE5fvFc05z+
	 MApqZ13vSwUgkZf0y4SPDgb1qkc22TNCGEE1SXz9ONxYQKDK3umi6JP6zA1bKMZDeh5bS
	 2mhFI0w/fPOD0VbuqquBexYpNrdKwmLsjpMMz/UpOXlTeBp27fEPGOhsntisJU+mK43uY
	 rrwOMWHTQ58KPHKsR/6CK4UAq6eFMty67X9yeOKeLDbN0Ys8WyTeW2tv2KF4S3dJMWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OyqYyZYC7yYPq/JxLM9yGcyKAmNEAvZrJ68Rutn5C1s=;
	b=5J6HU2JSwA/K7vdgr6uj4jZhDbL+5mii8FSUfewEJjlQQVH8yOmS6Cg/wOgIrAvkVCBN
	 h7ezzLyDenUGc8rGb5uH5qyZ1gNQAtxfXKW2G7k46n1+eOKfiv9TT2qL1P8Yvblk4x9++
	 ZWoiKvkjNi9B2yOPQMs9CJx9N2TX5pfce0M/ggo21IGC4kW5i6O4Ii8MHmHy97PRF988Z
	 YtQxNcHMTiV+BgpJg7C8MydXtEIZm3H7PYtAlqz0HjMVZx6bGVoKNqEM0X4spY09zCJZS
	 BSpCIJwY8sMzE0nl5nf+NnQ/nibGbg/Zv89vUU4K/FfS5UvxbYZ0oWuGtFhZSavFj7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOLUTtqm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFAE606A320;
	Thu, 19 Nov 2026 02:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOLUTtqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30341F000C4;
	Thu, 19 Nov 2026 02:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054289;
	bh=OyqYyZYC7yYPq/JxLM9yGcyKAmNEAvZrJ68Rutn5C1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOLUTtqm+nywU7qwH+zH2wp9ba16EbQbseS4iNjl27huJr118+Z3hiLl9XkBNEEtY
	 +zWCCxKxoChhEtKLuBamT/zwKQDlE1vLSjLlF869hECgSqU3O/kwm88OsLI2gg34Aj
	 70Crx3W5vg6ZJxq4Xgaa9cN654gF9y4j2jiKvsbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1222/2214] proc: add proc_splice_unmountable()
Date: Wed, 18 Nov 2026 15:48:18 +0100
Message-ID: <20261118150100.659053004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 32a0a965b8a5b7b505babae2ee10c513ede376d8 ]

Add a tiny procfs helper to splice a dentry that cannot be mounted upon.

Link: https://lore.kernel.org/r/20240806-work-procfs-v1-3-fb04e1d09f0c@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: eeecea75ece2 ("proc: don't let an entry below /proc/<pid>/net be a mountpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/internal.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 9c4a5540296fc..2c652681172b8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -332,3 +332,16 @@ static inline void pde_force_lookup(struct proc_dir_entry *pde)
 	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
 	pde->proc_dops = &proc_net_dentry_ops;
 }
+
+/*
+ * Add a new procfs dentry that can't serve as a mountpoint. That should
+ * encompass anything that is ephemeral and can just disappear while the
+ * process is still around.
+ */
+static inline struct dentry *proc_splice_unmountable(struct inode *inode,
+		struct dentry *dentry, const struct dentry_operations *d_ops)
+{
+	d_set_d_op(dentry, d_ops);
+	dont_mount(dentry);
+	return d_splice_alias(inode, dentry);
+}
-- 
2.53.0



