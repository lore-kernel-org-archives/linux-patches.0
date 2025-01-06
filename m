Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3C159565;
	Mon,  6 Jan 2025 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177918; cv=none; b=E/xblXgCT7VMP6v6OJ2SuanvUvTBpRijuS1+XndbFU81C6kwKqsHdEDkzfR2UGfqJumt0ANW9BsdvyQhU+UnfmfTDiPSa+8wUuZ9ujZYZeNDNAVmvN73/Nbs3Wp471Vksa2fXnVgOQo5K9R8n/IxeytWxSehFtgaMGjrDnHZubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177918; c=relaxed/simple;
	bh=srrWm9h3W0f/Uyxms1aeedWNqBErvPqNoAs5OcQ+q4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YW9B1scwllCZRyjpJiNYcATCtJpbm+z681wuK7tZDmepZmFeZabq2FemykW92aD6t8+WVbAFR39hEjkh7/ULOH5hTw8pJ4C1ATfz9VgB5UoOXdM1kMRdRIlIbxobV7k+cR/Su9alghLBiPLyLtcj4PaJE9BRCCxmmLezvWM4hiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJkWucYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJkWucYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF348C4CED2;
	Mon,  6 Jan 2025 15:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177918;
	bh=srrWm9h3W0f/Uyxms1aeedWNqBErvPqNoAs5OcQ+q4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJkWucYJHZW5QLPk/8JaQEjAVmThVu5myib239v4GGrMQIa6TxJ6EAZWSV+7E82/I
	 69u7BeMEPRW4rH6/6l2DPFQqUGCSXk10yj34XziUA9UsaABOUaHaqfiDRTkbNty/WV
	 bIi7R5Db8kN7uyZsCKIO0842xh/p5EdRrixBug4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/156] ALSA: hda: cs35l56: Remove calls to cs35l56_force_sync_asp1_registers_from_cache()
Date: Mon,  6 Jan 2025 16:16:09 +0100
Message-ID: <20250106151144.857515245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 47b17ba05a463b22fa79f132e6f6899d53538802 ]

Commit 5d7e328e20b3 ("ASoC: cs35l56: Revert support for dual-ownership
of ASP registers")
replaced cs35l56_force_sync_asp1_registers_from_cache() with a dummy
implementation so that the HDA driver would continue to build.

Remove the calls from HDA and remove the stub function.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20241206105757.718750-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l56.h     | 6 ------
 sound/pci/hda/cs35l56_hda.c | 8 --------
 2 files changed, 14 deletions(-)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index 94e8185c4795..3dc7a1551ac3 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -271,12 +271,6 @@ struct cs35l56_base {
 	struct gpio_desc *reset_gpio;
 };
 
-/* Temporary to avoid a build break with the HDA driver */
-static inline int cs35l56_force_sync_asp1_registers_from_cache(struct cs35l56_base *cs35l56_base)
-{
-	return 0;
-}
-
 static inline bool cs35l56_is_otp_register(unsigned int reg)
 {
 	return (reg >> 16) == 3;
diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index e3ac0e23ae32..7baf3b506eef 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -151,10 +151,6 @@ static int cs35l56_hda_runtime_resume(struct device *dev)
 		}
 	}
 
-	ret = cs35l56_force_sync_asp1_registers_from_cache(&cs35l56->base);
-	if (ret)
-		goto err;
-
 	return 0;
 
 err:
@@ -1059,9 +1055,6 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int hid, int id)
 
 	regmap_multi_reg_write(cs35l56->base.regmap, cs35l56_hda_dai_config,
 			       ARRAY_SIZE(cs35l56_hda_dai_config));
-	ret = cs35l56_force_sync_asp1_registers_from_cache(&cs35l56->base);
-	if (ret)
-		goto dsp_err;
 
 	/*
 	 * By default only enable one ASP1TXn, where n=amplifier index,
@@ -1087,7 +1080,6 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int hid, int id)
 
 pm_err:
 	pm_runtime_disable(cs35l56->base.dev);
-dsp_err:
 	cs_dsp_remove(&cs35l56->cs_dsp);
 err:
 	gpiod_set_value_cansleep(cs35l56->base.reset_gpio, 0);
-- 
2.39.5



