Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9074D263F44;
	Sat, 30 May 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161601; cv=none; b=JdVgNTQ4sCf7OfDj7Jz22amqv9SsxUK7nIvEQS/ePmNzhPau7bBux+VQ8ozfQ4N6IXJ9G6Cfo1yPHxysylnTQjzkLe42GzYaen97AFd3nOEW0r/RCTHIeAqcxDcXvvL+JKV5OB3BbAgTnkHX1kda/goiPayjGveS5mKxFBbltmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161601; c=relaxed/simple;
	bh=JvS565+tlqftYkVDUUkOE2kQku09fVavK/CiRdzc1Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA3wKJiCqO/rRM1oFmAXFhadjhQYaFh3AVjach+Pnm1/ychDYWtl3/Bbxsil5apWpz3AMc2vmcBsA4iwwa7U8itPWk1yvmOOVbMGxMp0jTo6cXG7yMQDLiZwQ04l7xIBpFMZAYH8viyGP9aaka58lly4iwFoMfa8DcMORGRYOTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRPvSewh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRPvSewh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D407F1F00893;
	Sat, 30 May 2026 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161600;
	bh=TEM69m8yVMlHzfRVaYK6rp092qmkDP5P4bi07j/YsU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRPvSewhcqFQpPP4LZd4pIX+sgFebBgPVpxi2dzT+deIj4fPaRzuvavH7Qoz41eOC
	 qg4r7OJv+MVqHDDJnD5AI730uwWT3oYY7+G+7AhuB53gRBRISgjeDKVDkpXyERNz/K
	 Y5g8HIigX1J8ZWAHw5R3mZSVq7PnHOPzhsP8LnSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 631/969] pinctrl: abx500: Fix type of argument variable
Date: Sat, 30 May 2026 18:02:35 +0200
Message-ID: <20260530160317.874807932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7aa534576a459..609313d93e31a 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -850,7 +850,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	int ret = -EINVAL;
 	int i;
 	enum pin_config_param param;
-	enum pin_config_param argument;
+	unsigned int argument;
 
 	for (i = 0; i < num_configs; i++) {
 		param = pinconf_to_config_param(configs[i]);
-- 
2.53.0



