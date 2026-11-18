Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041897;
	b=VtlVIPh61UTDKDM6spVvLbKz4L+kw8kjzBc2ejZ7K6dqLA6y1GJ7dUyYXgeyR8roHQLe
	 a8IQidXbTpT/DpVStYa8NbLo1ZH8JbkjMTVJCdNxSlPDz2Fw9MXJMGVg9gZ9J6N8B499p
	 R6LLMA09U0kY8hY7RtBrpkmfGS4w/PGoDp9ygsjosF2j7PqMwc+1x9MPKJxBePdQ2wol5
	 /a963X5t1zNGfnlOnbvWb+PoW+4kZrPC85R90+/03N+qpJQZt6r6Ue1dwYYXkRJqaqXcj
	 XmKkpi+KQGp/X44h0MuCqZU/NmD5BNVBYs3p/Ynhq059oNAfNb0TEbLlM5L7sgYzHTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pju23jzLvGIRnHP5zUqsY6+KmMBWcZlgVVbV3KM6vx8=;
	b=GsUz+G6Ij4BVAK/DVqMQktebGnF0HIlqflm1m/jqpQ/3AjcxCZZFHW3y6+vICQdFR0aV
	 yTm0pwgEo08tSpeiVQkxtFDuNwEP1L9QpKnUrOpYc+bcGF4Ig4N9E2xjUwsPUgq3RKC/k
	 8f3ao4OQs9byPfuMOEv6AzEsFZEX3VaA1CSE7kxMilIPwUn6cTeZ0ZhSAjT3IVZuoRuVA
	 b/9erRSjhXmZPk+82Lzu1meQcKIFE2mjno0WJazX5EIPRVp/jn6/ZOtJ/E247gsvYPfaf
	 nKq/fB6/gUD3iCdPCgrGYJKFZpSUIZnoAeOkL3lTNyKyIwlOcLw+5m7HsdDiP15ep9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HoXbH9/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E2D606A320;
	Wed, 18 Nov 2026 22:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HoXbH9/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BD41F000C4;
	Wed, 18 Nov 2026 22:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041896;
	bh=Pju23jzLvGIRnHP5zUqsY6+KmMBWcZlgVVbV3KM6vx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoXbH9/Db0B25drujX3OGO3YbF5ft8ihA6bNj9sUPhdGThegGYHebtXCZqQCwRBWs
	 GdCNSlLuvzJCntHQ498JMINaGsNYvMsCZ6H/LKFbnbMTYFGPVQ1YJizYi+ExXpHtfT
	 NJUMtq/sdpgbaJzYOr5b/rVzQw1+w/3qtPpREtGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2975/3318] selftests/bpf: Unmount the bpffs that cgroup_hierarchical_stats mounted
Date: Wed, 18 Nov 2026 15:59:57 +0100
Message-ID: <20261118150449.532382787@linuxfoundation.org>
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



