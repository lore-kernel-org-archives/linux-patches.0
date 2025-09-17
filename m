Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC21E489;
	Wed, 17 Sep 2025 12:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113079; cv=none; b=EDo72a0uQXbB2OIlSY5OrGGqkHy9TGPTws9Y7jTjlOOjk9safJQsSxJdKLyou1BBoTpNW0dGU+8iiWe1HdJjzteAmc6eoJ+jSXG70Y1tu79W7mTwN2nYOchXTxA3bqPIA+3kH01uZnXRWBOHlwlZRB4zodGWBzoaOcdkamY4tEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113079; c=relaxed/simple;
	bh=LU2Yqe4nWCnqp2h6y8KGyld4TQmYTzgyfZP4zHnYJz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1ZsSEsKeMbXdbhiojmgu903EvLSUqVQAyooKTCXGWZe4RJKrbI7QPk19Dx89RkH2nE+x0GxkWmKH8NjwtUEwBrQmJIwkxppV6lc22PWR2UaRY988xHdwPp6UijvtsEKj2OsxV/HqUCJ77HPA1ncJnA8YinTqC4m1xG+Y6syQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxY4EBWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxY4EBWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F85C4CEF5;
	Wed, 17 Sep 2025 12:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113079;
	bh=LU2Yqe4nWCnqp2h6y8KGyld4TQmYTzgyfZP4zHnYJz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxY4EBWuQe5pZ5zvcNw/zKFvAcnNuRa5KYlF2t0KJxzeGKXskYr0ARNFw99BRx8by
	 9VfQwguyyU/wocKJtAhhqFpyEMKhtC0qs9mZYVRlMS9bwzDl4dbAEfWTvFhPhShou5
	 BtNl2Za6bka+2FNplZpHtH+BlCffe3PqMpF0CeLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 166/189] phy: qualcomm: phy-qcom-eusb2-repeater: fix override properties
Date: Wed, 17 Sep 2025 14:34:36 +0200
Message-ID: <20250917123355.934407496@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 942e47ab228c7dd27c2ae043c17e7aab2028082c ]

property "qcom,tune-usb2-preem" is for EUSB2_TUNE_USB2_PREEM
property "qcom,tune-usb2-amplitude" is for EUSB2_TUNE_IUSB2

The downstream correspondence is as follows:
EUSB2_TUNE_USB2_PREEM: Tx pre-emphasis tuning
EUSB2_TUNE_IUSB2: HS trasmit amplitude
EUSB2_TUNE_SQUELCH_U: Squelch detection threshold
EUSB2_TUNE_HSDISC: HS disconnect threshold
EUSB2_TUNE_EUSB_SLEW: slew rate

Fixes: 31bc94de7602 ("phy: qualcomm: phy-qcom-eusb2-repeater: Don't zero-out registers")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20250812093957.32235-1-mitltlatltl@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
index d7493c2294ef2..3709fba42ebd8 100644
--- a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
+++ b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
@@ -127,13 +127,13 @@ static int eusb2_repeater_init(struct phy *phy)
 			     rptr->cfg->init_tbl[i].value);
 
 	/* Override registers from devicetree values */
-	if (!of_property_read_u8(np, "qcom,tune-usb2-amplitude", &val))
+	if (!of_property_read_u8(np, "qcom,tune-usb2-preem", &val))
 		regmap_write(regmap, base + EUSB2_TUNE_USB2_PREEM, val);
 
 	if (!of_property_read_u8(np, "qcom,tune-usb2-disc-thres", &val))
 		regmap_write(regmap, base + EUSB2_TUNE_HSDISC, val);
 
-	if (!of_property_read_u8(np, "qcom,tune-usb2-preem", &val))
+	if (!of_property_read_u8(np, "qcom,tune-usb2-amplitude", &val))
 		regmap_write(regmap, base + EUSB2_TUNE_IUSB2, val);
 
 	/* Wait for status OK */
-- 
2.51.0



