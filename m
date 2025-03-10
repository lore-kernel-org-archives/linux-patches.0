Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6451B3927;
	Mon, 10 Mar 2025 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627691; cv=none; b=Z0MaIT610nYVE2424qht181t7OLGYBjH/3Q4Kr0swO+yfLwpM6VQkLRteHXleH5Pw9l8S6YCv983+OdRWLx7fKaZd6cSaTa6JixSsv+Vw+wgQcnDbz1p7+ejaJJm2yf0s74W6L6GWDAY29W+8VGi3IiMsi8x9czkD3UtEWdihbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627691; c=relaxed/simple;
	bh=wTCri4Jlsh7Pjy2duu7Qm4sqSrmU9w9l/CGUlyownTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVwAm/zs3OwDqMecaYzlus96z58rfaA/eJKLO8bSzJaEEydesfRm19Xwvm0NJWZ21fzgM/fr7p3ZSEzvT0MjTiyjYhHyfgxWqUk4pOCr7mqez5aZN3nQI4MxKAa79AdTF7tiPJgX9E8e7XTZ9d3YEckfkyUilvopKdzGeMM40CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJNcQtT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJNcQtT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35577C4CEE5;
	Mon, 10 Mar 2025 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627691;
	bh=wTCri4Jlsh7Pjy2duu7Qm4sqSrmU9w9l/CGUlyownTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJNcQtT6g5OggHIUKCMk6k7Pz22Kyzb+A/zOieG1S/SPt+S0c7rsAd3M1OFCbDMJi
	 V3wKVetQSAynsRwsNE5p4v4pcqwv57MtgwxaPThGEeHwfKyYQPyP/eIkToKIIx4nVR
	 0BYPd6FKiQYHOa76WD2evCCmcrfeC2ot4LYOksq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/269] net: ipa: Fix v4.7 resource group names
Date: Mon, 10 Mar 2025 18:05:38 +0100
Message-ID: <20250310170505.081101246@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 5eb3dc1396aa7e315486b24df80df782912334b7 ]

In the downstream IPA driver there's only one group defined for source
and destination, and the destination group doesn't have a _DPL suffix.

Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20250227-ipa-v4-7-fixes-v1-1-a88dd8249d8a@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/data/ipa_data-v4.7.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
index c8c23d9be961b..7e315779e6648 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -28,12 +28,10 @@ enum ipa_resource_type {
 enum ipa_rsrc_group_id {
 	/* Source resource group identifiers */
 	IPA_RSRC_GROUP_SRC_UL_DL			= 0,
-	IPA_RSRC_GROUP_SRC_UC_RX_Q,
 	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
 
 	/* Destination resource group identifiers */
-	IPA_RSRC_GROUP_DST_UL_DL_DPL			= 0,
-	IPA_RSRC_GROUP_DST_UNUSED_1,
+	IPA_RSRC_GROUP_DST_UL_DL			= 0,
 	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
 };
 
@@ -81,7 +79,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
@@ -128,7 +126,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
@@ -197,12 +195,12 @@ static const struct ipa_resource ipa_resource_src[] = {
 /* Destination resource configuration data for an SoC having IPA v4.7 */
 static const struct ipa_resource ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
-		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL] = {
 			.min = 7,	.max = 7,
 		},
 	},
 	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
-		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL] = {
 			.min = 2,	.max = 2,
 		},
 	},
-- 
2.39.5



