Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027227;
	b=YnJIq+3245kFPjwN7WpIcvS1vTU+uGSptOFpLaXTu3IqinvnveJkmg6onheE2W7EUCrQ
	 n9qCncmLaJv5HEaPhNAwnA8OT3RRhVNnAgi+qYQeMATcvMo4JaF946p8kROd0Oh+BAN/v
	 g29fYD4nAVAVpYHXifzFc1vxsM4jJgk95zMv5l5mkIBG5svpBMzu1X02adFBKoT6YMkZ7
	 cL2mAws3IIUuyJYZd4p1peclL5RCW6iGv7Uj6IVrjl3OPjuR7NpaP3iixrrAdV+l192ux
	 usjFtdZIjdOKngDZ8i/87X05J5uUcOe6i1RPWEvbvaN4fuYUxU3bzQScb+fQXpSOxzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vqHp8IOzuoW9c4iMB7gqG3VFdCBCBhZxBN/ZUl5Gi20=;
	b=mCUiy8f3SzjOgMiX75w0nJ1KA3vO8nU7BnxlVV7Y34vtgh1A96UHpRxWcOmI1SnYCZSZ
	 2F8V1KnrHohyyYmTByBe5/LdRTqrS4ncUOCaVHQtoyD+kCx94dm5z00xZPRkSLGioWZhm
	 qxaW3ituj1DbQT7kjZC8iw/S8i+eHKf1/w3C3vsn6el3qLuioqhXb2k2veWV9mEIgjki7
	 HZA3bIXZaw/hTw8lo7EZAZUYWcCorYd3Wyhx0c01iqwCsajK8Ck8fL7Wr3k1pQ4YO82k7
	 uu5cbyaN6MsQragQo0cvWcJsmyu+Qq5VSPvymshCpjd0GsYjO+t/09fAefVdjaky1aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzETFfFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10917606DAEF;
	Wed, 18 Nov 2026 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzETFfFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BFD1F0092F;
	Wed, 18 Nov 2026 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027226;
	bh=vqHp8IOzuoW9c4iMB7gqG3VFdCBCBhZxBN/ZUl5Gi20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzETFfFyIXXRmUhbyVlG6tc0/qo1AL2SadhqSpvjQdhOe+FM3cNlPnv9ut3emhTDR
	 BA1q4ON6mvEoRWtxWmsBZAReZ9Tdy06UNNuHZ3tdOGs2h/h6ti0lUPWd1iH7uzskNg
	 72/hJD6JjlgRzk6VKHllcKClWz1ndJpX3ul+MR1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1715/2151] power: supply: qcom_battmgr: report the USB type from USB_ADAP_TYPE
Date: Wed, 18 Nov 2026 15:57:30 +0100
Message-ID: <20261118150224.299265477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Joonhoe Kim <26rote@gmail.com>

[ Upstream commit a49f86cd1333c6e12fd37bc0b3234ace10072553 ]

On SM8350 and SM8550 class firmware the USB power supply reads its
usb_type from the USB_TYPE property. On a Kaanapali (SM8850) tablet that
property is 1 (SDP) whatever is plugged in, while USB_ADAP_TYPE reports
the adapter, using the same numbering as POWER_SUPPLY_USB_TYPE_*:

  PC port                  USB_TYPE 1   USB_ADAP_TYPE 1 (SDP)
  USB-C dock, 5 V PD       USB_TYPE 1   USB_ADAP_TYPE 6 (PD)
  65 W PPS charger         USB_TYPE 1   USB_ADAP_TYPE 8 (PD_PPS)

Qualcomm's downstream qti_battery_charger driver also maps
USB_ADAP_TYPE to POWER_SUPPLY_PROP_USB_TYPE.

Request USB_ADAP_TYPE for POWER_SUPPLY_PROP_USB_TYPE instead.

Tested on a Lenovo Legion Tab Y700 gen 5 (qcom,kaanapali-pmic-glink,
which uses the SM8550 path). Only tested on this device; the SM8350
variant shares the property map and was not tested.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Reviewed-by: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20261012130053.442-1-26rote@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index d171ce7ff124f..8247eaca63d18 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -980,7 +980,7 @@ static const u8 sm8350_usb_prop_map[] = {
 	[POWER_SUPPLY_PROP_CURRENT_NOW] = USB_CURR_NOW,
 	[POWER_SUPPLY_PROP_CURRENT_MAX] = USB_CURR_MAX,
 	[POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT] = USB_INPUT_CURR_LIMIT,
-	[POWER_SUPPLY_PROP_USB_TYPE] = USB_TYPE,
+	[POWER_SUPPLY_PROP_USB_TYPE] = USB_ADAP_TYPE,
 };
 
 static int qcom_battmgr_usb_sm8350_update(struct qcom_battmgr *battmgr,
@@ -1538,7 +1538,7 @@ static void qcom_battmgr_sm8350_callback(struct qcom_battmgr *battmgr,
 		case USB_INPUT_CURR_LIMIT:
 			battmgr->usb.current_limit = le32_to_cpu(resp->intval.value);
 			break;
-		case USB_TYPE:
+		case USB_ADAP_TYPE:
 			battmgr->usb.usb_type = le32_to_cpu(resp->intval.value);
 			break;
 		default:
-- 
2.53.0



