Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973113D3CEF;
	Wed, 30 Sep 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794232; cv=none; b=mSyLUyLgSS5UiGyqZKLx07JMsRdKZ2BZOR42kQ6kbxtHUJrIgvwZCAtk5mRHIfWTUHfq9dJ0/foZH1ZD8LFFAuWs3uDH/MhDx4OSJdlQXfi/S+iOgzhXNvCigbKAuMYzeh3E6azTx3sCMWBT8Mj+R1oMdvcFrUv2EpORjhUdhrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794232; c=relaxed/simple;
	bh=lYf2U2mmWiJgQeYOF3WXXCWPxVk4rOHYJd7gQ0MIKr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e082ukXKJcBL7LCo1pzMdapgpsu5YUR7A8rdcjJYnBXMNmw4mr+kjW6HEQnPiQzB1RPlqFOdyDmIWO7v3gaRGDVM37wN1KeyKTAlOn3fXRpbe3+IJ3tTx6+tEgQ2UZuT5l1FNDs5k3K6XRef53ydk9xVfDTy3JRWrOd/Z9lJYY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtyhrLP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtyhrLP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A71F00898;
	Wed, 30 Sep 2026 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794231;
	bh=gSFQpYC049AvHTgPVpzPr/dZeryEOCT3VHjYnIOCedc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtyhrLP129hVOh+sMRrcEpkZ34Zptk8BtqR9DIPtVabVee0kfZcjafAtkk/8sA/Ny
	 /XTgrqik3q3+qoZiqPFcdAHrqWba5Klz6n+/cvT9RyuimeMVQtIjnOKURrbdCbS35A
	 ZWjzYwLZsxhc8sJaUTUWttDCn4Y2SOatSJPOEpBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0137/1193] libbpf: Add __NR_bpf definition for LoongArch
Date: Wed, 30 Sep 2026 17:13:41 +0200
Message-ID: <20260930152437.253830858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0f1913763a33..c2c6e3ab13ed6 100644
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



