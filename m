Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035021;
	b=PSwNS8pSrsItnf21PWorG/LqGGL2rl/uuweFCukwl0pPeXNA7vq85Inj71eXSsyNbuRk
	 4IC/hlXaELiMzVAPTGt2n/E7vA1n6YUXipdamcAPoV6jIS2u2jWfoSfq12kA5hxyK8Gsy
	 DznbQZRnykv8sl1PGP12Fp9/aiPTUdi6xSi4sdpIXjlD2Ije6QnNeVFgTMMoqOV330amC
	 LYFz06/QRs6twukc2VPgQyxL9kAea06wavFWSyNHY6y4uRSczoR2bOIgvW1wMfSSjIaXD
	 OXKNj+P7JLMM+d55OOL3Dw59ZVt+KrQPiOUGBg9NGr4DiXqpEEOPWE7NTUdZGwAwLaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FF1CMqI6QESt9PpZcgoeHb4oG38O69LDv6wyGxuhD20=;
	b=3oW883RfZJINxQzO7JeIo0dmyXT4Cii+ek9tgByxBKDqdt2wnCxx2t9V4gpWJYixmS2w
	 9Qy+mCEmlyy46cqKEwWywGlnGfkU4NyqQmsmPW6hw44Iak/PXP70Ms9fJpDTVWz4xO2Oy
	 9vu39rZLR2U+GNYH8opMeFA1ZVqk+Kn2uBxeSwmuIZyZcjvb0XipLJOJr/QGI4vitGv4g
	 gNWnIOCBJpQSS/am0dKWzUztQuaWCXeXSoJ5WtYAV3Lw5Q3mTT6r6qibZaTfdGtDz5zNF
	 5Bl0mZuUWY/M9EpBY4EWfCxPInKk6TW6dex9x8abbCCs5Pjxdp3ABE7ahUCqi5G0GNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aahWbx5N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0655B606A32F;
	Wed, 18 Nov 2026 20:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aahWbx5N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C9B1F000C4;
	Wed, 18 Nov 2026 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035020;
	bh=FF1CMqI6QESt9PpZcgoeHb4oG38O69LDv6wyGxuhD20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aahWbx5N4kDHB3cqJTktbjWWM2zG0z7Zl+4rrdqfYwDraVE1/8+CNzoMqITRS1dhv
	 /j9b58HdEQpT7V7SK1HJYToY1UUCUSga+yov4YomZDPB7QJPR649GSC9vzb1RQUgpC
	 Xy7mq9ckJz3nPZ1PzQ1YIRkF1vTqg8uOygoBHI4k=
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
Subject: [PATCH 6.6 0540/3318] ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
Date: Wed, 18 Nov 2026 15:19:22 +0100
Message-ID: <20261118150333.467591894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4df91ceeeafe9..b93280de1dc5c 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -76,10 +76,10 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 
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
 	ns_free_inum(&ns->ns);
-- 
2.53.0



