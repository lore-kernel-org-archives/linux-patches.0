Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544E30505F;
	Tue,  2 Sep 2025 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819429; cv=none; b=Zqo+5T9KpCaWCK6aHcTUGqsMiPGLED3zMuxaMBFRikPAe+XqEXO46jZ8K16+c44R9q+qceeL2BC4dAAl9zOu4Nsw8FPWgwINaba2xIZDRFexZ44LtCSyB8hgqINw9UFq9eu73HTULoDLEUS1LVO2JPCN0T/S7s3iaf90RdB59is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819429; c=relaxed/simple;
	bh=v7KI9lAROeCQ24byTU0JQ06rIfueY8hvYFz3iOfrCqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umMMxczZ5ZffE0HHPEACFHMLfVeXXm9V3x44CzBxw8+/oXegHBYnQC/Lo6jp5jp7k8RwCR9stGpPA8UckByb08OIxGHHnrp6y2Juf53iBxLvwm+6yArd7S4bUDiMou7upjzYzXT0CSlsrooYtyOn+85xaeEpIYgbYDMoAYn2N2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUerISVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUerISVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220FBC4CEED;
	Tue,  2 Sep 2025 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819428;
	bh=v7KI9lAROeCQ24byTU0JQ06rIfueY8hvYFz3iOfrCqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUerISVJJqHK6p+MVGY0Jm8O9kgoEoyNFFc7yhpuFGWZKk3gOJZvccvI19ylrBvbE
	 /qthYGiQCg0G0sUISK0hu945wmYE3depX3uIa2SX7KeK8QSGafexXt4kvF6Nz/lo02
	 A8/pNx+YoEUMcBKL1t11FOpWwKKmZrIcc4J10UPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 008/142] pinctrl: airoha: Fix return value in pinconf callbacks
Date: Tue,  2 Sep 2025 15:18:30 +0200
Message-ID: <20250902131948.476183994@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 563fcd6475931c5c8c652a4dd548256314cc87ed ]

Pinctrl stack requires ENOTSUPP error code if the parameter is not
supported by the pinctrl driver. Fix the returned error code in pinconf
callbacks if the operation is not supported.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/20250822-airoha-pinconf-err-val-fix-v1-1-87b4f264ced2@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index b97b28ebb37a6..3fa5131d81e52 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2696,7 +2696,7 @@ static int airoha_pinconf_get(struct pinctrl_dev *pctrl_dev,
 		arg = 1;
 		break;
 	default:
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 	}
 
 	*config = pinconf_to_config_packed(param, arg);
@@ -2788,7 +2788,7 @@ static int airoha_pinconf_set(struct pinctrl_dev *pctrl_dev,
 			break;
 		}
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -2805,10 +2805,10 @@ static int airoha_pinconf_group_get(struct pinctrl_dev *pctrl_dev,
 		if (airoha_pinconf_get(pctrl_dev,
 				       airoha_pinctrl_groups[group].pins[i],
 				       config))
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		if (i && cur_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		cur_config = *config;
 	}
-- 
2.50.1



