Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063985;
	b=qoN6muveLBtT5Jw0gLe9ds2hdcWSVD3IyiFcxE0GQto+XZKV0FIUtauQDPJ/YW8PAUwB
	 txbqi3hTsth/yCbTzre6LbrF2WsLppgHlqdI6w3AvckNah54XjsMgTJJJTczetzKu1J6+
	 5ZJUskRcyjkzsr1lVHQxq0IEWJJYra++AVth7HMXq+WIP1tOchtIygthtS7H6Qiy2eqaw
	 FQKa5e0HIHl/WaBBSOJ5pCPTREnKB0HKBXHacsuCJKyFwmYH4HtpClaxTIdnozD7hcKcl
	 5RPId9VS2JqO59vE3eUN3i1KsK8w33A5TPYc2NIpz/d0f2fJunPvXTMal09dRzCFnAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCFi3tBCYvTNZRduD2j79DWlrs4g2O9CZqBctrjoRoM=;
	b=L3bknDtL1b2xhgfLEpfZRMgVmAwivqydfhFmrzayj+UEOMzGackSOjkCgbBQhgPeJxio
	 jp8tCeAWldrj0FKxP5zWSb5QbMM6h+sskq8VoGMhPMPg6Q/hgYUkA94ZGQrUnr+9AqQ0O
	 YUD4v9C+sbELEed8HpvIbSakR2drrmQlkkOLxi0awRNy9sjNzYq5LcYaCwUg67Pt24/t2
	 PL9X6Y/NfZD8eyJybE93F9Hs68QdavDecFlQKRfsHx6HOTIglctfd+DmmnlTszsKPdCgZ
	 ZI6CbhMoI7GxMsWXsbFSfalInfHYLtzkMCR101ArI97hhLZ73FcToIqFokeCSq6s77A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+mvayw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB996082BD5;
	Sat,  7 Nov 2026 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+mvayw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086B11F0089F;
	Sat,  7 Nov 2026 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063985;
	bh=tCFi3tBCYvTNZRduD2j79DWlrs4g2O9CZqBctrjoRoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+mvayw+CCTk/mdSinKuup1lkd/ZTvCQIQsuMf+B5Z9xRBFkwZbrOB1ZDlUJOIMHn
	 DwBTqMWhH1CEaIEqG4GKZM8Iks+Qoo17Gw29qb9iI93fnw31psL03rAhko8s68Uony
	 Gznan4c0DYRR2rZ203kUF4WXFUO803hmuohcJ2Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0130/1257] power: supply: qcom_smbx: include base when petting watchdog
Date: Sat,  7 Nov 2026 08:40:26 -0500
Message-ID: <20261107134942.910954709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/power/supply/qcom_smbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 67fdb43353388..e6f2328f295c7 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -764,7 +764,7 @@ static irqreturn_t smb_handle_wdog_bark(int irq, void *data)
 
 	power_supply_changed(chip->chg_psy);
 
-	rc = regmap_write(chip->regmap, BARK_BITE_WDOG_PET,
+	rc = regmap_write(chip->regmap, chip->base + BARK_BITE_WDOG_PET,
 			  BARK_BITE_WDOG_PET_BIT);
 	if (rc < 0)
 		dev_err(chip->dev, "Couldn't pet the dog rc=%d\n", rc);
-- 
2.53.0



