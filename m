Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063900;
	b=o+nmZ1B8LvKf7ocsR3M3NCerDuiNZc7y5yt2m6ddm6/yjZ9IjaqeRzTE+q4ogmGZA+33
	 knqpdAvYOP5RQYdPWVpfTEBBwbfahpisQTISLmeYpM0VqGo/R8bPtr3Ed0qwRj4FNTvq7
	 zIakM0JSATEPWksm8O6uUOf5fnHOrk2lEKM3GlivhCKSAsa3wtytgO/SM3VnkADDWR5/G
	 vIneFjb6gm9Y7+O8R5gqPwJ2eUS7X8Zu/YantJJ0KdYMcJTfqSOJ9tHF+C06V0m2XW4+n
	 v13uSbRGssbn56ImV+mfQVTry2+hkTnHH7ViDKgyrIckvZA9IQbPLuSgUpZeM0Um1tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c33YMqI/8CYvevrzWxJbxxyuvjUR2Yj+CuT2qZLyf4E=;
	b=vzJQjg1RlyNPPdIYfP9bz9jHCqAXrrvJy+r6f1Pc44ms2ks4uyXoQFtJXMGvnbIxzOPG
	 LnF3N6WXcf4Qab8eQ70WtvgXzGjMzZHaP86XgMZPBWuHzr8T5/AUVb8Mj9pnb5T1CtLeK
	 jPTuWTVdbLT0OaVxjlfEesqkIi1HGL01OADPAGJAeMzyN6TgMgmMXvcRzd0BZN3em4OZi
	 4yHj3cNuASdiPJp9/XngBhY565fHysj0P3NS40s1pZPI2L/zK8/XoZs3f3U47XD0byGX2
	 LyPYJ8mt6vXGGFHRbXoFc7RG9Gse5Ii4qe+hBXgKyoSzM7tNSPNzxeZUzvCm/st4VkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImmAZcTV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9AA606B8BD;
	Sat,  7 Nov 2026 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImmAZcTV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999461F008A2;
	Sat,  7 Nov 2026 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063899;
	bh=c33YMqI/8CYvevrzWxJbxxyuvjUR2Yj+CuT2qZLyf4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImmAZcTV9Aw4Fqe36xODBwXKMuczpjQBfEFKwcSdE6VtUJluh4yrbWlBrsBKpiAyy
	 lncMz2dz+0JEW/DqHvDYG7jDvZW4QOKH+Loil0Vpt/NR+mFKppcmekXdNkWC2aos6o
	 5NtzE5jTpuEcLurVqEXWrxYb7cy7aeEW2hGLuuDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0101/1257] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Sat,  7 Nov 2026 08:39:57 -0500
Message-ID: <20261107134942.146722816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 1179929b3abd4adb6ca7fae91d649c64a7293aca ]

VIDEO_MMP_CAMERA selects I2C_GPIO without ensuring
'GPIOLIB || COMPILE_TEST' is enabled, despite I2C_GPIO depending on it.

Let's add the same dependency to VIDEO_MMP_CAMERA.

This unmet dependency bug was found by kconfirm, a static analysis tool for
Kconfig.

Fixes: 67a8dbbc4e04 ("[media] marvell-cam: Basic working MMP camera driver")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/marvell/Kconfig b/drivers/media/platform/marvell/Kconfig
index d31f4730f2a38..ab58175e433c3 100644
--- a/drivers/media/platform/marvell/Kconfig
+++ b/drivers/media/platform/marvell/Kconfig
@@ -22,6 +22,7 @@ config VIDEO_MMP_CAMERA
 	depends on V4L_PLATFORM_DRIVERS
 	depends on I2C && VIDEO_DEV
 	depends on ARCH_MMP || COMPILE_TEST
+	depends on GPIOLIB || COMPILE_TEST
 	depends on COMMON_CLK
 	select VIDEO_OV7670 if MEDIA_SUBDRV_AUTOSELECT && VIDEO_CAMERA_SENSOR
 	select I2C_GPIO
-- 
2.53.0



