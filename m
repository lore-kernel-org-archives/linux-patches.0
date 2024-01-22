Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25955BAD4;
	Tue, 23 Jan 2024 01:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974364; cv=none; b=tD/ylZjt3NamB+/WBAarG6tS6WeSUzK8S9tH2471eH7E6JUIBdLcWbEmGvDIixvFzy9aweWmD/E4lLDIYFxiqmvnSRBBDPSMkNQvxj4hetBSKGuLFyON8pCM1OuHlzWfZcvehqK8+bdSj5GdqpTNT/gjDsRfSELtua/nNKoFr5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974364; c=relaxed/simple;
	bh=DqkzRrHPS9pB+wG0rsY1MDW6bWvXJLHzF254yDG+21I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snxCJsWuEjj8lCkm7DQNbmC11AreXPaSOGZ8nza7CXVN++fd6R3UPXrHrGSZNNFl0ozxdUAKt4M6rh5S/YYTgWybJRjAnoKIcbk8O4/Bol/4JHMvDBVAjJgvAR4harmWDPI+w7bU/+8cyMOIFM6qjc0npNjVmI7GDYVTWXtE1SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVh5rRJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVh5rRJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F361C433F1;
	Tue, 23 Jan 2024 01:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974363;
	bh=DqkzRrHPS9pB+wG0rsY1MDW6bWvXJLHzF254yDG+21I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVh5rRJWitrzbc1PBzeK8V/dG3YInvyM82fcHx/vC8BwfWj8IEnVQMlYE+0zdIrxD
	 2dNExCKord8SvAo8weVD7Ydx1i6OtYUM75b1+Np5iwzdvfBmEV7Xk8zVEgNry2XWQm
	 7h9/4wLNPHnsncrOMD0TGdIIxrgEaKgeNkgWOR24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/374] ARM: davinci: always select CONFIG_CPU_ARM926T
Date: Mon, 22 Jan 2024 15:57:11 -0800
Message-ID: <20240122235750.728789451@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1d3aef84287d..01684347da9b 100644
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



