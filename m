Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024319;
	b=K0QsjVfBKGTnx8wfaua0gQm/qxb8+k8qJkPdioo6M1ASc9ohaUVJjIe94t3aa5+OG4Cd
	 AhsPQ6/Si5T1Pj4zBVgjRgFll7uvh914kyzmZf6tfutsxCyXLkG+bt0u2vNQl2mEfxesG
	 z5vJcjxocQ9KYkwu3LPDv/BLXoF5Qu/Wl9HuRCOzhlV2zgkEk1GbtjvbUFcLvgjXaXPXA
	 +2SIo8jedzFJ3BoIkIPlg9d4E6cJMPOmeXfh1bxYk+2rbAtG9+nGqQiB2u0Z4zt+vUEWn
	 5FGjbVzCxffpwyc5UiwzgLGdYIvC09kLgT8zgvvuLqsighNGtqIdiA/Z36MGjAwPRBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lFP67SRQ/91DG1nfNMD/3radkkV/TljMAvFl651XSVg=;
	b=t74kaHY6HiEBbOOTZk4wMQGpasoLP3xe7qRcRc+3zI0+sjX6UPaxVYye7eoPio2d7Xyj
	 TH/1u+GB+dOJlOsHU/1F1qlRGpznmEfLkkyr9F25H+2m9UnNDTP2vZKNpmG5YrxXLEq+W
	 ik5RtyyI2814QgBH3DVbhCFWaCMMNMSlWiKfO6c1hxWNM+Nzu7OxS8WHwQXoyWZe/yYK4
	 qFZZ2aDw1OIsmxfZFgT6pw7F5akHOzuV17zKjI2KQyQ83obuExEJzJB3fAOzI3L1G2HFd
	 wWPeCTcYSjTtg4TjCioW4gFTvOJnH5/D62WWa0vMPbmqwmOTo73iyT+93kAV+tkJ10A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVeExQPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E4D606A325;
	Wed, 18 Nov 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVeExQPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E861F000C4;
	Wed, 18 Nov 2026 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024319;
	bh=lFP67SRQ/91DG1nfNMD/3radkkV/TljMAvFl651XSVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVeExQPzJg9ArwEgyQ18eH/icgU7EVSYWkH2AWcJrpBBc69LiAZpPftoM0MMiGKWC
	 239BIunTD8OIz0UenQN0vHmTpIXbgIUWmv8CqmJluN5NklNYBLkFhEvNiPsicFb13T
	 dr1vw/yASO7kQbzZKkc3cSqFpFi4EhEACYTUcP8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Anderson <ejona86@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0682/2151] mfd: rk8xx: Register poweroff handler in atomic phase
Date: Wed, 18 Nov 2026 15:40:17 +0100
Message-ID: <20261118150146.646575568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Eric Anderson <ejona86@gmail.com>

[ Upstream commit 128115b520c6b61afbffd01809cfc3e8cbb78516 ]

This fixes a regression from v6.1 to v6.6 where Google Veyron devices
(rk3288) would not power off after being shut down.

Prior to commit 4fec8a5a85c4 ("mfd: rk808: Convert to device managed
resources"), pm_power_off was called by legacy_pm_power_off() which
itself was registered using SYS_OFF_MODE_POWER_OFF. But in that commit
the registration of rk808_power_off() moved to
SYS_OFF_MODE_POWER_OFF_PREPARE. At the very least, the code should be
consistent between SYS_OFF_MODE_POWER_OFF and SYS_OFF_MODE_RESTART; both
should be *_PREPARE or both not.

It appears interrupt delivery is already shut down (but not disabled)
when SYS_OFF_MODE_POWER_OFF_PREPARE is triggered, so
regmap_update_bits() in rk808_power_off() does not complete
successfully. Registering rk808_power_off() as SYS_OFF_MODE_POWER_OFF
runs with interrupts disabled which causes polling I/O to be used
instead, and the device to power down.

Fixes: 4fec8a5a85c4 ("mfd: rk808: Convert to device managed resources")
Signed-off-by: Eric Anderson <ejona86@gmail.com>
Assisted-by: Gemini:gemini-3.5-flash
Link: https://patch.msgid.link/20260908-veyron-shutdown-v1-1-066ecb80f5f2@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rk8xx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rk8xx-core.c b/drivers/mfd/rk8xx-core.c
index def4587fdfb8b..9b5fb033edbaa 100644
--- a/drivers/mfd/rk8xx-core.c
+++ b/drivers/mfd/rk8xx-core.c
@@ -800,7 +800,7 @@ int rk8xx_probe(struct device *dev, int variant, unsigned int irq, struct regmap
 	if (device_property_read_bool(dev, "system-power-controller") ||
 	    device_property_read_bool(dev, "rockchip,system-power-controller")) {
 		ret = devm_register_sys_off_handler(dev,
-				    SYS_OFF_MODE_POWER_OFF_PREPARE, SYS_OFF_PRIO_HIGH,
+				    SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_HIGH,
 				    &rk808_power_off, rk808);
 		if (ret)
 			return dev_err_probe(dev, ret,
-- 
2.53.0



