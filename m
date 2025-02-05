Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA6115B984;
	Wed,  5 Feb 2025 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765997; cv=none; b=lzcnW1x+Hg184PSSOV806vOyGOSvrol9V9HZg1Yce5PIGE7IqEULRrB17ZFFOPf8qJnpFW3uqbY3GZO/TwrgpflC2l07l07BvC6Z2t5Kv3BcQ3f+7FAdDXDlEqpl1SNOsutWWU0eedb2zA7g8r+PPdDf339T3YQY7e2pouQMGtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765997; c=relaxed/simple;
	bh=tK+TmaycY9PiTSuFU/EmLT0+j6ceeDNyT5bzjcKANUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tc+Y8Xiy0jaD+NcChlaovixGgy8wRiN6tZS9OUUvbm59ZdnrZYx2eUYROmDS+2joklvBZOgyRwPt6NPnx47r8K1ke9cp4e5YDFjlMoGlqGAiS8oq+SV1guvQfvo1qWb0Gomn/lP/avEa7Nh6skMNN0wmfbSplp5rMJ7ynEdy+j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8QdJQz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8QdJQz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB056C4CED1;
	Wed,  5 Feb 2025 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765997;
	bh=tK+TmaycY9PiTSuFU/EmLT0+j6ceeDNyT5bzjcKANUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8QdJQz3XFCaglcp1+OTpCiT1TY292xiZUFidh740Cf2wCc8g9J8qkC9D+B8ldFH4
	 g4dUy/uOcAJGD/DMElLSCHdUKSaWF0psn+Fxa6ybc2gHbgZWaWoeYa19oQqmXbBSO1
	 Q8pziijlINUwnNd5TltI/aJzC5v0SuzcOjDx7nHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/590] ASoC: Intel: avs: Fix the minimum firmware version numbers
Date: Wed,  5 Feb 2025 14:40:29 +0100
Message-ID: <20250205134505.756165310@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit dbda5c35b88794f6e5efe1b5b20044b0b3a340d4 ]

For few TGL-based platforms the minor version number for AudioDSP
firmware is incorrect forcing users to utilize ignore_fw_version module
parameter.

Fixes: 5acb19ecd198 ("ASoC: Intel: avs: TGL-based platforms support")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250109122216.3667847-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 73d4bde9b2f78..82839d0994ee3 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -829,10 +829,10 @@ static const struct avs_spec jsl_desc = {
 	.hipc = &cnl_hipc_spec,
 };
 
-#define AVS_TGL_BASED_SPEC(sname)		\
+#define AVS_TGL_BASED_SPEC(sname, min)		\
 static const struct avs_spec sname##_desc = {	\
 	.name = #sname,				\
-	.min_fw_version = { 10,	29, 0, 5646 },	\
+	.min_fw_version = { 10,	min, 0, 5646 },	\
 	.dsp_ops = &avs_tgl_dsp_ops,		\
 	.core_init_mask = 1,			\
 	.attributes = AVS_PLATATTR_IMR,		\
@@ -840,11 +840,11 @@ static const struct avs_spec sname##_desc = {	\
 	.hipc = &cnl_hipc_spec,			\
 }
 
-AVS_TGL_BASED_SPEC(lkf);
-AVS_TGL_BASED_SPEC(tgl);
-AVS_TGL_BASED_SPEC(ehl);
-AVS_TGL_BASED_SPEC(adl);
-AVS_TGL_BASED_SPEC(adl_n);
+AVS_TGL_BASED_SPEC(lkf, 28);
+AVS_TGL_BASED_SPEC(tgl, 29);
+AVS_TGL_BASED_SPEC(ehl, 30);
+AVS_TGL_BASED_SPEC(adl, 35);
+AVS_TGL_BASED_SPEC(adl_n, 35);
 
 static const struct pci_device_id avs_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_SKL_LP, &skl_desc) },
-- 
2.39.5



