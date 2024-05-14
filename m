Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE82C126F02;
	Tue, 14 May 2024 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687540; cv=none; b=bIW9vymLfv2J6padd7bymtOK2bUoXEg97KJLbIgHNTIZbGBm4rC3Q0gcKAIuEDlQYo0gTssVFma0gQG+UiA6NlJA/O+I9AKDq74foQ1ATRA5W8kD51J5HspySzWE7gz15fdl6xe6l/yLQH2IQMR2y3lLOOcpeH5ro9S1Xe6RiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687540; c=relaxed/simple;
	bh=YxijwhgQwzXgMPwWiZrMsIeCJ4bAGrkyoTXF5ahgnvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6fwAgwZQXMpTUQ9p5ujrM76lXupNwYJ/NQ0cvFSs+g0iDO3wtmWc5E9YJ8nabFeT/UvCZSJUWSIFUW5qSq7nPTKc58YSFKeK1G8uVR+e0NCV08XxJ+Mrru8OHkvHS5zdM/J9QZitlrh5t+kstfyJv4Urt2O+ivpOy3T5BK/xfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gOYgEMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gOYgEMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353D4C2BD10;
	Tue, 14 May 2024 11:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687540;
	bh=YxijwhgQwzXgMPwWiZrMsIeCJ4bAGrkyoTXF5ahgnvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gOYgEMu1GrnEbA8lZ2RXBkbJnIALWh9X6L35leVeEMuKMLQNboQUo2+MJkr9NkRH
	 uQ75gSsLchH8XPlPGk9Rj6ZH1Bdqr6djH70ECVAdo8WAtJhkCqcIIQSagGcwwxaRvC
	 EOZJsd+7MZDQe3ZiAs3yuioZyPd8dAGtNlKVI0eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/168] power: rt9455: hide unused rt9455_boost_voltage_values
Date: Tue, 14 May 2024 12:18:38 +0200
Message-ID: <20240514101007.450089187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 594bb3b8a4d1e..a84afccd509f1 100644
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



