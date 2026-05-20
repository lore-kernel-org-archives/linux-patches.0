Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F1E3F871A;
	Wed, 20 May 2026 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300939; cv=none; b=K3+oYzTtFoiteVXP3xMSdKiWn7BpZbcpj/Eyg5DCblg1R1v/IJt9Vrye3/owSw4tznmHX+HI30fiPUnygY25XSg6j+hzDb0+/X/5J1JgE33YE5cTupiVknv+5TPbynFzzzY5UT5l4hAo+6AfPwtTRPP07eQmMGiatGi+4wOmlZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300939; c=relaxed/simple;
	bh=IyQEMaU9FbIMbo8SbzZEH7Bd749Sf3tEzu3YXCEZCVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6JWvy1ovkSZ8dkQSUHZH1GBPoyum5lBLBvTD4W4QQSFJscI5ADI4ftBLQd5lJfHUIh5ZgLvlwW5/jzoDR8iLGL/EHajYGssIZIvN23twDx6lTlBHc0raL2B1hb523fV1SnjQ6stsle8jninSfik115d1U5Quw9lJUHcWBcTX5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxCNL3R3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxCNL3R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984641F000E9;
	Wed, 20 May 2026 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300938;
	bh=Jnjf5KntYO/gjwY5fxl8PZi5aDKDWdcB9/7Bg6ZXtyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxCNL3R3eNmN7KuLEugN5zzXwj/BGn4c8LrLrmgFoXKJTmUamj1X6NyDcyILAXvAv
	 aMJ45ExltQHHWiGs3FNWXk4cZcjVdvyDcQzfQ18I6oDmsIbYyxMviKuimqR9+V0Fq6
	 LwAA1awr1lvE/yJKCCuuElHNpkoD/Oh4vAP2z6Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/666] pinctrl: abx500: Fix type of argument variable
Date: Wed, 20 May 2026 18:19:36 +0200
Message-ID: <20260520162119.150895905@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 34006f77890d050e6d80cbee365b5d703c1140b4 ]

The argument variable is assigned the return value of
pinconf_to_config_argument(), which returns a u32. Change its type from
enum pin_config_param to unsigned int to correctly store the configuration
argument.

Fixes: 03b054e9696c ("pinctrl: Pass all configs to driver on pin_config_set()")
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index 68750b6f8e57a..22ef6c2d16a61 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -855,7 +855,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	int ret = -EINVAL;
 	int i;
 	enum pin_config_param param;
-	enum pin_config_param argument;
+	unsigned int argument;
 
 	for (i = 0; i < num_configs; i++) {
 		param = pinconf_to_config_param(configs[i]);
-- 
2.53.0



