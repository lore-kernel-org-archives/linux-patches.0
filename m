Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B96E4AFE0A;
	Mon, 31 Aug 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184196; cv=none; b=FV0oD08/VBOBRkj761ypCV1TehsjzuQ+kvB7Bq2wKLBK9nHx2ZCeitkO0wucBkDxXhwjs2YNwL3cVZoN1c6jrPt/HRcCoDnBli06n4obOvXQDJ+wvN5/QLu8nzK5r8DxF8Xh5FJSqFNuxLA5dlS1MdwFjIDfSqQOlXf0Huvuo40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184196; c=relaxed/simple;
	bh=VfD2j09VBdUggyDgSW+tvq1ZH/tor69TIHtAsu9Tb5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKXSfVDckgQY+0RjO31Ev4+Jhri5BPq30wiwXdmHqPVe2buOH4lJDHXsNjhmkOWqbyUZSjV5RtPtHopmH1Hr95uZVPI3HMrYM89I/rpacqTyQnZw4OfLCLuZnqVRAVaRIwoMhXfGvKK3ZE8Nm66DlC/7klcvBfMy28ywbx3yJtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJ1XeJ6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJ1XeJ6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2DE1F00ACF;
	Mon, 31 Aug 2026 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184193;
	bh=6CemtUV7yB0zcOm7thyvZQUiw7tI1NgtEP+EAwldGW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJ1XeJ6Bfqdu4kaqtEYP8ZW96fO79oYXp7/NZBZHKqhJMmipt249u/HpB8TWp4jpn
	 g0smBy3YFYsZxEHZJWVrTGJDm1UVnIskq0FwVG4duYpghYeLb2Yiso5lCdqawTbHzU
	 1ulC/RIKh9DPq/GhqTuheWr7nYr6ESua0w34WRhHxKTP1Jmb8e/kqb5UVvoDkCHsVA
	 MyQBRPHPde1QWgCQ3bK28hCMwcID1/g9lEevSdnJWsiHZasKgYldjnGWcNBmw6+V6Q
	 2uBs2ueOUakHcCI7uUlhhQHsyG3HD5wVRQgxRQUSl/yC6RIqpA3/jhq8GAYPVVxBkB
	 7YKVrZZFT//9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	CuerdOS Dev Team <cuerdoslinux@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ASoC: amd: yc: Add DMI quirk for HP Victus Laptop 16-e1xxx
Date: Mon, 31 Aug 2026 09:29:35 -0400
Message-ID: <20260831133314.4125787-547-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 38417f5fc8e3323218c19bd7e419eec4fb0697bd ]

Add DMI quirk to enable ACP6x sound card for HP Victus by HP Laptop
16-e1xxx, which fixes microphone not working issue.

Without this quirk, the DMIC on acp6x device is not properly enabled,
causing the microphone to not work.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218926
Link: https://github.com/CuerdOS/linux-kernel-nhs/commit/b29ba27a0ed672664071b4b345e63b62a419d31d
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Reported-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Signed-off-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Link: https://patch.msgid.link/20260730123920.104525-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished and match the earlier analysis:

- **Mainline commit:** `38417f5fc8e33` — "Add DMI quirk for HP Victus
  Laptop 16-e1xxx"
- **Not in 6.18.y:** that commit is on `master` only
  (`stable/linux-6.18.y..master`)
- **Partial coverage in stable:** `205efd4619b86` already quirked board
  name `8A22` for Victus 16-e1xxx; the new patch adds a
  `DMI_PRODUCT_NAME` match for variants that don't hit existing entries

The backport recommendation stands: **YES** for Linux 6.18.44.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d657287ccf43e..636b211856e7d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -675,6 +675,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Laptop 16-e1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

