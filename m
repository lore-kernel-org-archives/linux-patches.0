Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FDE2C327B;
	Tue, 15 Jul 2025 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585714; cv=none; b=Jsn5qzjqovaL/OAQbS+xEM0NKK5DOlRBavA+/CKGupa81pqqTGklFgTbG1JZvl5PEfL5aUMYgY/ebvMSC2Z8R1eYJ+mcQ2IRHuZmd4hwo1EVjCX1dahSD5XaTNeNQCaUMG9ZwuNczV4F6UcI+fPHhrY5eEv+ls+B2olmMUSZL0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585714; c=relaxed/simple;
	bh=JNQIOTpAbKI1hKo5u5uf3tYolwTTNxKX0S7k2GDrVYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTTPpQnV/ihbTu91O9fgQcAV3PJyX0P0PdQdEyugCCP9Npfg/F+moDh/ZOBLy9NYub+TNUfoX81s6jC/OSmFHEok7GBU1JrASryOf3thc/+XaRPpsfVUBrtLaVIRnMTT2jb+Ni1h/gEuxsIV1zgDknUfVUW1i3U07LrQ/273Kcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDutsMLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDutsMLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447A6C4CEE3;
	Tue, 15 Jul 2025 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585714;
	bh=JNQIOTpAbKI1hKo5u5uf3tYolwTTNxKX0S7k2GDrVYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDutsMLxvWGkTSxAIEcozciZ6n8IRwM+nIq7C1dX6lLIIxAw2QUbpVSuNgzkveJ1+
	 G96/gkslyd9NISp34xZulg9AdtMFI0DCO+f19e1sEMHUzsgZYMRLPzJ53DFKRBUb7k
	 Vri3i+bLE7xRWnySudYvGtmVuQSBRECYmXyJBH3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuzuru <yuzuru_10@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/163] ASoC: amd: yc: add quirk for Acer Nitro ANV15-41 internal mic
Date: Tue, 15 Jul 2025 15:13:32 +0200
Message-ID: <20250715130814.610645391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuzuru10 <yuzuru_10@proton.me>

[ Upstream commit 7186b81807b4a08f8bf834b6bdc72d6ed8ba1587 ]

This patch adds DMI-based quirk for the Acer Nitro ANV15-41,
allowing the internal microphone to be detected correctly on
machines with "RB" as board vendor.

Signed-off-by: Yuzuru <yuzuru_10@proton.me>
Link: https://patch.msgid.link/20250622225754.20856-1-yuzuru_10@proton.me
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 723cb7bc12851..1689b6b22598e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -346,6 +346,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



