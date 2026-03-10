Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBDA47277D;
	Tue, 10 Mar 2026 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133357; cv=none; b=Lnmu/IerBp5dxa7N0atTkAPY0RWdp5aJtF0WpHM0xQ6WQklZr3uK/EszPVMgNBiHJHII4d7bI59azLTTdEbkQXKuXQCJ3JOiC50mJH+XPmNZroZgbMkw2QouFUO7xRzmYX2ZoOUSHv4G9wibJZKVwgPe4Wo00o6fN3+/hbdJ5KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133357; c=relaxed/simple;
	bh=X04MSuYe+0MX6O5qj8SOGjt38XEk63ORDpQb1AL4ryc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBKpM62NhLmwxuBsApJqEnqYIM9PROacnjHfXDHvLdbqm9fFgVJwqoWZJwH2Fc+GFDbZFvV4MlFfhdUPiaQCIrEKc01n5W9yG0hD3VJcjCqexqynE1YSpkvwszRmLjQMpVxzUcZQ4KHHyhcjJucgRjgLyDdNNWOdwyhaXKmt/5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8/wlkIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8/wlkIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E29AC2BC87;
	Tue, 10 Mar 2026 09:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133357;
	bh=X04MSuYe+0MX6O5qj8SOGjt38XEk63ORDpQb1AL4ryc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8/wlkIH7GY+DUoXnJhbYmXkY0fQXl94txQX1hIVj4mXpHVi9atcgdqXGizPrIosp
	 oErLFgAgU6agX85/8Gi4zDP3o6lL4Et2Qg2qCZxSWjVudIWe0sCGwDa7y2vDRiCwcq
	 DdAfNWJrT7gnc/siExMFTxlAgyOdsD6Eyn3gXfapph06eephp3yuL5MDZ+Y7DjM5Tt
	 CkE+Pc0UF1IKoJWKskOZ5RCojyaZLUHI/bYaxstrrHsq9qvmx2juuRzf2u/oabrjSu
	 2crISrknGhgCNd3CTkXpCigo6fu7dhO/DeoUwKLZSHSxl1cQIUPEJj9ymun6+sn35F
	 5tleAGH2gLGsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()
Date: Tue, 10 Mar 2026 05:01:35 -0400
Message-ID: <20260310090145.2709021-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 54a86cf48eaa6d1ab5130d756b718775e81e1748 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_easrc_iec958_put_bits() unconditionally returns
0, causing ALSA to not generate any change events. This is detected by
mixer-test with large numbers of messages in the form:

    No event generated for Context 3 IEC958 CS5
    Context 3 IEC958 CS5.0 orig 5224 read 5225, is_volatile 0

Add a suitable check.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260205-asoc-fsl-easrc-fix-events-v1-1-39d4c766918b@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The driver has been present since v5.8 (2020), so it exists in all
current stable trees.

## Analysis

**What the commit fixes:**
The `fsl_easrc_iec958_put_bits()` function is an ALSA control put
callback. Per the ALSA API contract, put callbacks must return 1 when
the control value changes and 0 when it doesn't. This function
unconditionally returned 0, which meant ALSA never generated change
events for IEC958 controls on this hardware. The fix adds a simple
comparison before the assignment and returns whether the value changed.

**Bug category:** Incorrect return value / missing event generation — a
real functional bug.

**Scope and risk:**
- 3 lines changed (adding `int ret`, comparing old vs new value,
  returning `ret` instead of `0`)
- Purely local to one function in one driver
- The fix is obviously correct — standard ALSA pattern used across
  hundreds of drivers
- Zero risk of regression — the only behavioral change is that change
  events are now properly generated

**Author:** Mark Brown, the ASoC subsystem maintainer. He is both the
author and committer, demonstrating high confidence in the fix.

**Stable criteria:**
- Obviously correct: Yes — trivial pattern
- Fixes real bug: Yes — missing change events mean userspace
  applications (mixers, audio daemons) don't get notified of control
  changes
- Small and contained: Yes — 3 lines in one function
- No new features: Correct — just fixes existing behavior to match API
  contract
- Tested: Detected by mixer-test, fix validated by same

**User impact:** Any system using the NXP/Freescale EASRC (Enhanced
Asynchronous Sample Rate Converter) where userspace monitors IEC958
control changes would silently miss updates. This affects audio
applications relying on ALSA event notifications.

## Verification

- Read the current code at `sound/soc/fsl/fsl_easrc.c:46-62` — confirmed
  the fix is applied and is the standard pattern (compare before assign,
  return difference)
- `git log master --reverse` confirmed driver was introduced in commit
  955ac624058f9 (2020-04-16, v5.8 cycle), so it exists in all maintained
  stable trees
- The function is referenced at line 125 as `.put =
  fsl_easrc_iec958_put_bits` in a macro, confirming it's used as an ALSA
  control callback
- Author is Mark Brown (broonie@kernel.org), the ASoC maintainer —
  verified from commit metadata
- The fix pattern (checking old != new before returning from put
  callback) is a well-established ALSA convention — no novel logic

**YES**

 sound/soc/fsl/fsl_easrc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index 733374121196e..6c56134c60cc8 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -52,10 +52,13 @@ static int fsl_easrc_iec958_put_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 	unsigned int regval = ucontrol->value.integer.value[0];
+	int ret;
+
+	ret = (easrc_priv->bps_iec958[mc->regbase] != regval);
 
 	easrc_priv->bps_iec958[mc->regbase] = regval;
 
-	return 0;
+	return ret;
 }
 
 static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
-- 
2.51.0

