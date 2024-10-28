Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE708837;
	Mon, 28 Oct 2024 06:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098358; cv=none; b=QBNL7CtNn3jKPKK4z7Ck25CasXUcmYc8LCd5O0xqh+GgGCw1gm/wA0RQ7FWZyUhMKGlCaC2ZvS3JZQOIn4cYzItbOsxGqzo4Q2yU7Sq4aRiLhTURzeOB/seDOJCMPZ+BeOnJRMGpufnNUbeRwdFPTSFuOS3v0LLYBU65HDHgy0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098358; c=relaxed/simple;
	bh=SoP9QrcbI2mTgZ8pUsH5Ejy1moyqJRvgtYDuuhbAkgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxObQ7f0HDsyZii0bpyxQ/JFkG22/DZnsD1oLwr5EfoRJqfT68tdoMHpL/DVCYk63et4maRywl1mOjbBypj5ndiJKADj5RAMIZcOw3OMYnSwZZeg5DokeawJnJ6PuE7FUW3+6nKDW0Icog0eEY3VeokCCjaQFS+WW/GcyFuKbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Se0q4Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Se0q4Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34585C4CEC3;
	Mon, 28 Oct 2024 06:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098358;
	bh=SoP9QrcbI2mTgZ8pUsH5Ejy1moyqJRvgtYDuuhbAkgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Se0q4NuaHv2YkkNR/Q8Y76SWNmQLH7ATkQ1mGW/3s51+nzIjWSSoPwdMarp78raX
	 8JjPIzDnuPJzrIRJfO05vsAyT3od7DRrJjClnWJ9yotaAsR+DfXOi11+gVBymyt4ki
	 6LGDzvs8R/6ARoYbdzuin1UoV3mdpHbvG8Jrh62s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 192/261] fbdev: wm8505fb: select CONFIG_FB_IOMEM_FOPS
Date: Mon, 28 Oct 2024 07:25:34 +0100
Message-ID: <20241028062316.838444519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 51521d2e2c35959cc70a62ccddf694965e29c950 ]

The fb_io_mmap() function is used in the file operations but
not enabled in all configurations unless FB_IOMEM_FOPS gets
selected:

ld.lld-20: error: undefined symbol: fb_io_mmap
   referenced by wm8505fb.c
   drivers/video/fbdev/wm8505fb.o:(wm8505fb_ops) in archive vmlinux.a

Fixes: 11754a504608 ("fbdev/wm8505fb: Initialize fb_ops to fbdev I/O-memory helpers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index ea36c6956bf36..1af0ccf7967ab 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1374,6 +1374,7 @@ config FB_VT8500
 config FB_WM8505
 	bool "Wondermedia WM8xxx-series frame buffer support"
 	depends on (FB = y) && HAS_IOMEM && (ARCH_VT8500 || COMPILE_TEST)
+	select FB_IOMEM_FOPS
 	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
 	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
-- 
2.43.0



