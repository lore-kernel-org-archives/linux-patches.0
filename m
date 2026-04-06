Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003EC330B29;
	Mon,  6 Apr 2026 11:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473557; cv=none; b=dNFJYg7FTjRT+RRKsMcTgurFA15sD3M4idS4H1njPWcy8MzT9LzdKP335j1+KDFpbileyn57LanSGs9BLqrwggyX5kvDiaWYoYkCuUS4o1dvhtoe4DePwsCijWOlOtR5WbBLX74sYnM5ol04jZJ9HwlqrhB/Egy4QXT1a4IyWxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473557; c=relaxed/simple;
	bh=pbOWswPWb8cGO+6o/yWtkJeLzE1vClqYdZRyjya3/Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOp6hco75ffyV1DaFo4mU6PYrWr+XKcaAFsHeU417mohj+Ji/CLf652bWxEraXoxP4Rk6clQKPkXC2ZgQv73PnHak2DtBrdyD/LaKgyidKiq+P775wOMLh0gDlumdMD9CZnoEA/OUJIUN0H2lEGEnu7ONzNIh8dSqZA5+J0mYYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8VHKlDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8VHKlDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D741AC19425;
	Mon,  6 Apr 2026 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473556;
	bh=pbOWswPWb8cGO+6o/yWtkJeLzE1vClqYdZRyjya3/Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8VHKlDU/5VWV/4WIG5ZIFeE48814XVc7zbRA9/9NXsg7f6smXcgHswQAKRaboSv0
	 Nilm4VmPHtK5a9EhV5z45B/yDX0tNyOf+B8qBYWciNPgVYcMYV4dUnliKWupeZUrC5
	 +sos4TyIt4I/Us0Sn+5+vdO7h43UutuH3x4tsTxc/OvSDUIdqIyP4yHB15Oux4H0MG
	 6XftkxIc8+A3lQ7yb2/3MxoUT9MbtjjnbScSZzyxmPsTYDtzHTheCfLkxFeIXsendH
	 f1TtWElUJOgTGtRmKhOzzXukBvUNsyo3mQyCouLNozbAvovPB0dd+qA1JXw2Xu6rOr
	 9quS0HD+mlkIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ALSA: hda/realtek: add quirk for Framework F111:000F
Date: Mon,  6 Apr 2026 07:05:36 -0400
Message-ID: <20260406110553.3783076-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Dustin L. Howett" <dustin@howett.net>

[ Upstream commit bac1e57adf08c9ee33e95fb09cd032f330294e70 ]

Similar to commit 7b509910b3ad ("ALSA hda/realtek: Add quirk for
Framework F111:000C") and previous quirks for Framework systems with
Realtek codecs.

000F is another new platform with an ALC285 which needs the same quirk.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Link: https://patch.msgid.link/20260327-framework-alsa-000f-v1-1-74013aba1c00@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The referenced commit exists and is identical in nature — a single-line
quirk addition for a different Framework platform.

## PHASE 4: MAILING LIST (abbreviated — textbook quirk)

This is a standard one-line quirk addition accepted by the ALSA
maintainer (Takashi Iwai). No controversy expected.

## PHASE 5: CODE SEMANTIC ANALYSIS

The quirk `ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE` is already
defined and used by five other Framework entries. This just adds the
same quirk for one more device ID. No new code paths.

## PHASE 6: STABLE TREE ANALYSIS

The Framework quirk entries have been present since various stable
releases. The `ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE` fixup is
well-established. The file path has changed recently (moved from
`sound/pci/hda/` to `sound/hda/codecs/realtek/`), which may require
minor path adjustment in older stable trees, but the code itself is a
trivial table entry addition.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: ALSA/HDA (audio) — IMPORTANT, affects laptop users
- Accepted by Takashi Iwai (ALSA maintainer) — authoritative

## PHASE 8: IMPACT AND RISK ASSESSMENT

- **Affected users:** Framework Laptop owners with platform ID
  0xf111:0x000f
- **Without fix:** Headphone/microphone jack detection doesn't work
  properly (mic no presence detection)
- **Fix quality:** 1 line, identical pattern to 5 existing entries, zero
  regression risk
- **Benefit:** HIGH — makes audio jack work on a specific laptop
- **Risk:** NEAR-ZERO — only triggers on matching PCI subsystem ID

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Textbook hardware quirk addition (explicit exception category)
- Single line, identical pattern to existing entries
- Accepted by subsystem maintainer
- Fixes real hardware for Framework laptop users
- Zero regression risk

**Evidence AGAINST:** None.

**Stable rules checklist:**
1. Obviously correct? YES — identical to adjacent entries
2. Fixes real bug? YES — audio jack not working
3. Important? YES for affected hardware users
4. Small/contained? YES — 1 line
5. No new features? Correct — no new features
6. Applies to stable? YES — trivial addition

**Exception category:** Hardware quirk/workaround — automatic YES.

## Verification:
- [Phase 1] Subject: "add quirk" — hardware quirk addition for Framework
  laptop
- [Phase 2] Diff: +1 line in quirk table, identical pattern to 5
  existing Framework entries
- [Phase 3] `git show 7b509910b3ad6`: confirmed referenced commit
  exists, identical nature (Framework F111:000C)
- [Phase 3] `git log --grep="Framework"`: confirmed history of Framework
  quirk additions to this file
- [Phase 7] Signed-off-by Takashi Iwai confirms maintainer acceptance
- [Phase 8] Risk: near-zero (only affects matching PCI subsystem ID
  0xf111:0x000f)

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 9a00e1d324cef..19f23c92fdcdb 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7725,6 +7725,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.53.0

