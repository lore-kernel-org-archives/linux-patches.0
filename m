Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62A230BED;
	Mon, 10 Mar 2025 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628072; cv=none; b=G43qVBB0P7NfBjJ8O0LbsrP8HMR75/N2sL7agaLvOpdnFLkuSleK9uYYQIvJFJN002nPOKuhkgT7ozS4fcCx02tphA+tmTiZ3owHu/TcI1tLp/FDO/m+FvUx8rsykPG+r13zrPM6ZGUbJAie2zw2/PZKUFp7jx0fuwtSzxFXJEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628072; c=relaxed/simple;
	bh=/t/lWVgBEuaprf2jP6FZvGcHhOBaeBmLjXPBOtQwIuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WicYV0rJLfIRfZWTzC8I5sGThqj8SdCOXoNNCU7nxjFiYDXZQeIbnyMbZmHevK9BI3w5hrGfoSTbD0U6o4/pIl9Yg0cc1mrVXMsE6FyqGkNoBjwYOi6aR89DLsnmnLZvtrU4Mz/ZiO/ssf+6QXb0stPeq9cyGy3pMxh9ciBdavI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Af5kVhp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Af5kVhp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BD4C4CEEC;
	Mon, 10 Mar 2025 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628071;
	bh=/t/lWVgBEuaprf2jP6FZvGcHhOBaeBmLjXPBOtQwIuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Af5kVhp+2j1J5wsMYIQF4gE211c3+r/jgJT2JCtPhO/P8G/vWcOB85w04wfhf50Qx
	 JYAii4O3+iG1d5o+nVSW5hcWaLE+JBimSrNcHqV4hMrEKnUy+bikE/m7ydsnuwJkqz
	 fVtZLlqZKEwWGsOiKt253svcuq9rP8KJlnhaQPv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/145] net: ipa: Fix v4.7 resource group names
Date: Mon, 10 Mar 2025 18:06:12 +0100
Message-ID: <20250310170437.900869302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b83390c486158..f8e64b9025820 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -27,12 +27,10 @@ enum ipa_resource_type {
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
 
@@ -80,7 +78,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
@@ -127,7 +125,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
@@ -196,12 +194,12 @@ static const struct ipa_resource ipa_resource_src[] = {
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



