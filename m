Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017129;
	b=MgHFulJIAtvClNx3ZKpplDPLBqE30GUCKfFu6UpKYimkuvkyEh5em4KAIZmb79UL5Uv7
	 m/3GqK1FfVKE7Z+/g/ef4RM3gc7SM3ZF34FL3ZmhYeyF/rXV5BDmXulfFwQr2XF7j1sO5
	 h5CgvPXqly/7mbI1i23gmV66eIqSWjPi+qGoFfc9QWhUoIQSW7rw485aEqktNG/2w0BL/
	 36leumdSaxEtpIeVJGgV7Flk/6FYBxaxRRJ7cv6GdNLVQbhHKO5xcWoOFxN9eMf24zkmJ
	 mlFBJfUf4qmG+VIeaZYNX6FrmJtqhTDXZj5WGanMRwdWTu6PFbY6DFfqdP1YAeJLbYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j5OKgPMJB1aYduWE+NJBMq4qmF+mhxPjeONUk0GA0V8=;
	b=qnvIBPUXo3wKYv15BbdG6WnV4VdsrKM4aB14ATBy0s0hNIsNmJ/Djaitl3hVTtJLfvSs
	 o2UTfeAyeMpg5f91imb6f9ZPpDAWXWCymBzxgrcPnFeet/aAmmez5zUqqc6ZOdUABCiPT
	 12jKcq6moPDhUcGEnfofx4jYB0pCYhDy85gwtOdfskPlq4FriSjbwGLqEPRIygDsKzBRf
	 JqhgtTcwKnEwMSi8pAF/Qd14mu28CGuoMwFuiJ0UL3Pfw1x+W/98Gu47hC65lK7yNUVgY
	 3i+AbMKtlfR2yI6Skj1M9zIPUbrEAHEEBLsp879SrDjUs24osS7dgvZVKu7src8GUrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qwF2DtIy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA265606A320;
	Wed, 18 Nov 2026 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qwF2DtIy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4C01F000C4;
	Wed, 18 Nov 2026 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017129;
	bh=j5OKgPMJB1aYduWE+NJBMq4qmF+mhxPjeONUk0GA0V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwF2DtIyWVcqKYMENN6KVYacL2uZoT/eyhUKR3Bcj7zBbpgp6w3eJ7FIp607aMngB
	 gB9+FKLO0ohT2AHvQsHliT5bFSY2RhBlIsthRSQV0yQWrAt1bQxtg6rVyUcj+DOG5c
	 VTnglZ9sXcKRiqm9EayAI5EWIRJSyI0+Ey5ADbNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Anderson <ejona86@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0773/2651] mfd: rk8xx: Register poweroff handler in atomic phase
Date: Wed, 18 Nov 2026 15:33:33 +0100
Message-ID: <20261118150315.720069923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3dcf6abfda74f..21182df45d1b6 100644
--- a/drivers/mfd/rk8xx-core.c
+++ b/drivers/mfd/rk8xx-core.c
@@ -875,7 +875,7 @@ int rk8xx_probe(struct device *dev, int variant, unsigned int irq, struct regmap
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



