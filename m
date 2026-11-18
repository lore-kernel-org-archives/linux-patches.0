Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032322;
	b=MwcWcOc2KLUw7ZokyFlbGMSGGFT0Xlpd3mSxNICQRhVl984WfsvEWBg+TZGHJjjFc21O
	 5KjpZtsCbmgFod3dKENk1cAUjMyolInytG4T9DFEvnptJB3EbCIXoCK3f89isAvPtN/P4
	 3lMFGqlZV74bqE6ZaSDFmAQ21OYjEZQjPvq8iUjyWG844jHlFBOTUVV3UOebQs1rvICFV
	 R7GuPx9JAioYACrBhLx5exu+LoSfYQ5P27ALf7CqHvXzTF78uPUltAu/fUh9fSSxB56/n
	 oSQjqXAXoVAa/wQhclL8GzWxW/dbBbX2n1t4DwmB/UPpLw8f9d4Qz9I2fKbOFQd3hUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cHJ4cY3KFVYNmLkPgv3dcEi91zfnd4kqZidhNwKo76c=;
	b=JhBys1x6MZ1XzQTATdjT3B0u0R5DpkF6lPwaZE8xerdCJBb+EiT9w+cjLk86hN77IHy2
	 Qd7HRQ/2RjJKMAL0FTU+BUwefWvVYDbPWY9crWKoQmJ/TZjASLykWUTfz51RKbXxJgSez
	 A3ams4gPl1CX8h810NyfheIqmz0R7oH7lW6fid2TV+8XYvJB1Sl/RWVYl2GEnqjpDrwIB
	 SNh+Atg76Fcj3V8kaApjHaIl42eJpfcRzM1IqSnLkvLoIFmt3hIIli1kKyHzFn2EM0uFo
	 IVgYazmSvOreQlhA40ZCUPFGPou1dET7Y8TUaV7aBvLOfn4sBHbq9TgyjmACPYxyQHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEWt9vrG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B200606A337;
	Wed, 18 Nov 2026 20:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEWt9vrG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7031F000CC;
	Wed, 18 Nov 2026 20:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032322;
	bh=cHJ4cY3KFVYNmLkPgv3dcEi91zfnd4kqZidhNwKo76c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEWt9vrG9073uuAqIQ4FPsSZZUfVp3MA+byLBQ4zyZfGOqjsON1KH3AHj9mZgQwqP
	 jQ7+v0+w3SXaFbGI6C13t5l8pUggZG5PgyZoe7LkmBX3ar1Gr7RaiyX7qpcEDES/NK
	 pr87C7pOHaFeqnvVPlbaVTDy2LaJ9d3E93IR4YYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1329/1756] selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private
Date: Wed, 18 Nov 2026 15:57:36 +0100
Message-ID: <20261118150102.308183706@linuxfoundation.org>
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



