Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A511265CC5;
	Tue, 11 Nov 2025 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823257; cv=none; b=DxrpmqAvQhUE7oqSD/0QLt14InOqvqxxd38L44Onxxf6kIhY7lP/Tq4mBpAMy5W+s3IKJd6j3zIefld+m2ASXK7mp0V8Cikp3h+VakTZpZyujDpdfho2TijVyIVcA4/lQWaWJJbpcunyoDddfiRG3dFCPmDlkWJ9pL4TaDYcRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823257; c=relaxed/simple;
	bh=cWA8GNsEIoTzoKAvfA7Z6BaPxH9SIkBdYBkjBe9jFaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZRFWbsMvyZrnOPC//jVsWuB4hVf9hQkPhC05QpQKn2CyroCfKhJ7OW216Pa5JvqiXPyXq+jJ43wmWGe2W8GGl+rIu1K2J+94JzXLRJm09FIlPfyyQVCg485eOGffpfZpPl3wxWbaitE+VoBIa1OIguNcW7mKLmFEFif06Av3u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcZDVm8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcZDVm8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97908C19421;
	Tue, 11 Nov 2025 01:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823256;
	bh=cWA8GNsEIoTzoKAvfA7Z6BaPxH9SIkBdYBkjBe9jFaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcZDVm8q7dVcWXU7spK059NYM59j9uMrrfp9dHSzIh/xNNj26kzaoa3WE5ViOzNfw
	 Q3psnCFBq578FxGUXj1SzbTyhivqv6zZrEOMKM/NmCM7fAsbu/UNLqNpNlax23l3g1
	 oxg9E+i5gZsLFkJ465m3RNuwVEGTrNqkIkZBg/7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 263/849] ASoC: tas2781: Add keyword "init" in profile section
Date: Tue, 11 Nov 2025 09:37:13 +0900
Message-ID: <20251111004542.790485687@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit e83dcd139e776ebb86d5e88e13282580407278e4 ]

Since version 0x105, the keyword 'init' was introduced into the profile,
which is used for chip initialization, particularly to store common
settings for other non-initialization profiles.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20250803131110.1443-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781-dsp.h       |  8 ++++++++
 sound/soc/codecs/tas2781-fmwlib.c | 12 ++++++++++++
 sound/soc/codecs/tas2781-i2c.c    |  6 ++++++
 3 files changed, 26 insertions(+)

diff --git a/include/sound/tas2781-dsp.h b/include/sound/tas2781-dsp.h
index c3a9efa73d5d0..a21f34c0266ea 100644
--- a/include/sound/tas2781-dsp.h
+++ b/include/sound/tas2781-dsp.h
@@ -198,6 +198,14 @@ struct tasdevice_rca {
 	int ncfgs;
 	struct tasdevice_config_info **cfg_info;
 	int profile_cfg_id;
+	/*
+	 * Since version 0x105, the keyword 'init' was introduced into the
+	 * profile, which is used for chip initialization, particularly to
+	 * store common settings for other non-initialization profiles.
+	 * if (init_profile_id < 0)
+	 *         No init profile inside the RCA firmware.
+	 */
+	int init_profile_id;
 };
 
 void tasdevice_select_cfg_blk(void *context, int conf_no,
diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index c9c1e608ddb75..8baf56237624a 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -180,6 +180,16 @@ static struct tasdevice_config_info *tasdevice_add_config(
 			dev_err(tas_priv->dev, "add conf: Out of boundary\n");
 			goto out;
 		}
+		/* If in the RCA bin file are several profiles with the
+		 * keyword "init", init_profile_id only store the last
+		 * init profile id.
+		 */
+		if (strnstr(&config_data[config_offset], "init", 64)) {
+			tas_priv->rcabin.init_profile_id =
+				tas_priv->rcabin.ncfgs - 1;
+			dev_dbg(tas_priv->dev, "%s: init profile id = %d\n",
+				__func__, tas_priv->rcabin.init_profile_id);
+		}
 		config_offset += 64;
 	}
 
@@ -283,6 +293,8 @@ int tasdevice_rca_parser(void *context, const struct firmware *fmw)
 	int i;
 
 	rca = &(tas_priv->rcabin);
+	/* Initialize to none */
+	rca->init_profile_id = -1;
 	fw_hdr = &(rca->fw_hdr);
 	if (!fmw || !fmw->data) {
 		dev_err(tas_priv->dev, "Failed to read %s\n",
diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 0e09d794516fc..ea3cdb8553de1 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1641,6 +1641,12 @@ static void tasdevice_fw_ready(const struct firmware *fmw,
 	tasdevice_prmg_load(tas_priv, 0);
 	tas_priv->cur_prog = 0;
 
+	/* Init common setting for different audio profiles */
+	if (tas_priv->rcabin.init_profile_id >= 0)
+		tasdevice_select_cfg_blk(tas_priv,
+			tas_priv->rcabin.init_profile_id,
+			TASDEVICE_BIN_BLK_PRE_POWER_UP);
+
 #ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
 	if (tas_priv->name_prefix)
 		acoustic_debugfs_node = devm_kasprintf(tas_priv->dev,
-- 
2.51.0



