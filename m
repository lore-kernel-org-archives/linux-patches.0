Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFEF476CD6;
	Mon, 31 Aug 2026 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184380; cv=none; b=CtrRBE9PBTVtRg61WSO7mfRyL05RFxNm4QHdRCAIpLUdUOnCV8gBMyh25DRS4LFIxITZmpjlx6ReGjdsIz/KiqmwjSIVBTTHR0vWRCgVTJmUHGUd+joZNPs/kCcDnko1clrZ7UCx5xBw7wVDkPj3HRC8T021MutgBcCuBeswptY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184380; c=relaxed/simple;
	bh=0GnKRMGzbyWbMXbQ8K9NRe3rPOBo1iJiuPo+9bQ2ud4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r++y4WBx/t2OgSKBcS4E2Y66auSr3QgSu5XppjOZfwyCUQYul5YTHPmpIghW/fAjvNaoKMbHO4zLDTofpAH3Dn6fuuMI7otuvH8hfc6Ehhc+SZyWFhHYxX7TLyWNy/h0NFvS39TIHVg3l0xNNQhOJ/bXHwbQ7ndBOZtF3s0FTag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klxrtnBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klxrtnBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BB11F00A3E;
	Mon, 31 Aug 2026 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184378;
	bh=qdInuau1opK/NX1CRfecjEgVmT9hD+5UWjqPRkbGtwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klxrtnBg3BcSTzJ8E7cCoOzW1xS63h5D5wkzC+lqQDb0oRrxJnx3cYY3DUfrPGmUO
	 t2SPjEYQ1KZMgK1RA+8ZLpHks1xpnYfBtb4AM+Y56Kd5eTH5AHEwvVDv+DjdQO8Fvi
	 MjVfquerzNh3ESwyFZMjnUXLwA8UipJTzhEqOe0lzsd9cZGON0K0EapyLVIfnsQSBR
	 l8tsrOl5sSqpErys6+mOZ/cK5H6jJVwzNLGBH60TzuxCiXENxmlCH1ja2l4XLR5R+5
	 +OpbK2waoxYZMX/6VMfl3DRxO32KWaqQsL/Tz1+JYoUSN5lwVn4rsSGogXMVNIxuXI
	 cX6yr+kIRsWkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cezary.rojewski@intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: sof_sdw: Add a quirk for 0x17aa383c laptop using sidecar amps with cs42l43
Date: Mon, 31 Aug 2026 09:31:26 -0400
Message-ID: <20260831133314.4125787-658-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 04f15d8f393037ed72876399882265604a370b2b ]

Add a quirk for a Lenovo laptop (SSID: 0x17aa383c) to allow using sidecar
CS35L56 amps with CS42L43 codec.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Link: https://patch.msgid.link/20260703130210.21991-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Both background git commands finished successfully and match the earlier
analysis:

**`SOC_SDW_SIDECAR_AMPS` history** — The flag landed with the 6.18 merge
(`5d324e5159d9e`), then showed up in Dell PTL CS42L43 quirks
(`921903d73967f`) and the Lenovo `0x3821` quirk (`2ca80dd4bb0e2`,
already in this 6.18.y tree). All prerequisites for the `0x383c` entry
are present.

**Stable vs upstream** — Merge-base with `04f15d8f39303` is
`7d0a66e4bb908`. That quirk commit is on master but not in stable HEAD
yet; it should apply cleanly right after the existing `0x3821` line.

Verdict unchanged: **YES** for backport to this `linux-6.18.y` tree.

 sound/soc/intel/boards/sof_sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index c9f4fe84c7eed..4a2b375d7dd9d 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -811,6 +811,7 @@ static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
 	SND_PCI_QUIRK(0x17aa, 0x2348, "Lenovo P16", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x2349, "Lenovo P1", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3821, "Lenovo 0x3821", SOC_SDW_SIDECAR_AMPS),
+	SND_PCI_QUIRK(0x17aa, 0x383c, "Lenovo 0x383c", SOC_SDW_SIDECAR_AMPS),
 	{}
 };
 
-- 
2.53.0

