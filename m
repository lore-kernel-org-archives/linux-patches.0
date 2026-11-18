Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030022;
	b=wdUS15mzlatlQJUcryBDDhjm6abvhwVxynJEoGsuakFgF6Xm0zORvJ7RbS+DNE6w5Nd8
	 DLeoQOhD2C0gUY6WvbTZxlYiCQYJJq/k/ZypPgXNOLLjZtescCgAI9xtq+DgQVl/dZSbX
	 n8z0QkJQZdl0+tN7ogUUxtzMuR9t2rsnZW73xQVPWb6PX+oW4ODp0jt9LPOx1hhDyPAH6
	 hSxQGKU2FUCe7gCyqHYXVWllt2u1eCbg7IiN+SAEiV5fXsGkAXYHyP6JHPmvulxTkwWSi
	 EXd04+vLieCgkrUPiAzc8ZNyVNGSSQ+lbcUU/TGAX67AAmjU88LrS5iG98E47uFvJgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bH8p/N6P5v6d1fLwlWn3zFX4Yn9y0sDE52lEi+37f6o=;
	b=DgbGQ4+zuf/bMFTZtQDo6i/0TCLZZIFT3CfdTMDwm1cMnpfksOuJzhFRNzTqJyZSmmTt
	 C9b6GBwHw1C6SDyJwQpKSRCus4FcvIIHGYcjcOwUZXlDi3RfxfCKdzDjtVrqV4QndHbtK
	 Ekb5zh9OYxqxtXabZ0sIYvwgfHiD4Ld0vWadhjY10mRmIVnmemnnMEEvZdQxx3M4FhEzm
	 estbiKi2EbXJUofCQNFEuX/ITMg26lF+kurjL5HsHxzMoh2lAwfmTJz5FW5lyJ5WJdCpn
	 +Qx6EPCcQmYZhrWWzqeRipEa9o7RPY1doTKIKkiKLABT3aXvwrU8kGeLzbMi1DxJMdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtXfgZgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA4606A325;
	Wed, 18 Nov 2026 19:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtXfgZgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D011F000C4;
	Wed, 18 Nov 2026 19:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030022;
	bh=bH8p/N6P5v6d1fLwlWn3zFX4Yn9y0sDE52lEi+37f6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtXfgZgFVZypb+afigOq/MXu2lm07uxWGgCaqPW0zasy+GSWacP64g0XlSdF15Tev
	 zYjU5zRS58EO4g89gI6w0j3+icM/JlskD9Qg5mPdndlBlBL2fKT+jGrEVJcw0mDZt3
	 TzWus/Mb3Uwewz0aWDg9RM8wE+obCp8jbkbrM8yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Anderson <ejona86@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0555/1756] mfd: rk8xx: Register poweroff handler in atomic phase
Date: Wed, 18 Nov 2026 15:44:42 +0100
Message-ID: <20261118150031.204276194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 39ab114ea669d..b27d14b8fd868 100644
--- a/drivers/mfd/rk8xx-core.c
+++ b/drivers/mfd/rk8xx-core.c
@@ -788,7 +788,7 @@ int rk8xx_probe(struct device *dev, int variant, unsigned int irq, struct regmap
 	if (device_property_read_bool(dev, "rockchip,system-power-controller") ||
 	    device_property_read_bool(dev, "system-power-controller")) {
 		ret = devm_register_sys_off_handler(dev,
-				    SYS_OFF_MODE_POWER_OFF_PREPARE, SYS_OFF_PRIO_HIGH,
+				    SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_HIGH,
 				    &rk808_power_off, rk808);
 		if (ret)
 			return dev_err_probe(dev, ret,
-- 
2.53.0



