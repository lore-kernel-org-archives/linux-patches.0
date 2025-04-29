Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E8215060;
	Tue, 29 Apr 2025 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945933; cv=none; b=uB+L6k5XneSRvEXPbXAtYmsvvGP6j4OELwmumEMqd+Z0LDxOjrfPh5oSaivllYSwI5vdl/ejuFOsPRanZxxTjVuPZUZHXUVqlJ4WrydrFLDUx0YVgDvXJ+jriea2psQ/SxKcBzGXVHvmuM4Eq3bpwJuGxSjY8SMWRMLe4v44mPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945933; c=relaxed/simple;
	bh=tOyjoal5w5Zh6+AS3pupW1vgh5lQc/jTMtCOIN3Stgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZJKOqVxlFV5AdbC555u/YPyDzZDHHu0bamEPi2a8q+0bn6RZ/dvC/RH7Zq96g/yfNTRXmTRJHZ6vATngb/caDwzVzx33Ipg9FhHhBluL3usq4xT7Onv8r451iI8FRshMVUvkDDFxZKjamT/yzq688IUS/vkZOxj/3FakGRR9+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXoeF5h5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXoeF5h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F61CC4CEE9;
	Tue, 29 Apr 2025 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945933;
	bh=tOyjoal5w5Zh6+AS3pupW1vgh5lQc/jTMtCOIN3Stgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXoeF5h5a6SOsU7d7Mjf35SL3cHsjqABxb3Kl265XQmjlezWEPtEif5iYMAVwkiUf
	 E3OMq6MqgIfcxmfPEFkdRk8cITPICzI8PQKtylWJAhLWrlZTgNvHfaBqPKIbXLSvQZ
	 uL1ZkeekUrGCODYvNEXgP8lx193B6QKhn8xo0A3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 099/311] LoongArch: Select ARCH_USE_MEMTEST
Date: Tue, 29 Apr 2025 18:38:56 +0200
Message-ID: <20250429161125.095891407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index bdb989c49c094..b744bd73f08ee 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -71,6 +71,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_RT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_BPF_JIT
-- 
2.39.5



