Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7D13329B;
	Tue, 14 May 2024 11:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686139; cv=none; b=BvBjlQK+t+FnmnbIKF3xrLXmSp1AjB0SjZJvQZyAAWu49QRLkuZPzr1MBwiS05FwFqeWykQOd495DgTW9OMbrxa6IGbBWrCEdwtLZfYdQIrDGPa+Q/lxAxs1RSPqKDgBe0fP6vatiRoWQqQirkJ7CspSEAH7GPuTw3Cypvg4V0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686139; c=relaxed/simple;
	bh=L7JSsHKOzZvkQJRuRV/G/nbJviAkpKiG1JiTQxRveOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1YRfnRWZC5fOZ5r7RHlz8v5qOUJCLK0iDBB33yP9fmZE7a2U6uIgJY0DobRxb45dMkuAjYT7LYLRStBFZlzkrOpOHiGFCJQ4KYu5pCTiTQRfL76dd1BAaPHCQf2+IfqBz1wHhaGNdqcGlSaSsEDmfrTjlzUphyvf0QgVIr5tbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUhF1tLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUhF1tLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1511DC32782;
	Tue, 14 May 2024 11:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686139;
	bh=L7JSsHKOzZvkQJRuRV/G/nbJviAkpKiG1JiTQxRveOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUhF1tLeiW8/BHTDl4/C1mrVJMPTA6i5PiSdGrKan2Y+tD9HPEjsoa9HgV0QiD9kl
	 3FeVhzA/CwWJ803rfEyN+/Pw5DnrECreegf5pBuPIlyIOO2Ni1p/TvcEAa4aertriA
	 nhTdkXG7Gy+Ye566HOxzhbJ6V5UVSYk7kfg3dGbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/236] power: rt9455: hide unused rt9455_boost_voltage_values
Date: Tue, 14 May 2024 12:16:36 +0200
Message-ID: <20240514101021.637118555@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 452d8950db3e839aba1bb13bc5378f4bac11fa04 ]

The rt9455_boost_voltage_values[] array is only used when USB PHY
support is enabled, causing a W=1 warning otherwise:

drivers/power/supply/rt9455_charger.c:200:18: error: 'rt9455_boost_voltage_values' defined but not used [-Werror=unused-const-variable=]

Enclose the definition in the same #ifdef as the references to it.

Fixes: e86d69dd786e ("power_supply: Add support for Richtek RT9455 battery charger")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240403080702.3509288-10-arnd@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 72962286d7045..c5597967a0699 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -193,6 +193,7 @@ static const int rt9455_voreg_values[] = {
 	4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000
 };
 
+#if IS_ENABLED(CONFIG_USB_PHY)
 /*
  * When the charger is in boost mode, REG02[7:2] represent boost output
  * voltage.
@@ -208,6 +209,7 @@ static const int rt9455_boost_voltage_values[] = {
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 };
+#endif
 
 /* REG07[3:0] (VMREG) in uV */
 static const int rt9455_vmreg_values[] = {
-- 
2.43.0



