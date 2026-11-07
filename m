Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061966;
	b=y2iwHyOaOxjRRkzpeoRHIPAH50SzUGRUnRiG2jxO/Z8sDTgetRCxUAZHsoiJA538yPq7
	 9uQizpKbkhR63PWd73ARabyHwmyKkYZsbQM0/HQ0ijfFwZvwWO5lrAPiWjO9R9DuFyF6s
	 8zwZMUDLKSHY0DqPRrUQqyhdj3n7EiRB/DFb+p9REslR+R56u3C4qlHmqSy6w3AfQY5Ev
	 Alh8+nd4RFEtSLggePU3tC5caqca+ozWIZWfO0rkv8kTd8kS+MuVMuWJzmqn1eVZ7MHPj
	 aEcueiKptRl5kha8cGBk+QNJ2B7sjXuygVQBBc+wpQXqlW3B7EQ6aJfo/mQvvQ0EKDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c2+0E/vLYhIpn+RvOPI8B7cXzkfhwo/xHD48E+/t4XU=;
	b=2Yyxr0OrEUFqczijW9nZiAVO5m1WyuH6SkTVh6MkmLhT5NnjzlUPg1845SQwmqWXNytL
	 skzkZaksh8RWSrn6+wfJDwnhrG5+AxCJ8tvQivvlu5xpH5rnfiaieTkasJWOyiFgSVcWp
	 A4MaUtYL48ZiTeXyEh3fja/jZL2UesM63deUrc7VpSliO7puUcF4On9k+pkVeuLgO2LIR
	 UX3NYP7H5QwLkzAdXAuV2WlPw5lCBE+hXKsTLTTkWeyUOGalhPPCxAZ49UCKWR8oRsZku
	 For6gQfWfyQukZuCE1Qk0lIj+O5U1oMVZctf3cTUoMJ1HiNd0N4fsJhDNvTXd6ByljA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDIESzzt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A67606A32E;
	Sat,  7 Nov 2026 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDIESzzt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FA91F0089F;
	Sat,  7 Nov 2026 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061966;
	bh=c2+0E/vLYhIpn+RvOPI8B7cXzkfhwo/xHD48E+/t4XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDIESzzt0f7doDiyNI/oUf3CNCcUGjBWcO5l/EmiVCuWn+5LTu+2cOhYG8HX+FQiM
	 0JMzkEJ36ZD7/mHOyi94RCW4Fo373lj2MmQPeMfVO7dKMwrCnIFRBuvDkWRqJ91C6y
	 PlmJftcQE1D99jGKOtOow4YJriM9kAgRA/zywN7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0963/1536] power: supply: qcom_smbx: test battery health status bits
Date: Sat,  7 Nov 2026 08:49:39 -0500
Message-ID: <20261107135024.698816799@linuxfoundation.org>
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

[ Upstream commit 68f645192f64e1037685dbdb0dffb41a5a012056 ]

BATTERY_CHARGER_STATUS_2 contains independent status and fault bits.
Switching on the complete register only recognizes a fault when it is the
sole asserted bit, and can report a healthy battery when another status
bit is set at the same time.

Test the relevant fault bits in priority order, matching the Qualcomm
downstream driver handling.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-2-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 22 ++++++++-------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 6e5d78232f388..7d13da8e8cb93 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -629,26 +629,20 @@ static int smb2_get_prop_health(struct smb2_chip *chip, int *val)
 		return rc;
 	}
 
-	switch (stat) {
-	case CHARGER_ERROR_STATUS_BAT_OV_BIT:
+	if (stat & CHARGER_ERROR_STATUS_BAT_OV_BIT)
 		*val = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-		return 0;
-	case BAT_TEMP_STATUS_TOO_COLD_BIT:
+	else if (stat & BAT_TEMP_STATUS_TOO_COLD_BIT)
 		*val = POWER_SUPPLY_HEALTH_COLD;
-		return 0;
-	case BAT_TEMP_STATUS_TOO_HOT_BIT:
+	else if (stat & BAT_TEMP_STATUS_TOO_HOT_BIT)
 		*val = POWER_SUPPLY_HEALTH_OVERHEAT;
-		return 0;
-	case BAT_TEMP_STATUS_COLD_SOFT_LIMIT_BIT:
+	else if (stat & BAT_TEMP_STATUS_COLD_SOFT_LIMIT_BIT)
 		*val = POWER_SUPPLY_HEALTH_COOL;
-		return 0;
-	case BAT_TEMP_STATUS_HOT_SOFT_LIMIT_BIT:
+	else if (stat & BAT_TEMP_STATUS_HOT_SOFT_LIMIT_BIT)
 		*val = POWER_SUPPLY_HEALTH_WARM;
-		return 0;
-	default:
+	else
 		*val = POWER_SUPPLY_HEALTH_GOOD;
-		return 0;
-	}
+
+	return 0;
 }
 
 static int smb2_get_property(struct power_supply *psy,
-- 
2.53.0



