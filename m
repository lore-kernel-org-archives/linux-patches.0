Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041936;
	b=vKCx5QMm5yAky94ye2dPkxUU9m1umFW+omY8i/wtL0TAvdtLkD+VSXIsbc3X1ql1fDZS
	 pMK534iWyIiFrxZ0IlKaROQk4BYyZh6wVy+fW+xiEp489k5F7bnJUgBBUt/luznhEyiRo
	 n6+7uBKbvFCGVXmrFRBusGq696mXrJvZLCJwGocVvDIH7IZBSA+YwBdzPbTqjs6bOOEpc
	 nblLHZiowBYYb6wAAWXqaVTIEk0k3GoJCrYCRvgKTtomVBrOPnKXjqNYpQu4jSzeoOnyq
	 ddUIsfuIOHxblUBtY6PUkCOYYmneJ+cHAFsBPjAwqkQ+oZ0SVgOqssK3hB+AQVcUY8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2NjvW7GHxkub9EH7wpQ51fn9WQw9OD01TwsZUrwMq4Y=;
	b=AH3UFq05IPDxzd6o0mOYoPHbnNnbn7+VGBDo7zcTSFu/lbSqrciY2Jac+IYW1fyzZVoP
	 1MNS37xCDbRzqxArOV0yo+uHJVJckmyhkVjqrZURxZtzAS6nIVkdbvcNaxyORJnEWiY9e
	 kktS+oaIUqC+mU5f1zJVZTLzhPyClSRDyq3IUF/Lkm0EBXtK7YVB71gcAIR+sEK6KoioN
	 liDgIsLwUU3QUph+5XrymQvQzHUzrVb03jIvI7SHyxwjIZKicihxulU3RhXMbLGKv9Hu6
	 E8Mk+boI4gA+YgXRI11B8hutGCGW1nhXMwMoMT6hePco/WHvzV39E3sXXSgU0Idufpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWUNMtQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F33606A32A;
	Wed, 18 Nov 2026 22:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWUNMtQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ECC1F000C4;
	Wed, 18 Nov 2026 22:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041935;
	bh=2NjvW7GHxkub9EH7wpQ51fn9WQw9OD01TwsZUrwMq4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWUNMtQUewpoFFJfcqD0hhfecX1Vbwm4gDMkAieY2AiEaF6BRQG01hfGjpOk011ol
	 c69Eb/yO8l44ZsJQbLR8wAUM4RZmVUEvorY3t4qgPqW21BPNyoKZP4P+97qpHg0IlP
	 peK/jwHW3dn5NvrqU/sBab7HeLb91AZq8nUMUoD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2992/3318] power: supply: qcom_battmgr: report the USB type from USB_ADAP_TYPE
Date: Wed, 18 Nov 2026 16:00:14 +0100
Message-ID: <20261118150450.028499539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65140d4985af1..63799fd24e837 100644
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
@@ -1237,7 +1237,7 @@ static void qcom_battmgr_sm8350_callback(struct qcom_battmgr *battmgr,
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



