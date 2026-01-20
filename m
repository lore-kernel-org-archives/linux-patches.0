Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C5647DD5D;
	Tue, 20 Jan 2026 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937711; cv=none; b=Q9D3Ia5fa0t2nntVsO22H4FYlJ40EC9xACNfmmd5kQt9i9voojEtQV8arAs65VM5lAC4rBEjfbXW83ohGlVbEU0qN3DEm1sYNaxE0gefwyOF9IMeXj8A5O9ETRUqroPZDeRIV7qMUpMEh5awi1TRdy0EgkzY5PC9/fqvzOMYavA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937711; c=relaxed/simple;
	bh=qH3/LtNVi+hMB2qYcvwqkIxDHjFJK3VtL162Y4ACYvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJb3ZxNfHNLYHL5ceWbv2IXKPZ3UzCgt3JoCxtO4A2/U6C003onhscKgUiNzwtk4081ulVC67qC0NPc9UFACrAqiFjavVCcwVkHcpCj9zKzmI2DvdqEVZV0bD7YgU7hS7uKw8i40RWxoEEnlX6FUQy+8KJ5O5lfDxzr7YHEciQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQ8oURh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQ8oURh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4361CC19421;
	Tue, 20 Jan 2026 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937711;
	bh=qH3/LtNVi+hMB2qYcvwqkIxDHjFJK3VtL162Y4ACYvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ8oURh7itENn3AAZxMZ3jNIKcLzoqViThvp6NArAzfVk/FzliyA1QBfw4nn9kPVa
	 Y/Z26XkL3rpuc4Ix74ValjkWF1rqQ6cW4oQnrl0HIKJ3KHroSSQsSF7k9x7PGDr/kH
	 IWY9OuulY7LMWFr/W+84loh+QOlYBIE8R9YMFwQS8DFaGVVSyP+SjNv1ygZW9fLOtf
	 aDwFLBK/ItTTWNMkTwars3rxAh+dppfIDZ5hjbMSLJGWLMXwbEIhiDApKZLnYIpJvn
	 xA1nmXQJJvY+Q0BW5iST304s8kwocgN6183SjL7LxzhJ3viD0nkEELGIMxt1C9TusJ
	 9/6UL2jGAsmnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deep Harsora <Deep_Harsora@dell.com>,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	ckeepax@opensource.cirrus.com,
	mac.chiang@intel.com,
	rf@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.18] ASoC: Intel: sof_sdw: Add new quirks for PTL on Dell with CS42L43
Date: Tue, 20 Jan 2026 14:34:52 -0500
Message-ID: <20260120193456.865383-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120193456.865383-1-sashal@kernel.org>
References: <20260120193456.865383-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deep Harsora <Deep_Harsora@dell.com>

[ Upstream commit 12cacdfb023d1b2f6c4e5af471f2d5b6f0cbf909 ]

Add missing quirks for some new Dell laptops using cs42l43's speaker
outputs.

Signed-off-by: Deep Harsora <Deep_Harsora@dell.com>
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Link: https://patch.msgid.link/20260102152132.3053106-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### SUMMARY

**What problem does this commit solve?**
- It enables audio speaker functionality on new Dell laptops (Panther
  Lake platform, SKU 0DD6) using the CS42L43 codec with sidecar
  amplifiers
- Without this quirk, the speakers on these specific Dell laptops won't
  work properly

**Does it meet stable kernel rules?**
1. ✅ Obviously correct - follows exact same pattern as dozens of
   existing entries
2. ✅ Fixes a real bug - missing hardware support (no working speakers)
3. ✅ Important issue - users can't use their laptop speakers without it
4. ✅ Small and contained - 8 lines, single file, static data only
5. ✅ No new features - uses existing quirk infrastructure
6. ✅ Applies cleanly - follows existing patterns

**Risk vs benefit trade-off:**
- **Risk**: Near zero. The quirk only matches specific Dell hardware via
  DMI. Other systems are completely unaffected.
- **Benefit**: High for affected Dell users - working audio vs. broken
  audio

**Concerns:**
- This can only be backported to 6.12.y stable (where
  SOC_SDW_SIDECAR_AMPS exists)
- No dependencies within this commit - it's a self-contained table entry
  addition

**Conclusion:**
This is a textbook example of a hardware quirk addition that should be
backported to stable. It's:
- A trivial, low-risk addition (static data in a quirk table)
- Enables hardware that wouldn't otherwise work
- Falls squarely into the "quirks and workarounds" exception category
- Follows the exact pattern of many other similar entries that have been
  added for Dell/Lenovo/ASUS/Google devices

The fix is small, surgical, and meets all stable kernel criteria for the
quirk exception.

**YES**

 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index c013e31d098e7..92fac7ed782f7 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -750,6 +750,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
 	/* Pantherlake devices*/
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0DD6")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.51.0

