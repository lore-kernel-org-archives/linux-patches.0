Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A4718E025;
	Tue, 17 Jun 2025 16:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179212; cv=none; b=Rh3V0ncc06fasnmZ2PRmCFeLk0Qw8YlHUx9RhbZbaKkc187XYbNpRQp4VX0fFWFDH29bTPWC4+ZEZ1Sl+51xY40hSRW0+rK1xmoskJSa89/JtkRcSIl8krdg0C0DOqtq1msR5dWIUb7cCcCD4eVoggn1cy9+JiMAPdnuU0xOrzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179212; c=relaxed/simple;
	bh=GaIaDROnCU1qd1SJ6bc2vj0kCqMC+UIgPXgZVyG50Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9mzEns7qFkThdYnJ/hCvsn63S1doAkJQZyCzUmsCg9UYX2gxrNimPZ6T7e9ZG9w+7zHprFXBIN2cHrjc19KZF+dU2cNqjzsrseka8Rh/MrNQD3hcPpSXGrkXmypHLSYNYkUwLOqvOC6iAeXgqvQlkNjOa/1mb+22gSFTLO+/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeAAmMMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeAAmMMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2208C4CEE3;
	Tue, 17 Jun 2025 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179212;
	bh=GaIaDROnCU1qd1SJ6bc2vj0kCqMC+UIgPXgZVyG50Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeAAmMMGVuoSGEtzPfo5k7aopiGCiY3IVlOROJa/qZ/ZbeHODNi6W4nnym0hczoB+
	 gZrUA3AErt9y7tqNuOIp3G41NGC9We4LZAZCF3sFJika5qmqV8TGtejwOa3gIFvhsS
	 N0EWKvIDPTrcVmGSNDY7q1wmTOhB65GoOyE2/dIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Slenska <wojciech.slenska@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 683/780] pinctrl: qcom: pinctrl-qcm2290: Add missing pins
Date: Tue, 17 Jun 2025 17:26:31 +0200
Message-ID: <20250617152519.287655362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojciech Slenska <wojciech.slenska@gmail.com>

[ Upstream commit 315345610faee8a0568b522dba9e35067d1732ab ]

Added the missing pins to the qcm2290_pins table.

Signed-off-by: Wojciech Slenska <wojciech.slenska@gmail.com>
Fixes: 48e049ef1238 ("pinctrl: qcom: Add QCM2290 pinctrl driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/20250523101437.59092-1-wojciech.slenska@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcm2290.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcm2290.c b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
index ba699eac9ee8b..20e9bccda4cd6 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcm2290.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
@@ -165,6 +165,10 @@ static const struct pinctrl_pin_desc qcm2290_pins[] = {
 	PINCTRL_PIN(62, "GPIO_62"),
 	PINCTRL_PIN(63, "GPIO_63"),
 	PINCTRL_PIN(64, "GPIO_64"),
+	PINCTRL_PIN(65, "GPIO_65"),
+	PINCTRL_PIN(66, "GPIO_66"),
+	PINCTRL_PIN(67, "GPIO_67"),
+	PINCTRL_PIN(68, "GPIO_68"),
 	PINCTRL_PIN(69, "GPIO_69"),
 	PINCTRL_PIN(70, "GPIO_70"),
 	PINCTRL_PIN(71, "GPIO_71"),
@@ -179,12 +183,17 @@ static const struct pinctrl_pin_desc qcm2290_pins[] = {
 	PINCTRL_PIN(80, "GPIO_80"),
 	PINCTRL_PIN(81, "GPIO_81"),
 	PINCTRL_PIN(82, "GPIO_82"),
+	PINCTRL_PIN(83, "GPIO_83"),
+	PINCTRL_PIN(84, "GPIO_84"),
+	PINCTRL_PIN(85, "GPIO_85"),
 	PINCTRL_PIN(86, "GPIO_86"),
 	PINCTRL_PIN(87, "GPIO_87"),
 	PINCTRL_PIN(88, "GPIO_88"),
 	PINCTRL_PIN(89, "GPIO_89"),
 	PINCTRL_PIN(90, "GPIO_90"),
 	PINCTRL_PIN(91, "GPIO_91"),
+	PINCTRL_PIN(92, "GPIO_92"),
+	PINCTRL_PIN(93, "GPIO_93"),
 	PINCTRL_PIN(94, "GPIO_94"),
 	PINCTRL_PIN(95, "GPIO_95"),
 	PINCTRL_PIN(96, "GPIO_96"),
-- 
2.39.5



