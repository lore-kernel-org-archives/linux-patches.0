Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD357348C55;
	Sat, 30 May 2026 17:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161884; cv=none; b=PP6i7E1TwlEfuNL7I87ThcbPGhLILk7T1W/ckLaTCZ4UHCHxzpnmH/MuUl7LqTzYh2aeT4cQnroQX4bOM4i5rZvI2L4ffiK2HMkV7rhV8MYix1R/IUc34aNdqg+q/8PvtkMjG1Yrkeh9olHkVEXXP1VJL0ctaEZmbcKw5S/YlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161884; c=relaxed/simple;
	bh=AhxfZ/32oZ4lddNgoGHqiGYcnAGDzA41mZhPTtnNehU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VM5MQwIWV0iFwsCEHtDY0JuhiP+Awe2MEUW/urTrpMJUgQIlZn8B5jcPxMAQq9jpFnm7QkKqPPEwONSCqutSxI6uiWHtPx3FmazwAGpUJNUg3VrZhV4n3LKeYpPQ0t/5BLo4boji+txAcmOX167XOGnDQsV5PbgLfa1jLJwfcWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLXo0mKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLXo0mKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD1A1F00893;
	Sat, 30 May 2026 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161882;
	bh=21GLyUZFq1AWMRnMVSntb3kAdv7pjZhEs712V3SMK9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLXo0mKctzgetY1EZuHmrmuKPVyCxv62GzHpIw2T8kor/TPCAMTMduKdGHl6MvJVG
	 DqRbb+RXWdlKlum+WrwYLKAIFR6ugXjpHfdO7f2MNUiAU0uoLz7bT4zltYi2vPFZTp
	 CIQfsbGGnFDp0cFG7NfwaesUarBVRLBaiunnBmMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul.geurts@prodrive-technologies.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Greer <mgreer@animalcreek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 755/969] NFC: trf7970a: Ignore antenna noise when checking for RF field
Date: Sat, 30 May 2026 18:04:39 +0200
Message-ID: <20260530160321.413442386@linuxfoundation.org>
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

From: Paul Geurts <paul.geurts@prodrive-technologies.com>

[ Upstream commit a9bc28aa4e64320668131349436a650bf42591a5 ]

The main channel Received Signal Strength Indicator (RSSI) measurement
is used to determine whether an RF field is present or not. RSSI != 0
is interpreted as an RF Field is present. This does not take RF noise
and measurement inaccuracy into account, and results in false positives
in the field.

Define a noise level and make sure the RF field is only interpreted as
present when the RSSI is above the noise level.

Fixes: 851ee3cbf850 ("NFC: trf7970a: Don't turn on RF if there is already an RF field")
Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Mark Greer <mgreer@animalcreek.com>
Link: https://patch.msgid.link/20260422100930.581237-1-paul.geurts@prodrive-technologies.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/trf7970a.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 7968baa626d16..b7a8d525e3c29 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -311,6 +311,7 @@
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_MASK	(BIT(2) | BIT(1) | BIT(0))
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_X_MASK	(BIT(5) | BIT(4) | BIT(3))
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_OSC_OK	BIT(6)
+#define TRF7970A_RSSI_OSC_STATUS_RSSI_NOISE_LEVEL	1
 
 #define TRF7970A_SPECIAL_FCN_REG1_COL_7_6		BIT(0)
 #define TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL		BIT(1)
@@ -1253,7 +1254,7 @@ static int trf7970a_is_rf_field(struct trf7970a *trf, bool *is_rf_field)
 	if (ret)
 		return ret;
 
-	if (rssi & TRF7970A_RSSI_OSC_STATUS_RSSI_MASK)
+	if ((rssi & TRF7970A_RSSI_OSC_STATUS_RSSI_MASK) > TRF7970A_RSSI_OSC_STATUS_RSSI_NOISE_LEVEL)
 		*is_rf_field = true;
 	else
 		*is_rf_field = false;
-- 
2.53.0



