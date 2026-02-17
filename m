Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC747A13A;
	Tue, 17 Feb 2026 20:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361253; cv=none; b=NZXnAj2xn060zF6yVi1aAanvYTmtNmeH+nkIwkifmHMzhQpmZlzKyp08dFOlXFdZ+moFlS2oXg1xJVv2oFGP0rxsCaI6mt6MlqKlT5iIABhvY3mw6isqWKRIX9i+VBLhhzYQVp5rUduf/kR65wVHvBZoLxgMZVo/V6FRRsiZmLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361253; c=relaxed/simple;
	bh=X58tokUHQiamljwo5OfrGKfsZkHLLd3aAaxIJ3pgi+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYD0khQWNqTUQA/0Yi4Wrgt3xqL1ppj//zVHHvKnz6hpIJyDOg3Ppi3LgLDlLgVNc8TNlcXDJRO/1+tYtt3JGa4iDOPKClzcYAUxyTUpwpMd7AUhoiM7WBcaT3KSh0VfTBwZKCXti5WzgK+vPX1a+r63uzQEcw//dHiKOoQV5ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBXvWSJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBXvWSJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D66C4CEF7;
	Tue, 17 Feb 2026 20:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361253;
	bh=X58tokUHQiamljwo5OfrGKfsZkHLLd3aAaxIJ3pgi+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBXvWSJIApC1lQ50ZYE8UtcKKOklJo+FLYkSXvzftSOf1QJPRIc6pY8XsPBZD3Msc
	 XpMkEjLIBRk+vJlNEkG5dtJHgC9UK2r8csvshWhl08Rb5A5FvFZaDJK8i+9ndXNM6n
	 SgSEBTVyQun0YlozjTUS6OPQiv9i46s4rD8Coi9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anatolii Shirykalov <pipocavsobake@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/64] ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list
Date: Tue, 17 Feb 2026 21:31:25 +0100
Message-ID: <20260217200008.611813650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolii Shirykalov <pipocavsobake@gmail.com>

[ Upstream commit 018b211b1d321a52ed8d8de74ce83ce52a2e1224 ]

Add ASUS ExpertBook PM1503CDA to the DMI quirks table to enable
internal DMIC support via the ACP6x machine driver.

Signed-off-by: Anatolii Shirykalov <pipocavsobake@gmail.com>
Link: https://patch.msgid.link/20260119145618.3171435-1-pipocavsobake@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 6bbbcf77fc525..43f7f64015b25 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -451,6 +451,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK PM1503CDA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



