Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773162522AB;
	Tue, 29 Apr 2025 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949815; cv=none; b=lhR75xBnj8cVfyibZYdVG24dRAHYRJX/lB8n5pOuasQt5XFZlRVJQ7Cob56seD8UOai21WeBbnOZYfaTbkmIn3tNadMCD4a+MMMD7QQaArzCzQGlAmQCYvGpWQmQsvLr6sJEMak9ZH+kmUWy+yT8Lz79Ddq0IeogndiNEW1xfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949815; c=relaxed/simple;
	bh=0d0oDCnh6C2QHnYVFlETYS8X05J20Zgu+tfDwG5BZCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yqml/j4M3RA6hFHOunU+sGJPbwWg9Me6hbBfVoO/LPHd8gctLhEuVNbfXADpgKeKnF87BG1lUwyKbJwy08oeFHeXPUGe1AYTJh0exe8LlVsFH/QgiWCHf9dzn54KVEPmpYvA30Zqmi/5sVglU1hhL8OvabHt6VM7UCJ5ONb+6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuKYhdg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuKYhdg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0FDC4CEE3;
	Tue, 29 Apr 2025 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949815;
	bh=0d0oDCnh6C2QHnYVFlETYS8X05J20Zgu+tfDwG5BZCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuKYhdg8GBxq9OY7z4jZbVYDeXmVJdWbWttBpsqaRiXktdZoYxzYjbEe6lUWklSLf
	 41RrdYHexUP8Dvx2eBKoYb7yGItNFd4bWB3gSqPcDOCZdAchwMdgyb/n3wzKykCYp8
	 qM8Rd7Gs4WqQAiVfO7KW/itimD0jw7IBKz3ZWWbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/167] LoongArch: Select ARCH_USE_MEMTEST
Date: Tue, 29 Apr 2025 18:42:46 +0200
Message-ID: <20250429161054.112558635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0166d357069d9..6c55d85b1c767 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -51,6 +51,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
-- 
2.39.5



