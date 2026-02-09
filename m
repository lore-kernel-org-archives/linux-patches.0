Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743237A496;
	Mon,  9 Feb 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647391; cv=none; b=KGiGwiykUACwClwiEmoKmjqbArd4MPPsRT7ZBAVIc/Y9BH9ZhwpP0cpOyPOA2xWBX4AZjEThixkR2bGXZRej0IVDr3mRuDAY3mHiK2sdNSPBopRPj+m1EC7yFhi5oZgi18m/ZDmxPROEIJu4oazq/voDbJ6HwPH/8cMGVrtPFU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647391; c=relaxed/simple;
	bh=Qtbf6uSwj92W25+R1yN/1rLGzNtCv8Wtdducwy3OQXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9/Fs0QjaMRouU/MSiKm89ahYNxetF4+zKsJuHI/J+a5morc4487H0/b2UvhWTxohHfCo6cAFMFTQE1XB2M+ogEvYliT5knhwIdTbnG5jA+CMac9/OB8uGrpn5WRyhQdQitlGpa2O4dSAEJjDqk1iBxcEYyxZqnootstVK0p6GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9T1FehE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9T1FehE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B871CC116C6;
	Mon,  9 Feb 2026 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647391;
	bh=Qtbf6uSwj92W25+R1yN/1rLGzNtCv8Wtdducwy3OQXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9T1FehEmPotpnWqO0azPfK3+y87mKWA6zNN4nwerSb0jiCR+YMBMtWGjCpicXJyy
	 wV8SPxPgjaM6N7S+i9iWCsfckdwatc7ywE84clZ540Ff2SUVMBESUNx8RnPCgLMsPH
	 L7xP8+u/4VWK8uA0JmE3zndDeZY+QCJn6XquOJTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deep Harsora <Deep_Harsora@dell.com>,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/175] ASoC: Intel: sof_sdw: Add new quirks for PTL on Dell with CS42L43
Date: Mon,  9 Feb 2026 15:22:38 +0100
Message-ID: <20260209142323.493813046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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



