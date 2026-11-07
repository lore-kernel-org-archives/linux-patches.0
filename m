Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061965;
	b=ihDodHu1y64PHFOrEgmCvBJ47B1Mob1u6UYN+JVg3mDQV4aqgYpNqpumcBdrTINQUBiU
	 odNrWVgsrPUxa4h4iLsnA0D9hMnOmT+LSFt4JEhc0Xue8ViBIVZuOr5Id8f0fKjX49QcJ
	 nU/nRq0tjqjZJos1ctOvhXG0qLo+PbiQJY/GGt/pNrlWt5wnsrQMbO9b9TjpIA1ZF/o1Z
	 9jDx+BylRm227OmmkHJwrw0ll9Ie3SB9Ey1Myvb3weqH5qISHy3J9XJyh6q2UNAT/BWT4
	 D13ZUeVh1ThorwM1RkNA4BDAqomFaSyypmEAcJp4CWChor7u09ru3iqC0yOuRreNZPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z4RO40POcRCdnDWELn1+evAioDidJmFq6BEZOODW4DM=;
	b=wssi4kaYpsOmKhPO7PJ7KHgviA/1bQQBs83tZrhRoa3p6nb5X9KPvyf5/M7MpwuhkOoH
	 CF9w2kC/5RUMhVp85dYG+nNGg+8TuEynHU2/+rtMkdi5UExEH7Fxpz2l2XzFxGNZ1T0/A
	 ibwE7sl0oI/bzVbGx8JUYAbIdqiNApNe/mA6JvBrXmFFLcE0MSjswEwbsTjpvHlt6dEDn
	 aOv9i+e8KlUV5/Nx2zXdqY+DG9H9CdkL9cPl9C/jtqzGlRZWZtkL+fKHvCzJO93MXsTux
	 T86fYjm0gImzYkA1H72MANcsCL3YBi2RQnEo7ecD1zmhY+chTotmxMordFKFAbLLvsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOF+tafa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7AB606A32E;
	Sat,  7 Nov 2026 14:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOF+tafa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8881F0089F;
	Sat,  7 Nov 2026 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061964;
	bh=z4RO40POcRCdnDWELn1+evAioDidJmFq6BEZOODW4DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOF+tafa8GzoOHdr4jy/EfyGDh5zFXFu76WiAe2rkEBmZrp6kEehcavS1mcn7ikGK
	 egeINb4CYZd5izkKd2705nqEmEpd4nyeL3KLW80l4CwYhUPmWP+MWn5TBeEehFK/dc
	 HtXWb62FY2+dUc/2duNSpDwDf8OXYNO5rKK9BZbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0962/1536] power: supply: qcom_smbx: include base when petting watchdog
Date: Sat,  7 Nov 2026 08:49:38 -0500
Message-ID: <20261107135024.669951030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Snyders <robin@snyders.xyz>

[ Upstream commit 2f0dec12007891398e6e3041aca0b8656918973d ]

BARK_BITE_WDOG_PET is an offset from the charger peripheral base, but
the watchdog bark handler writes it as an absolute SPMI address. This can
write another PMIC peripheral and leave the charger watchdog unserviced.

Add the charger base, as all other qcom_smbx register accesses do.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-1-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 81acbd8b2169c..6e5d78232f388 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -757,7 +757,7 @@ static irqreturn_t smb2_handle_wdog_bark(int irq, void *data)
 
 	power_supply_changed(chip->chg_psy);
 
-	rc = regmap_write(chip->regmap, BARK_BITE_WDOG_PET,
+	rc = regmap_write(chip->regmap, chip->base + BARK_BITE_WDOG_PET,
 			  BARK_BITE_WDOG_PET_BIT);
 	if (rc < 0)
 		dev_err(chip->dev, "Couldn't pet the dog rc=%d\n", rc);
-- 
2.53.0



