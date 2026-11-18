Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059960;
	b=R5pxQlnt3zq+okbKb1FRv3E0HTfmCvhvl/7WPCkoxhM1IUl9dwF2rf7SIoIYIt82UTlO
	 9VLzTAvCylyoUb65CYTRGYxQiiW7POZGXflJe5lL2rGTEb3QBT4hsJ24B/NWvLqu+BAeO
	 o2YU/WeXDQAsedGHWzvPg9xU/fzP/1tuULoT6xD0HZr/zxMBxwPBv2EA5GlSC1vKNkjG1
	 YM5S73mBNNwcQko2D1hy0XavOLzq/PksiL1uX6m+stJb4QSbuk03TNnfqEQtEj52nemtS
	 llKEZ/dw9PtHexoKMrJO5FSl3scO1eVj4k+s8YTVyj29f0/Ygqv7oem3IFKxfdFfixQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QHnOgD2EoWnrV3y/JOLJiOTRf0/GuwUEhohX7gdiEZQ=;
	b=Qy6vJpNk8bj4HYdiDmvYVgP1xcmsr3CJWQH2MFhn/lCo7rwgvJl1SpsaBQ7x1hE9HKpZ
	 StgRBduNkA3v3iVK/Ee0vw46VxcbZr7oExytwC/VuIIHSAlb3KJnlWgW1e3lLgtlqSFWc
	 +u6ue1tt0aK3ErJd+w1pOzJc34O/q/KmbKZ7UBArLOPUPXqc57x294f3oZcKY10ZM8h/b
	 46XfGV2QBwKZShk7Y7tYfR4DTZ/ZvyhosCZQgBGMvbW8yAl8nYVNvryKt9JSmubKPDyQN
	 OAXZZzT/Xf75MKDjv1MC738kzWcivq+L7/tKcN+Qg+mQLZRaZYe1QPsLAvARkH66rAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9cjjwtL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAFA606A320;
	Thu, 19 Nov 2026 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9cjjwtL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272D01F000C4;
	Thu, 19 Nov 2026 03:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059960;
	bh=QHnOgD2EoWnrV3y/JOLJiOTRf0/GuwUEhohX7gdiEZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9cjjwtLwbn1HvmSXllKgow2mDLAmZmTE3Pq4DyzT8SJQvo4VvPTB5bHPG44+M0TD
	 5tb2aldYN4vvpbl9rtoPcfC+IjaQWuoPHhxlw4hvTbJ/00iiYkmwHwgOGfvg/i6NjO
	 e/JGYLRj43mfsEJLBRzC4GEwLmNRSyiB9IBAnnGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1029/1848] proc: add proc_splice_unmountable()
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150000.477761511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e601bf77a5f80..e35e28415dd8e 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -331,3 +331,16 @@ static inline void pde_force_lookup(struct proc_dir_entry *pde)
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



