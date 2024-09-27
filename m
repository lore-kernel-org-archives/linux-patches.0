Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F296918BC1C;
	Fri, 27 Sep 2024 12:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440098; cv=none; b=Ak4MsZei4SGx0kmMUvV9oZNurTmnPguEFar++GbRRYN5POTb7PDhaRUtQSkttf31SBwiSDYwUX81sW82gx3E2zp+3/dXFzM5MeBQJWm+KYQ11uk1pAwt92dWQQg2Np505w3GucxwIBf232tTKlz+onKrTEF+QA3IG0D/j2vwTv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440098; c=relaxed/simple;
	bh=81a0nQbgGIW3kofSpfmw5IS5Ah/FeCj+v0Yr52zoTZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1qt44jdh15wDBek4khBJhzeey1kGvek+Oc98EdVrjUtWVV0suFa5Lh4Dbx/jixyBh8381xmfNy8sSXzF2eKgadZiBszIQPGvsDQgj81GDjYX0krnzYYEJBsGwdaK9rv2PU+EdsSI5RHPJxRrZ9mNNtbGiRFgqtP8BFhZ6ku+uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUHwkfhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUHwkfhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E47C4CECD;
	Fri, 27 Sep 2024 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440097;
	bh=81a0nQbgGIW3kofSpfmw5IS5Ah/FeCj+v0Yr52zoTZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUHwkfheHv4VclBJF1FTpDPa4ONuSwZDwI3syD+bS9kfqc/VsXdtHLLtGXOZZM0qh
	 kOpUR+r2kGfN3hgXk/QiVdbZ3BS72NmvLqLooNAYt5ylLnc9hoc9QrLWuSmfudSxOV
	 zPb4e8Qm6ghkqNUlA2se5aHh1Ba5nDsJ9dOL5Bjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markuss Broks <markuss.broks@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 32/58] ASoC: amd: yc: Add a quirk for MSI Bravo 17 (D7VEK)
Date: Fri, 27 Sep 2024 14:23:34 +0200
Message-ID: <20240927121720.093333772@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markuss Broks <markuss.broks@gmail.com>

[ Upstream commit 283844c35529300c8e10f7a263e35e3c5d3580ac ]

MSI Bravo 17 (D7VEK), like other laptops from the family,
has broken ACPI tables and needs a quirk for internal mic
to work.

Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
Link: https://patch.msgid.link/20240829130313.338508-1-markuss.broks@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f6c1dbd0ebcf5..248e3bcbf386b 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -353,6 +353,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7VF"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VEK"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



