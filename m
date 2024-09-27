Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2156618C34D;
	Fri, 27 Sep 2024 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439956; cv=none; b=n0/Y6f7udRFnfy7Yxi1xdE7EECV+UpcAPZwsoB1YKWlMSHh50YES866jGx3tmiCSc4Lqfvt3L+rTEeETA/m4CF23lilCPZcPnj9euQWd3Y5jdABSos/DU78fIhH+g07iYqxBc2LNFxWOmU2ppA688ijoNpENwD4ATYzlTSMuJdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439956; c=relaxed/simple;
	bh=i1cAtaNLXj0ih9gg1GS8uSArew5oyhmhlQwsEvzCwrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srUBlU4cwNOm4ZnuFqa6YQlzMw3NUmEBSdYiYjH6gDVO6CSrnthmQAhfP7xQgLSccPd3XLaFv2z+UyEBbol3IEuUJt50z1gFZWXA+CJ2dMC+ff7m7zGH5YEya7BYiPAfdvMhsQdD7s5dq9x9mJ0xm5nkprPsGvFdetWOBHNlzyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R131U2BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R131U2BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24EEC4CECD;
	Fri, 27 Sep 2024 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439956;
	bh=i1cAtaNLXj0ih9gg1GS8uSArew5oyhmhlQwsEvzCwrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R131U2BOV6POmx8zNBbmJ9fzXwSrRPTXvbVFQSMORJdj/50Vhxy5jUI/HslHEJ8pW
	 x/CoEM3Es8ZbPF0lYGvAgEXKNyySt/aIwqXzMXHC5aAFNQb1vIK3fuksy1/+TnPMbr
	 gxwgcpq4bEtCPk5ErC6Lks+LSUNITzGLUVzkOV68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Brown <true.robot.ross@gmail.com>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/54] hwmon: (asus-ec-sensors) remove VRM temp X570-E GAMING
Date: Fri, 27 Sep 2024 14:23:01 +0200
Message-ID: <20240927121720.089231549@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51f9c2db403e7..f20b864c1bb20 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -402,7 +402,7 @@ static const struct ec_board_info board_info_strix_b550_i_gaming = {
 
 static const struct ec_board_info board_info_strix_x570_e_gaming = {
 	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR |
 		SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
 		SENSOR_IN_CPU_CORE,
 	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-- 
2.43.0



