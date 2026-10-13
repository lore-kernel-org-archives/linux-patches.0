Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BBC4EBAD7;
	Tue, 13 Oct 2026 12:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892849; cv=none; b=W6bEs4+NYhvi9qMoQcTWAPjqtW7XllehHRQFdWdju86hGeEKmgavJ0om1JblE/ruIzkchVeudmVQzLDqfv75K4/DHd4DgM9Yvks4/K6Pv86gUnNiMlzps1sXRcXkLQ1hfmCM9Z2ZBu00kvzSBWaZ0eM0tNVX2Ok/6Duw8NIyt6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892849; c=relaxed/simple;
	bh=KPTtQplvNOHCgoxGjtpH8jyJc5W2Lzn3/rpeZCIKoJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxPM6npUIuDtU+JPITT6onMSFMcgKnEfaoiAt4LcHypeebGnv7vzTdYLqrWYiniHmxfbmUDI95h3iXkG34nSxpFBjzyJVQivTA/LR8Rl72F0g9nHiNq1dHFwnKAsduQvH+5MEOBAlvNqsx5r1pi2kZGEgYSJXl8e8FUNUvV0bNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px7orDRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px7orDRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A74D1F000FF;
	Tue, 13 Oct 2026 12:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892848;
	bh=Xoqg+TZTwaM07j821/lSODN0vDXYHy9CdllcviyMCDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=px7orDRUnHxLkMs+GcABfLi2ldMXy7pLiYra16pyLwIuEAop11WuP+VQD99QwWy7J
	 8JQvklI8xl6XTEtUBuKhjbWXv0hlfylyekaa3R5vS/gjeL4gujOpqkk3uXqoqvSTsx
	 t+A+yhzDklV8pM4oklIl5mUu6LYmhO7TftRV0MDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Garland <minimelkav@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 029/621] ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)
Date: Tue, 13 Oct 2026 13:30:24 +0200
Message-ID: <20261013112921.557352529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Michael Garland <minimelkav@gmail.com>

commit d0cb7a7b2a490c381ad97f53155d02a748b60dea upstream.

The Acer Aspire Go 15 (AG15-21P, board MDC Herbag2_MDU) has two PDM
DMICs connected to the ACP. The BIOS does not set the AcpDmicConnected
_DSD property, so the acp6x machine driver never registers the DMIC
card. The existing Herbag_MDU entry does not match this board name, so
add a DMI quirk for it.

Tested on BIOS V1.11: the acp6x DMIC capture device is registered and
records audio on both channels.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Garland <minimelkav@gmail.com>
Link: https://patch.msgid.link/20261005-acp6x-herbag2-quirk-v1-1-a1f2683d758f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -706,6 +706,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MDC"),
+			DMI_MATCH(DMI_BOARD_NAME, "Herbag2_MDU"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
 		}


