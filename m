Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CFF18DF60;
	Wed,  2 Oct 2024 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876284; cv=none; b=u8Sr7FyTiUqx/vYVNx7NO1+fGETjCeTgUAkFQMGd6bYJg3Jibxo/Vz8yTLFjVpfirLacvyRQ/VDr9V82OHJ9ekpOW9fPr6jh0f1Ak0lWnvnxQ4m43f+liU6JDaXXr/hEjcP8gv6LWxNz7eiuAmQG+Lpe9kDa0kLyWre1omiJ34A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876284; c=relaxed/simple;
	bh=7Tivnvo2wL2VEP0OWMRvS6byf4uDJVJvNd0FR5Hkjic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc21id23u19qUtC6L7uj6irtXl1DKYfRAmCd+mQUQEPRNwqXaJ68q1dFV3VJA3LLxr36TKIIuVR9RNnx9CieS+y9IH2PV+b8urKMFX2jeeRpN2mVaLI42Fh7FTHrF+Prbih5vZh2Su0j0gXjaWU0wBIbFIXk7uvQ/qlOucSMmo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxUh6mqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxUh6mqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5483C4CEC5;
	Wed,  2 Oct 2024 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876284;
	bh=7Tivnvo2wL2VEP0OWMRvS6byf4uDJVJvNd0FR5Hkjic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxUh6mqXQRMeYUV3ouMU/JqIfS/P41pQqRPoavXUWKFTyTgpEi8ZBFCHkJ1HuioXt
	 4Z0L+M3qakj1TPGV+xt4Ft/tB58DIzylOmbb/lQ8YInbMpJ4kleJvleUiBYJTu4DPw
	 hOhCpuNx9QDOEeNHLH3FIjdZrm8mBUgDP3y256gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 360/695] pinctrl: renesas: rzg2l: Return -EINVAL if the pin doesnt support PIN_CFG_OEN
Date: Wed,  2 Oct 2024 14:55:58 +0200
Message-ID: <20241002125836.814627489@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit d56abfed1c02814b5ee96b0ed1f989ea9d7f6cbb ]

Update the rzg2l_pinctrl_pinconf_get() function to return -EINVAL for
PIN_CONFIG_OUTPUT_ENABLE config if the pin doesn't support the PIN_CFG_OEN
configuration.

-EINVAL is a valid error when dumping the pin configurations. Returning
-EOPNOTSUPP for a pin that does not support PIN_CFG_OEN resulted in the
message 'ERROR READING CONFIG SETTING 16' being printed during dumping
pinconf-pins.

For consistency do similar change in rzg2l_pinctrl_pinconf_set() for
PIN_CONFIG_OUTPUT_ENABLE config.

Fixes: a9024a323af2 ("pinctrl: renesas: rzg2l: Clean up and refactor OEN read/write functions")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20240723164744.505233-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 632180570b704..3ef20f2fa88e4 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -1261,7 +1261,9 @@ static int rzg2l_pinctrl_pinconf_get(struct pinctrl_dev *pctldev,
 		break;
 
 	case PIN_CONFIG_OUTPUT_ENABLE:
-		if (!pctrl->data->oen_read || !(cfg & PIN_CFG_OEN))
+		if (!(cfg & PIN_CFG_OEN))
+			return -EINVAL;
+		if (!pctrl->data->oen_read)
 			return -EOPNOTSUPP;
 		arg = pctrl->data->oen_read(pctrl, _pin);
 		if (!arg)
@@ -1402,7 +1404,9 @@ static int rzg2l_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 
 		case PIN_CONFIG_OUTPUT_ENABLE:
 			arg = pinconf_to_config_argument(_configs[i]);
-			if (!pctrl->data->oen_write || !(cfg & PIN_CFG_OEN))
+			if (!(cfg & PIN_CFG_OEN))
+				return -EINVAL;
+			if (!pctrl->data->oen_write)
 				return -EOPNOTSUPP;
 			ret = pctrl->data->oen_write(pctrl, _pin, !!arg);
 			if (ret)
-- 
2.43.0



