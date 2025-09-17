Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E24330D39;
	Wed, 17 Sep 2025 12:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113555; cv=none; b=ix+XsDgdkB6N//fpTRljLCjmijRwPUpoz0r0fwGIwzrShLBawNVV6JxkgdYUklS8N1/f7LJFSYBiCMjzamecxQaT4T41IU5Y9tSCl4LgOD+9dPBP5EKjv+YEq3ecE/PmciDVqxBBwVe5Qf/ZQFNqMowXJcOY/M+o6c3SEBjGXyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113555; c=relaxed/simple;
	bh=mXbB54AtO5FpaEoxUhp0Feaz0rySCnsNEXXA8kJTEJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaeocGl454qag2CcAGsTmFunRcIlE87T1ie5KWNle6ePoVJFD7fKgcWYu95shx3PVG9+dIroBpQWSfeG49RAvpupZTzIur844Tc8c8MvHDyLauKKm7sQFG1VxCgzfNw4Z3RAt4nFzMmZe37SSnWNoVzPw1siH028Mcu+EW9tCXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIg6HPG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIg6HPG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B17C4CEF5;
	Wed, 17 Sep 2025 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113555;
	bh=mXbB54AtO5FpaEoxUhp0Feaz0rySCnsNEXXA8kJTEJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIg6HPG7mZc14r3+3zhLVR2Kpm49BR5ozmWq0zDgfw3wkML1KZZ/hgzwTQZe8opGw
	 o0DqWTb3L6nkBFRlSv9R2aGCIV2tjWYDpA2Yepnua6vLjwgzonGvG6ZxGD+ezHtcGc
	 qcni4wzc8hqwDv8qAqJ3k03m7I299HOwXMoJQe1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/140] phy: qualcomm: phy-qcom-eusb2-repeater: fix override properties
Date: Wed, 17 Sep 2025 14:34:52 +0200
Message-ID: <20250917123347.236607166@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 163950e16dbe1..c173c6244d9e5 100644
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



