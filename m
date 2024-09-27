Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3E818C02B;
	Fri, 27 Sep 2024 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440306; cv=none; b=D571Y3xttfQ0vcROX25YaKq2DdCym9d+7tZxIRpgpDbc7g/wDHUX8woQ5wzxtWKILPUlUgPGVnjK0zQoMO9PKTlUoqtXrxcKyzC+HK89Dp0hia6vqiTcXmMDQfbBzbeB5inT1HLHa18iVE3Jt1yZzkv/VPzUyaVQxmJT+T+ulAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440306; c=relaxed/simple;
	bh=unjbsM1e5RW0c4y+kF3MWl7TimJJrPrHqcqg2XV1H9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcpTTMqknuOnpi1wupfshw5pPQT44NtdEfRTFJZ40194/v+3Hzjtj+Zd/9jHLIp1nll6LKgQvNMMQgkR0oXZAWXr5f+U1k7rHxXyxX/HpYthIF7TjeYzz5J3SpcPq7P3Jbv3Avs7FUHqCKlunc/c/6a8AKir76qKIV6Zly0/lfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoOGAWJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoOGAWJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27528C4CEC4;
	Fri, 27 Sep 2024 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440306;
	bh=unjbsM1e5RW0c4y+kF3MWl7TimJJrPrHqcqg2XV1H9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoOGAWJm/Zq6IquFi4WMuF8yJx9MkgL+5G+jRfpPdlWfQAekOJWjR/y9yjUFIe850
	 +Bgd0Cms4YcWTs3UIpdoaw0/EuJ6VQQNCT3GAmfkfi4V2G5zrFrmvvSlIn7IrzzQiA
	 HtVTWNpI02Faa0Oc95FZRXmKT9DBsNA24pfROedQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Brown <true.robot.ross@gmail.com>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/73] hwmon: (asus-ec-sensors) remove VRM temp X570-E GAMING
Date: Fri, 27 Sep 2024 14:23:19 +0200
Message-ID: <20240927121720.220728100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Ross Brown <true.robot.ross@gmail.com>

[ Upstream commit 9efaebc0072b8e95505544bf385c20ee8a29d799 ]

X570-E GAMING does not have VRM temperature sensor.

Signed-off-by: Ross Brown <true.robot.ross@gmail.com>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20240730062320.5188-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index b4d65916b3c00..d893cfd1cb829 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -369,7 +369,7 @@ static const struct ec_board_info board_info_strix_b550_i_gaming = {
 
 static const struct ec_board_info board_info_strix_x570_e_gaming = {
 	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR |
 		SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
 		SENSOR_IN_CPU_CORE,
 	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-- 
2.43.0



