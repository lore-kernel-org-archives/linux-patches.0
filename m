Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31E17B515;
	Fri, 27 Sep 2024 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440075; cv=none; b=eVGzoB1Es5MYX/2aJ3zRgwhlU5oqVObqScM4UEeG1/E/iC+PS75XsBDu4ZBIwLOk1vV0DS0qc93yhgeK3AA3oX6bQZX557tlqPIwNdCgmXGE5+GrZZFKTH+zyJNDONZIYe1xsxacLfS554OUWao5bfEyn4RS88MydXbaRrtQEEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440075; c=relaxed/simple;
	bh=TZrbR6ov1sGsyaCGjGAh4BTkl+K5r/7Dipc3s01MCjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hafRq6sjUBx4vzJj+XepFTsh/2bQDnwwokty6HA7AGh6Sr+FAI2zMe/eLEU/k3yhIjW0PKV87peH6oKaKfXg3eKMbQABaU6J1pyKQ+z0LGgGCl/XUlNza+47B7j9FuMagOFk5z0MI2vyj3rg12FxIzIeF355LlRGrhEtpJhypW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNtuBt/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNtuBt/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49691C4CEC4;
	Fri, 27 Sep 2024 12:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440075;
	bh=TZrbR6ov1sGsyaCGjGAh4BTkl+K5r/7Dipc3s01MCjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNtuBt/dwIreABaq0t70EwP9Wc4tmbX8z5XbuMfIIo/wbCk0VbdRmmesZphYGu4fk
	 jwwun1T/RgtC7TjYpf9dWauAbEcJqWLrlnV3Nfxk0k3mOJXODZDLFGhmtkzqYgbABA
	 m4gA5VjWHJ+O83ZG7GmzI7CEiqdVqT0FKnzMT1dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Brown <true.robot.ross@gmail.com>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 09/58] hwmon: (asus-ec-sensors) remove VRM temp X570-E GAMING
Date: Fri, 27 Sep 2024 14:23:11 +0200
Message-ID: <20240927121719.173740536@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 36f9e38000d5e..3b3b8beed83a5 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -412,7 +412,7 @@ static const struct ec_board_info board_info_strix_b550_i_gaming = {
 
 static const struct ec_board_info board_info_strix_x570_e_gaming = {
 	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR |
 		SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
 		SENSOR_IN_CPU_CORE,
 	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-- 
2.43.0



