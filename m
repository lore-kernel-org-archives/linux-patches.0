Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5311B3002A4;
	Sat, 25 Oct 2025 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408670; cv=none; b=VGTjQUV/tTQ+N2goLxfWISGgmIEZN+a3YVsNdcZiHClfQz/T4t5HO0eIOs2j9rvzlw7IXaCQS2g5zEZ7jfl4EqWMNB1W2H2NtzJlT0XpD/6uKIKiB4NjoEy2ze+BQOBPP5SQSu22/e1lRWI2OTI+9lNC0E/hPuy5qiKxlNMLFOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408670; c=relaxed/simple;
	bh=Uw/qqjBLX5Cwc3c617aNFdkLX8uxq+a/W+TRSRaK1MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZbZyWwFxygSt/QOG9saVu5Xqo3QLg5wJ9eMpiebBX1rKu9ljmoTMrWqXwmMgqjGxszgUDibWWCFw3MPTcvi8kJKx3AWL7QvA76eH71ZpeMx4qks4EIkiN/M5LIkSqOj7YS5oCBB2Rt9ryULqIXfRtOFRva7/veUBLe/MYan4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iX/rvna1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX/rvna1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A60C4CEF5;
	Sat, 25 Oct 2025 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408668;
	bh=Uw/qqjBLX5Cwc3c617aNFdkLX8uxq+a/W+TRSRaK1MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iX/rvna1yKhmH8g5K8JesUXdfKKHE/gb7fJDf/vtMjCVf8g3gIzgX0hEWYEBgrJSS
	 Q/hA2nuhFnxrET1qo0wX2/xFwN3KObGAkRUZ4q0tvwNw/oGgY0dxLLPQFmqZg+sqyb
	 pH4O0OD/0KAHnNXd5LXoVZJzFk228pqAaNguO5UollBJ41mOA+gKPhNeExAE/nyoKF
	 nozxxNUeTLdMWRp2Itug5LulA9CvkYxuNjpOEF4dTzA/01VeWAv+czT7QXDLRabeMP
	 lKQM/MwNDHyVGxW/USIQnVlldk/azPQjbeywn5ikqjpwPTrsV80UOpA1OmAbp5z58c
	 SB77Y1UD2lEAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shimrra Shai <shimrrashai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	u.kleine-koenig@baylibre.com
Subject: [PATCH AUTOSEL 6.17] ASoC: es8323: remove DAC enablement write from es8323_probe
Date: Sat, 25 Oct 2025 11:54:26 -0400
Message-ID: <20251025160905.3857885-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shimrra Shai <shimrrashai@gmail.com>

[ Upstream commit 33bc29123d26f7caa7d11f139e153e39104afc6c ]

Remove initialization of the DAC and mixer enablement bits from the
es8323_probe routine. This really should be handled by the DAPM
subsystem.

Signed-off-by: Shimrra Shai <shimrrashai@gmail.com>
Link: https://patch.msgid.link/20250815042023.115485-2-shimrrashai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - The unconditional write in `es8323_probe()` that sets
    `ES8323_DACCONTROL17` was removed:
    `snd_soc_component_write(component, ES8323_DACCONTROL17, 0xB8)`
    (sound/soc/codecs/es8323.c). This register holds the per‑path mixer
    gate and level bits for the DAC/mixer.
  - The rest of probe remains the same (clock fetch/enable, sane
    defaults via `ES8323_CONTROL2` and `ES8323_CHIPPOWER` writes).

- Why this is a bug fix
  - `ES8323_DACCONTROL17` includes the mixer enable bit (bit 7) and
    bypass volume field (bits 5:3). Writing `0xB8` in probe forces the
    left mixer gate on and sets the bypass level to its maximum,
    independent of any active audio route.
  - In ASoC, DAPM owns codec power/mixer gates. Hard‑enabling a mixer at
    probe bypasses DAPM, leading to:
    - Always‑on or prematurely‑on audio paths (increased idle power,
      potential clicks/pops at boot/resume).
    - Mismatched DAPM state vs. hardware state, undermining DAPM’s power
      sequencing and pop‑suppression.
  - The commit message explicitly states this should be handled by DAPM,
    which matches standard ASoC practice (compare the analogous ES8328
    driver where DAPM controls `DACCONTROL17` via DAPM mixer widgets).

- Scope and risk assessment
  - Change is minimal and localized to `sound/soc/codecs/es8323.c` in
    `es8323_probe()`; no ABI or architectural changes.
  - It removes an unconditional register poke and defers control to
    existing DAPM routing, which is already the intended mechanism (the
    driver’s bias management and DAPM paths handle DAC/mixer power in
    normal operation).
  - Potential regression risk is low: only boards that implicitly relied
    on the incorrect “pre‑enabled” mixer/DAC at probe would notice a
    behavior change; correct machine drivers should rely on DAPM to
    enable paths when a stream is active.

- Stable criteria
  - Fixes a real, user‑visible issue (unnecessary power draw, audio
    artifacts, and DAPM miscoordination).
  - Small, self‑contained change with minimal regression risk.
  - No new features and no architectural churn; confined to the codec
    driver.
  - While there’s no explicit “Cc: stable” tag, this matches typical
    stable‑worthy ASoC fixes (removing stray probe‑time enables in favor
    of DAPM).

Conclusion: This is a safe, corrective change that aligns the driver
with ASoC/DAPM design and should be backported to any stable trees that
contain the ES8323 driver and its DAPM graph.

 sound/soc/codecs/es8323.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index 70d348ff3b437..4c15fffda733c 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -632,7 +632,6 @@ static int es8323_probe(struct snd_soc_component *component)
 
 	snd_soc_component_write(component, ES8323_CONTROL2, 0x60);
 	snd_soc_component_write(component, ES8323_CHIPPOWER, 0x00);
-	snd_soc_component_write(component, ES8323_DACCONTROL17, 0xB8);
 
 	return 0;
 }
-- 
2.51.0

