Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128BE423A7F;
	Mon, 20 Apr 2026 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691669; cv=none; b=kIrfD9DNK83bfDGRxe40+KsBkNL9T30Mn1LWuhFP2aegjwVflYHWeYhsa1dCYJdpZZUdEaTvNjEhQISZMikb7EdxVopCTNdRRtdyxidRBPGRRQ9xbh/ErYj6HGdIC/g5aSdjEjJxiNGlsSgFuZjRZ9sGAfO/979tfPQBcioD+3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691669; c=relaxed/simple;
	bh=CbbPeTaf1gFXC/ygo7w5u0I8jQX2hUGzqfIlREQtQcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+g04DcZt2fBGZENgLiP1WxHUX6BEkxCEkpuPdcDMMQHX4xPO1l9pMhT7SinH2Dc99cc7nGGT/w1tYn+caGtEoJFSdY/8Z1fnl5uTN5TWxixDDx9z4YmQsXBI2Zzse0OatK20ZlAcQ48pZdb+yuwNjNAOhW9r5HL15dXoSF4zHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnbROm0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnbROm0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EAFC19425;
	Mon, 20 Apr 2026 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691669;
	bh=CbbPeTaf1gFXC/ygo7w5u0I8jQX2hUGzqfIlREQtQcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnbROm0XOr/xY0Ea2Ag7Jd+1Eq8GfIpaWfWL00RUDJmnlrhG9nMnC+56Vr0AbinVg
	 i2bS5Cf0ZAz1crxZpVwrnknim6zw4e9lg4pltQBuGUxlKOiVtykpmls5ZodPcWIxPz
	 o8M0XB4JVnLj7Ct0y4A4IaH61f2tTdDneIu0x66G56AKEvl8HNjcBMD/OONLJht2h0
	 U2lCB8vlIf+6o8JqhXsZ0ZAIWCmlCfoohg4Wq8mMD/A/YDCJyPVNvduOo8OKdvYLOE
	 g9FzDvLSRN8H9KNE5kVGaNeVVJ3uH8acS3yqXCNTzCDt92f+cvNOn5GEVG5XgFjsUA
	 GCjZy+Ai1Y30w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vee Satayamas <vsatayamas@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA
Date: Mon, 20 Apr 2026 09:19:17 -0400
Message-ID: <20260420132314.1023554-163-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Vee Satayamas <vsatayamas@gmail.com>

[ Upstream commit f200b2f9a810c440c6750b56fc647b73337749a1 ]

Add a DMI quirk for the Asus Expertbook BM1403CDA to resolve the issue of the
internal microphone not being detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221236
Signed-off-by: Vee Satayamas <vsatayamas@gmail.com>
Reviewed-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260315142511.66029-2-vsatayamas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1324543b42d72..c536de1bb94ad 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -717,6 +717,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0

