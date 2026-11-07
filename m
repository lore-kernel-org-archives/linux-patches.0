Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063986;
	b=C82sRTOuTRf0oKdgLk5FdRwdD1iMqrbV5/xoPwpJsx67J12ZeBbHlq8WwUpJtzeiPGUj
	 eTAVJR1graQuhLtybSALAc07cAi06KRpnG+/3yS8IoMkzv3kPC/EuA7QjNxQyOYHcoBtf
	 JUxSTQEnQBR7Fsd0yYTbHb3f1ev50EBMiBDH+x19m5zOB+7EmfrdAjRMMcqW/PNlWPfm1
	 2U2JvEWwET0UUKTOPu7t3lw82FgIlXW5j4A51G6bJJGiHGlgi4oxGlWpy7eCOUR/gparS
	 +RstrCNI4RH8DXKNwsK0+O1awieBEt/o0cTBUHG1ftWoZthJ1ah3zYJz1RX98xymxCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dKPpBz+F+JLUge0DsiWhUKE698SkqNaDU7og1r+G+8E=;
	b=Untytu/liVmrefLc8zn78fIDzfIpnYtJ3fN/4OVOA0Pzhnk++fEDKy1h3vb64AgT3Scc
	 7K0ZTHayyePpIgKMnpl0+C0LqmbDgkNfMRw3SJzWl8tL++bxQUQJ/atJu11upx/ZoRsB8
	 xYAY67Ic2UzsmZY3JLG25O/Br0DLFJMZT5/83cFe3l8t/Qdz5Q+oIejQKdWZBxelvDQFB
	 uIkkhW6PowbjdFyttyJ9LJfrxFlTXQ2NaB9pbx90X+JebcAO1OKpevrGo+yyuwY830dRk
	 udvhA3fm1TdChlet8sHgZime6ePHqfnQ2xn/byf9AndJfjlY6LESY5fDZwz/VAL68mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrGREg7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D5D6082BD5;
	Sat,  7 Nov 2026 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrGREg7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350761F008A3;
	Sat,  7 Nov 2026 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063986;
	bh=dKPpBz+F+JLUge0DsiWhUKE698SkqNaDU7og1r+G+8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrGREg7OEDLh8hEG37Jv5s99JTH9RgzLSGYjhflBs/6qXMxW7b1vqQSeAj5klZgPF
	 O/sPcnGXrQQAw5UouO5PlVSv+jTf7FUHiYI8Mwh+LVDc8WKGrqCmxA+7vjOyL6GU1d
	 O+Qd5gWciuRWRjwgsHU+aN4AoPMPouKl/mju3OGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0131/1257] power: supply: qcom_smbx: test battery health status bits
Date: Sat,  7 Nov 2026 08:40:27 -0500
Message-ID: <20261107134942.936871514@linuxfoundation.org>
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
index e6f2328f295c7..0e50d81aefc2a 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -632,26 +632,20 @@ static int smb_get_prop_health(struct smb_chip *chip, int *val)
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



