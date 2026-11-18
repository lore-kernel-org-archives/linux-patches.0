Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032325;
	b=o3RYkHOxRNi33cnpBqyLxl6hvuvJUyAp6aJDwxQvoU0DFuyj6FJBtDhK4q/JHgZ0pXte
	 MLAROtd7BcxE6ElOxzG9ajk/0cqUbw0wECoIX081cBjV9HWISJtd/4BFhEPgytja3kzoq
	 iRiIOvHVTxWGPcHL9YKSx6rfqIyoxMd59U+U8Fs5Go/n01qKH7iAIbTys2zE1vT8bjFPa
	 0LKqUKmpO7ZYQmveZh3TWJQty67iOBJ2ziAt8zxJmrFi/d8TRr+WD+JqsXnxz8TaPc+JM
	 5VyvmvsA9aZ8NwUifDShrfc7J9ogmxFrnDTKRPmU2iVO4i26rykWY5fpgzRkkEmxVTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5M+vZJkGthcHTrbOY0VH24tRvVrdaDCMMGocrlA6BZQ=;
	b=FYBLNIJYAb4foSk4M270dGx/GMctykJieFerCKGJw6MU470FE+kBf+QD+J6bxEYryzuN
	 jqENJvwuwdcCpcc8bxkrO/QsPGRPFhHUJLtbgL3VkBGNTrNGsMTdOGMAD6eXR3+UjHdfL
	 3LyA6vms+NB14CvaTHX7fV5Mf4KEt+o/A0q/b9BVrXOx9AdiY43/Ibk1EULE7EmdBOrJF
	 u2v7uQc4EQ9qPx5Lru/kJbDe8X41I79wb/xog6rAgWQ9xqyBDbD70Q+R2sNXddB6cGxjU
	 E8emBVnQCQGeF0SdMbyTiBgxt1hhi9l3/jErv1+Z75OGFpCcXE4i1TLnVpZz0CxWlhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6QJn8vl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8505606A31C;
	Wed, 18 Nov 2026 20:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6QJn8vl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE171F000C8;
	Wed, 18 Nov 2026 20:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032325;
	bh=5M+vZJkGthcHTrbOY0VH24tRvVrdaDCMMGocrlA6BZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6QJn8vlYimhqiYstZ7MyOMpyJbkWwFst+zxy5HlVfqFDi9Ozahc3YKjGg9dp7Ti+
	 fJo3svDrRSMORWt4sTFjnDT4UrjFwLrlgZNHCEGWuQuV6eNyheR2Y3dA7LNLOKalqO
	 kLF2YPGoCdZ+DehICPgSZtESV2SAsn/OA1mK0kxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1330/1756] selftests/bpf: Unmount the bpffs that cgroup_hierarchical_stats mounted
Date: Wed, 18 Nov 2026 15:57:37 +0100
Message-ID: <20261118150102.340961229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit e0645cfd0e1b2ae7b8ad989bef00a30016b16b5f ]

setup_bpffs() mounts a bpffs on /sys/fs/bpf and records in mounted_bpffs
whether it did, so that cleanup_bpffs() unmounts only a bpffs that the
test mounted itself.

cleanup_bpffs() checks the flag the other way around. As mounting on
/sys/fs/bpf succeeds even when a bpffs is already there, the test never
unmounts the bpffs it mounted, and every run leaves another one stacked
on /sys/fs/bpf of the mount namespace that the test_progs worker keeps
running later tests in.

Unmount the bpffs only when setup_bpffs() mounted it.

Fixes: 88886309d2e8 ("selftests/bpf: add a selftest for cgroup hierarchical stats collection")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20261009-selftests-bpf-cgroup-stats-bpffs-v2-2-f93a111da992@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/cgroup_hierarchical_stats.c        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
index ad19d6d41918a..cc6ab2c263da1 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
@@ -110,7 +110,7 @@ static void cleanup_bpffs(void)
 	ASSERT_OK(rmdir(BPFFS_ATTACH_COUNTERS), "rmdir "BPFFS_ATTACH_COUNTERS);
 
 	/* Unmount bpffs, if it wasn't already mounted when we started */
-	if (mounted_bpffs)
+	if (!mounted_bpffs)
 		return;
 
 	ASSERT_OK(umount(BPFFS_ROOT), "unmount bpffs");
-- 
2.53.0



