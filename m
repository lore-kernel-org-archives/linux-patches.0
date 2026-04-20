Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2EF3ACA5E;
	Mon, 20 Apr 2026 13:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690989; cv=none; b=IqKQmD/4ef4/qH3wooB6IeS7xqYqw51rEA16lzKRIQs1Vq0G02nmOQFWTBrF5/znVFgUiIOqF/e51MiGC+zSK4FzZMCV6t03fPulC1dyuZt+Dpq17qJeBhUc/nrhOTcNemRZ22U5+P7cOH7j0iHi0ozU0OitSk8QFp4xKSv5+Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690989; c=relaxed/simple;
	bh=vkzzGTOHKrKoWmi+13q+XryH3dbacgI5j5+9eSrxdeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRidvSPebzmTJ3QaCoj+NkF5rv345+iSWT29039YjFew/bj0T7Ha4J8sesjf9PNAzBhpoafVRs5Pl9YpMBqOMCmYRFxAXBpDM1XzuFTgQKqarZjk0XOliG6lJY+4sBb32fUv+EIK4C0axo0Wqme+8GJTPWsWe1U171bar50Jb/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mfus0JA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mfus0JA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E33C2BCF5;
	Mon, 20 Apr 2026 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690989;
	bh=vkzzGTOHKrKoWmi+13q+XryH3dbacgI5j5+9eSrxdeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mfus0JA9DddmFVgQSXSzAz5Ai1oY8kzEo2ObQ1tDlUgRyrGkoJ/7JOzzHKMV9ZLxO
	 VNe5Jgj6GdnMemShZNlfl5XCwmT/KrxoDSaZ3dVnXY1CBabMt5pbbQ2mS94XuNin8E
	 CqMqffQBQohbrr3syCVjHEWHNKwuHplysiNcjRFNnzk/KS+VTn4BQWJt0RJ+bSCD4s
	 jjR8aOtMGlbt4Iy9d1COp98gBz1G97CI+ZA0l6PPvefd09nRD7Hin71Mev0wqqvI3j
	 6U6FS3lrIUeRI9SqPQLXsXLnZA4/zA7thmgO3njWDFdtdoVQhnNH8L6h/lHa+1QB3u
	 KWukfP0xsc+vw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Gilson=20Marquato=20J=C3=BAnior?= <gilsonmandalogo@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: amd: yc: Add DMI entry for HP Laptop 15-fc0xxx
Date: Mon, 20 Apr 2026 09:08:15 -0400
Message-ID: <20260420131539.986432-29-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>

[ Upstream commit 8ec017cf31299c4b6287ebe27afe81c986aeef88 ]

The HP Laptop 15-fc0xxx (subsystem ID 0x103c8dc9) has an internal
DMIC connected to the AMD ACP6x audio coprocessor. Add a DMI quirk
entry so the internal microphone is properly detected on this model.

Tested on HP Laptop 15-fc0237ns with Fedora 43 (kernel 6.19.9).

Signed-off-by: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>
Link: https://patch.msgid.link/20260330-hp-15-fc0xxx-dmic-v2-v1-1-6dd6f53a1917@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 6f1c105ca77e3..4c0acdad13ea1 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,13 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15-fc0xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

