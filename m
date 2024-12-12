Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22668205ACF;
	Thu, 12 Dec 2024 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017239; cv=none; b=d4vrY9G5Btmxyew3Y55Gg5RysW5bwnUEnNkNg6lg4wTOlIc+qAsaIyGlg12O+cZihYgY4GuFT7OyGxLe/OaP8Z1AKjsONuTndKLbmpTv3iTJBOS1i2wpI0DwePjw9guU6Iy2N5ajMwwJ5J1sb/++BzcSelE8+cfftaMGLSNMmPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017239; c=relaxed/simple;
	bh=AcnDeEGrz6Uk1rCbPmVtM71q0CDmWsYMQ+QyoYlh01k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d26YbfJmSy4MfoIcD8bjAONjeGXEkncNeVnucTrcYIG8TR/JKeyCUFEG08MoLsEj6kaVBGam2m4d6ObzxBwJ1aAbKq57+sLFl2tGaUe5QDFhhM6mbMTp0g48vByOuH2gbJ5D6Md4sRZkouOtQ6BsYr/9OkCV95Zhjh5fioSYGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgGMJmOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgGMJmOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6485BC4CECE;
	Thu, 12 Dec 2024 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017239;
	bh=AcnDeEGrz6Uk1rCbPmVtM71q0CDmWsYMQ+QyoYlh01k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgGMJmOsefCE5ysZEGRchmsEkaW1fADkHdYRoyOj8dfWvmyzwOUq1b0hjehNeRC3e
	 jKig/u2tAM9y4i/DyA1/bUSY4eBUwMyQIx3fXREDh2IihX2HQY1F51c1q+S6Xcehhc
	 bI1rAfKfpULC/FgkwbY1AdsAktlMKJgUrEcgfqPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tova <blueaddagio@laposte.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 420/466] ASoC: amd: yc: Add quirk for microphone on Lenovo Thinkpad T14s Gen 6 21M1CTO1WW
Date: Thu, 12 Dec 2024 15:59:49 +0100
Message-ID: <20241212144323.348518905@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 37820753ab09c..e38c5885dadfb 100644
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



