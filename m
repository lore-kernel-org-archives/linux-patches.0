Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831294;
	b=Z2MtXLAGvn21iDfKkll/UaFEjgFVTV55XmCeK1M+NxUCLYbARUGcEkf4ApXVUa3EcKuH
	 bufuqMNozaPrYk++gz4iItjbdGwBEW0ZDPKPOUEjdSRcZ6YHVjWWshvuEG6HuivqyDm5f
	 fkUrdh9kmV6XkcayHV8lRGLtmL4Voi3AfHWwLE2NLrnbuTH/cR9rHtpzCFR2DFJx28BcA
	 4A5UVF6WA65phA6UiND3OYr5AegH02vRKFI+n9oBQYbq2x8Ek49b5zeP/ND/spyLwuehX
	 5yWN8wOZ+hnFf1JkL17RPJMrjabUkhqaDTv3sCgON/aozuGcHR2M7TJ7rHfq05dNTGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1srtMi5LBiZ9wnXpvGaJQFSGsoDlBYBnKNe5I6oVt8o=;
	b=Ee5yTZelfHAN/ZbericA0xTsZ412nWBL9OOhXh5fRojdsByT25Z5yKgoK4nJaowf9VKX
	 X+79DtcmboZfcrI3R8dmy05OKyeAHy1J9ii8DA4tPnPOTJn6/ZTFVgb1JiiOpUpHCTlMI
	 SJ8NCSpkQuokemLu5mVzYk1QqDR/usw5iX2wc3XjSwnOjKU6m/PBqW9PSLZe3x3YQh9jU
	 gLO/d1EBPfLG2WEmypmtJIXZXmU6D2W38U3tuFc0CG8NeoVvMro5ZxlqPqldFSlgq1zsS
	 B/4AeVWi4SiXSYZvAPEH6GbGFy8jxhrswtUHfdxNE8HQTt0GHpcmvDBMFHkuGHN9qTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jd0iwPkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3157606AC1C;
	Wed,  4 Nov 2026 22:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jd0iwPkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAA81F00919;
	Wed,  4 Nov 2026 22:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831293;
	bh=1srtMi5LBiZ9wnXpvGaJQFSGsoDlBYBnKNe5I6oVt8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jd0iwPkYK6RsW5qJmT+oYr8BPepPWHPWNsaaOZJD5lLfCpSVO0JJZFihHK5kuoOxw
	 n3GNnTejNO8a2D+kbatmcdZ8MyzqbUSsWGmwUc5XwSrpL9kD0CUHiJGoD+AY5Y3sPQ
	 tCK1wE/w2stYywPZYaoBPOaCHdYpMZY2yszEp9Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0616/1005] ipc: drop the mqueue mount with kern_unmount() on setup failure
Date: Wed,  4 Nov 2026 16:05:49 -0500
Message-ID: <20261104211101.085631709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index cf62d11a09b90..7aab1e6e0f86d 100644
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
 	ns_common_free(ns);
-- 
2.53.0



