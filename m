Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1856E3BB12A;
	Thu, 17 Sep 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667704; cv=none; b=UyJ57tLNeRr2nUeh0d+iLWa7+xCFWy4gM5x8swZDifP8dPwuSsb4ZZ4sia51u/vxPETuB6f23zqd65OyBInB4rgg1dEmzv7VuIJZJVM1moLh5dxzj2YjLeZwq2NyXfZ6EdeT94cYWE7IDzMXSaABGkXsDQlUa31aivcS5DI9Hac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667704; c=relaxed/simple;
	bh=gp3akycf9cOvLhTx1slll7pgDbhPCjlZ4V7MNh91FyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ5ckIOuNJGUG7TTiNP83IIaliHzie5RU6TtCMNzMuDZDFVPxtAZ5YNOPmqXI4MzA6JzJreIyMOU7dTYFZ1NonbQvlDl7VxBRFmAqyviMovXGmWzIeH6rRctp4GrHGXA6nh84V7ld9tbVEERAX+I3daOX+Eel9BnlOfwRV9NuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvzvJHSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvzvJHSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A02A1F000FF;
	Thu, 17 Sep 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667703;
	bh=Ao+QnoaPmYigdYHCKVQ6GqWTnWJFPiPB8KpMKFcIr8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvzvJHSRx17AZ28zMCA7jX74wioBEQ6F8x3Fbpw1BCmUcTXvF+cQRnz/Gk5SPboH7
	 amrPF84pVUOJQ5bzYXHs06WPaFg7woubX2dD3TdH0qqVOo9Na0RkMzAtaYWCS/ezPS
	 CMEJnAsEIrjymMRvFH37vQ8sadTeVcaDDijWuX0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0182/1102] libbpf: Add __NR_bpf definition for LoongArch
Date: Thu, 17 Sep 2026 16:02:05 +0100
Message-ID: <20260917151544.132149210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 727d22e34a6e5..febc3a93c29fc 100644
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
index 2a4c71501a17d..4c6bd01a40f75 100644
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



