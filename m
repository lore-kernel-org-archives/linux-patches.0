Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE23824A10;
	Thu, 18 Jan 2024 11:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575659; cv=none; b=B6oNeQq7CUDuozd6xOGP2QhlgIurvt63TEnFSXYEpqdfFl7HHexo9XEGsL4ukEzBNrA9aW968GUHMcKBXuDBW6t4sEPfSdDk0vPeTc+YnUPzmAIPShZT9wNhUkMzKPhh5qX38aW/X1r4SydzZdDvwuokl30dYkRSp5I4EyyLh7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575659; c=relaxed/simple;
	bh=/QM3tMleN4NpEKXYRJy0Qp1MrWQe953RN1XLwyiqqN0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=LCFp6Ls3nWzNM6pXwiqlNKLlGq77pue2bKnDq6pQGMAICi3vl88vgIqPR3Rv++2npv9EEMGmjPNpMfF6IkeXjLGIVvwjemQd2u2CSrJecukMv9HLOnGqCSzguugSXFQ5efozhHGRUlqW8UGNHg2zq8kWY6RLM34JAPiQhif4h+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5vupR+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5vupR+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B4FC433C7;
	Thu, 18 Jan 2024 11:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575659;
	bh=/QM3tMleN4NpEKXYRJy0Qp1MrWQe953RN1XLwyiqqN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5vupR+6WiWn3OUIcVLrH1uzqWcaFUlPnAgrzXHsF4BeF+JM/PmQqVOGzM45x5p4u
	 AYCPy6HK01U/aMpLT8KDGpi4JwXLfbN1cb3DSbI5gGyO9893uYNUwv5DNwMpP54z+g
	 e3LtlWgf/DpFQ4wdpeqweD5dS8xsCwxEDGHeIm7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esther Shimanovich <eshimanovich@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/100] Input: i8042 - add nomux quirk for Acer P459-G2-M
Date: Thu, 18 Jan 2024 11:49:07 +0100
Message-ID: <20240118104313.492031257@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9c39553d30fa..b585b1dab870 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -360,6 +360,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
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



