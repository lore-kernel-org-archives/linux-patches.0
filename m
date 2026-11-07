Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062816;
	b=MdrCPw+7FFLl3tkiR4PSQ3iyKuyRUwWuX0Kt12TuWEuPFTwDHQIkUKEsHfQbMhL56Cnj
	 0NaJph0Bht2crigzgst8Lqh5LmH03R+Ch3YPMSRwTIsPWtCcCXDnPBQQRe8sKy4WgVIVg
	 LbAsXmn+nkgddMgjJy/VLqK6s8oK7LZ4LQ+wbkqyFhrlOvz7Ufs7Ag6x4KHTY5gZN0P2T
	 2qmslaqJhLfcmUINeS24WF2ybhiynOMNaQOFTHl1nKeKRWMUOFu5VYHmD4wV3pbg7roV/
	 QfMrBv6OACPHIfZyQGqtKIHIeOIGeQnQy6RykJ9fZ7A+0t2h7qj9Q7Oc/KG8Xbshoqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FNodHOSEzT0/2JHmU/fxQExkoAFLdx98B5o1LkMVByI=;
	b=s7bxzo3M2tLGkRHcSNgibgDriEotq7b622yYtTcdInOec/J5P3jnzLMK/2rXGdUBlYeu
	 FiTAGSlwl7oAj/3QCKQnF3kbryROVSYM0t89JiGukyuuuCyz3bWE3O6VI+zNhsJjlPmeF
	 sjR1tJhjxQWT9c/+yFmVS8P9iSsdAGSI+YPk8VN4+VmA+pLmsdCqe+Pp3BJZmeCLLxQkt
	 EEet7yY+56+SDbtmsgJhJ+a7bghXneBcQh6yDp1QYR4+lTM/Uu2HsgMPCbkPz3u6quJSi
	 MNUHkAhhuWHGS2c/NXpbWWkKgDL2IhoNoJ8ku9f+SVzRPeNWuqXDkX9ifs9Plh2XX6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AcvK/OBK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F41F606D817;
	Sat,  7 Nov 2026 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcvK/OBK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1839B1F0089F;
	Sat,  7 Nov 2026 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062816;
	bh=FNodHOSEzT0/2JHmU/fxQExkoAFLdx98B5o1LkMVByI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcvK/OBKiPz3b//2W3LDw6RK5ic9x809bagELlPhgwpnS/2+mNoCeeH3F55bdPehG
	 rnxoXu5LaAbsbPoQ3gKeccqNE0Il9/zgMtddm4meK5tnNb1qEctJD9i4Vi9U47RD6E
	 LabQKNIc0Cd2V5GC/zcgNoHJHTmOqhi8X8Wnpd04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/869] power: supply: qcom_smbx: test battery health status bits
Date: Sat,  7 Nov 2026 08:46:36 -0500
Message-ID: <20261107134856.430428829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/power/supply/qcom_smbx.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 11aab7e635592..6e976342a3fbd 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -629,26 +629,20 @@ static int smb_get_prop_health(struct smb_chip *chip, int *val)
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
 
 static int smb_get_property(struct power_supply *psy,
-- 
2.53.0



