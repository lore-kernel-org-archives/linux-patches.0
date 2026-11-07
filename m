Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061452;
	b=BN9gMPv8ys2iTehTHleTffi/1OX7Cq7wCMVhUyxwCIJTTY0G8E8kIMrKXgK2bF0Qg2ov
	 7Ur+QbthzbNuwfXSUIWrKbbVYOjjh+ZTPXLmx0c/izHT+Wk0KN4phi0Kr8NzPvuwMB9og
	 DbkeAWCMM5eAmjUtG/aH2OzolqnfOmq2PriCq/hJ571qzVxiEgbdcwf8TMiQifS0mD7m3
	 2H2iiz+V2UWhOXS/BeM/jyyxeEuUrvNu9OuH4DzicoYeb60eNjeuxSPPLYJHeIzBxRNZj
	 BeIVTpaeW8Z8bRjfUmwNWlg+ylnlkAU7HAdQfb7h4Mz/jOXf4/mqnWOZLKG4OZuz+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sARE+m+vUeVfAjnKJlFcWDdT6f9hFAMia41NZA+4rfY=;
	b=DgqZfpcCXBQva69NO64HqiVRJSY3WAjxbo1+uoaZdZEDvsTJQOc4tjv4J90pAxD0kBQD
	 ljB9YY7MkJ9PYjDyzcU3Mq9wBIr1UNnLBOGuC9D7pEKdNkBDvRdK0uPvDVUTkjMUMfjWh
	 d/UahjRpKE9S1HsHhxx6X937UckOvZpojctvxthhfd77OXy4wI/o/yOyXdzXa6qcIVC5z
	 F+lBZ9bolJHrTv4nNji4jKAPwdnnb3PNdT/gpEy+NzkAGAi2A9BccENFugFpgiPzOjE5/
	 X+/DfkmNMfbebPO6bJ4TYoYG9VG21nkxn9VGH+EIVmBar92BIBh6cazXKBc+990ImKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tr2pJiXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A9F606A331;
	Sat,  7 Nov 2026 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tr2pJiXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191711F0089F;
	Sat,  7 Nov 2026 14:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061452;
	bh=sARE+m+vUeVfAjnKJlFcWDdT6f9hFAMia41NZA+4rfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tr2pJiXqP7byAleRF+GWqFZaWr8JAe6j1YN4Rp6ewyfQvV8zIKfUe7Srs7bwDbv6I
	 SSnJG4ECs632XEWLrW267ydsuXCH4d5FdA+ZZVXE0eChw2zDcGPgR4JlYKsle91C2L
	 eHa73dfHFWOm6pRWcPoWxdoO8yEHHQqQ82T6UjC8=
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
Subject: [PATCH 6.12 0557/1536] ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
Date: Sat,  7 Nov 2026 08:42:53 -0500
Message-ID: <20261107135013.233055428@linuxfoundation.org>
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



