Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E4F4EF149;
	Tue, 13 Oct 2026 11:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892696; cv=none; b=HgcWcSl14/OhqO6diFJvoNTX3JTIpSBmOhM8LxadG1o2HIMCsxRoQGNEXSpylfa1J2tymuvdl9JiDdB6UoClzn39p+QweprDgiqE6JOXkI340Ir4r5s7NqPZCU+2pXfxZGshfC4mWc8KJPG5des2UrFKesnDwvo0TbX+aL28lho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892696; c=relaxed/simple;
	bh=xCIkdl6ejgHbGhO9TZ4K2rWvhHWLY1dfUGpzFYZtU3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQWz5DjnKW6b8R7xx7BIYl/4r1iBlro+juQOZLKmhwWiGqRjM3KHiF0EAZN8ZLkgzuJnws10dkJ0xDbfZlD+adH0rHuqBW1DbhlpssATJPt9bp7gKZGx0aQ8ZtQCF5YLlV6PtqBkjKOCamiXLopS/j5ptd7B60444/ROsTEb24E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4EsAHOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4EsAHOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65861F000FF;
	Tue, 13 Oct 2026 11:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892695;
	bh=zIp18C4B0knZb9rUELxY9x9LdYGHNBUt69M0PTMIvvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4EsAHOx3jGhqbNfrLuat4WCDvyMstUgfPe6hqJyqFyaTB1nydaTn2p9PO5l84C53
	 1YO3zsSWFbeh/nuGu+A3wvmFLFrmG1LIYtiZn5Q1NLtBlaGUznvH8XXcKcB+Z1gW+i
	 3AgEUVX6jvtSO/pJbojMkRKP5290NEFB1dKDgTMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 257/281] ASoC: sdw_utils: Switch CS35L56/57/62/63 to use OT25 DAI
Date: Tue, 13 Oct 2026 13:39:33 +0200
Message-ID: <20261013112901.379086449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 4b7f393a01f88e8d03cba94cf4948652de14789b ]

Change the CS35L56/57/62/63 entries in codec_info_list[] to use
the OT25 DAI for amp feedback.

The AMP feedback was incorrectly using a DAI connected to DP3,
but that is reserved for SDCA companion amp. The correct amp
output is DP4, which is the SDCA OT25 feedback output.

Fixes: 898cd43bde307 ("ASoC: intel: sof_sdw: Add support for CS35L63 into machine driver")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261005155235.1386525-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 2570f40673bdf..a47f34afd1d19 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -797,7 +797,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			},
 			{
 				.direction = {false, true},
-				.dai_name = "cs35l56-sdw1c",
+				.dai_name = "cs35l56-ot25",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_AMP_IN_DAI_ID},
 				.rtd_init = asoc_sdw_cs_spk_feedback_rtd_init,
@@ -826,7 +826,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			},
 			{
 				.direction = {false, true},
-				.dai_name = "cs35l56-sdw1c",
+				.dai_name = "cs35l56-ot25",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_AMP_IN_DAI_ID},
 				.rtd_init = asoc_sdw_cs_spk_feedback_rtd_init,
@@ -855,7 +855,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			},
 			{
 				.direction = {false, true},
-				.dai_name = "cs35l56-sdw1c",
+				.dai_name = "cs35l56-ot25",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_AMP_IN_DAI_ID},
 				.rtd_init = asoc_sdw_cs_spk_feedback_rtd_init,
@@ -884,7 +884,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			},
 			{
 				.direction = {false, true},
-				.dai_name = "cs35l56-sdw1c",
+				.dai_name = "cs35l56-ot25",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_AMP_IN_DAI_ID},
 				.rtd_init = asoc_sdw_cs_spk_feedback_rtd_init,
-- 
2.53.0



