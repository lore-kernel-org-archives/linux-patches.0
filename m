Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9820C2F1FC1;
	Tue,  2 Sep 2025 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820107; cv=none; b=eKiRluWyMW0Puo8LARgXS+E/Z9RnFMaD/1pktTw1GGDZxEQ45cvEqCdIdZo3k9CAf1U8aRqiry2JsXjGgmhkSpA3//wuQsV1Izqe47E2rGSEM7W5xRvRlYWoFTcyHCltguti5LlqH+xp0sU/isrpx+JvdEndBk28LUy/rz9GwNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820107; c=relaxed/simple;
	bh=2itubXLEG5y0Rr3byMt9CThocEEg77VOCOW6VN4Z4mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqLICQmz5MHVmIj56nBj5DLGSRSfFZAtNUyZLZxjmzWfv1y54fgmtwPjKTgSdmJOQlkyuzvxdkjwLxzz3IXcaIYTZaxBdlpzKV4PMh2jtcx5HSyxn+A6sBWtaf8Palb1SODcIoIcz5ZFf4EeXfcFiCiTbuTEvtC9h+TASh4TW28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghp6sMtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghp6sMtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DB6C4CEED;
	Tue,  2 Sep 2025 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820107;
	bh=2itubXLEG5y0Rr3byMt9CThocEEg77VOCOW6VN4Z4mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghp6sMtWZk5cHdEGHFmwkGvwhcMGUlzNsq2CYPAHyAhkXcmKKNNKQ2EotPFjAFJZ4
	 mWlTEAZjs0b5dj+/bTRjGmjk31QnugLaWo6hPLZAyVzoeFzhluMoKthPybm3z+EcTU
	 xLPEfHCLYJIogsFdNwRbeP1vHsBy3QQpPl36x4gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Chang <mason-cw.chang@mediatek.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH 6.12 95/95] thermal/drivers/mediatek/lvts_thermal: Add mt7988 lvts commands
Date: Tue,  2 Sep 2025 15:21:11 +0200
Message-ID: <20250902131943.246957281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Mason Chang <mason-cw.chang@mediatek.com>

commit 685a755089f95b7e205c0202567d9a647f9de096 upstream.

These commands are necessary to avoid severely abnormal and inaccurate
temperature readings that are caused by using the default commands.

Signed-off-by: Mason Chang <mason-cw.chang@mediatek.com>
Link: https://lore.kernel.org/r/20250526102659.30225-4-mason-cw.chang@mediatek.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/mediatek/lvts_thermal.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -1421,6 +1421,8 @@ static int lvts_resume(struct device *de
 }
 
 static const u32 default_conn_cmds[] = { 0xC103FFFF, 0xC502FF55 };
+static const u32 mt7988_conn_cmds[] = { 0xC103FFFF, 0xC502FC55 };
+
 /*
  * Write device mask: 0xC1030000
  */
@@ -1431,6 +1433,12 @@ static const u32 default_init_cmds[] = {
 	0xC10300FC, 0xC103009D, 0xC10300F1, 0xC10300E1
 };
 
+static const u32 mt7988_init_cmds[] = {
+	0xC1030300, 0xC1030420, 0xC1030500, 0xC10307A6, 0xC1030CFC,
+	0xC1030A8C, 0xC103098D, 0xC10308F1, 0xC1030B04, 0xC1030E01,
+	0xC10306B8
+};
+
 /*
  * The MT8186 calibration data is stored as packed 3-byte little-endian
  * values using a weird layout that makes sense only when viewed as a 32-bit
@@ -1725,11 +1733,11 @@ static const struct lvts_ctrl_data mt819
 
 static const struct lvts_data mt7988_lvts_ap_data = {
 	.lvts_ctrl	= mt7988_lvts_ap_data_ctrl,
-	.conn_cmd	= default_conn_cmds,
-	.init_cmd	= default_init_cmds,
+	.conn_cmd	= mt7988_conn_cmds,
+	.init_cmd	= mt7988_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt7988_lvts_ap_data_ctrl),
-	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
-	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
+	.num_conn_cmd	= ARRAY_SIZE(mt7988_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(mt7988_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT7988,
 	.temp_offset	= LVTS_COEFF_B_MT7988,
 	.gt_calib_bit_offset = 24,


