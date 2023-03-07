Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03647BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6864DC433D2;
	Tue,  7 Mar 2023 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213022;
	bh=cDv81CRFHIsoqIGkZy7byR7wvu4GaiIgPSCBNHJh2BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNP9FiCyQkz2EPj+y1AmROfbnCcbBgYUikgpq9fVob4/+lXkWHcvrDoKYDD7ldARg
	 B4l5UtkQcLx/pBjjsMajy4w8tUlF/e3pH3siDLO5Y37HEtAQhePpAbL3yXSh5xbmj4
	 fF0guZbDJ0aYKmxE7YK+8OWTrilFeO84PoDfAZg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 343/885] hwmon: (asus-ec-sensors) add missing mutex path
Date: Tue,  7 Mar 2023 17:54:37 +0100
Message-Id: <20230307170017.131243187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit e2de0e6abd91b05411cb1f0953115dbbbe9b11ce ]

Add missing mutex path for ProArt X570-CREATOR WIFI.

Fixes: de8fbac5e59e (hwmon: (asus-ec-sensors) implement locking via the ACPI global lock)
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20230121111728.168514-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index a901e4e33d81d..b4d65916b3c00 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -299,6 +299,7 @@ static const struct ec_board_info board_info_pro_art_x570_creator_wifi = {
 	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
 		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CPU_OPT |
 		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
 	.family = family_amd_500_series,
 };
 
-- 
2.39.2



