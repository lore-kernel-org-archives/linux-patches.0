Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED6A4E1AD;
	Tue, 23 Jan 2024 00:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971381; cv=none; b=JlE462NHb0uOuteGsf0CQKdyHR2H5BekxzE5G2+PGmPvAeQiwMPD1cEHM76LODlO9UVv5uYZLSryI2n+USzQYuSWO+nwl7hxtjiAu0w2TvXKiOPV6rR8FCJHeS3gj9WeSCZwJ2VKXDRiWd9/Ny3cvQBkCftrs48UVYD8jWrgP4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971381; c=relaxed/simple;
	bh=fVsgDIvomxgnv0axbnbIOWUPNtCTpw9xbEPIc9tJLy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TySwD7zyMCDG9C6XIbYVccML5aN9lbvSDhU4dp8h7qAeGfaSc5t/93MN/0dKWcEg8Lg5xli5dpQ5SqHOBh/pZ6xw0fYHHKGEMOx4NEECwo8Bg5T854poiPEwMlcpvwFkJlObxPM8uk2GbOv5VYqepR70+oZdpIw0L6a6XiXZKh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qlWz/77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qlWz/77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E818FC433C7;
	Tue, 23 Jan 2024 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971381;
	bh=fVsgDIvomxgnv0axbnbIOWUPNtCTpw9xbEPIc9tJLy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qlWz/77MhDhjXUZmtUboGbE6yH1eo57IqDDaJ06O3LxAaCRZH701fGQ3tb1SmbQK
	 px4GFffHTj4rQAjqOpd3v+pGs1VMdjGQ/RnNQ4MBmK0ugoJajkKi/kbc9MRgHV/QFP
	 lNElU+96JUmjTZO2AiJUqiH74X8A9fJfxTlRkPBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/286] ARM: davinci: always select CONFIG_CPU_ARM926T
Date: Mon, 22 Jan 2024 15:57:29 -0800
Message-ID: <20240122235737.654796340@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index de11030748d0..b30221f7dfa4 100644
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



