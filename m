Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260762253FC;
	Mon, 18 Aug 2025 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524286; cv=none; b=Hj8QbnVbLyRwhokgUDDexnm9edNiOrX4XIpM8QztACCO9ncqWsuW9mZe2C1HHMVSG1YkLRfLB7W0J5Ay8pGDvkC1nuTSVHnocvjsb2YEoeIbnREUtkQSmmfhAW4LDyZJ49YoB0sNjRJ/I+yM5QpMl7+Y+JnH3mNrHiyCIy0sSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524286; c=relaxed/simple;
	bh=S/rFdGZ/fOtapMkXLCBu/HUvewUqr73cxlsSAycRRDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmMYTFONCzqi0awOHiH5goIw6gcb3PMWfv3ZgHIUcE5zfkKMoffYxWEI8gsMjGjXUgeaZGMHezvnnbKwRFxLYvsp7+mrPdJAYMz8A4kKOOrPTNucbVD1VsflCVbRcLJiPI3CjLd0oYatUFhtwhTAq2cwAOWK7jZmUl4WuJMCOeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDnHVILX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDnHVILX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983BCC113D0;
	Mon, 18 Aug 2025 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524286;
	bh=S/rFdGZ/fOtapMkXLCBu/HUvewUqr73cxlsSAycRRDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDnHVILXk4CzOa6eIz+lv6t6IttkAdzWBZHQNPPUkJosBwJ4dgGXg0E0Lb/WOfuDY
	 7cQbtixhkBNCYKDsTZ6KjI7JpMl3gBP8NAABVPiyO00nFQjT2GU0af5et+oUtz8z1g
	 gJQOsdUsjKtboGjeIwv2q0XeSl5gFbitdMQ/uORA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Jakubek <peterjakubek@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 424/515] ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCC SKU
Date: Mon, 18 Aug 2025 14:46:50 +0200
Message-ID: <20250818124514.745839412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Jakubek <peterjakubek@gmail.com>

[ Upstream commit 1b03391d073dad748636a1ad9668b837cce58265 ]

Add DMI quirk entry for Alienware systems with SKU "0CCC" to enable
proper speaker codec configuration (SOC_SDW_CODEC_SPKR).

This system requires the same audio configuration as some existing Dell systems.
Without this patch, the laptop's speakers and microphone will not work.

Signed-off-by: Peter Jakubek <peterjakubek@gmail.com>
Link: https://patch.msgid.link/20250731172104.2009007-1-peterjakubek@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 095d08b3fc82..c479b65d73df 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -741,6 +741,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0CCC")
+		},
+		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
+	},
 	/* Pantherlake devices*/
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.39.5



