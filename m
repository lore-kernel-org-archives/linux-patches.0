Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CDB23F405;
	Tue, 29 Apr 2025 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947737; cv=none; b=KpnqDV/r+VutnlGm+nm9JyA0oeIDlU7Z2Noj+AHQjTW0xstVVXtAfQDXph3sgSb8mYtNvI57DZ+7kGnK+9uMWxNw+dr11U/UWkuvfCCEtp+CDudhCytLutDQ9xoQRin9x/sSeh82fb0sVALyZPDlLFOKy/SElpafQ9d41iDEq/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947737; c=relaxed/simple;
	bh=VJ7ZR/bzFsNIpj55r4tHZxFtejs8yrQsR9yQQvm8ziI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezEPu+zlLJ4kQUgBmxoCMoWh5VZjrqNQgTqvP3fZHI1U1MNMFIeBIBIhpmJszftOPC0RI0RFCZpuZ4yrr6Ucq9eNvlguQ7WAr77/Ey+bnv1iub3DEl6cG7EChyZrRzzgUDJcTu10sL5t69ROve3DpdJ1hPbmSllJPv/w29hXa+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4GDT6Ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4GDT6Ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3108CC4CEE9;
	Tue, 29 Apr 2025 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947737;
	bh=VJ7ZR/bzFsNIpj55r4tHZxFtejs8yrQsR9yQQvm8ziI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4GDT6EemsrQS3uwuhGNj3GIHd5ZqH5V/hQW3lVoA2k1yS3cPYLe0Ea5DVXpbnAA9
	 TcfsdX1w6+rFiu1qC//gY0hsS4IfPGKdfpNDj5BJZXRDdvQNiej6InwNpxgbGGJREK
	 w8xxwfclz5gtW5uHxNNXt8f5gdqPbjljjyUzSu0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/280] LoongArch: Select ARCH_USE_MEMTEST
Date: Tue, 29 Apr 2025 18:40:30 +0200
Message-ID: <20250429161118.751837102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index fe9f895138dba..a7a1f15bcc672 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -68,6 +68,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_BPF_JIT
-- 
2.39.5



