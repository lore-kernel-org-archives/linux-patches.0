Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831292;
	b=cF5rHzg3hARdGrDLwdOubP70bVHLvyw0nUoWYnZPSRWD94gdX0706nD7fOBMmrjYerAJ
	 QlI2UMVNGR5bg3cnAHQ4DbqjtreQiDEExLPN1+l8hNh3ijVJyTR2KesCH750JssLATSKP
	 I7KsV48RML6vHq16bCKAZDU7jJRmk7mzj9ZYKI+84PrmxcyKAsDejvSesWgP8QVztl+En
	 m5U83aynnC+knsbOIrr9JJJNn/1Lby0AueGaUzPjAL6FoctiaCh7DgeZ8/YpbGyIdHeA5
	 vP5y6TNqDvD+aCLBbKNo3BFUBLbM4xkJcgC7N+aJAt108Svzvg5Qae9eJS06nKRx+Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gl+LV55i23UwCzLTL+gWyXGUmjYLcwqiM/CbUZwSgMM=;
	b=nkgHwYYLgQ6DZsI7LJjb45S4QLXM/cJXsok8GMSX74AKxnOBFE+U/Vbup3kE8wcBdCAx
	 QvFJ1++sdqSo8gJvF6zLaBAyZOyKgx/8ZK6iXUJIVXusRlRayWtTz29iLuDJjg2cIVs2F
	 18CCLQNahdkT1u2TQsSiCeBi7tAdAI0AuNP3oOqEjl7XmmLHW1OZ/ei5Jk56EJ66kbYNy
	 +egp54wnlhyK/kWcSq5LSL1GnoI65i4NQzvq6uJDvk3OFTeKqOjfB+qrxFEdIj6esPs7N
	 YqfM/HXPdS8GswMOi94cZ3i+JEPR3Csy19vwYbEEyfn2Zfpqh4jer3kjipUqVF/o8Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lHl1XU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707FD606AC20;
	Wed,  4 Nov 2026 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lHl1XU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85A51F000C1;
	Wed,  4 Nov 2026 22:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831292;
	bh=gl+LV55i23UwCzLTL+gWyXGUmjYLcwqiM/CbUZwSgMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lHl1XU5Kh2GbVVgZVfimCH/Ugbmw+uqaQFgvEqVojYqr6lB9dpqFMB0d5nXKZym+
	 hgx80ZMg/C3sChSEW3EzWWGh0XXT/6aW7ba+h3szUSniWUJM8IX5IrFm6oUYbdf9Iy
	 7E8AX5FsIjlLd2OV+g1bH5Ivz4ml2m9qpG3QE81s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Kulikov <vlad_kulikov_c@pm.me>,
	Jan Kara <jack@suse.cz>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0615/1005] ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
Date: Wed,  4 Nov 2026 16:05:48 -0500
Message-ID: <20261104211101.061579375@linuxfoundation.org>
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

From: Vlad Kulikov <vlad.kulikov.c@gmail.com>

[ Upstream commit 7229d74e5e8c1f140529d405c88d4493e37ce4e3 ]

If setup_mq_sysctls(ns) fails after mq_init_ns(ns) succeeds, the error
path skipped releasing the internal kernel mqueue mount kept in
ns->mq_mnt. That leaves the vfsmount/superblock referenced until final
namespace teardown, i.e. a resource leak on this rare failure edge.

Unwind it by calling mntput(ns->mq_mnt) before dropping user_ns and
freeing the IPC namespace. This mirrors the normal ordering used in
free_ipc_ns().

Link: https://lkml.kernel.org/r/20251021181341.670297-1-vlad_kulikov_c@pm.me
Signed-off-by: Vlad Kulikov <vlad_kulikov_c@pm.me>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f0e48172a59e ("ipc: drop the mqueue mount with kern_unmount() on setup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/namespace.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 59b12fcb40bdf..cf62d11a09b90 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -75,10 +75,10 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 
 	err = -ENOMEM;
 	if (!setup_mq_sysctls(ns))
-		goto fail_put;
+		goto fail_mq_mount;
 
 	if (!setup_ipc_sysctls(ns))
-		goto fail_mq;
+		goto fail_mq_sysctls;
 
 	err = msg_init_ns(ns);
 	if (err)
@@ -92,9 +92,10 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 
 fail_ipc:
 	retire_ipc_sysctls(ns);
-fail_mq:
+fail_mq_sysctls:
 	retire_mq_sysctls(ns);
-
+fail_mq_mount:
+	mntput(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_common_free(ns);
-- 
2.53.0



