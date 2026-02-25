Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A60D1F03DE;
	Wed, 25 Feb 2026 01:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983976; cv=none; b=QFEaK+KBHZiQ9XX3wbix0RZQBAEq9jYqnyoR3DtghwrVCsLP54QUXQNIaejmKL9jTSsafPtYahd+czbjZeeO7yZqUTHCxwhb4XqBXznRyhWjC4DtnOEp7iLFCeNFnAuufPZjRAj2JTxtwTrWPx+Wl7yhibbvqrDpTazGXq4M8iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983976; c=relaxed/simple;
	bh=Ea2NcJw9co1lrivec4lMNDZULtiyFspYmu+IFDthD5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkXkYNp1lpzohHdmUzlyVUd5pgZuHE0hfPQOSJiYw2Q5bzLPTelXaCXnGdGsi13ydTKBp3MlIZxtcPsSd9bN70uNjUVfIWkKZch4T6gphOPKd3TYMaYWLFQ65AyG1Hzt2pGVHuLE87mxbSWqFOvvvjd/n79CcuhqQhRYMrHt/N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osz5KThO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osz5KThO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A94CC116D0;
	Wed, 25 Feb 2026 01:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983976;
	bh=Ea2NcJw9co1lrivec4lMNDZULtiyFspYmu+IFDthD5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osz5KThOtJJZb55BOubgdkRgdYLkbh/FKhV4VwrLnlOex3RaKpLx3epyaSLqpn9R0
	 iKpuNxNKYqZVC7trdAWQ+k/zvPTua7/QXjjYK+ueKyDI7XtiIKS3SxrTN4k6TzoxQf
	 F/1WHtLasQCKLe30PGCgU8eksoia64pbZr+Q2jmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/641] ASoC: SDCA: Force some SDCA Controls to be volatile
Date: Tue, 24 Feb 2026 17:19:15 -0800
Message-ID: <20260225012354.450999959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit c7b6c6b60594fd1efe35c61bc6a2176b25263ccc ]

Whilst SDCA does specify an Access Mode for each Control, there is not a
1-to-1 mapping between that and ASoC's internal representation. Some
registers require being treated as volatile from the hosts perspective
even in their Access Mode is Read-Write. Add an explicit list of SDCA
controls that should be forced volatile.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20251020155512.353774-10-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9fad74b79e5f ("ASoC: SDCA: Handle volatile controls correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_function.h   |  1 +
 sound/soc/sdca/sdca_functions.c | 58 +++++++++++++++++++++++++++++++++
 sound/soc/sdca/sdca_regmap.c    |  9 +----
 3 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/include/sound/sdca_function.h b/include/sound/sdca_function.h
index ea68856e4c8c4..86fd74146c33d 100644
--- a/include/sound/sdca_function.h
+++ b/include/sound/sdca_function.h
@@ -771,6 +771,7 @@ struct sdca_control {
 	u8 layers;
 
 	bool deferrable;
+	bool is_volatile;
 	bool has_default;
 	bool has_fixed;
 };
diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 7adbf653bd8ac..4417278e39bb1 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -779,6 +779,62 @@ find_sdca_control_datatype(const struct sdca_entity *entity,
 	}
 }
 
+static bool find_sdca_control_volatile(const struct sdca_entity *entity,
+				       const struct sdca_control *control)
+{
+	switch (control->mode) {
+	case SDCA_ACCESS_MODE_DC:
+		return false;
+	case SDCA_ACCESS_MODE_RO:
+	case SDCA_ACCESS_MODE_RW1S:
+	case SDCA_ACCESS_MODE_RW1C:
+		return true;
+	default:
+		break;
+	}
+
+	switch (SDCA_CTL_TYPE(entity->type, control->sel)) {
+	case SDCA_CTL_TYPE_S(XU, FDL_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(XU, FDL_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(XU, FDL_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(XU, FDL_STATUS):
+	case SDCA_CTL_TYPE_S(XU, FDL_HOST_REQUEST):
+	case SDCA_CTL_TYPE_S(SPE, AUTHTX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SPE, AUTHTX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SPE, AUTHTX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(SPE, AUTHRX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SPE, AUTHRX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SPE, AUTHRX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(MFPU, AE_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(MFPU, AE_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(MFPU, AE_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(SMPU, HIST_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SMPU, HIST_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SMPU, HIST_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(SMPU, DTODTX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SMPU, DTODTX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SMPU, DTODTX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(SMPU, DTODRX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SMPU, DTODRX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SMPU, DTODRX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(SAPU, DTODTX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SAPU, DTODTX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SAPU, DTODTX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(SAPU, DTODRX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(SAPU, DTODRX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(SAPU, DTODRX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(HIDE, HIDTX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(HIDE, HIDTX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(HIDE, HIDTX_MESSAGELENGTH):
+	case SDCA_CTL_TYPE_S(HIDE, HIDRX_CURRENTOWNER):
+	case SDCA_CTL_TYPE_S(HIDE, HIDRX_MESSAGEOFFSET):
+	case SDCA_CTL_TYPE_S(HIDE, HIDRX_MESSAGELENGTH):
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int find_sdca_control_range(struct device *dev,
 				   struct fwnode_handle *control_node,
 				   struct sdca_control_range *range)
@@ -927,6 +983,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 		break;
 	}
 
+	control->is_volatile = find_sdca_control_volatile(entity, control);
+
 	ret = find_sdca_control_range(dev, control_node, &control->range);
 	if (ret) {
 		dev_err(dev, "%s: control %#x: range missing: %d\n",
diff --git a/sound/soc/sdca/sdca_regmap.c b/sound/soc/sdca/sdca_regmap.c
index 72f893e00ff50..8fa138fca00ff 100644
--- a/sound/soc/sdca/sdca_regmap.c
+++ b/sound/soc/sdca/sdca_regmap.c
@@ -147,14 +147,7 @@ bool sdca_regmap_volatile(struct sdca_function_data *function, unsigned int reg)
 	if (!control)
 		return false;
 
-	switch (control->mode) {
-	case SDCA_ACCESS_MODE_RO:
-	case SDCA_ACCESS_MODE_RW1S:
-	case SDCA_ACCESS_MODE_RW1C:
-		return true;
-	default:
-		return false;
-	}
+	return control->is_volatile;
 }
 EXPORT_SYMBOL_NS(sdca_regmap_volatile, "SND_SOC_SDCA");
 
-- 
2.51.0



