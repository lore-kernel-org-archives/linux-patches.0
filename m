Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68BC4E9C36;
	Thu, 17 Sep 2026 18:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668429; cv=none; b=WVlYXYKjlZs5mm+s8piJPCX5Kr3tZ7l8Ia8jtl1CHBGnB6MK4/lKUShQujhA7bBoFNRPfLAlbgxsZ9370wl/yH/aCT9sZlzC1+RAHMg9CDI646porXlpqblEc8xfsVzQNKsKJXWkww7i3i9hbsvISd9QzdaCF809lJ5Zn9Qw+xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668429; c=relaxed/simple;
	bh=htQluL3of0vGBeSKwTX5hMmWYkreEsLz5ty4nFAIrEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgTM+2GYP0PQGGBk5TwRz17Se3X+PVMPcMgBvQ7A6AYGNWQdTkDPjoFakq3rgRdNlpsz0lPv64fX3MwO626Zo88Ko5RGx9VnusS/CvMdMiRC1r1rM2kbresdyydcMg4RVIqrcjfr/Y9RdohveyJKIrB12cLiFANRk+2UxYafFWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D51BaCZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D51BaCZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C91F000FF;
	Thu, 17 Sep 2026 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668428;
	bh=Ixh/dnYe4oCiT50JMeZ77UYfsR1K9XV1U5BAPX+qSVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D51BaCZh2wNx/wOubMGi5Gmi4evjXuG2QJ6FE6gWClJHwjmDYgmNAGV1/lE6F1QPl
	 2f5vustAbm2nSjRMeM0uAzT4jjDiNv/sKGut5KHJaMLOf4Gvq82wMwV6kFMH3ACGP0
	 hQF3uGsmAM8Kgp7K7pAn99AECdkzqp5BXF4WWuD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0423/1102] ASoC: Intel: sof_sdw: Add quirks for new Dell laptops
Date: Thu, 17 Sep 2026 16:06:06 +0100
Message-ID: <20260917151550.289839769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit efd80de2de9d06ddf0eee55ca11b04e39bfc7cd8 ]

A couple of new Dell laptops are shipping using the sidecar amp
configuration. Add the required kernel quirk to enable.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260716144209.2411523-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index ba53b67530e5a..b1e40784e7f96 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -687,6 +687,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 };
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
+	SND_PCI_QUIRK(0x1028, 0x0e53, "Dell XPS WCL", SOC_SDW_SIDECAR_AMPS),
+	SND_PCI_QUIRK(0x1028, 0x0e54, "Dell XPS PTL", SOC_SDW_SIDECAR_AMPS),
 	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1f43, "ASUS Zenbook S16", SOC_SDW_CODEC_MIC),
 	{}
-- 
2.53.0



