Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72C47CC61;
	Mon, 20 Apr 2026 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691858; cv=none; b=VxTeJx33UOehfzKw+zNxFwyu5mFz0Cwm6IRGfZBhobUW/vhmdZlMM58ZABAShElCVFv9Ssni1V1FBL/cUCdjRjIxLjXc6qFc2UQSYJxLIErtOUejuySzR/lOMzetXasxtuFs0jV3VRdnpo1PaYbMCaiVsOUCf1/N7dAU8PQfISE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691858; c=relaxed/simple;
	bh=nXEAcfBDRWsMsIw80u/osjD2Kn/qrXgp57FbxQ/qnSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGt/n38gxg2rl5KisM1E8Zql4j19+r90XvETUzFR0kNaHN0k0tvL6DPj6FPwB+YZ+2v6m8jmvRfYymQ+MiI3wk9VuHQaOaGwhGkhlrgGW5YG2D9vtckvwi1xtDq85t7lMkpyRbx4AhteJFf4+SyNu0k3ksYM3yjWGn+EmlQvJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/GVXn8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/GVXn8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD78C19425;
	Mon, 20 Apr 2026 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691858;
	bh=nXEAcfBDRWsMsIw80u/osjD2Kn/qrXgp57FbxQ/qnSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/GVXn8k7DnebaDBFGzRirnlGhHq9p9BanuTwGIuC0aIyIkh6kyjy2ZRhVjHZSLxE
	 6IVLZFPNjDD9erkdgG0Z/G4eKYlCbknTgWA0toc6Y1ZtbeU8+9hQUBJEAFustQsZk9
	 V0xaM1ruNcs0LyKRlRd9A+Zx5igendh8eYIxZcViFnhBCuvbA9lQ8b8xOE2tws2jHR
	 wBHbCtbIxQfLFW6bcmoQlc0iyUZZCJ6s3AzLMJg1iL6T731GwVGn/hGCiaygRrVQYo
	 PFWPXN8P1iQC7LlDlVPt775LmtMXsnX1fSMd7oKKoyArqNiej6c+SBv8Xt0LMzPMqS
	 PVpN5A4TLl2/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Throw <zakkabj@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add quirk for Samsung Book2 Pro 360 (NP950QED)
Date: Mon, 20 Apr 2026 09:20:29 -0400
Message-ID: <20260420132314.1023554-235-sashal@kernel.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ea31be8a2c8c99eac198f3b7f2dc770111f2b182 ]

There is another Book2 Pro model (NP950QED) that seems equipped with
the same speaker module as the non-360 model, which requires
ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS quirk.

Reported-by: Throw <zakkabj@gmail.com>
Link: https://patch.msgid.link/20260330162249.147665-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e7f7b148b40e5..c76d339009a9b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7211,6 +7211,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc188, "Samsung Galaxy Book Flex (NT950QCT-A38A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Book Flex (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1ac, "Samsung Galaxy Book2 Pro 360 (NP950QED)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.53.0

