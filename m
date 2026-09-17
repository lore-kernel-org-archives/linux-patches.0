Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB904E77E6;
	Thu, 17 Sep 2026 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664212; cv=none; b=uYrMjbiLvW5tCSXjHEsjbSPeaPxdPK7jbuTiP+lzwvDQ+WERU7AKUJnJ2zxYXwOrdPX1EpB0j0evp7HY1qYmme4Fqd1F9MfrzFeL7aa9/rmdYyKYCv1Bvyv7/TlhlM1kG/IUd8nw5rsz7KNlzwY4028qbTRxduTKqzXkSWUS7zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664212; c=relaxed/simple;
	bh=SWMmBatbjW0yUPiEE+TizuRHFwoTf0H0UYwefKAqQhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmuNG/wU1ToelaoqYRvuzjT7VVJgQ7RBjqopLC9s0i88C7idxsoXt01WIl/3QmsguCtInzvZBB9qqT4o62/aiw/53o7Los55zyE0L0ZG2CkVxEdd5I4ExLlz0WZgYujfEp7J1hhCkCF0AKuETQt7XoEuo/JPOgaIUc8DYHAOd9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvHX7qyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvHX7qyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0FC1F000FF;
	Thu, 17 Sep 2026 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664211;
	bh=crovUlVCH0E/atYkox8zJ1H1siL1q40qsUVkHuew76I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvHX7qyqtUgGrzv4ZONHZnQNY0mPyYZEhTHLnHIlOGawnkV/J3zp4LG2HTMVnSfe+
	 H2A2y9svYA7t88xcUE4WIPM6zXudIGoWaaIlDYRFtWgNzZ8C2/5EXlWaFcMlF6KtdY
	 pe+m7NUtEhic6pUktrPduwOii64xwmhhVqBMOFPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0258/1250] libbpf: Add __NR_bpf definition for LoongArch
Date: Thu, 17 Sep 2026 16:00:53 +0100
Message-ID: <20260917151559.148100642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit a4a5d4ee061240a1d39053db0a87f841d43277c0 ]

LoongArch uses the generic syscall table, where __NR_bpf is defined
as 280 in include/uapi/asm-generic/unistd.h.

To align with other architectures, add the __NR_bpf definition for
LoongArch to avoid a potential compilation failure: "error __NR_bpf
not defined. libbpf does not support your arch."

This is a follow up patch of:

  commit b0c47807d31d ("bpf: Add sparc support to tools and samples.")
  commit bad1926dd2f6 ("bpf, s390: fix build for libbpf and selftest suite")
  commit ca31ca8247e2 ("tools/bpf: fix perf build error with uClibc (seen on ARC)")
  commit e32cb12ff52a ("bpf, mips: Fix build errors about __NR_bpf undeclared")

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260526063936.16769-1-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/test-bpf.c | 2 ++
 tools/lib/bpf/bpf.c            | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-bpf.c
index e7a405f83af6e..89d59674f39b9 100644
--- a/tools/build/feature/test-bpf.c
+++ b/tools/build/feature/test-bpf.c
@@ -20,6 +20,8 @@
 #  define __NR_bpf 6319
 # elif defined(__mips__) && defined(_ABI64)
 #  define __NR_bpf 5315
+# elif defined(__loongarch__)
+#  define __NR_bpf 280
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 339b197972374..1e8f01bfc1bfd 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -59,6 +59,8 @@
 #  define __NR_bpf 6319
 # elif defined(__mips__) && defined(_ABI64)
 #  define __NR_bpf 5315
+# elif defined(__loongarch__)
+#  define __NR_bpf 280
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
-- 
2.53.0



