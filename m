Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7BC1537C8;
	Thu, 12 Dec 2024 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016802; cv=none; b=S53+r8d8kKQ0wXH+b1R8sDQEssnoqQNZdBCPVjZKBICoLaWnouwt7oFYE+LbrLPXNOOTr5uwwpIF4DDd2p0z6saHNHXnsDypoiQH/Dd94/3y5dpE+IyKR67Hl0SLxyjI1O4LkNuPW4UjA9N/GkS5ZPc6F+sxYVqCsYpCfNNt8Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016802; c=relaxed/simple;
	bh=6QdLQllylCFKvlIsJLyNUwA3jDXs6+RP3bUAF5ImHOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU96I2uR73KKEde+OpeumjWO4r9IkqlxLoNaWZFmjAyU5PBMQbwJVE0phP8UQLaVk55eH+uh9Nc8jNpB++6RWTOCa6MnqkMtTB5BIfYulScWK+Rgdpgs3I2igfOErkHYVewms6a15bH+VGxw5asr9b7iEnexEPtKDeKjbHcY+S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPiC0x24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPiC0x24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C65C4CECE;
	Thu, 12 Dec 2024 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016802;
	bh=6QdLQllylCFKvlIsJLyNUwA3jDXs6+RP3bUAF5ImHOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPiC0x24OXfsuHX+fl8y1QOuaj4aVaPsikID09NoBgHK1iIoRv4XXPgZhaQw7/+yR
	 jLWUfUPYicmnwJQGVQQeFP/LFxzYWtsMXP8Ncl4L/ooD/mY0E1uZhESsQy2CYuesvm
	 GGINSfKXrz06DEnIZzigQlvuxUrSwNqGzD7zzC2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/466] ASoC: Intel: sof_sdw: Add quirk for cs42l43 system using host DMICs
Date: Thu, 12 Dec 2024 15:57:50 +0100
Message-ID: <20241212144318.671770174@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ea657f6b24e11651a39292082be84ad81a89e525 ]

Add quirk to inform the machine driver to not bind in the cs42l43
microphone DAI link.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241016030344.13535-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 4a0ab50d1e50d..fa937cc4d8cd1 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -580,6 +580,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "233C")
+		},
+		/* Note this quirk excludes the CODEC mic */
+		.driver_data = (void *)(SOC_SDW_CODEC_MIC),
+	},
 
 	/* ArrowLake devices */
 	{
-- 
2.43.0



