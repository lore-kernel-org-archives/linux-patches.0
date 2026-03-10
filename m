Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9A40759B;
	Tue, 10 Mar 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133308; cv=none; b=CyjIRuMA+j0T4qktd/yVqFA0jd61IdliXQsPeV7cU0aM/fvWeFs88qiAIKr7iDEYGZAuH2CaXI5KxY5Fp4K000Fna/y5jbOkJmbmyWpLu8UK3c0mHfBpMFxjL9O0JZ0dV7eTp/0iLYMcVH5mfm9gYcIFU2vKeeaXIPJzesb6+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133308; c=relaxed/simple;
	bh=u2Vzam/bYA8NgPkPOiOe7/hybQIcVlVZQq2S9mdk6yA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c+RAeywAUhGz6OW+nzC691sjbRK+ZPebpwBLaSp7YzlIL9Nl6J92Fbq6n264wMhchOJtyxgvz8UQnc0ILpumdIluoMfUj0wF31UrWEphlcYrRAqmUg465YGZpCtKVQsXuVqUgGQgeqRov9Xk+YqTaHxL8BpziA16HunzH7D5Ew4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3CUmkxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3CUmkxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED944C19423;
	Tue, 10 Mar 2026 09:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133308;
	bh=u2Vzam/bYA8NgPkPOiOe7/hybQIcVlVZQq2S9mdk6yA=;
	h=From:To:Cc:Subject:Date:From;
	b=m3CUmkxiQNWKnTq2OcXs1ei9ZwJ+kqQEJmYgF1nwy0UKJt/iQZOJ7aCFVWcLKAw74
	 9fsioppodr4kXiO0yV2SrEzkKTV4o8ByF9T19sGs1qp11JFoTzI6kqSn6XnOktioLo
	 MrucCmbwSW+Ga12hP0/GYYv6v9imyokDg/Zbp8HUup45zpv5sXUGbja3YMrwvNKuxG
	 e0OnbmJgIXw1tZZiEEm/pZ3DEwERc0JvsHEHXJmW5x2i7TNVPNldD4UsZSAM01IREy
	 /Kk9fZ7qRTmm+9MBuYRCu9r9yhgt3j42KdBDBPdjqKhdUE/U5h+xqfwJiehUUYvsei
	 +A1McfDbIhLLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sheetal <sheetal@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-sound@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: hda/hdmi: Add Tegra238 HDA codec device ID
Date: Tue, 10 Mar 2026 05:01:01 -0400
Message-ID: <20260310090145.2709021-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
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

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 5f4338e5633dc034a81000b2516a78cfb51c601d ]

Add Tegra238 HDA codec device in hda_device_id list.

Signed-off-by: Sheetal <sheetal@nvidia.com>
Link: https://patch.msgid.link/20260302084217.3135982-1-sheetal@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: ALSA: hda/hdmi: Add Tegra238 HDA codec device ID

### Commit Overview
This is a single-line addition of a new HDA codec device ID
(`0x10de0032`) for the Tegra238 HDMI/DP audio codec to the existing
`snd_hda_id_tegrahdmi[]` device ID table.

### Classification: New Device ID Addition

This falls squarely into the **"New Device IDs"** exception category for
stable backports. The change:

1. Adds exactly one line: `HDA_CODEC_ID_MODEL(0x10de0032, "Tegra238
   HDMI/DP", MODEL_TEGRA234)`
2. Uses an existing model type (`MODEL_TEGRA234`) — the same model used
   by surrounding entries (Tegra234, SoC 33, Tegra264, SoC 35)
3. The driver already fully exists in stable trees
4. No new code paths, no new features, no behavioral changes for
   existing hardware

### Risk Assessment
- **Risk: Extremely low.** This is a data-only change — adding an entry
  to a device ID table. It cannot affect any existing hardware or code
  path.
- **Scope: Minimal.** One line in one file.
- **Regression potential: Near zero.** The new entry is only matched
  when the specific Tegra238 hardware is present.

### User Impact
Without this ID, users with Tegra238 SoCs would have no HDMI/DP audio
support. This is a real hardware enablement fix for NVIDIA's Tegra238
platform.

### Stable Kernel Rules Compliance
1. **Obviously correct and tested**: Yes — follows the exact same
   pattern as all other entries in the table, uses the same model as the
   adjacent Tegra234 entry.
2. **Fixes a real bug**: Yes — hardware doesn't work without its device
   ID in the table.
3. **Small and contained**: Yes — one line.
4. **No new features/APIs**: Correct — uses existing driver
   infrastructure.

### Verification
- Reviewed the diff: confirms a single `HDA_CODEC_ID_MODEL` line
  insertion using existing `MODEL_TEGRA234` model type, consistent with
  adjacent entries.
- The file `sound/hda/codecs/hdmi/tegrahdmi.c` contains the full Tegra
  HDMI codec driver with probe, init, build_pcms, etc. — the driver is
  complete and existing.
- The new entry is placed in numerical order between `0x10de0031`
  (Tegra234) and `0x10de0033` (SoC 33), both using `MODEL_TEGRA234`.
- Commit is signed off by NVIDIA engineer (sheetal@nvidia.com) and
  accepted by the ALSA maintainer (Takashi Iwai).

### Conclusion
This is a textbook device ID addition — the single most common and least
risky type of stable backport. It enables HDMI/DP audio on Tegra238
hardware with zero risk to existing functionality.

**YES**

 sound/hda/codecs/hdmi/tegrahdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/hdmi/tegrahdmi.c b/sound/hda/codecs/hdmi/tegrahdmi.c
index 5f6fe31aa2028..ebb6410a48313 100644
--- a/sound/hda/codecs/hdmi/tegrahdmi.c
+++ b/sound/hda/codecs/hdmi/tegrahdmi.c
@@ -299,6 +299,7 @@ static const struct hda_device_id snd_hda_id_tegrahdmi[] = {
 	HDA_CODEC_ID_MODEL(0x10de002f, "Tegra194 HDMI/DP2",	MODEL_TEGRA),
 	HDA_CODEC_ID_MODEL(0x10de0030, "Tegra194 HDMI/DP3",	MODEL_TEGRA),
 	HDA_CODEC_ID_MODEL(0x10de0031, "Tegra234 HDMI/DP",	MODEL_TEGRA234),
+	HDA_CODEC_ID_MODEL(0x10de0032, "Tegra238 HDMI/DP",	MODEL_TEGRA234),
 	HDA_CODEC_ID_MODEL(0x10de0033, "SoC 33 HDMI/DP",	MODEL_TEGRA234),
 	HDA_CODEC_ID_MODEL(0x10de0034, "Tegra264 HDMI/DP",	MODEL_TEGRA234),
 	HDA_CODEC_ID_MODEL(0x10de0035, "SoC 35 HDMI/DP",	MODEL_TEGRA234),
-- 
2.51.0

