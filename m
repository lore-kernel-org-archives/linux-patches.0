Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33737F1;
	Tue, 23 Jan 2024 00:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969469; cv=none; b=lDVMSRBfus4V+jKqP8GQ69oNnulP0nTZA9UiRvWrpmG1cMPX7MvDlQgiigXii6/LDyxy7qedbOz68iBoqMdodcx8+bbswGjwLdRmPRpSf9GzPpNFEanxF1YwnxjIXcOlBMHCCNB2rqN3ppiHM6oH2Fl40+LEJDP5tD6BAumEKO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969469; c=relaxed/simple;
	bh=OU7Zz8aSDBxdL/x3+Q0FxVN4MIcOjcR2O20wiVesGWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0FsileWolV9lik/4vj2JHazqL6g8AJcHIBYJz+mLPXgd/d0XFtTZrAPaJZCHpAM1xRiFYLNm2hyJcLxTIl2Lhk4Fv7tBWkOyuQ4hXkuAgRMsHyzyadNQP778RpSK0EfLnGg6y67RuLhMlj1FxTZOyhUG82SWF3E+M5bE+i37P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoD5yh9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoD5yh9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2210EC433F1;
	Tue, 23 Jan 2024 00:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969469;
	bh=OU7Zz8aSDBxdL/x3+Q0FxVN4MIcOjcR2O20wiVesGWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoD5yh9yTMKTB+6zmrZmsTdXSBYuRyZTskXwnXXpOgTYYHCHhEmsZiojCOpucxLD7
	 FRA2XI0/j27XkOmze8/4Wwqpvwazc0xsWpl7WX4DLODv1+IZJrkLNCbMc1/m5lM2rK
	 HcGUxYj5ZHuXZ9Exlvf3qlI+Z5Kv9n4hgPnUjeAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 241/641] ARM: davinci: always select CONFIG_CPU_ARM926T
Date: Mon, 22 Jan 2024 15:52:25 -0800
Message-ID: <20240122235825.469617331@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



