Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBBC1DE89C;
	Wed, 19 Mar 2025 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394975; cv=none; b=SZMBEhi/g4p14IuwOVhlxpRziQDrkY62vtcfCsdc1BAD1YwaXRwLGzEo8ZREcqK+bbhysiwUDWPPvcnHP61Inzt4kCN7+qlgFR+84e4akL9CSG60to0nHpN3QzcBXwjGWD8r14EF1e/Ntln/iDKexNq2v82Py0C5P5Rufo5K62k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394975; c=relaxed/simple;
	bh=UVPI1uX79bBVScglC0chtxirVfShLf59aFO1p0mLC6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkdJ2poqq/7nQjrxZcN4NF5Sfm64Nl7dE4t+3KdE21Sb5K+EoDxeTVq882hddz2AfVGn3zvfjKmT614MxVoRnjExmaOKndtKnUzS0E7wPm6Hi746BSdt6OqSEcx4AbNU8QMh/gY3dj6MaS3+g4dOmAf/VVIA63UHs6I5yo1K+yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmddBv8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmddBv8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771FEC4CEE4;
	Wed, 19 Mar 2025 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394974;
	bh=UVPI1uX79bBVScglC0chtxirVfShLf59aFO1p0mLC6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmddBv8q2AZWpOt5/qu4huvhp5uD52oaNSKMaljN5Lr2IqrgEFkEfgFZCwiF4X8a/
	 5L+RV5WByRx5FH2v7eJCxD0xI/nWdQb7TAiP9oZACPt4ktz4ADJyAOyyOZ4OxdRL8D
	 T1rclD2cb9S6Xg99TRbwoGTj+aV3VOnsoeM87C3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 211/241] ASoC: rt722-sdca: add missing readable registers
Date: Wed, 19 Mar 2025 07:31:21 -0700
Message-ID: <20250319143032.971630959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 247fba13416af65b155949bae582d55c310f58b6 ]

SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_FU15,
RT722_SDCA_CTL_FU_CH_GAIN, CH_01) ... SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY,
RT722_SDCA_ENT_FU15, RT722_SDCA_CTL_FU_CH_GAIN, CH_04) are used by the
"FU15 Boost Volume" control, but not marked as readable.
And the mbq size are 2 for those registers.

Fixes: 7f5d6036ca005 ("ASoC: rt722-sdca: Add RT722 SDCA driver")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250310080440.58797-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 25fc13687bc83..4d3043627bd04 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -86,6 +86,10 @@ static bool rt722_sdca_mbq_readable_register(struct device *dev, unsigned int re
 	case 0x6100067:
 	case 0x6100070 ... 0x610007c:
 	case 0x6100080:
+	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_FU15, RT722_SDCA_CTL_FU_CH_GAIN,
+			  CH_01) ...
+	     SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_FU15, RT722_SDCA_CTL_FU_CH_GAIN,
+			  CH_04):
 	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_USER_FU1E, RT722_SDCA_CTL_FU_VOLUME,
 			CH_01):
 	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_USER_FU1E, RT722_SDCA_CTL_FU_VOLUME,
-- 
2.39.5



