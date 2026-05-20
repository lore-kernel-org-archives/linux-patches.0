Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4943F4114;
	Wed, 20 May 2026 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296826; cv=none; b=ggiuzJmL9kYN3YYZKlOCsLd2CjJjlkclkub+D43OptjzWz636KbnGyrbKxo1Q9yoMKbHw6Isi91zgSdG6WJ7zoGNbYjTAQMdZsVFWYSaVn1THU6uqK3SEa4oB9fGXtHgbMwv9pyzCN2i3k0OqYyT7x63OgB4//Sla8agUcWOPQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296826; c=relaxed/simple;
	bh=oamvajJuZ/fBo+/CpM16q2irh3q6Hg/AIu8miRy0Vbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRViHx0Y4YoKmvxEcCXkBrD1h08TSMHQhMPpeH9TvUGSmAPepG57fDM9i3tsa91YHuyx/2JLQCfamhAkD8jeSUY/8FUrHxhqxXOqm7oIqdiZDfNql7ZhUyy6vqg58IhOB4eF6flsXumd60uGsh3/MnWDn3+MbXaYbfFJIptUnLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxGE/vpE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxGE/vpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1231F00893;
	Wed, 20 May 2026 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296825;
	bh=drV+8A2tJ/qm0aLqqAvegIG4GnPzrmhBLh6oQDk1LD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxGE/vpEOamJkDR2FYKdyjrVWk26RYqYSYyHbKb09HgC8Ay9eDISXhV3yZJw4P5yB
	 5fdTdinxOhCrM9+FhdvcbP8GRdD134WTdxtMsk/CLcKAfRqpNlGCMUi41NkaHtldFz
	 FIApQ2wCY3U6mYLrnoXr/F+4JMWqxmFaBJaL1+CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul.geurts@prodrive-technologies.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Greer <mgreer@animalcreek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0945/1146] NFC: trf7970a: Ignore antenna noise when checking for RF field
Date: Wed, 20 May 2026 18:19:55 +0200
Message-ID: <20260520162209.619374655@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d17c701c7888b..08c27bb438b59 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -317,6 +317,7 @@
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_MASK	(BIT(2) | BIT(1) | BIT(0))
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_X_MASK	(BIT(5) | BIT(4) | BIT(3))
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_OSC_OK	BIT(6)
+#define TRF7970A_RSSI_OSC_STATUS_RSSI_NOISE_LEVEL	1
 
 #define TRF7970A_SPECIAL_FCN_REG1_COL_7_6		BIT(0)
 #define TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL		BIT(1)
@@ -1300,7 +1301,7 @@ static int trf7970a_is_rf_field(struct trf7970a *trf, bool *is_rf_field)
 	if (ret)
 		return ret;
 
-	if (rssi & TRF7970A_RSSI_OSC_STATUS_RSSI_MASK)
+	if ((rssi & TRF7970A_RSSI_OSC_STATUS_RSSI_MASK) > TRF7970A_RSSI_OSC_STATUS_RSSI_NOISE_LEVEL)
 		*is_rf_field = true;
 	else
 		*is_rf_field = false;
-- 
2.53.0



