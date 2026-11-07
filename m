Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061944;
	b=U1708xJ7JYcns14ibgW9dVEVlEETlgTF64HxCyW8mNGiGH6pASbyob8pGndqTQjQprl0
	 I1GDaGppPfI7zsGIg7lNsFy7UJfHH6qDNQRTdFOoqvm+BOAlpGsg7xrPInmTLjuoCZR31
	 NuF1kg4NaW0KQGsI3loWHSwk7D/i/V9xpH9+LPu7Ig943nMrtKZX7GGL+DqO2fBrm7Lbe
	 Nqi/JJjBTES3n/f4w5FgCm4YqfMLE667tu6uQH507kZRjPGzCoCaSFyqmJiceDf0CgYxO
	 utMk9EWBYR76gtow+rdyEtMbxHlsIUj0EaFE98LiJccaBvb0bDKZlSINffY490InEQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZqXucCzi94zUSIusJea/hDW9QeHBGAF5vfHuOuh84oE=;
	b=Hroo75YZwNKlGEEjCNQWfyEqefX2W0g5QC+f1f2bBe2SmxTcsxjtheKJCNyqBojkWXgY
	 FPMehD9BlSl/0bAPr6gjYwE5C5jVyzSBVCkS7mpGEERcgAAmUlLyjJ7hRXZdpQW42EqY5
	 jU+foBmTqqMOcJsmt1rGwzO8Z/KZQ6q9qq2M0yptji9P6U/cfZJ3frnlGaLgKqUHAKyGq
	 mPbySFG9J8Fkga4zckp/wbiP1ZOGNzuRYw6jw+/fsSl/VavgLhd1/8eJ+rWfWGlyDnBJL
	 Xq/aUy81KiGgwiWIKxsXe/DXrcpgevNUNB5G9viE+oyYVfFeDIVPNfjkQm7yFMf8fEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9rAbxku;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C0606A326;
	Sat,  7 Nov 2026 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9rAbxku
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0915C1F0089F;
	Sat,  7 Nov 2026 14:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061944;
	bh=ZqXucCzi94zUSIusJea/hDW9QeHBGAF5vfHuOuh84oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9rAbxkuljEsgtkJp4Z9xrXS083nn2keUqGfV3lA/ZbDleQAPLFssjejXl/Z4V7Ks
	 OAiJFDrG0wcKUNdsCorcu4ts+7CwTtnYz5MzmosS4n7P9b6x1t3BZzkide3mGaIHhs
	 fv2hjSA4S64RNjEpNGovgHNPeSLLRYXayie7RxOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0943/1536] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Sat,  7 Nov 2026 08:49:19 -0500
Message-ID: <20261107135024.137522005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



