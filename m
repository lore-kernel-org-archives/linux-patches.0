Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EFB26B085;
	Tue,  8 Apr 2025 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116440; cv=none; b=fSXkusmc/Axq/pjzkGfYSDlI7ZCovVzTqq1QpyoNtkFfuzx8t29EQLXL4dgKR2uZY4hycVkH3+ofy0di+MAHGbU65HMdapy/n5YmC6EVk02pu78cdt9wL/+qlYW8aDFyzaf5O8FZIl5xHIcd8vk6hzl37sBoHX8I79Ua4G5kuZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116440; c=relaxed/simple;
	bh=6Rq+us6pbkI1Da4WewV6FNKxcbdgvwy4OTu07wRovOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3JmL80EDvaKj4CfI0bC01bnD9vDUXhU/JDGP45o0+hAuPPHm2VIhQEfyyDNk8cI21aQVO/nvdcpGMUJ5z38a3wUmQw0icNL23jnL8EaZiYxZ7nyfpsw9H8etmuRcGrgAIAcebq0ufT6E0qUURC5yos78PvkFR2wWR8qUQO4jDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+ZPBayh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+ZPBayh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA1C4CEE5;
	Tue,  8 Apr 2025 12:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116439;
	bh=6Rq+us6pbkI1Da4WewV6FNKxcbdgvwy4OTu07wRovOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+ZPBayhiXg5fi4KaCtxPZL5q01w4TzoMdVPIM2P4/9gXzhJFUr5+i5zxZAzBjMwb
	 EaFEftjS3VGT+CorjucPbifwLu2uuUbzXpBZddh0mpOuu9dklQesnXKyz96aemISbX
	 QoXkztL0DYBqr3zctbiIQdnfgCgibTSfUyD+gVKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/423] selftests/bpf: Select NUMA_NO_NODE to create map
Date: Tue,  8 Apr 2025 12:47:48 +0200
Message-ID: <20250408104849.037881095@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 4107a1aeb20ed4cdad6a0d49de92ea0f933c71b7 ]

On powerpc, a CPU does not necessarily originate from NUMA node 0.
This contrasts with architectures like x86, where CPU 0 is not
hot-pluggable, making NUMA node 0 a consistently valid node.
This discrepancy can lead to failures when creating a map on NUMA
node 0, which is initialized by default, if no CPUs are allocated
from NUMA node 0.

This patch fixes the issue by setting NUMA_NO_NODE (-1) for map
creation for this selftest.

Fixes: 96eabe7a40aa ("bpf: Allow selecting numa node during map creation")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/cf1f61468b47425ecf3728689bc9636ddd1d910e.1738302337.git.skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
index cc184e4420f6e..67557cda22083 100644
--- a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
@@ -6,6 +6,10 @@
 #include <test_progs.h>
 #include "bloom_filter_map.skel.h"
 
+#ifndef NUMA_NO_NODE
+#define NUMA_NO_NODE	(-1)
+#endif
+
 static void test_fail_cases(void)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts);
@@ -69,6 +73,7 @@ static void test_success_cases(void)
 
 	/* Create a map */
 	opts.map_flags = BPF_F_ZERO_SEED | BPF_F_NUMA_NODE;
+	opts.numa_node = NUMA_NO_NODE;
 	fd = bpf_map_create(BPF_MAP_TYPE_BLOOM_FILTER, NULL, 0, sizeof(value), 100, &opts);
 	if (!ASSERT_GE(fd, 0, "bpf_map_create bloom filter success case"))
 		return;
-- 
2.39.5



