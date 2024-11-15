Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D724EAD0;
	Fri, 15 Nov 2024 06:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653283; cv=none; b=GS35kwiP6gE41OG+YtogCzdCgypMa2OmpVh+QqZUOX3BR8Lz9w1cw2Q45OWZYW91nbqn2PUFUyKtilTADKFaaByKQ8cmDaJipCYMMnuPLfYiiJvybva2eHMA5oB0MZkS8quiFtwayRarCwgZKWBS2rgmzWk92BTn3n/O569KzqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653283; c=relaxed/simple;
	bh=NttNPvl/1IFMLLU+2Q3od8ajasXWQjmtRTCXwJdcRks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeFyEVNoNtcYIDMNSYMzzdawizBD0yNL/QfmmzlpP056iBNVXYwgkkHTOSvzNksUjdih9JaoW3MlqGrEhURoHECaZQ6j47PkgrGHkvh+Lhi8de9dX9j6o6B8OJDKmgXivMxbP+RsAv9MX4CPD3tXIbuuiIzQWafygmGbdB2rR5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktA9xMNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktA9xMNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F2DC4CECF;
	Fri, 15 Nov 2024 06:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653283;
	bh=NttNPvl/1IFMLLU+2Q3od8ajasXWQjmtRTCXwJdcRks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktA9xMNm8Dfo2QdMhogYzs9kTP7zKPV427uAL2a2XNhnqRdpGHUTaS5OAml//kvHm
	 gy1kYpblE5gPyWmGlugKQtoCx4yefeWfuwbm8d2WT6T3wEgwqOwue0B5KyrmV3u2PJ
	 HIXbAT3WRT+thLHsuing4OCmoFUZrMXJXYbGWjRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dudikov <ilyadud@mail.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 41/63] ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA
Date: Fri, 15 Nov 2024 07:38:04 +0100
Message-ID: <20241115063727.398364986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dudikov <ilyadud@mail.ru>

[ Upstream commit b0867999e3282378a0b26a7ad200233044d31eca ]

ASUS Vivobook E1404FA needs a quirks-table entry for the internal microphone to function properly.

Signed-off-by: Ilya Dudikov <ilyadud@mail.ru>
Link: https://patch.msgid.link/20241016034038.13481-1-ilyadud25@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 275faf25e5a76..dc476bfb6da40 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -325,6 +325,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E1404FA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



