Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71BF18C03
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsJKoxBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C0FC433C7;
	Mon, 16 Oct 2023 08:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446412;
	bh=HxUh6dkyYoo9mPYxpMzcnChugwjAsIHSZGIIsf7HYc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsJKoxBHim5qiesk1kPhnE/GhKnQ22k7rLENhnFrF1sDtyAX6JJCK1yjgCi/VpIbA
	 RDIuwD2xcyCpmx7iiWajU2g8b+UiEjTUf1c6tagbTLMOa9CI/fmGdWcQcUOL6jXScy
	 gzUaoXb+jPiqRagNbSXqX2dKydW0KeMsLChRNgNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 024/131] ASoC: Intel: sof_sdw: add support for SKU 0B14
Date: Mon, 16 Oct 2023 10:40:07 +0200
Message-ID: <20231016084000.667263984@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit fb0b8d299781be8d46b3612aa96cef28da0d93f4 upstream.

One more missing SKU in the list.

Closes: https://github.com/thesofproject/linux/issues/4543
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20230919092125.1922468-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -351,6 +351,16 @@ static const struct dmi_system_id sof_sd
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B14"),
+		},
+		/* No Jack */
+		.driver_data = (void *)SOF_SDW_TGL_HDMI,
+	},
+
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B29"),
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |


