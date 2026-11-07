Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061453;
	b=l8UXeX/lLlRQSv4flP4iwfKzVAn+VYPRzNUwmC6kM+cWru93PqygW8y6V6uR8B6x23Ub
	 gVXjerbGmQL6vLezjAbK0pPOW+Vk5lkN2u5a3BMPElTgaG9/f3bOAEdWv8kcggt5IPhCN
	 gU6ZAvTtyWPaHblUz/jw8C7L8bLgPmuUpwLj5Kkjlxe14PmV8xECXNmyfljNKeX74xFpD
	 lYiU4a4Gt8c5k+/iZHymQfSCsFRjF909Ccm6Ypt7FxSOHU5Wo9I6Elk2j4VqWbi2uYNO3
	 Wo0ZpP/SSPfBEVYR+uKIOlMS87DzFtiHqR46gIDedc0XeiO7LhulIMaGTGJhcfo6VBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVvE3TkZE2lmOjFlaMZewf4y4EwB5MMGhKKeK+xH5pE=;
	b=MpX2IPnU9gZ48DrBl09et5DyZr7QLmRVD5EblqnXf1vOQKDuDE+rxv+s0e6Ky3TtSUuQ
	 vdC//MH2HLN2iaSlKkk0QulIZl2RPZYVdXOXNvc/3OIWjXfMho4e895Hw/4f+4WNMY4ui
	 X0mCCvxibgYlWdQuCYze1TKrnx+tVZdkBZH/ltsaVreiniLzBgA7wiOKpu8caBvW70LLs
	 Ld8DvK/4bwtHCyKculXLjorS7WGnf3Sj9bc5A+f6qHYHet/QuNOtbmlTx5g6CbVE66eVZ
	 iO0l83J8admTwH/b4Ni7hnRh5IuzC5Sk5oTZ76wZfY5xehWVr00R/8t6jWa42DcmUKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7mlUu2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E59D606A331;
	Sat,  7 Nov 2026 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7mlUu2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACC81F0089F;
	Sat,  7 Nov 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061453;
	bh=BVvE3TkZE2lmOjFlaMZewf4y4EwB5MMGhKKeK+xH5pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7mlUu2xS6tmDuPBMCzz+Y8iqFX8G+RBCliztWqg0ii3fVCJhYJUvGGI87YjAh3Md
	 K0UjKITMPCOKh+mdeXdeN8NOwF9pb8xKhNoVbLQ5Zs4RnNAsrVqWH3r3Wf2LHNwW61
	 8B58LiN+j0k8qhauBOt/hA3zXT06HJKdeUWBshTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0558/1536] ipc: drop the mqueue mount with kern_unmount() on setup failure
Date: Sat,  7 Nov 2026 08:42:54 -0500
Message-ID: <20261107135013.260017610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit f0e48172a59e517e613b73f73cc35f24fd123aeb ]

mq_init_ns() creates the mqueue mount with fc_mount_longterm(), so its
->mnt_ns is MNT_NS_INTERNAL. When setting up the mqueue or ipc sysctls
or msg_init_ns() fails afterwards, create_ipc_ns() drops it with a plain
mntput(). With ->mnt_ns set that takes the fast path of
mntput_no_expire(). The count drops to zero and nothing ever kills the
mount, so the mount and the mqueue superblock are leaked.

Commit dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
added the first failure path after mq_init_ns() and never dropped the
mount. Commit 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on
sysctl setup failure") tried to fix that with a mntput() but that
doesn't help for a long-term mount.

Use kern_unmount(). free_ipc() open-codes the same thing for a namespace
that made it.

Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Fixes: 7229d74e5e8c ("ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-5-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index b93280de1dc5c..e703b23127916 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -95,7 +95,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 fail_mq_sysctls:
 	retire_mq_sysctls(ns);
 fail_mq_mount:
-	mntput(ns->mq_mnt);
+	kern_unmount(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
-- 
2.53.0



