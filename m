Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13612CDBB;
	Tue, 23 Jan 2024 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968975; cv=none; b=TM/otdXlb5UPLRTi2a48wOGXXLI45LEqeP0k/PV2mdswetAoKl9/C03GqJhK92k8tLFYob5k/hxJXkwx13XWMEja3VunELX5n3V5g/FcZWJlFOYTYlOyqePupVW3qAiIoATw6Z+bLTbPm+pSAoHKSimV1wPr2RSl2NVZ1/Hq7JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968975; c=relaxed/simple;
	bh=qFVBNJPP0OlNCEJ5P31nn2txDEbljM4YV2ysmzJqhf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwOVpPgk9mqsVwhFCKzeawrUhqr0dvqXj1v68fB7VoFwi8hkTx2+sJghwaoGMhWt/pA5SFHcVb6duJbNH+fI0KhrRL/txkEZnUM4gBMkSyx8WUxpaH81mDLpttGjmPBtgZCawWsSLvOx4nkDyXahgwmFHi1Fy1EHrcsoqdMHDEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYmEpfcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYmEpfcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E4DC433C7;
	Tue, 23 Jan 2024 00:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968975;
	bh=qFVBNJPP0OlNCEJ5P31nn2txDEbljM4YV2ysmzJqhf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYmEpfcf+stcr4+NjvBAWm3ojRdXfOILzPX3I2CCNIjAyvde1VcCdrPF/OewqhDgs
	 WO7pvO47MJm+Ysc2t7Gm0BtJjMBcazSi2SFKslOseYE9I5SEFHc+/kvI+vulOIM7Im
	 nZqmtLsTnUNoCileknHDSRgBvroP2CXZhl2qbOq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/194] ARM: davinci: always select CONFIG_CPU_ARM926T
Date: Mon, 22 Jan 2024 15:57:18 -0800
Message-ID: <20240122235723.870180482@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4d3b7d0418c4..68e3788f026c 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -3,6 +3,7 @@
 menuconfig ARCH_DAVINCI
 	bool "TI DaVinci"
 	depends on ARCH_MULTI_V5
+	select CPU_ARM926T
 	select DAVINCI_TIMER
 	select ZONE_DMA
 	select PM_GENERIC_DOMAINS if PM
-- 
2.43.0



