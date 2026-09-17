Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC204FE2DC;
	Thu, 17 Sep 2026 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664218; cv=none; b=jIgUb0Irhynllt9jvQINtt3fxiNNaQoXIC+d+nQSF+JlAqep3zGOj8lEwDO7nB8108t4UzWsWTdSVKAckhlwspWpL/IpPOZwQ3wT/uSmzGZenMM7hOTnlMX9+WyLQUIq5KAEdX0Xg75GmM+zyrpnUQJQIcPc1FyXsnmpph3EdT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664218; c=relaxed/simple;
	bh=Qiqxh98ToBlQeKGVE62BOMvHXy1L9chh7PlpWGETqaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7Q585b251TCfRB9jO7nnVWMys7rlKhW5dzvIy5JY4RCtEzQ/4xWNgHX6ceiSN6LCyv3vK4svALA9idr1s71jy7AthbN+SKZvL0eHDluNb7TrNqt+o/JvFkqdT9XxqrTiJS7jMk2uJtgAU117ClETfrIG4OUZrxyk26Ec3CL0Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLWct/Pz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLWct/Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932811F000FF;
	Thu, 17 Sep 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664217;
	bh=Cff7ZKV3ruKuhwAV1nzkQ1zRyxRY9s/aOlkp0h7+QBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLWct/Pz3q2wggSEyfOj0KcOj/spxvdV+QDOy2yFtp7FK4d9pWPjCx3b4cLIPh660
	 4oo7coGPC7TA22ly/kamW6sLAh7e617JSr++PbL4DzS1kvzx/Prx/mKDmOrLRQzDfo
	 0lguR6Qnvp4gZqXWXtK8t52MdY5fJBRHHQ9Eufdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0260/1250] soundwire: dmi-quirks: Disable ghost Realtek devices
Date: Thu, 17 Sep 2026 16:00:55 +0100
Message-ID: <20260917151559.199661599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4dab2b904414fac53535c4e4cdad808132f4cdc2 ]

Many systems ship with a Realtek audio codec in the ACPI that doesn't
physically exist in the system. This confuses the newer function
topology system that creates the soundcard, as it builds the card based
on the ACPI information.

Whilst we are working with the laptop vendors to try and stop this
happening there are quite a few systems where this has shipped. Add a
quirk to disable this "ghost" device.

Currently this patch should cover:
 - Asus UX5406AA
 - Lenovo Yoga Pro 9i (83SF)
 - Lenovo Yoga Slim 7 Ultra (83QK)

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520163631.3300102-4-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 35 ++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 5854218e1a274..32a46a2d90f7c 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -90,6 +90,19 @@ static const struct adr_remap intel_rooks_county[] = {
 	{}
 };
 
+/*
+ * Many platforms have ghost realtek devices in the ACPI that don't physically
+ * exist, remove those devices.
+ */
+static const struct adr_remap ghost_realtek[] = {
+	/* rt722 on link3 */
+	{
+		0x000330025d072201ull,
+		0x0000000000000000ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
 	/* TGL devices */
 	{
@@ -164,6 +177,28 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)hp_omen_16,
 	},
+	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX5406AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83SF"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{}
 };
 
-- 
2.53.0



