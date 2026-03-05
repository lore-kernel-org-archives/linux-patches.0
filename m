Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702BB3CA486;
	Thu,  5 Mar 2026 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725036; cv=none; b=tHysndD2RmMv57XGJdsxlDdK9Rt5HnTJG+Z7yU+/KqpfhOc0VvbwHgFtal9E+iSLYFKZNncTo5OGG9zdJu6VAg+WVrHO7s3qqpQg8ze1QwzvU3Gk3BeOLqayR1etrCXidpWP0IhTmirzzgVAu3xRa0uXC5JZ+lxyPXjtLLFS8mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725036; c=relaxed/simple;
	bh=BqbKEO0ra3UtYdhYFSHXRy4hyOD4ATuuxuw62fu7vx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ti2axHrFDxRjdzmvnICheQMBXsFr15zQBk+m1IIBMGuJhzu4PMZJn2b4B1xo4BkUXAqEMM39ttbYeuCV+uTBug5/QCvEez3su+FJsvwLiM30m3Bx9xvPdWbOhllDHFNmEgAKsdAep5B00KBNJv1wFcxBeBVFMHMhO3/dGFRaQOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpSev9bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpSev9bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA5CC19423;
	Thu,  5 Mar 2026 15:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725036;
	bh=BqbKEO0ra3UtYdhYFSHXRy4hyOD4ATuuxuw62fu7vx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpSev9bzTkUD1ZC9Es6nFzm6hfX++RZqxbT6sMpNnmyXzJfP0j/v3IimUs62QbrBa
	 H14FFsn+rba1VFZ6goSmKUBYEqdEEh34VbO4R4Iep++qXYpwO5Mp0Ob8kJ1bxD+5zD
	 fNtX03qXvRghH2vYjS3wONmKUS3wEK5AbeoW2Wq6I6hvfV3PNcWpOS3F511Mwdyv6v
	 DEb38mvQ357O14bx+tVUUQZP/gqpMi56HYGZU5dA4zs4h+TacAZ/6p4xEfpeHmNgTs
	 Kno5VD2zTmk5lfPk1OZXEllIrEqR8SW/jMYJSQx8D8DrjC5mPZsxQP00lDZNIjWFwp
	 vPkmm1s4n0ucw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] ASoC: cs42l43: Report insert for exotic peripherals
Date: Thu,  5 Mar 2026 10:36:50 -0500
Message-ID: <20260305153704.106918-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 6510e1324bcdc8caf21f6d17efe27604c48f0d64 ]

For some exotic peripherals the type detect can return a reserved value
of 0x4. This will currently return an error and not report anything to
user-space, update this to report the insert normally.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260223093616.3800350-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does

This is a one-line fix to the CS42L43 audio codec's jack type detection.
The hardware's type detect register can return a reserved value of `0x4`
for "exotic peripherals." Before this fix, value `0x4` falls through to
the `default: return -EINVAL` case in the switch statement.

### What happens when -EINVAL is returned

The caller `cs42l43_tip_sense_work()` checks `if (report < 0)` and on
error:
1. Logs `"Jack detect failed: %d\n"`
2. Jumps to `error:` label
3. **No jack insert event is reported to userspace**

This means users with these "exotic peripherals" get no audio jack
detection at all — the device appears to not be plugged in.

### Bug classification

This is a **hardware quirk/workaround** — the hardware returns a
reserved value for certain real peripherals. The fix treats type `0x4`
the same as CTIA/OMTP (running load detection with headset=true), which
allows the system to properly detect and report the insert.

### Stable criteria assessment

1. **Fixes a real bug**: Yes — exotic peripherals are completely non-
   functional without this fix (no insert reported to userspace)
2. **Obviously correct**: Yes — the fix adds one case label to treat
   `0x4` like other headset types. The author (Charles Keepax) is the
   subsystem maintainer at Cirrus Logic.
3. **Small and contained**: Yes — one line added to a switch statement
   in a single file
4. **No new features**: Correct — this just makes existing hardware work
   properly
5. **Risk**: Extremely low — it only affects the `0x4` type value which
   previously returned an error anyway

This falls squarely into the **hardware quirks/workarounds** exception
category. The CS42L43 driver has been in the kernel since v6.6
(introduced August 2023, merged for 6.6-rc1), so it exists in recent
stable trees.

### Verification

- Explored `cs42l43_tip_sense_work()` at line ~766: confirmed that
  negative return from `cs42l43_run_type_detect()` goes to `error:`
  label without reporting jack state to userspace
- Confirmed the file was introduced in commit `fc918cbe874ee` (August 4,
  2023) — present since v6.6
- Confirmed the author Charles Keepax is the original driver author and
  Cirrus Logic engineer
- The commit was reviewed and merged by Mark Brown (ASoC maintainer)
- Multiple prior commits show ongoing type detection refinement for this
  codec (dc96528b176fa, e77a4081d7e32, etc.)
- The change is a single `case 0x4:` fallthrough to the existing
  CTIA/OMTP handler — no new code paths introduced

The fix is small, surgical, low-risk, and makes real hardware work for
users. It clearly meets stable kernel criteria.

**YES**

 sound/soc/codecs/cs42l43-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index b83bc4de1301d..3e04e6897b142 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -699,6 +699,7 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 	switch (type & CS42L43_HSDET_TYPE_STS_MASK) {
 	case 0x0: // CTIA
 	case 0x1: // OMTP
+	case 0x4:
 		return cs42l43_run_load_detect(priv, true);
 	case 0x2: // 3-pole
 		return cs42l43_run_load_detect(priv, false);
-- 
2.51.0

