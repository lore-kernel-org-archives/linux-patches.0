Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027092;
	b=jzLw6BZ1sd7ntGUedRtm62XU8kg9GuM4QDSvso4qwsN0ebU3cWPg1R7uUNxSHAQoCVw4
	 TZ/ywbQXjGJ3pmT3dA3B//IJg8yHj0uZHT6A2mmoDtMTdpLS2XvRiem+b5hOp9jgzwOwh
	 axrijBgjp/QUWmWY1GwpfhUbD8KwM0amclzO3KOE2+nbDOya6kXFqMLL5azBjTG24q5V6
	 Rwj2oIsGw5Z8MO3i+MoRHicC8XtHkyLuEVfgIrC6ygl6R4BzuVSGph+zM4S+pgiBMCj6S
	 PIglEjLetMuMJEI84e66oXp1qujE99VO64hVJKL5Z1CGxG5/+DsP5DN4j2xNUzLSs6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=csJk3gfmFeFQMYmAcJ5jJk/WytPxdEJH9OYmWiWjMtQ=;
	b=yQoGOXB8sV54WjZ+5LtUzoCDRS+S58XXcEtu3HSvzCemsUocvUqRwVefHkeig880eYDk
	 /aU129tQv3d3GzVYeN/CnIIgKaIb3kclTpAzGvdswyuWuElwERqF9oxIdyHB31EE5MCu0
	 s1DZ68zrV65uM4YD+34lbf4KDcWCnd0dFAe/RlCzT2NrqPIbjhfcgcmyM9eMDCrNJZW3P
	 hgtFIAa2QKRohXENuGX2HVKeY0Rh9TSHFOUgJkLtbi21TgkZV8GWKsE15hhhmKBqJUnqa
	 +6OMQg038xNMzmbMvLPXDspIEPoP+/3ZvEwrY0m0Ti5NOMHyp+z0yh8TamwlYcVBt/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDWDeMuh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6E3606A32C;
	Wed, 18 Nov 2026 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDWDeMuh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29FB1F000C4;
	Wed, 18 Nov 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027092;
	bh=csJk3gfmFeFQMYmAcJ5jJk/WytPxdEJH9OYmWiWjMtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDWDeMuhbMtSs1WHTNx+K0ptx624/1DGT8JIAOFLWSHVueP29S3bPblUjQT37+JER
	 CE9NIEqtrhYyPckMINffys4eT6xIw8UWSj7FYp6Ka5z8bRCR3FmMJN2DDqsRRct5bN
	 NHH941807TD6cT2XonE4ZlqumVFpqZZLXR49Qxv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1667/2151] selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private
Date: Wed, 18 Nov 2026 15:56:42 +0100
Message-ID: <20261118150222.562361028@linuxfoundation.org>
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



