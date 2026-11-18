Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044934;
	b=myGmpV8lxFbq8bvpue+JdYkNq2pKG7skMySIjTc9gyomWqe0xkqKXz8d7ufvn6Aarn45
	 FS6vP0N122PZE7sMT9f9bFClXviuNAtEDPzeCT3Q6R+SLUdqhXOTn8YA4g8vqFRPEFWdT
	 LdIKG8xdiw7jG6k6aJobC5sik1Ldx4ug/yMCDcgG4WaePXhQMp5r8M4cid324gw1FunZ9
	 YT3u4V6nmwCrrwc0a+Ox3my8UmB7MTcwC/ApzI+6teCy5tKi2AIXN+nmmyg4ko2bfyy4q
	 CUxnkxVJ4TqyByeQF6l1qZPMS8fb6qRfTWn5cP6Hcym2GRx6uAUZwIRjVg+mrDPfpYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1eIPldyTHzydIn+PPWcouyWu/qVzfq2hucm2eJryu70=;
	b=mlQGx6PDc78Ai7tv8BqQ+RInzyUEsJfSOmsnVR5lnALonSbFdfcWtRj0j116offtxe+4
	 b5YYALk7/hUu9Jp/Ayi0RuBBs3kX5g+K+wf4GPLBw/oIqG+zZRzBZ6qdDRMvE7Ne1sBiM
	 LEiA1dYLYFZ9H8+9SxmBHW7hZ4E8EY/AE+ZTl2HZHHe9dZx7tbzyyFQ5ZWNquB+qBQjD7
	 /9ihzTtB+8D9+9+FgUetk7JvhigwYHznyZtcxvHFqhhyaCaFnPk8coCaqa7Q4429yrjkQ
	 lN5/jwfvmhomCeujtNdCNKn6l1tLCuxzM2zzrHV3a0LTDVIvDClhUjBvJCLEVhDTWVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LI5iQq01;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBC606A331;
	Wed, 18 Nov 2026 23:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LI5iQq01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ED81F000C4;
	Wed, 18 Nov 2026 23:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044934;
	bh=1eIPldyTHzydIn+PPWcouyWu/qVzfq2hucm2eJryu70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LI5iQq01oIbvOTbNCP4qo5Z/BNxQ1dmxryMcMLk/lBPaUZUqzLcNRB8iw6Fv6VGwg
	 AsWKds1I2AWs9diNA4olgm7lBz7bUH9QD1kq+t9Lfy7xe7+bmjjYdF0pB/+pJZADkB
	 5CqsAwQvlNxKpAF5IV7aF2Kmq3mSap5ae5JeSCn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0745/2857] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Wed, 18 Nov 2026 15:29:39 +0100
Message-ID: <20261118150228.377426362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



