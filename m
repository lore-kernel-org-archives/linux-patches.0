Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027095;
	b=jKCpp351IYXR3qbNCckyuImYGMwmqd3giuJOcwOzrU2/O5+4lFUFHJs5n63aK2KdhyQB
	 U8iBnCWgQzAd2VCj/sud/L3PpCegp0Gogls6g9aVfjXmOMjnbGiiztdA36f4kawX5/wkx
	 7ueesm3l3Ni6jX0LGr+/PeoHGSWZ0HlfT9e5QaSWmCApew+48lXb2w43FjnMnE4SzGz0h
	 sdG5mDGPw6Ju40FktFilY/zv1fNsWc4uirBLblVN8ibksrJTnVXuoutcD+iqkTWIf0KCP
	 kWOa8wqGvugGttnutR38mkj0/gp4yjpJWV8CGQOVAUJydHjZizHATjjwfuONLihp4DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pvUmchdl6B7yglL7gM2ehnorEroqGLHdfX/3+KRRY2s=;
	b=Cw5tWuE3mkwCCG1bbxIBWaIogrEQtmt+1Nd8gO6SaMPWD6cxX9uIeuOrz022DjewWdg5
	 YXrtpFgFuhHO8RYHqBJzwCar2bYyz5xtx9AhJjY+2yKxlMUwciibsUdUI6Gzd2UwXYfZM
	 5JMGiKvIXA6aZm/pLj9onsgXvybzauxZM33K3tTX2+DxzJMdyMv6XMdVsCxTQjdBRIaTQ
	 AQjfIZQCh9s34+2vwXKEsh/RaIETlZQA0wygBJ3bLM+ytVypFvCshvQsRzG5nA0zGFIkw
	 e2KEuwlB+8dU1S68camBvvechOhzM2v4vR8B5kBiFi0ucAOo8Sousp1tnZOawQNINSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xz7lcv8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660BA606A32A;
	Wed, 18 Nov 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xz7lcv8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C971F000C4;
	Wed, 18 Nov 2026 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027095;
	bh=pvUmchdl6B7yglL7gM2ehnorEroqGLHdfX/3+KRRY2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xz7lcv8fFVp1OM2ZN7Sf2MM7EAQum8Ewk6F0TDiZPO5lXMQKTrTNYLNX46jVHQB/Z
	 +VvsiBnVGrP4voYATKZ4/GW0arD0FMnY5ok/zShwilJigphx6OzNlDuw2wL16P1hEu
	 sE8vt22ZtxUvLCsNUXsxLm2O9zwOM6/ohxjoFjlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1668/2151] selftests/bpf: Unmount the bpffs that cgroup_hierarchical_stats mounted
Date: Wed, 18 Nov 2026 15:56:43 +0100
Message-ID: <20261118150222.601139075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



