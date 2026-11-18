Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041891;
	b=H4+ts4ZUBi4OaKMIQEV+pAeBVPGVLN1n3Ber9oUgYpghESxviwl015OoRlcsY1RiMCVG
	 1emRqFZ2hqhtFahLGjdcoP933KhnbAY3NC3cfHQYSbXCG7tFAGkki1y1I9VGT9gr7dHVP
	 jzQNpzTNnHwIl4obop8cYMcVJEQTWWkIug3qYeMqUS/2u6A71E7YlhgpMue64aP2WYX6t
	 Q2J5XuHupaSFnxuDh1aLzfBSrg7yw3N9LHjJ3stwpPpBszwOpyDLk+pSwn3Ql7hK8ZESD
	 JCQKh+5v4OuniUgeeciM5L81feJnFve3QwHA6RrbGsu9jZlLkRmFpznxXmg97PA+v3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rzoc3oEPpj9Tkl3x8h75ljrtx+mtFvopVWQFeaQZIYk=;
	b=FqGuHZOSdgxbEmETEMEm+4qwgeisfiLVFbVA8NgmQrblcQtM+MPWCZ9VCL01i82eRdyC
	 L+MQEvT8TMx6POK4NzwW2qJhcF7yh4h+FRkR999Xtx3eQn/7wdi6rfn4/LViJ3rW8b8YI
	 Gj7EfevT7QZX795hxyp/dCfEhrYE6jqjk7lwpsogfSb6hfA9Howonb5DPHsPbWme2y5rl
	 OIm6pUKcamE8KeJYiG3VLgUO0i9LWDmCdBuJAWl2MGxz+L4OclYdBjdJKwSgxePlvuYqx
	 n8brGT+jDYy27uTxipnyIEYoAmFvkpwCepGmltJhTfXF0LmiuYguZRFcspNkkOueCSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McG3Avje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A46E606A32F;
	Wed, 18 Nov 2026 22:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McG3Avje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACE01F000C4;
	Wed, 18 Nov 2026 22:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041891;
	bh=rzoc3oEPpj9Tkl3x8h75ljrtx+mtFvopVWQFeaQZIYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McG3Avje+uvXw7g4lssoYOp3TQ1K6HvXNHMsOlxvNfSK+aRoUJSAl8fW9NZwMSBaC
	 m5qPXcCx4CWD+2CQejiiUak3sKSFSOxtGt4DvJdUvmXCSGttaB2frhyx9i46d6h+b9
	 TXMxpQBc4WU8oYhXeJMbmVmT/6lvzrQqiAohyKXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2974/3318] selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private
Date: Wed, 18 Nov 2026 15:59:56 +0100
Message-ID: <20261118150449.504057555@linuxfoundation.org>
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

[ Upstream commit 3c824dfd17e6e918e45a6a96bda0d020ddec8287 ]

setup_hierarchy() mounts a bpffs on /sys/fs/bpf with setup_bpffs(), and
then sets up the cgroups with setup_cgroups(), which moves the test into
a private mount namespace.

The bpffs thus lands in the mount namespace that test_progs shares with
the tests running in parallel, on top of the bpffs already there, and
hides what they pin. cleanup_bpffs() later runs in the private mount
namespace and can't unmount it, so it stays there for good.
bpftool_maps_access then fails to pin an iterator because
/sys/fs/bpf/test_bpftool_map doesn't exist anymore, and bpftool_metadata
can't find the program it pinned in /sys/fs/bpf/test_metadata.

Set up the cgroups first, so that the bpffs is mounted in the private
mount namespace.

Fixes: 88886309d2e8 ("selftests/bpf: add a selftest for cgroup hierarchical stats collection")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009-selftests-bpf-cgroup-stats-bpffs-v2-1-f93a111da992@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/cgroup_hierarchical_stats.c        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
index 3bd27d2ea668c..ad19d6d41918a 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
@@ -151,7 +151,7 @@ static void cleanup_cgroups(void)
 /* Sets up cgroup hiearchary, returns 0 on success. */
 static int setup_hierarchy(void)
 {
-	return setup_bpffs() || setup_cgroups();
+	return setup_cgroups() || setup_bpffs();
 }
 
 static void destroy_hierarchy(void)
-- 
2.53.0



