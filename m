Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020823;
	b=EcEJAQGfsODshDxdsDxFx9jP9jsAIZjeetwS0xOBe5fAopB3qbRqMsQCslTYi6hZ10bD
	 +Z3GpqrOppPuOmKX56vfxvLkHMO25aX8AzAdsRjvw95VDoL44V53t5MKKQ7i8DpaI8pcI
	 PugTSMHjWagJuhO2wJ2mv36ivUj7iHO5Y6rEESqMB2yKFF4snAYgZ1L4x9zZS/Xstfk4f
	 XjmrRkWuSkSiHC7sbwDFRc5jhGu3mtTxP5PcwiByyETHDVp70RxikQbk4u+ZwQEmaQ6MW
	 9B0QC9KiuFKXyPI6gOpkedwA7B7k3pnGNxRdAY2NoOMOqw0rcoZz0buILaZg5MoYVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43l1Pq7Nkw41XvRLVtnlFjAlUID/r4wAmUlKlXIeS7A=;
	b=HgN7IBpPor2f9j+bbVF2jS0fGooo/cF1GONaf8esbHgBSr7eZcY76WUvnW+e2sK5660b
	 1sbK6apTJF3ACoJuTBEesQ3stjo3BXHTBhosiMwFxObG5Pmckcl0nh5Vm2+1aQdjt+85s
	 7ZziOQgYslp3jnwojzzOh//Ypt72BQw+ee7s5LY2X7izIBlF2PtKTVk3yw5E8fzSJH2Cb
	 YMUS2fEBKiWMtT0R6w+zmtyysKvtJxFQGgC/SZlC5J3TJPxxpG/385gocBrkKIFLYy++C
	 CKIGrRBrEDAnJryO+RanEI7DLZde2/vLifiZCPZroM1efklqxZb5mFdvUB0Z/XUQH3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GiJrh+qe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69CB606A337;
	Wed, 18 Nov 2026 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GiJrh+qe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C631F000C7;
	Wed, 18 Nov 2026 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020822;
	bh=43l1Pq7Nkw41XvRLVtnlFjAlUID/r4wAmUlKlXIeS7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GiJrh+qetUFMhTu86YcQxOZmKz+5hH6U5MEgOueSouMCx2TRvK3h2IOjKVxkPw78L
	 5Uj38Q6Nn7CQzqrhwehnhcBsthYawK7jhW1qjcQqaWt7/4Lsq7IA7ASYNkGnqMbai0
	 +Z5y6Zl0OcBc4wGoq4tofnXKwwXpqFyB1ikL0XD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2087/2651] power: supply: qcom_battmgr: report the USB type from USB_ADAP_TYPE
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150401.156808550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 4ca3409819229..99ae0920f7264 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -976,7 +976,7 @@ static const u8 sm8350_usb_prop_map[] = {
 	[POWER_SUPPLY_PROP_CURRENT_NOW] = USB_CURR_NOW,
 	[POWER_SUPPLY_PROP_CURRENT_MAX] = USB_CURR_MAX,
 	[POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT] = USB_INPUT_CURR_LIMIT,
-	[POWER_SUPPLY_PROP_USB_TYPE] = USB_TYPE,
+	[POWER_SUPPLY_PROP_USB_TYPE] = USB_ADAP_TYPE,
 };
 
 static int qcom_battmgr_usb_sm8350_update(struct qcom_battmgr *battmgr,
@@ -1534,7 +1534,7 @@ static void qcom_battmgr_sm8350_callback(struct qcom_battmgr *battmgr,
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



