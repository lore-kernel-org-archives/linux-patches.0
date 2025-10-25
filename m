Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2106308F3B;
	Sat, 25 Oct 2025 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409697; cv=none; b=uybRy82ASijZu4sbysQGbwdEE7uDr7sTcLJxtUIjLyknW8pYsaITkItHa5K0wMoMXwX17/lnshcqskEvyp+X7G8lhY4MnCbLNdW3xuejH78Uvvm6uGQJ8biOpawwBkkrOLoJlMAGNtOALQBCN8DOzgM8lZ3BXfPo+O96SwxACC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409697; c=relaxed/simple;
	bh=Xugtb/EcZpXhNKGuCSeIotDcPpkDEuPmbHbkUfTCnB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KOC+fNNHjBVAsxNqBw3LabvJHyIA9fjl7c9sIFOI3TU5SKdDBlu8mnWTX/HqdhYiQPFNUlZCjYQRK3vxjvV+I+Ffsb8hmjGu31hFdOBra9rhHh5hJ+7czHzpEn+uhOudWz2l7D+lfkJcplZjyjVFzl3+2uowBuo3ix60nfALE+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezzhGSCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezzhGSCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951EEC4CEF5;
	Sat, 25 Oct 2025 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409696;
	bh=Xugtb/EcZpXhNKGuCSeIotDcPpkDEuPmbHbkUfTCnB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezzhGSCfqI7gZbdot8WpFnYqihmL2V/EwNbBNdVy47tb1gn6xh0WIBqzhl8nrAMHB
	 hD6iOOiAfbsF0UmScdq9z8DS+QExBVvVw5sc24FYHRh+fJDUr7sweq+5BQ4+0byGxq
	 YXAv2yIFKTUeoCnWfCEFDvx5sSsSWBz3h8PTxMJo+zsEDkij/uUC/aoU3wbBqrjyHx
	 z3vyeIorpVCdcaqy7zlnrHwNgvUadM/8Nk/poPH51DLZki2qv6+PnRjMF6ATpnfvX4
	 wjawFyapvQMYqFyN5vg/uG+kTrq234PKhqZiZfjzbVlVVVBxQblf8jHtdAIHqzJFpX
	 lF+x0ZIb+fbRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	cryolitia@uniontech.com,
	pav@iki.fi,
	hulianqin@vivo.com,
	alexandre.f.demers@gmail.com,
	dan.carpenter@linaro.org,
	bsevens@google.com
Subject: [PATCH AUTOSEL 6.17] ALSA: usb-audio: don't apply interface quirk to Presonus S1824c
Date: Sat, 25 Oct 2025 12:00:54 -0400
Message-ID: <20251025160905.3857885-423-sashal@kernel.org>
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

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit d1d6ad7f6686e208aba06b7af3feef7a7cba61cf ]

Testing with a Presonus STUDIO 1824c together with
a Behringer ultragain digital ADAT device shows that
using all 3 altno settings works fine.

When selecting sample rate, the driver sets the interface
to the correct altno setting and the correct number of
channels is set.

Selecting the correct altno setting via Ardour, Reaper or
whatever other way to set the sample rate is more convenient
than re-loading the driver module with device_setup to
set altno.

Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – Removing the 1824c entry from the interface-quirk table fixes a
real regression while keeping risk low.

- `s1810c_skip_setting_quirk()` in `sound/usb/quirks.c:1554` only lets
  one alternate setting survive unless the user reloads the module with
  a `device_setup` override; because the 1824c reuse of this helper
  (added in 080564558eb1373c) defaults `chip->setup` to 0, capture alt 1
  (8 ADAT channels) and alt 3 (high-rate analog) are always filtered
  out, so normal sample-rate changes cannot expose the full I/O set.
- By deleting the 1824c `USB_ID(0x194f, 0x010d)` case in
  `sound/usb/quirks.c:1599`, the driver now falls back to the generic
  path that enumerates every alternate setting, letting the UAC2 core
  pick the mode that matches the requested rate, just as it does for
  other compliant interfaces.
- That generic path is exercised from `snd_usb_parse_audio_interface()`
  (`sound/usb/stream.c:1165`), so the change immediately restores
  behaviour for any PCM open without touching unrelated devices; the
  1810c keeps its quirked handling.
- The existing rate filter shared by 1810c/1824c
  (`sound/usb/format.c:387-394`) still guards against the invalid
  combinations that originally justified the quirk, ensuring the auto-
  selected alternates map to valid channel/rate sets.
- Impact is user-visible (ADAT channels and high-rate modes require
  module reload today), the fix is a three-line removal with confirmed
  hardware testing in the changelog, and it has no architectural
  fallout; stable trees that already picked up 080564558eb1373c should
  take this to restore expected functionality.

 sound/usb/quirks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 766db7d00cbc9..4a35f962527e9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1599,9 +1599,6 @@ int snd_usb_apply_interface_quirk(struct snd_usb_audio *chip,
 	/* presonus studio 1810c: skip altsets incompatible with device_setup */
 	if (chip->usb_id == USB_ID(0x194f, 0x010c))
 		return s1810c_skip_setting_quirk(chip, iface, altno);
-	/* presonus studio 1824c: skip altsets incompatible with device_setup */
-	if (chip->usb_id == USB_ID(0x194f, 0x010d))
-		return s1810c_skip_setting_quirk(chip, iface, altno);
 
 	return 0;
 }
-- 
2.51.0

