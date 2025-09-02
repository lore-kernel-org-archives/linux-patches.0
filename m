Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760F631A56D;
	Tue,  2 Sep 2025 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819788; cv=none; b=bzOoSxLQQ2rz8Bi0vSdtStxsdtEmNbYSytMG4a5/ZvLEVG3ztjWt6ySxmvc2OLEcCmhO4AXyT9Tea1UK9bsygTbzBEU2rCypiUcKeUHyogBr3UtmJu4emvw64Evwcd6+LD9FL9voUUdMiz4bcp7Oa0eaHNWcT4zDOwHiD2syEhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819788; c=relaxed/simple;
	bh=FdBcf5e+FPe31VBsFpvOAIFxarYTXeQ6cCgInh+XoZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJQrPbt9K8OZjCoAwz65PnmJqqEm2gOrWYF286n6eqsFBqOduOJCO/NTW14iwAXSrlgZ1E/vYmF/xsWuFl5NG5W1/8aZpmKph6Op4fJSEQZedJ08e+UFwoOa9uEQt4b1LmaEo4UG/CV71TfrZV7/AuM1tf1Na69SstJvfE0/1xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMY6QDyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMY6QDyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69759C4CEFF;
	Tue,  2 Sep 2025 13:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819787;
	bh=FdBcf5e+FPe31VBsFpvOAIFxarYTXeQ6cCgInh+XoZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMY6QDyH0UT2BDvhtFNuFpPPWZ8cdygk4Qj06nKk55edtkA/05qaXoUyS7rfUMYRB
	 B9G+Bhj3XCXC2cIUoo3QEYngkoGi3mT47cAUGxjkJyeAWAGdJ1P5TfRQWRVnupot2F
	 trFasjRxhWsGTrlYxOQWXeh8uFDMTwfdgkKWcbR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Chang <mason-cw.chang@mediatek.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH 6.16 140/142] thermal/drivers/mediatek/lvts_thermal: Change lvts commands array to static const
Date: Tue,  2 Sep 2025 15:20:42 +0200
Message-ID: <20250902131953.642798124@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Mason Chang <mason-cw.chang@mediatek.com>

commit c5d5a72c01f7faabe7cc0fd63942c18372101daf upstream.

Change the LVTS commands array to static const in preparation for
adding different commands.

Signed-off-by: Mason Chang <mason-cw.chang@mediatek.com>
Link: https://lore.kernel.org/r/20250526102659.30225-2-mason-cw.chang@mediatek.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/mediatek/lvts_thermal.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -96,6 +96,17 @@
 
 #define LVTS_MINIMUM_THRESHOLD		20000
 
+static const u32 default_conn_cmds[] = { 0xC103FFFF, 0xC502FF55 };
+/*
+ * Write device mask: 0xC1030000
+ */
+static const u32 default_init_cmds[] = {
+	0xC1030E01, 0xC1030CFC, 0xC1030A8C, 0xC103098D, 0xC10308F1,
+	0xC10307A6, 0xC10306B8, 0xC1030500, 0xC1030420, 0xC1030300,
+	0xC1030030, 0xC10300F6, 0xC1030050, 0xC1030060, 0xC10300AC,
+	0xC10300FC, 0xC103009D, 0xC10300F1, 0xC10300E1
+};
+
 static int golden_temp = LVTS_GOLDEN_TEMP_DEFAULT;
 static int golden_temp_offset;
 
@@ -902,7 +913,7 @@ static void lvts_ctrl_monitor_enable(str
  * each write in the configuration register must be separated by a
  * delay of 2 us.
  */
-static void lvts_write_config(struct lvts_ctrl *lvts_ctrl, u32 *cmds, int nr_cmds)
+static void lvts_write_config(struct lvts_ctrl *lvts_ctrl, const u32 *cmds, int nr_cmds)
 {
 	int i;
 
@@ -985,9 +996,9 @@ static int lvts_ctrl_set_enable(struct l
 
 static int lvts_ctrl_connect(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 {
-	u32 id, cmds[] = { 0xC103FFFF, 0xC502FF55 };
+	u32 id;
 
-	lvts_write_config(lvts_ctrl, cmds, ARRAY_SIZE(cmds));
+	lvts_write_config(lvts_ctrl, default_conn_cmds, ARRAY_SIZE(default_conn_cmds));
 
 	/*
 	 * LVTS_ID : Get ID and status of the thermal controller
@@ -1006,17 +1017,7 @@ static int lvts_ctrl_connect(struct devi
 
 static int lvts_ctrl_initialize(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 {
-	/*
-	 * Write device mask: 0xC1030000
-	 */
-	u32 cmds[] = {
-		0xC1030E01, 0xC1030CFC, 0xC1030A8C, 0xC103098D, 0xC10308F1,
-		0xC10307A6, 0xC10306B8, 0xC1030500, 0xC1030420, 0xC1030300,
-		0xC1030030, 0xC10300F6, 0xC1030050, 0xC1030060, 0xC10300AC,
-		0xC10300FC, 0xC103009D, 0xC10300F1, 0xC10300E1
-	};
-
-	lvts_write_config(lvts_ctrl, cmds, ARRAY_SIZE(cmds));
+	lvts_write_config(lvts_ctrl, default_init_cmds, ARRAY_SIZE(default_init_cmds));
 
 	return 0;
 }


