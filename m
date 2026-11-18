Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035824;
	b=au1oC7feCsfAmST8Vqs7ap8bLPgF2t0S/Fa5GC5kf8UwLNbN7SoGr03A/rFGgVK2QDFa
	 Op9rmtL8DHMTbJT2H4+W1o2VJn/JW+8aPAuU6Ypb5Az854xCOzmN+WtVzn8i4LGztN7Wz
	 gSXTmgg4klxEcF8zbFS84JJk27FtDe2jBnaJ+49Nr9NKwePA3WsohO5J/KO2vsH1J/lBd
	 A3Ua4g6pt0f8n3f4qBC1ELx0Dpv7+53B5G9Sb2xqX/HRpArLgCxN1uNlNo9dhnxOw50ZM
	 g7AO7DLtiBsNPHNJHqDmrGY3c/67c9fO07KhD17Ef5+BwKKpb6qAYiyPlqP2W1ee8Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i4nLUwxYqSVYGtnzX8317SUJFUjrM1UnnYldinKyDCI=;
	b=jvI0tBJMIoNmoyaySwwF8EUpS5QFn/PqNk10a8I8NgSuUD+ceQUnaKgUnJ2KATil25De
	 6q0tw6PEsLtcJvBxZbPYQVs+emn85GEIhMefrg0WGZGwqpxMHQ5uoy82fJzddvfMTPaBK
	 vVSKkaJnR4Tsn3t2E6t6YsO27keWjoUz77UvjqDx8Pwdt57mQYgCkIFED2un2agNpxr7u
	 DGFk0hsH1eVD/xqIT01Ph6IZ2JYab3oDjKOhgLS8PI34Lvh+xIhKf0ynQ3ArhTQlblPPA
	 77GGX486jGf7No69dd3XZK1EZK0PZrhhAL+ZLzlrrurqOKcBznV/wp4EBGcesSUarew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+hQXH3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041E606A32F;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+hQXH3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570461F000C4;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035823;
	bh=i4nLUwxYqSVYGtnzX8317SUJFUjrM1UnnYldinKyDCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+hQXH3QUO7zZrJepGgEwtTm2MazdZO2oZQ7u8XO5UghZo/hIF2DBtC4Vg3l3WLLx
	 +QOykAxfFiWh1Sc+wEXykhVoAwWuaBZ1exJ2nx8xRyJhqb099ku58BlCjFwH+bDP5r
	 d0TehmkLXIdsH4Rll3gE4W66p8nedec1aF+coOhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0841/3318] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Wed, 18 Nov 2026 15:24:23 +0100
Message-ID: <20261118150344.406068184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6499ffe30e8b..5a4897896c797 100644
--- a/drivers/media/platform/marvell/Kconfig
+++ b/drivers/media/platform/marvell/Kconfig
@@ -21,6 +21,7 @@ config VIDEO_MMP_CAMERA
 	depends on V4L_PLATFORM_DRIVERS
 	depends on I2C && VIDEO_DEV
 	depends on ARCH_MMP || COMPILE_TEST
+	depends on GPIOLIB || COMPILE_TEST
 	depends on COMMON_CLK
 	select VIDEO_OV7670 if MEDIA_SUBDRV_AUTOSELECT && VIDEO_CAMERA_SENSOR
 	select I2C_GPIO
-- 
2.53.0



