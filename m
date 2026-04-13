Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EA2225A38;
	Mon, 13 Apr 2026 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097942; cv=none; b=U+1FIBiIXYLYkqJ9peFXm0VClZWZMphPlqX6Z/uHJhV5M7wMBXMTOLPrB5+Gr/iCSlyftehZRQJh+5TqHn4VLjRT5kfmXdl3+EpSXqhVf52gjnExNj3pOT7Mz86ZHLJ5Rn3JWpA8j0tkwBaXkidcBeCK7jXK+RKhFQ1g+8wbJ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097942; c=relaxed/simple;
	bh=y2LaEDwgeZLU3ywLBCVFGTghzVGifk/6JTcw6bVpq0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TvQN9VuhiqD+pEXnxgMh63e+SAJ7n+dF27nlNq7i5UHZ7D/0ifuDxYHOfIEELHl8/j2WdL+wGljNHTD+RdZVBalU8EV7YPVpJNc0QBpj6WyCnDozp7+vc5lKBjnlzbNnEZLj5xkNnQFlS7TCejGnAIqSBEED3//yvqlf4scMHAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fb9V92nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fb9V92nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4ADC2BCAF;
	Mon, 13 Apr 2026 16:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097942;
	bh=y2LaEDwgeZLU3ywLBCVFGTghzVGifk/6JTcw6bVpq0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fb9V92nuiwlwLUFTGRnGThm03H2acA/P0o8H5r50Szq5NHJaYMyS5Fm1etjblIzpm
	 MVUZr7ucFg+O7NwMS15tUl9tIJRf26sLVwixEI8dMDIT32k83nWwExWcoPV+Lzftj5
	 WkhuJiwZiF8ivLiRFVNLRGq+Y6s5ABVYHWI/2Lgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajat Kumar <yajatapps3@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/570] platform/x86: touchscreen_dmi: Add quirk for y-inverted Goodix touchscreen on SUPI S10
Date: Mon, 13 Apr 2026 17:57:12 +0200
Message-ID: <20260413155841.776063280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 7d87ed70fc95482c12edf9493c249b6413be485e ]

The touchscreen on the SUPI S10 tablet reports inverted Y coordinates,
causing touch input to be mirrored vertically relative to the display.

Add a quirk to set the "touchscreen-inverted-y" boolean device-property
on the touchscreen device, so that the goodix_ts driver will fixup
the coordinates.

Reported-by: Yajat Kumar <yajatapps3@gmail.com>
Closes: https://lore.kernel.org/linux-input/20251230221639.582406-1-yajatapps3@gmail.com/
Tested-by: Yajat Kumar <yajatapps3@gmail.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260217132346.34535-1-johannes.goede@oss.qualcomm.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index b0b1f1b201682..50b1ce7f450eb 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -402,6 +402,16 @@ static const struct ts_dmi_data gdix1002_00_upside_down_data = {
 	.properties	= gdix1001_upside_down_props,
 };
 
+static const struct property_entry gdix1001_y_inverted_props[] = {
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	{ }
+};
+
+static const struct ts_dmi_data gdix1001_y_inverted_data = {
+	.acpi_name	= "GDIX1001",
+	.properties	= gdix1001_y_inverted_props,
+};
+
 static const struct property_entry gp_electronic_t701_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 960),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 640),
@@ -1631,6 +1641,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_SKU, "PN20170413488"),
 		},
 	},
+	{
+		/* SUPI S10 */
+		.driver_data = (void *)&gdix1001_y_inverted_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SUPI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S10"),
+		},
+	},
 	{
 		/* Techbite Arc 11.6 */
 		.driver_data = (void *)&techbite_arc_11_6_data,
-- 
2.51.0



