Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032286;
	b=UVSdEMy3tI4IWlIuNIil1gp+TIoyPVXwdAgW8C8AbHg+eA1gWSOKsgbAKsrcIHVYdRgL
	 U+vRxohKfiRxPBbqrNXGwuwpnTNpo+4azQlywQ7GB8aA15p488QSHzWELAFLuzWisUZtA
	 sRDAMfOVGwZ8KVVaX/kFDvvumlT5DfDjWecnIWh1pa7dWqzw90CaR4cYYbVvSaCARyQgD
	 8jQqMg044V6Tq5S4aRdjRJXaP+FiaP8UH+kXV+qvKQfqw+2lv5z3PYSrAn1v6m/QD6Ndu
	 kiDeT+qLnn7zTJwrnF1V7FPce2itJgzoskeGG0iR47zfGpvw64yctwIGrfwdP2vZnTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gxIpvL1tHGWuYcFYaWC0USv+gYrfVN5a98EKeU6gVm4=;
	b=BAgdtxuaNTftAp8+GnJMnBEGUH9+stQ4V3uNre1VF1MoBfOgzo83ie/P9AyAO36jMl6W
	 uCL89UDnnrr9qGFXqSFKbxqeY7gf29C8beI00DQ3uNWKCP3e69QZLU2jrPZa6MFpni692
	 DIRNQPD7oGvl7imE0C2AwOSkjPZGShlgfNHmiUSzDpQTibhvu+YAa4GjdhXaiz9LOAl9L
	 euZ4b+DPLNbkpdZ8msn1EHCVdkeB8fZGYFzERWxVgFq4/Ulg05tqbVOju2neNmdgWQUlJ
	 smfpYkkXOinmKFyw/LsX2bAHsuIDvzlVkzogssTn/OJ4TQ1vW+uoA8XSaaVfeCaTNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxZfK0Qz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E90606A31C;
	Wed, 18 Nov 2026 20:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxZfK0Qz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8AC1F000C6;
	Wed, 18 Nov 2026 20:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032286;
	bh=gxIpvL1tHGWuYcFYaWC0USv+gYrfVN5a98EKeU6gVm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxZfK0QzLgmmJD1DgdsX35spexK33nakCNrioiRk9yCCRZCDF6B1PqCm+/oEb0hUu
	 JGOf2DHiMH7uhYj97uMmmUmitqD0bqccTTHrUPf9+DcTLe31Lvc4TaP7S7RCQQRBel
	 TWjEeWrbhOtzZBIVmg5Lny/Gu8SaNmrBwUpaSmSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1357/1756] power: supply: qcom_battmgr: report the USB type from USB_ADAP_TYPE
Date: Wed, 18 Nov 2026 15:58:04 +0100
Message-ID: <20261118150103.309512957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 3674afb0d49d0..0cb66b131e3f1 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -721,7 +721,7 @@ static const u8 sm8350_usb_prop_map[] = {
 	[POWER_SUPPLY_PROP_CURRENT_NOW] = USB_CURR_NOW,
 	[POWER_SUPPLY_PROP_CURRENT_MAX] = USB_CURR_MAX,
 	[POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT] = USB_INPUT_CURR_LIMIT,
-	[POWER_SUPPLY_PROP_USB_TYPE] = USB_TYPE,
+	[POWER_SUPPLY_PROP_USB_TYPE] = USB_ADAP_TYPE,
 };
 
 static int qcom_battmgr_usb_sm8350_update(struct qcom_battmgr *battmgr,
@@ -1242,7 +1242,7 @@ static void qcom_battmgr_sm8350_callback(struct qcom_battmgr *battmgr,
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



