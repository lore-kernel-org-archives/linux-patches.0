Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D52324036B;
	Thu, 12 Dec 2024 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021382; cv=none; b=Z03+12rAWkCwpFmjKpR1UdML1KITrCIXxwjG0M4OEF5y7WSwxNru0btCvVE8uFcNZrLquTOojgrdS40FXSQskKoJYJn1YEEteYjXNLCEeCTfozOC3WRRtyAWd9yrQmUZ7MNxtgOOTD37T4bCSNyIS1JmkiKCiRktBQZ40iNr+LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021382; c=relaxed/simple;
	bh=aVVQRb+iDj3LXzoKSX0UZvDH4AtP03OxELowBUjV9Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ylmedl8JdBO3MsQuRO1v8noHKpsTbIiRVJgW+cVpKR6jpbT/k5HXIaAMPmSdhksoj90ysjMZtEgECWxwEvzVddkC9v0GfPdjIO1zcg+YQ2rEtGekh05vxC5WDNmD0ZIHNBip9VwWStyuX0iVXkIz4ZE9Wn6b6NJlSNlzPE7lIR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adng9LL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adng9LL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847AFC4CEE0;
	Thu, 12 Dec 2024 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021382;
	bh=aVVQRb+iDj3LXzoKSX0UZvDH4AtP03OxELowBUjV9Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Adng9LL2bb432276mdO1W4hQI7nX1GCfBzn6i8CL253wOO3Odgy+lhASeQVty4KOE
	 zLF55OkkQfmUUU1Dwk+zw8BNG1zbDTaG+Bp3Pjd3R6pvXZrtRln75Epfx+MTQieqis
	 o+gaQmaT0CWtNQnklmgJ+RYgoGgUH7rSHg/Q4Pag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tova <blueaddagio@laposte.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 723/772] ASoC: amd: yc: Add quirk for microphone on Lenovo Thinkpad T14s Gen 6 21M1CTO1WW
Date: Thu, 12 Dec 2024 16:01:08 +0100
Message-ID: <20241212144419.766629436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <ukleinek@debian.org>

[ Upstream commit cbc86dd0a4fe9f8c41075328c2e740b68419d639 ]

Add a quirk for Tova's Lenovo Thinkpad T14s with product name 21M1.

Suggested-by: Tova <blueaddagio@laposte.net>
Link: https://bugs.debian.org/1087673
Signed-off-by: Uwe Kleine-König <ukleinek@debian.org>
Link: https://patch.msgid.link/20241122075606.213132-2-ukleinek@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f38f882fd55ec..af9601bea275e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M1"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



