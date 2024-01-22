Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661146772E;
	Tue, 23 Jan 2024 02:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975288; cv=none; b=nDhE+yeSmF4S1ZMBxNqVhypmG9smgAdY6P48ZyddryM9hMxLPmzbm+TDeunvsaLf0pWy+azuDVdOOrtr99+y7q2frF9X+ITqkYf5E1Pmz7xa01VdwfsCaTU2pl4edm8o6mJql1dv3aKsOlrh4Vv+bfKbSZHWLrZCe5duMRFulu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975288; c=relaxed/simple;
	bh=cZ15Rj1JqkDdos4+5Hu7lGeoDO5KTXV+k+1yH2wrHlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGLjk9alBa/mpZ2JxRSRkIHH52tkomjcvPtKAiqF1Gt8VqvT/bM29Hy83TiK7WQDTC3nMu/tll5qj4vbJ9KWD8/EfVRp5jp70HrS7Gx5RZSIYvk7qhcEmYDz4l6mtCSLXDG+TY6oTw0zb7139LqfuGN1VH2fibOV8E43sz0u9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu+M6F72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu+M6F72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF418C43399;
	Tue, 23 Jan 2024 02:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975288;
	bh=cZ15Rj1JqkDdos4+5Hu7lGeoDO5KTXV+k+1yH2wrHlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu+M6F72s5OdZC1pnosfMtwSh7Kwz0aCzBBH1HfsD5lciRWHDEojY1gGrL0I+sajV
	 vAtDU2esqfU0uouUoofwG2PmIn5n2cWv1LoXDYb/XF57KpAnV4l3ZlHip/80461o3Z
	 1Og0RUCdm/OIXODEMDnQ7t7XzL+YvkkAL7yzzASw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/583] ARM: davinci: always select CONFIG_CPU_ARM926T
Date: Mon, 22 Jan 2024 15:54:32 -0800
Message-ID: <20240122235818.762568032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 40974ee421b4d1fc74ac733d86899ce1b83d8f65 ]

The select was lost by accident during the multiplatform conversion.
Any davinci-only

arm-linux-gnueabi-ld: arch/arm/mach-davinci/sleep.o: in function `CACHE_FLUSH':
(.text+0x168): undefined reference to `arm926_flush_kern_cache_all'

Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20240108110055.1531153-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 4316e1370627..59de137c6f53 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -4,6 +4,7 @@ menuconfig ARCH_DAVINCI
 	bool "TI DaVinci"
 	depends on ARCH_MULTI_V5
 	depends on CPU_LITTLE_ENDIAN
+	select CPU_ARM926T
 	select DAVINCI_TIMER
 	select ZONE_DMA
 	select PM_GENERIC_DOMAINS if PM
-- 
2.43.0



