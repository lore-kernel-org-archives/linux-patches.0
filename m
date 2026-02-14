Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4DA221FB6;
	Sat, 14 Feb 2026 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031252; cv=none; b=ZtC44cOfVd9uD5cB+H+xgn/dd2+nGGSq/v/J4TH4hm22LMYfrr2Dl+2yhqfI3XuhSZZNCgzP80VWE8NaN5KDzIXYnsx0zNTB2MdiVYVqOL2BXYitl/kKq6prYBx/m+U8Tnk4iz4eRtuiaCY8QSzKJAruHGEymMH1EimQNWiCYuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031252; c=relaxed/simple;
	bh=dpGPNahTjb+M+DM+/ryym8oCDrMo4Pp7gVQxUK/c2Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZxpparEXMfOgnY6tV0Yzg16IlTBsLDERH10Jk0QU3Wp0cxTr7CwHv3Bu1m4J+ljUkdQ6OTXtZT2VBUzlpUmXuKzGe+x3+U2H/qrY3dKQzBwNh29rIsVtOmfD6wBq88i0Q9Ji0HgrnSYcW0aFfS/JOhALFPt82b/CY2Q6j/SQDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKmbdAFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKmbdAFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F05C116C6;
	Sat, 14 Feb 2026 01:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031252;
	bh=dpGPNahTjb+M+DM+/ryym8oCDrMo4Pp7gVQxUK/c2Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKmbdAFJGRGZbekahml6mKTGcm5BdH+qpuaEN8Zb1v9a/ggivy4Inqf0I11gsjCeX
	 cP6ml2Z6wtDd6bV7XV/ujImNXDvbv9t2FjeCt7Ze2+RfFHhtzIkQ+2wV626FYO4ILt
	 ohvPRGNBRlwX7khCcL0DkyYW0fRgKRfHPaV4wvywJm8ru3QaKz9gZ0H9pY/GN5+4c6
	 +Rciwnf+s/IbPBjabJt6QyaI+LV5UU+7vd1QNhGNrK4z4r07HdusKvURyWylqbwuLx
	 jJjmPnnn2Zdq0NvcaMbURivvQwm867GDmhdQFFZm5EDktGMO//Nuc9fEoJLEXvlPJ4
	 vpSdGAYHUqh5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kuninori.morimoto.gx@renesas.com,
	neil.armstrong@linaro.org,
	brgl@kernel.org,
	shengjiu.wang@nxp.com,
	tiwai@suse.de,
	yelangyan@huaqin.corp-partner.google.com,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: wm8962: Don't report a microphone if it's shorted to ground on plug
Date: Fri, 13 Feb 2026 20:00:01 -0500
Message-ID: <20260214010245.3671907-121-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit e590752119029d87ce46d725e11245a52d22e1fe ]

This usually means that a TRS plug with no microphone pin has been plugged
into a TRRS socket. Cases where a user is plugging in a microphone while
pressing a button will be handled via incoming interrupt after the user
releases the button, so the microphone will still be detected once it
becomes usable.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260105-wm8962-l5-fixes-v1-3-f4f4eeacf089@puri.sm
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ASoC: wm8962: Don't report a microphone if it's shorted
to ground on plug

### 1. Commit Message Analysis

The commit addresses a hardware detection issue with the WM8962 audio
codec. When a TRS (3-pin) plug is inserted into a TRRS (4-pin) socket,
the microphone pin gets shorted to ground. The codec's mic detection
circuitry sees both `MICDET_STS` (microphone detected) and
`MICSHORT_STS` (microphone shorted) simultaneously, leading to an
incorrect report that a microphone is present along with a button press.

The fix: if a short is detected immediately at plug-in time (before any
microphone was previously detected), don't report a microphone. If the
user later releases the button (if it really was a microphone + button
press), an interrupt will fire and correct the state.

### 2. Code Change Analysis

The change is small and well-contained:

1. **New field `mic_status`** added to `struct wm8962_priv` — tracks the
   previous microphone detection status.

2. **Logic change in `wm8962_mic_work()`**:
   - When `MICSHORT_STS` is set (short detected), it checks if
     `mic_status` previously had `MICDET_STS` set.
   - If no microphone was previously detected (`!(wm8962->mic_status &
     WM8962_MICDET_STS)`), it sets `status = 0` — suppressing the false
     microphone + button report.
   - After the check, `wm8962->mic_status` is updated with the current
     status.

This is a **hardware quirk/workaround** — it handles a real-world
scenario where TRS plugs in TRRS sockets cause false microphone
detection.

### 3. Classification

This is a **bug fix for incorrect hardware detection behavior**. It
falls into the category of hardware quirks/workarounds, which are
explicitly allowed in stable trees. The fix prevents:
- False microphone detection when using headphones without a mic
- False button press events on plug insertion
- User-visible incorrect audio routing (system thinks a mic is present
  when it isn't)

### 4. Scope and Risk Assessment

- **Lines changed**: ~12 lines of logic + 1 new struct field = very
  small
- **Files touched**: 1 file (`sound/soc/codecs/wm8962.c`)
- **Complexity**: Low — straightforward state tracking
- **Risk**: Very low. The change only affects the mic detection path.
  The `mic_status` field is zero-initialized (struct is kzalloc'd), so
  on first plug-in, if both MICDET and MICSHORT are set simultaneously,
  it correctly suppresses the false report. The subsequent interrupt
  when the short clears will correctly detect the microphone if one is
  actually present.

### 5. User Impact

- **Who is affected**: Users with WM8962 codec hardware (common in
  embedded/mobile devices, including Purism Librem 5 based on the
  author's email domain)
- **Severity**: Medium — incorrect jack detection leads to wrong audio
  routing, which is a real user-facing issue
- **Reproducibility**: Easily reproducible by plugging TRS headphones
  into a TRRS jack

### 6. Stability Indicators

- **Reviewed-by**: Charles Keepax (Cirrus Logic engineer, the codec
  manufacturer's developer) — strong domain expertise review
- **Applied by**: Mark Brown (ASoC maintainer) — subsystem maintainer
  accepted it
- The fix is logically sound and handles edge cases (subsequent
  interrupt for real mic+button)

### 7. Dependency Check

The change is self-contained. It only adds a new field to the private
data structure and modifies the mic detection work function. No
dependencies on other commits. The WM8962 driver has existed in stable
trees for many years.

### 8. Risk vs Benefit

- **Benefit**: Fixes incorrect microphone/button detection for TRS plugs
  in TRRS sockets — a common real-world scenario
- **Risk**: Minimal — small, localized change with expert review. The
  worst case if the logic were somehow wrong would be a missed initial
  microphone detection, which would self-correct on the next interrupt.

### Conclusion

This is a small, well-reviewed hardware quirk fix for incorrect jack
detection behavior in the WM8962 audio codec. It fixes a real user-
facing issue (false microphone detection with TRS headphones), is self-
contained, has been reviewed by the codec manufacturer's engineer, and
carries minimal regression risk. It meets all stable kernel criteria.

**YES**

 sound/soc/codecs/wm8962.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 1040740fc80f8..bff8644674163 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -67,6 +67,8 @@ struct wm8962_priv {
 	struct mutex dsp2_ena_lock;
 	u16 dsp2_ena;
 
+	int mic_status;
+
 	struct delayed_work mic_work;
 	struct snd_soc_jack *jack;
 
@@ -3081,8 +3083,16 @@ static void wm8962_mic_work(struct work_struct *work)
 	if (reg & WM8962_MICSHORT_STS) {
 		status |= SND_JACK_BTN_0;
 		irq_pol |= WM8962_MICSCD_IRQ_POL;
+
+		/* Don't report a microphone if it's shorted right after
+		 * plugging in, as this may be a TRS plug in a TRRS socket.
+		 */
+		if (!(wm8962->mic_status & WM8962_MICDET_STS))
+			status = 0;
 	}
 
+	wm8962->mic_status = status;
+
 	snd_soc_jack_report(wm8962->jack, status,
 			    SND_JACK_MICROPHONE | SND_JACK_BTN_0);
 
-- 
2.51.0

