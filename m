Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFE2472771;
	Fri,  7 Aug 2026 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117690; cv=none; b=LnDhn9KUmWBy3JhvyVIbw76UA2B5MGRqTuvswn8oD3ti5VPhVxdhu8OvTm9oJBsIDBO00zjug41ERAgfCmBIaor1W0W5zhhliPef6NKl4vnHyhtkkE1f06irm89CskwYDgMEz2DSt67SoiuFy4fOT8J0ygsZyJ7Sj4rpEZtSiWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117690; c=relaxed/simple;
	bh=S89GF84+Z3lren1WFQVK//gN2ImfyfwyNWVzhrCRmIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pya5wTXHzSk6xZT4vS+h1exrUj9AyEGLk37M4tzImWjtfZmvNVPHpRUIkzOiFQiWhST9wX7Xkv7yWOJOksxraxYrSt2BMi55cAjLsP5RnjuOiQQzpIeFhHKQul/uad0KQyeOgoCOpOvk1thwr7CsD7uarq2GfKXZBML05u3hrRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHph7uPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHph7uPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4A01F000E9;
	Fri,  7 Aug 2026 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117689;
	bh=fWno6lQ3K3vG8/JWdmwk/Led/XwmVtKbF8Bv7d+0vvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHph7uPN15WNFl70dmWP/XVBBK5cZFtCXaxFOx2LT5TjwgOde1hiRK1TOlODkfNzJ
	 XviYtFhkndCNneu/5mdarcYUUkEWU1SVp8D8w62zokCXn/OIo4OBi+TUxcCPPr8LNf
	 oBByCsiKw57AOmEkCv8FupRAqFQTHPe54Whr9kJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Swanson <reiver@improbability.net>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 400/438] drm/amd/display: Silence link_dpms I2C retimer failures
Date: Fri,  7 Aug 2026 16:39:56 +0200
Message-ID: <20260807143436.488222220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Swanson <reiver@improbability.net>

commit 8ccb87b1c9be594fc2c36b0a4006a66f08dee1c8 upstream.

Commit a4f01bf729b2 ("drm/amd/display: Refactor and fix link_dpms I2C")
had also changed the "Set retimer failed" messages from DC_LOG_DEBUG()
to DC_LOG_ERROR(). This unfortunately can create log spam.

Change those back to DC_LOG_DEBUG() only.

Fixes: a4f01bf729b2 ("drm/amd/display: Refactor and fix link_dpms I2C")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5520
Signed-off-by: Alan Swanson <reiver@improbability.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit da8609eef18b0a3490d0e1fa9440659fadc8194d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -379,7 +379,7 @@ static bool write_i2c_retimer_vga(
 
 	for (size_t i = 0; i < ARRAY_SIZE(vga_data); i++) {
 		if (!write_i2c_retimer_offset_value(link, address, vga_data[i][0], vga_data[i][1])) {
-			DC_LOG_ERROR("Set retimer failed, vga index: %zu\n", i);
+			DC_LOG_DEBUG("Set retimer failed, vga index: %zu\n", i);
 			return false;
 		}
 	}
@@ -400,7 +400,7 @@ static bool write_i2c_retimer_byte(
 		return true;
 
 	if (!write_i2c_retimer_offset_value(link, address, index, value)) {
-		DC_LOG_ERROR("Set retimer failed, 3g index: 0x%x, value: 0x%x\n", index, value);
+		DC_LOG_DEBUG("Set retimer failed, 3g index: 0x%x, value: 0x%x\n", index, value);
 		return false;
 	}
 
@@ -416,14 +416,14 @@ static bool write_i2c_retimer_byte(
 			if (!link_query_ddc_data(
 					link->ddc, address, &offset, 1, &value, 1
 			)) {
-				DC_LOG_ERROR("Set retimer failed, link_query_ddc_data\n");
+				DC_LOG_DEBUG("Set retimer failed, link_query_ddc_data\n");
 				return false;
 			}
 		}
 
 		value |= apply_rx_tx_change;
 		if (!write_i2c_retimer_offset_value(link, address, offset, value)) {
-			DC_LOG_ERROR("Set retimer failed, 3g offset: 0x%x, value: 0x%x\n", offset, value);
+			DC_LOG_DEBUG("Set retimer failed, 3g offset: 0x%x, value: 0x%x\n", offset, value);
 			return false;
 		}
 	}
@@ -444,7 +444,7 @@ static bool write_i2c_retimer_setting(
 		uint8_t value = settings->reg_settings[i].i2c_reg_val;
 
 		if (!write_i2c_retimer_byte(link, address, index, value)) {
-			DC_LOG_ERROR("Set retimer failed, index: %zu\n", i);
+			DC_LOG_DEBUG("Set retimer failed, index: %zu\n", i);
 			return false;
 		}
 	}
@@ -455,7 +455,7 @@ static bool write_i2c_retimer_setting(
 			uint8_t value = settings->reg_settings_6g[i].i2c_reg_val;
 
 			if (!write_i2c_retimer_byte(link, address, index, value)) {
-				DC_LOG_ERROR("Set retimer failed, 6g index: %zu\n", i);
+				DC_LOG_DEBUG("Set retimer failed, 6g index: %zu\n", i);
 				return false;
 			}
 		}
@@ -487,7 +487,7 @@ static bool write_i2c_default_retimer_se
 
 	for (size_t i = 0; i < ARRAY_SIZE(data); i++) {
 		if (!write_i2c_retimer_offset_value(link, address, data[i][0], data[i][1])) {
-			DC_LOG_ERROR("Set default retimer failed, index: %zu\n", i);
+			DC_LOG_DEBUG("Set default retimer failed, index: %zu\n", i);
 			return false;
 		}
 	}
@@ -519,7 +519,7 @@ static bool write_i2c_redriver_setting(
 	);
 
 	if (!success)
-		DC_LOG_ERROR("Set redriver failed");
+		DC_LOG_DEBUG("Set redriver failed");
 	return success;
 }
 


