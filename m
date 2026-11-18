Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040104;
	b=xzS+/FC34GvCygG4C1fBzyNvQRRao5VfL3i+FhNYHjiKaPcgdnHInEcB+JEe47Adkx51
	 Tl9auEo6yFxlgidtESZyqIgIVOI34e757L7R6myGyqGWvUUUhEB+2qWUgPnIY76UUINi8
	 dDttMOiu2XEabuvZtZr955dILNjHpP8QNT1FquF3nCnmJh9IfRxB+qUQtiinbf3YGD4SZ
	 NnUtfwzfm+IPWRJjFASyC2Kj3papnptqvq7wecpuhJ2cqW1F0betF8iBInggd9l5Zr2Gh
	 tYcoNot2p1LIZHcYEYrQ6c8OnP33ydDA5p/gOVYp4jb82ngFPnOedH6GM2Ta9xLxdKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0D9olcUM7QCFlrutDDIZagddW1eedrFwRiGF87eM8E=;
	b=VXeUPrrZsi/xHI6cwo9ElUnS68m8yfHGjONmSIXt98lvSn5vtZfgdBWo/PsEgkYE1SZp
	 ZQ124w9kGHbB0enRx/JyQcyBcX+0lAC/E0vkhpJf3MHaWokRIMVYKhnQaGKI1OJtDUcsk
	 2C+OtzNZqQTMROHqArd5dx+OLLtdTCRVH/G9m/NeietMr0/MkRfKH3opbaDC6T5wyildu
	 MEX3+GCvVL9S1DpaCjmgDVsw3c/jFxUMUQoWEUIpNSsmkc2EmJBvemkKRtbeYOhG7prOu
	 K4a9sf2QF2QqLR5LWELczguObu7n2iQXE89X0xhAYi+h/dJ5/hBojWJTK+0ka2n/8Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NqQH6Q/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B36606A32C;
	Wed, 18 Nov 2026 22:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqQH6Q/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A121F000C8;
	Wed, 18 Nov 2026 22:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040104;
	bh=N0D9olcUM7QCFlrutDDIZagddW1eedrFwRiGF87eM8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqQH6Q/Y9acGVt2S+VX1gy8Pf1On9WfuQINNffLibeg9LcYTvsRWG/4dd6OPn8nGs
	 XXq9m8YHyRTXQMUfHhSB6egghENoaLBrGqgGN/t+DBcjpLz/A8f+e1RPTlkY8CYbzF
	 4wMc1yPWlwxDPVsdbPyGDib/5wr+w/nW1mbPdrZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Anderson <ejona86@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2338/3318] mfd: rk8xx: Register poweroff handler in atomic phase
Date: Wed, 18 Nov 2026 15:49:20 +0100
Message-ID: <20261118150431.776329190@linuxfoundation.org>
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
index a577f950c6324..c75ce0a9b56e1 100644
--- a/drivers/mfd/rk8xx-core.c
+++ b/drivers/mfd/rk8xx-core.c
@@ -679,7 +679,7 @@ int rk8xx_probe(struct device *dev, int variant, unsigned int irq, struct regmap
 
 	if (device_property_read_bool(dev, "rockchip,system-power-controller")) {
 		ret = devm_register_sys_off_handler(dev,
-				    SYS_OFF_MODE_POWER_OFF_PREPARE, SYS_OFF_PRIO_HIGH,
+				    SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_HIGH,
 				    &rk808_power_off, rk808);
 		if (ret)
 			return dev_err_probe(dev, ret,
-- 
2.53.0



