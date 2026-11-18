Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020647;
	b=l8RAIHtygifmabalVix37bp+SP6Vp6MfKZv0aQ5XL6LkU+P+nw6wWDx0raGfl8ONXu5B
	 NLcShPZD00aPRcujuyjUXdjWDXKgjPrkrnFUm4HZGQ/2pLFVvDve/0wolY2c1S1dSlYkS
	 DNrxgYvmMN5PT1WU9N7+MZkjXHjSShwEF6ohBn9YkegqnwSucj8yh2Hygoak1rkiFA7Z2
	 b964TZ/jYdCoKZRFnlT0Gt9dSvlUdhJRU9UJx+tY2cugo3K+zkTiNWolSpJ2goj0lz3gL
	 U27/jNMJLR6Ry+gRI9ETvodtsrnFI59isfdKQ06xhfHCKzkqzLORvHT3jkScnqNpiWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ilRGwoGZUSnPRU6gSlKaHotC5gkBqdA+a+/AyQD/zY=;
	b=bJfvHRZ059NwzDtJtApc/mR5+mtzfpIBEUwiTnFYWD4mjE4Z2WHrzRp9cjMqAaZBXirG
	 CZArUBMlYmkvmUcoHwa2VEBQidRQLfPkUyY9j08kAbSuWtVQfmlL55Efy9JaadGdV7n8D
	 n48sITp4J3p1+8DNIe4bJnVY2MW7bI99HgdzGejzYONnLTyqxyONuOSwpcNcXzzUsE4k5
	 CETNcnRWMIBhRUkR4OkHHqZ2GXVwHLruY2aM3GihhjpXSAXsqUuA1BOqdAvt7Xod+huIX
	 LtsJyv+g28rIS6iyupgfeaG7tCE/F+6gpm0uy0odOdr7zTP3Pm1q8Y6jIntNrZLcjrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPBpuXfi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E4F606A320;
	Wed, 18 Nov 2026 16:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPBpuXfi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FF1F000C6;
	Wed, 18 Nov 2026 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020647;
	bh=2ilRGwoGZUSnPRU6gSlKaHotC5gkBqdA+a+/AyQD/zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPBpuXfilZswzbLZYpO/s7lnl8BWNYXNaOASRN+Lvg6Lr8IFUUrnmRIrRf3VV71+x
	 aW2tARjEoLWVNALlxwt3s5XBUJmtqj3Io3l/+pkMpwvLbKu7uByAwipwDfRWHKhigV
	 4jg1wP2TBYi8PkHfOE08W3bN1KVjuTOXtizEEoDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2027/2651] selftests/bpf: Unmount the bpffs that cgroup_hierarchical_stats mounted
Date: Wed, 18 Nov 2026 15:54:27 +0100
Message-ID: <20261118150359.147031441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



