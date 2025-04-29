Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FCC40C03;
	Tue, 29 Apr 2025 18:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950447; cv=none; b=qd1mS0X6HGo0d+kZKHXk5J/0uPJxNRlRbxbYQBR7j+4UDx9VIG76+dgiCFx8eNnQlaQKe5Y5LadtasWR8n++r+hPXpujpFW4hbSAWAU30LqIQBQz5IIG7GmgHkbe4Xy5K7gqDh/YCJMAwRZidY0pBbKkNx+MXlP6/aHUbO4FQqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950447; c=relaxed/simple;
	bh=XGzaSmcNVgmLHB3ZomZtvsddH76vDJRKXBO/61DDBf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa/91jrHt7vOYHvpGbDeZ5vrEBePP9LQ5XEn3RuMoiZ2tOgRhjWMdWy/fwOpOhwpARK26b4vUcR1XI8BEEMcJ3tBnVpcguh8yynw3oI3T66doSoSNUoeXRwn9Qn55Qhx4vNPe0PmJXM0buT7irzv5o80cFUOI1nbtpF+eAOupyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiBQkF3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiBQkF3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6393CC4CEE3;
	Tue, 29 Apr 2025 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950446;
	bh=XGzaSmcNVgmLHB3ZomZtvsddH76vDJRKXBO/61DDBf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiBQkF3NjEOWmJcdJwQKv+SwsLAm/92+xYC4C76rcKBBvNuPwyAeC7IcXaYB6kHsE
	 qnI2GTspuRvLF9/+BEGamFg/uYZURSiuBLKenFuMNW3CSFDF7ukDZ4SX20J5tyCcNE
	 vLhXEitUkSaBev5pzIthfIB1cp3Vb8v0LQBiUyfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/204] LoongArch: Select ARCH_USE_MEMTEST
Date: Tue, 29 Apr 2025 18:42:37 +0200
Message-ID: <20250429161102.251388606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuli Wang <wangyuli@uniontech.com>

[ Upstream commit fb8e9f59d6f292c3d9fea6c155c22ea5fc3053ab ]

As of commit dce44566192e ("mm/memtest: add ARCH_USE_MEMTEST"),
architectures must select ARCH_USE_MEMTESET to enable CONFIG_MEMTEST.

Commit 628c3bb40e9a ("LoongArch: Add boot and setup routines") added
support for early_memtest but did not select ARCH_USE_MEMTESET.

Fixes: 628c3bb40e9a ("LoongArch: Add boot and setup routines")
Tested-by: Erpeng Xu <xuerpeng@uniontech.com>
Tested-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 623cf80639dec..25aa993abebce 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -59,6 +59,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
-- 
2.39.5



