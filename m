Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B2146A9D;
	Tue, 25 Jun 2024 09:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308916; cv=none; b=qpMkE/2sL8hYUFjqfPh/Uocteos//ETXjX4VkPvX+zZ8a0dx8ESt/skNyrWht6lrZIsGnWgZFuSXGE1dtj9Ce0yT7epXWFoTAIw+BCv7FrQQrG7Chn0gCS/xwNDKe2owGM3Z/9KBnm+SjE9iRTIvC/C1WSqzJsp5sTEzg9gTnWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308916; c=relaxed/simple;
	bh=CWnZe5EW6+gSNGJQyWPNOla5AxxQ1lZKVOWfKNlcVRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcOkJljtLNv/810854PzpmLkSbQSaS04zdIwlxIvXigTMckKEoYGlz3ofm4imX89NK/QojG3EEc2C3wBRejaJ+kWQYrjrHXpGnhz5iqPdknkyBIBTcErYTRBzzUN1VPSTVvwI0PYu+MLlfdcxoPHE80L+VyYecInCVUp9mW9/74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUKPpnQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUKPpnQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D987C32781;
	Tue, 25 Jun 2024 09:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308915;
	bh=CWnZe5EW6+gSNGJQyWPNOla5AxxQ1lZKVOWfKNlcVRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUKPpnQy80iqLl+Tx+rdK5+W8Kc8fTAsvN3q5iyDo6wARcidaad4kkxbkBDYXwk71
	 gq18usjiOWbmy8Px4bGIWMB8Ha4g1oW4hmZt014Rt2MwCf33Lv1awRIbKrHjIanRx+
	 iWy5KCUgaixu0Nfk1NJgI/58/NVWY7KVz8ifl9wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/192] ASoC: Intel: sof_sdw: add quirk for Dell SKU 0C0F
Date: Tue, 25 Jun 2024 11:31:44 +0200
Message-ID: <20240625085538.394251177@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b10cb955c6c0b8dbd9a768166d71cc12680b7fdf ]

The JD1 jack detection doesn't seem to work, use JD2.
Also use the 4 speaker configuration.

Link: https://github.com/thesofproject/linux/issues/4900
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20240411220347.131267-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 59621a9c389c7..91098d7922bef 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -436,6 +436,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0C0F")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.43.0



