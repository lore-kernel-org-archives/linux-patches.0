Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624386;
	b=IVe7HIxwKkkVqP5AoOOtQn8YuLwjDoFNfMQ49mn6BlfXrYrFcnGw6yGckPY4kvJH4E/S
	 w6gDFs1MuaOuYbbJJdkAZxkTXZJwroHEKHJYJu04s5Q1mzqYpcAw6TtyXjkqNp20JHlVZ
	 v3N82Cb0Eus6G0TZAPSpUhbdA6LnAF4XlFHJYiXwbxvJ46DYzpOZNVeA4G3vo9iq6mSQf
	 XMccO4C/Y7bFi9nmCGTm6UY3xBX4DpSbaDr14CFkjANbhojTv2L0tmUyXBmhYdzkjag2f
	 umq9p2f8eIAxKslZxZisIcLAlg7mxsmgStfyPuJJ8lCM0DRisSmipfYHqp47/GnRRQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1b8mvYcYWFaGNA0H80kUSU/8u5sbVBx49WLv2F17gE=;
	b=t88ibWPkwEkGkNUqh7ON5KhtKmBJKoYSdVKhfgesYuvmeLzBalsYhmHx/TiFkcE7uBS9
	 mEfKDUJkXimyWCxfESW2jBbSrsGYrFrBaPF+khLw+zhQlVk0M1JbKk14tQSs26sNiN+Nr
	 tSg60aiFLl8Ly9npjW1rtxZY/yb5tb8vFfqqYYNLyARkbK8IBv8Hl4aZ3BG2sb5VGlq7g
	 oL2xqYSux/FgUdBflR9aDNzyToS+dm8hiiyZWDrQFsJSSW5sBTcIAA5jVES2k7peOrDbI
	 SOdq0MVc+oGCJUxosCgG5+2sVnk8SgWFWpsEkWKtivtWY77phPh7mEh8cZWP++x25wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YuybGuFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FAC606A69E;
	Wed, 25 Nov 2026 16:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YuybGuFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9805E1F000C6;
	Wed, 25 Nov 2026 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624386;
	bh=N1b8mvYcYWFaGNA0H80kUSU/8u5sbVBx49WLv2F17gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuybGuFrin4tkemumRWH1HnlOl83k4Pl2YnlMH/CGw+IvMDHwNwDFcFk0VkE43fjB
	 CObwpACqJBl64+dTRPR2R67kQFncUoNLOfdD5L4/aZENJKm1usFZvN4AMLhAS9rFXL
	 6V44wXHl+k6TqlzOLtKx1zcBcoyVB6LWG6VJMgzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Jiang <cheng.jiang@oss.qualcomm.com>,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/816] power: sequencing: qcom-wcn: increase WCN7850 power-up delay
Date: Wed, 25 Nov 2026 15:28:42 +0100
Message-ID: <20261125143853.220213774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Shuai Zhang <shuai.zhang@oss.qualcomm.com>

[ Upstream commit bd60a639b621453fe37b780df4b6d3a13f981f13 ]

When the WCN7850 is powered up from the Bluetooth side first, i.e.
BT_EN is asserted while WLAN_EN is still low, the chip starts from a
cold state and is not ready to accept the first HCI command 50 ms after
BT_EN goes high. The first command (0xfc00, read QCA version) is lost,
hci_qca does not resend it and fails after the 2 s command timeout:

  Bluetooth: hci0: Reading QCA version information failed (-110)

When WLAN is powered first, 50 ms is sufficient, so the failure only
shows up in the BT-first ordering. Measured on the affected board by
which enable pin rose first:

  pwup_delay_ms   BT-first boots   with -110
  50              9                9
  75              23               0
  100             21               0
  300             20               0

Raise the power-up delay of WCN7850 to 100 ms. The delay is shared by
the Bluetooth and WLAN targets, so WLAN power-up also waits 50 ms
longer.

Fixes: 2f1630f437df ("power: pwrseq: add a driver for the PMU module on the QCom WCN chipsets")
Signed-off-by: Cheng Jiang <cheng.jiang@oss.qualcomm.com>
Signed-off-by: Shuai Zhang <shuai.zhang@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20261102094800.3225454-1-shuai.zhang@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/sequencing/pwrseq-qcom-wcn.c b/drivers/power/sequencing/pwrseq-qcom-wcn.c
index 682a9beac69eb..63ffa4d74425c 100644
--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -306,7 +306,7 @@ static const char *const pwrseq_wcn7850_vregs[] = {
 static const struct pwrseq_qcom_wcn_pdata pwrseq_wcn7850_of_data = {
 	.vregs = pwrseq_wcn7850_vregs,
 	.num_vregs = ARRAY_SIZE(pwrseq_wcn7850_vregs),
-	.pwup_delay_ms = 50,
+	.pwup_delay_ms = 100,
 	.targets = pwrseq_qcom_wcn_targets,
 };
 
-- 
2.53.0



