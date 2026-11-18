Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044225;
	b=IBoxCZN9EGL5Hz8nydB9sUEk3U3KPh2GlDz47fRAF497hVcFkB2rnGroLzuVgungPxCa
	 bPJEgXrNffAgwoxzviCfzMuKbVny4if1iugFPBTzSVy1r2ecAyiE4ygA5s4IUIL1p1fGH
	 3wt8JwFjllIUAth9ct+fCBYzbMOUw36CMHk/FO2TOt0zWGehdGTajcndjTtmUstIUH0KZ
	 oMUQUDy9OjAlBXDxoSbbtE4vlG5rYRU1RmUFh1VivxCDWF1NgMBWrEAXGuxb/UpkPDxaC
	 VPOAibI0AI+7OQI1WAqlL4bqpRnclNREMY2QfVHc/TMBZuIXBFVs9YDfq5MIkBv6I5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gbTvhCHGJ2dibuv+ffo85m2+WRgLAR90+L4tJsPHWG4=;
	b=XiDwxtSYyqX16JYcBvWDdQuTddMQo0b6DtJS52MtmjgYGplJfQ6Tu5rwciUH8gozeTZf
	 LK9jKfkocpbXj4349rgUdLvZ7OiifCxF0W2y7kwWdC7yKcg6U+UVoKgpK2ewWEbv2/Ah+
	 +VQLdd6FShQ+4CTtNckVguijZznuXqGAodNCuBeFZbqH1ksZQV86WAmfoTVNi3j/OXEln
	 P8MPA7JENve2Dl/wgILQmYX/fQxOEGx5hv75qafvFuMtk080XfY7TPrg2XQvdBQDyp8hC
	 fIG3V+ryFsWI0nOudciI2gZhVvOtVUicmTkJjFc1DPBmmRChyNK4Rv8iHSA8ZFijohw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1DgqUQS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC481606A325;
	Wed, 18 Nov 2026 23:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1DgqUQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F2B1F000C4;
	Wed, 18 Nov 2026 23:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044225;
	bh=gbTvhCHGJ2dibuv+ffo85m2+WRgLAR90+L4tJsPHWG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1DgqUQS2tSljbMoUqWqN9+o+Mto2jWpvGBV/d9inGPVL5RcCow2dOpS2LaKms9Uw
	 8TiADF2VIIjd95zQ+08c5VopgcYmLadRQbHnHcwDhrrsG3qlRjqu1E/kiYE1vEiGMX
	 e/xvPspBcznrbQH4/LkV9P64L+eKt4VkJ4X5gxm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0492/2857] ipc: drop the mqueue mount with kern_unmount() on setup failure
Date: Wed, 18 Nov 2026 15:25:26 +0100
Message-ID: <20261118150219.168619315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 745826c9206bc..58be7a072d19c 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -80,7 +80,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
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



