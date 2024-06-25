Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B894EFBEF;
	Tue, 25 Jun 2024 09:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308235; cv=none; b=ESdtxxl9u+b825IDgRK5PQvTWrtdafRE+dqYriD/hhwyfTrUlNSZQI0BfaITPi7MLYCcuj26adDW6rN8bsBL82jBsuprV5IKGf4yHTc7muVM51A+SDs1YKLll5xTFylK/xLteC1xZVD1ISSlh9kVaJOso5DbE7b1MhmvmxH4jtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308235; c=relaxed/simple;
	bh=CNV54RflDqIQCJiMk1p6WlqZ+JTWn6yWfln9L+pF1qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqqMfNz0GdSYRgFCrdlVouipxm/sf9crMxhiI/izuHvdc1QCMY/E4KyA0aQsgQuXZ2WMWhDvW2kMtyrAjEy5Y1dw/jEzNfRb2hoF2Ew0oKwkbTe9Y73OzrCfgohyJvQdwaBp62vajDxKLL0PzADOP7oYZH3/BfctR/yzLj5LnoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9U1ysks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9U1ysks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388AEC32786;
	Tue, 25 Jun 2024 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308235;
	bh=CNV54RflDqIQCJiMk1p6WlqZ+JTWn6yWfln9L+pF1qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9U1yskscx3p3u1Y3TJ7lsuhMd7B+hH3hYnw+tR2HIHFnsa74mARbHfVPSup4RHoq
	 KRFj7mJ94zb+MCV0yvcQbLRqOhftqAC7q0cWdaBjJCm5BQTwhJLs3FhB6bUkx/RxCC
	 jDggWdeMdw3N+geCBWW1obEHbV0SU1V5N7XTiR8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 052/250] ASoC: Intel: sof_sdw: add quirk for Dell SKU 0C0F
Date: Tue, 25 Jun 2024 11:30:10 +0200
Message-ID: <20240625085550.057872027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a98b9da2a2c4c..a5e2ffcc36e2e 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -429,6 +429,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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



