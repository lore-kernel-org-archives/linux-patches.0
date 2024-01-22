Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE460252;
	Tue, 23 Jan 2024 00:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970855; cv=none; b=Hn0AurJSUYpnmSTbD0jravowrWH/66HJrTFUEXsQkjeT7FuIsK+nfkONTFpqqJzzZeH32XI1KTgpck30usncMpFM/Qkex9d/EU1YDrpqVGgJuSoH7mxQe1ukxyB3K7aebZ4qXBuoReunMTsSKYhsffYjt4Zw8h1tpt95vnaj0D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970855; c=relaxed/simple;
	bh=Szby5sHJsyWSqC3RibumbK9HR7pqGf1Xf7CWgbNoXHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBEQao4pZ4qBEtQLv/QQRd5mLgPb47EDNfKJzbUjp4/gqM06m/qqo9kOjZ1g5TgaohvGOBs8wdeGk/UfnHVJj+NLwLjpZmZlEUne2PufhtgrBoRvXqOudAwo3qABNJ4GjNUyyFkbRvLW+KkFYZ9wVLfJnY9ghd3w1RKoDD39fcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqfF5khf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqfF5khf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B8CC43399;
	Tue, 23 Jan 2024 00:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970855;
	bh=Szby5sHJsyWSqC3RibumbK9HR7pqGf1Xf7CWgbNoXHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqfF5khfYHRCS20a/muKYLPENp9mxpF24q52sQb30Lt8Zs9T/3dA7E+eJfQ+YjCPI
	 MBsUdA37nKH/6Q+8g4Ynkofdged/1k0WvccqsXOBGnX7LNVsic1T93oAC7P+WNN5Sw
	 sMBnQ2k8vwzealduajKVg/szGXDU1k2eWnFWEmF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esther Shimanovich <eshimanovich@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/286] Input: i8042 - add nomux quirk for Acer P459-G2-M
Date: Mon, 22 Jan 2024 15:55:37 -0800
Message-ID: <20240122235733.221720540@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esther Shimanovich <eshimanovich@chromium.org>

[ Upstream commit 335fe00319e030d481a54d5e0e68d50c5e672c0e ]

After the laptop lid is opened, and the device resumes from S3 deep
sleep, if the user presses a keyboard key while the screen is still black,
the mouse and keyboard become unusable.

Enabling this quirk prevents this behavior from occurring.

Signed-off-by: Esther Shimanovich <eshimanovich@chromium.org>
Link: https://lore.kernel.org/r/20231130195615.v2.1.Ibe78a9df97ecd18dc227a5cff67d3029631d9c11@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-acpipnpio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
index 09528c0a8a34..124ab98ea43a 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -351,6 +351,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
+	{
+		/* Acer TravelMate P459-G2-M */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate P459-G2-M"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Amoi M636/A737 */
 		.matches = {
-- 
2.43.0



