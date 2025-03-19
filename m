Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75281DEFD6;
	Wed, 19 Mar 2025 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395259; cv=none; b=GQlbDJ5a8HFR98fSj0NwSYRQSe5l42mqdbSlkWKVCE7fpy6JG/eQVIYtQIhQy7m48Q9v6m4J0s46dAIUg/pCTZO3XnV64oIWmfgN2bUcPYZrtkawMEs2PUySeYVGiQgK48uCkxuS5ulEBuDBGeRl3XNrh1QyFSUPumV0i9v/Jzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395259; c=relaxed/simple;
	bh=0MQT58wwDeitmmQkVv9M9h4LjKikxHM7ALDG30PfG5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrmrSbq7I1yhlwN8iAPpWW5ETmnel+bWE8t+gcwDH8jSPSTi8tyrQgNDmB8P1GJTDYg4FkkLHP1yPtqA0KY3jZY+yWyf6PmuONpSgmk2MaYRNqsdJgUPXmhd3RZqYxC/kCSm71ELs5KrRxOmpzm2ffsXptL1EuH+M1LEVHrkPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JquwNjIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JquwNjIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4B5C4CEE8;
	Wed, 19 Mar 2025 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395259;
	bh=0MQT58wwDeitmmQkVv9M9h4LjKikxHM7ALDG30PfG5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JquwNjIKUj1q+tXDfodgV5/xpWPJLu/ScSbpdsbKe5X22f7dcYFae+8hJ6bCmH7eR
	 RtGr91ss4BD+mf+GEI69bxvJsd/QrScMM3YC6376BZrXnfXP/iEBGLiyHu1WhbfNGm
	 2f+Bcf4y86LqYMYm1QkPsF/rw+nnErdyL0UlX6qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/166] ASoC: rt722-sdca: add missing readable registers
Date: Wed, 19 Mar 2025 07:31:55 -0700
Message-ID: <20250319143023.921630818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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
index 91314327d9eee..c382cb6be6025 100644
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



