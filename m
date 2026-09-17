Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148044F96B6;
	Thu, 17 Sep 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664785; cv=none; b=gwDrNWztM9CKCBvqxakvn4AqjRUPelZvOqDE19Nh/f+wwzHpnu8H4n/s43Gc+I/MJ/9VyC8kztznzNJdAQ4O0FNZ21PWrdzD+DxlqHDeZlhmQf3ugiXGFClUxRw5BAeA6Byc5XmJnDbdLZj9gPQkMKt4OKsTlgeWUJiuDj9IA68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664785; c=relaxed/simple;
	bh=ZKL13A4hyLzZ5A+kir4Rb5X45gsNLI8zi/12RjVOxsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUoM9OAKsok8i5813UvBg9NTYkGzdDnMQnviJnvuplFuj0NYRnoap+VzlXQJ/BtoTulyyXViX5b2Hd8H4OmDWM5WLXZ2PNbby2kH1kNsqS0mQhUJAbwA7+9+OtydxhL5NZADKfPZa8kCtrHSBUyOAGb7T2wiV+CqxVv15e04qgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1SbBdw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1SbBdw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FD1F000FF;
	Thu, 17 Sep 2026 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664783;
	bh=h+2DWpdDxPFwGO13hDCT9GgT7RxmmYrty48QSEa827g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1SbBdw8NO1LFwCf+nTA4//VaYx3WxdMAcRGKWTLezmtgXXIoK4S5dH7zvQ0cRSUo
	 /6sHJACEhk3vCYR59FygHmZL0N8tvO8FUzLRYBkghIuDtt45UUH3tmZ2YnZg2rZGFe
	 LDgio/2BHA6N9ipY4Nkj9w9Uht5DzXnME+Rnmb/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jetha Chan <jethachan@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0488/1250] ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table
Date: Thu, 17 Sep 2026 16:04:43 +0100
Message-ID: <20260917151605.196110630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jetha Chan <jethachan@gmail.com>

[ Upstream commit e782d687d2f5bf8b8113dc48ba22cca4b472c252 ]

The Alienware m15 R7 AMD exposes an ACP6x DMIC path, but its DMI
product name is not present in the Yellow Carp ACP quirk table. As a
result, the ACP machine driver does not enable the DMIC card on this
system.

Add the DMI product name for this machine. With this quirk applied, the
kernel reports:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI

and ALSA exposes the ACP DMIC capture device:

  card 3: acp6x
  device 0: DMIC capture dmic-hifi-0

Tested on an Alienware m15 R7 AMD with product SKU 0B59.

Link: https://jethachan.net/dev/2026/03/21/fixing-internal-microphone-alienware-linux.html
Assisted-by: OpenAI-Codex:gpt-5.5
Signed-off-by: Jetha Chan <jethachan@gmail.com>
Link: https://patch.msgid.link/20260630003328.15675-1-jethachan@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index df845260f5701..03735eec3af0f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -500,6 +500,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15 R7 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



