Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020645;
	b=oZm+gyIHJRNscILSAawY8ZKYfIq9b677i9WfCh9cIJLsH0FEha0zfnDQrhdPDynu0EIV
	 o3P4uMDAJBMuMqQMsYEcKjZcvGvnTIsVCOCf+VcQvZs3UJffSCCRKs20ctfTlfYj7a/K3
	 XTLrlPNAfKDtX5TEDwD39GohuCILY0EA4dcwG/yTkoZpJUXGn5L04gby0Sp7SLmMIQDbn
	 +vr9i1OPcUOxE5vBJu3LIopbW7ieNqlQWijU4uQIPg8434fybUAURsFhzb2c80zBstMcQ
	 Lnzb5Uiw9zGFPpnw/vYHguG65VUpq/Quv8zgatT1CeQqTbGkPbJeofrFr5W3bVjQxmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i38Ywe4qsdRJKWxDAQj36lYr0r8euHtJB6Z4ycI8Olo=;
	b=nCn/+NKehNYY4A/V4ld4SwP9GatbBEfOJodNAN2PLGJIS/NJyuwYCbEhqLSowsqWoRM1
	 3thlroN3eI6+45ErGNdErI+2tIxZWO+6HVlyGyYK5nDBXOIVL+iCxhOpGde4Qsa07ABEl
	 N2sVQIkxHrK6e1FO11Jk4I4gG9MwbLwXKshb4jCJTbJrxY/LFYPqsKQypqpak94rWNcY1
	 mhg9aFYtZMj+COh1JOPdSUCPq3J+sXHPiSaoXQ+0K4Y+Y7oGKkheJiRU2VnUnRFWg+HHJ
	 Gp7JGI8FLTK0shmqgYtBVEPi7MHTwOf4l0LLwa9fps4KixE7vbEcD0QxRAgqjK+InSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLLwSQ0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0961E606A32A;
	Wed, 18 Nov 2026 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLLwSQ0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF441F000CA;
	Wed, 18 Nov 2026 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020644;
	bh=i38Ywe4qsdRJKWxDAQj36lYr0r8euHtJB6Z4ycI8Olo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLLwSQ0pGBC+7OqkNbl/VUW8I1gCDW6tB55ZXN70QJiKrHbSdaCWUO8rTmBP8UkPs
	 MHhZExS2+jzJvMJrlsI7M1TAol+mO/uDYSBbzHRFIxDAdJlNukTNhYTm7241KI+XK7
	 eBTS/pxmDfMAXl7vQgIO9+YUcNoCat+CiSCp5J1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2026/2651] selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private
Date: Wed, 18 Nov 2026 15:54:26 +0100
Message-ID: <20261118150359.117868797@linuxfoundation.org>
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



