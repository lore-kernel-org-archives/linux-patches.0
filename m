Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062834;
	b=ydQcUiiVZS5VU2cNmtosj3TiMiiDN9MuKBoUEefCr8TBqB9tZ9eV8/n8H9roSCc+PqSm
	 4SDc9GkhplLjVETehiUFiZ2SwUHBT48YRbcuuyKLQqp28tqBCAbqsF6tt3i8bVHl7+Tlm
	 +EkuE1CIPJJ1cCLM+28oXpeBp8t2qK5v3mYa8oVbCM17BQ35MKg5vO2aNs139+KUm234I
	 iPY+MN+HBXQ3lYLrSZJ6JPgES12pMRf7DRss6M9E8VPD5cDyDyNd+V5CzlMcgZc4GO6g4
	 5a6duHBdU2z2pzXGywXxSORTjrDUOgcBH4xwmEz7u6WY4ZB2ftNaz0PRtB1S0yrxOCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6lNMUMLXRkPVvT7/3utIBoAEdbN9P8S2qafZaUfH2fM=;
	b=y/ATMyDQWrv/1QBKLqnBb+0g5GiU/C/MUTWZbxtuGnK3PwqA9Q2mLMKkEl7jJeg07jsl
	 D1hQYMRbgO4OkeCkONVYHmj9izFYLCUlfsXabWfDURV9Ah69HKNKYhxHeJnih1ljtSDRv
	 lg59uL1sdtOylIVt2Bb3AiZKUDtsMRTh/fDVvlGkd2JbzW4aeybkjC4OXOWZ4dz0SMljC
	 4dmI4bdNXRoVfg0A/VeT5+i8lKGNLZR8aBBSW2H+lMWIIQ3Is6IkVCY6NcpVt4b6GdGmx
	 CsuVx+5Y3O/dL+pBZ4lvfSXjCybQv76+HaJDG9fdv5hwxJh48kNa1D65h3GvZX+MlHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmvgE476;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C2606A334;
	Sat,  7 Nov 2026 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmvgE476
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA82A1F0089F;
	Sat,  7 Nov 2026 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062833;
	bh=6lNMUMLXRkPVvT7/3utIBoAEdbN9P8S2qafZaUfH2fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmvgE476/vlK4abMOXolgK6npQ5aCl0UNjDsJ++o0NHtu/Ig42jncgX0dBXV58wwQ
	 RrchlJugpijZ678KT6P8vXso5MQmW0GwV6XoDYW1fm1n6C+wI6K/wxpG1B7YvfP+r7
	 GelssxVHZBMlW2KcnELMNVHoT7FQZGVEvPkPRijg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/869] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Sat,  7 Nov 2026 08:46:11 -0500
Message-ID: <20261107134855.744344916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



