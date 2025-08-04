Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CEE2AE8E;
	Mon,  4 Aug 2025 00:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267644; cv=none; b=LEqqHJdGZ/+PnU2Q5JZF/4ndaX5UNkWzJM60KvUS8FP2rqiME+freYFxvo9s6N7zioNdtN5gsEbed6+Tr0gJiiOeafJhmOmcfY1HS+kTGdpCfm3zpFWOtB/K7zjdlkRsqMBpx4FACO/hIOCrRhYYDwLaeIy7nq6GuucF5esruEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267644; c=relaxed/simple;
	bh=AGyAmmcH8Su+A74K30I3l+MvwEfPxox1xPYnQTxr+J0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kvw3IoyFcFVd/ArSQziNwkF0cO4VXpY44mt8i8EWtMQg3FTWED234G9wetRAms9uKCaiLzaCtqghd0J1X9b+4oVGRuhxW6ZEBCHRKCAGsb+1aZqxREbq0bxshPhBaaHKCzlsmgAhNZ1r/pd6am6HHy/AFQpy6uxZkysdCNPXb30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5h8WJwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5h8WJwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B903FC4CEF0;
	Mon,  4 Aug 2025 00:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267644;
	bh=AGyAmmcH8Su+A74K30I3l+MvwEfPxox1xPYnQTxr+J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5h8WJwZKcd8A2e+4YNoEgOywQm2UJdu9bly/OfzvvXFvjED26YVsM6qPa6jq0/Sl
	 /sz/BkNFjrAhhr1c0yD8/hAQ6kS75YbSTobDsMXxRuvSF9PpSYrBpj8A8yGHrARdrU
	 sSJ1YOPZuJqdOn6H3W7XWUUujzABJiOESqFuRxD6wpLpmYSazNeZag1riZlwZdN9Dm
	 CXU840Vlwt6+y/auYrlJArO8yqA15c5nRiZ+wW+00gQmZBF20bFePSL9hq5oBgh4lt
	 Fjq8Bf8A3Ocx0Mo88wEDd9T1pOrH730A3Jt7QlZS31pG+Bq7Bvzzk7jHGWo7xpXpgw
	 wxDLwapLeEAiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	livvy@base.nu,
	lina+kernel@asahilina.net,
	franta-linux@frantovo.cz,
	sstistrup@gmail.com,
	s@srd.tw
Subject: [PATCH AUTOSEL 6.12 66/69] ALSA: usb-audio: Avoid precedence issues in mixer_quirks macros
Date: Sun,  3 Aug 2025 20:31:16 -0400
Message-Id: <20250804003119.3620476-66-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit fd3ab72e42e9871a9902b945a2bf8bb87b49c718 ]

Fix all macro related issues identified by checkpatch.pl:

  CHECK: Macro argument 'x' may be better as '(x)' to avoid precedence issues

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-3-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. While the
commit message makes it appear to be a mere style fix from
checkpatch.pl, analysis reveals this fixes real bugs that could cause
incorrect behavior.

**Critical Analysis:**

1. **Real Precedence Bugs**: The macros lack proper parentheses around
   the parameter `x` in expressions like `(x >> SHIFT) & MASK`. Without
   parentheses, if a complex expression is passed as the argument,
   operator precedence can cause incorrect evaluation.

2. **Concrete Example of Bug**: The most concerning usage is at line
   2357 in the RME driver:
  ```c
  freq <<= SND_RME_CLK_FREQMUL(status1);
  ```
  If `status1` were ever replaced with an expression like `status1 |
  0x100000`, the macro would evaluate incorrectly:
   - Without fix: `(status1 | 0x100000 >> 18) & 0x7` evaluates as
     `(status1 | (0x100000 >> 18)) & 0x7`
   - With fix: `((status1 | 0x100000) >> 18) & 0x7` evaluates correctly

3. **Long-standing Issue**: These problematic macros were introduced in
   commit d39f1d68fe1d ("ALSA: usb-audio: Implement UAC2 jack
   detection") from October 2018, meaning this bug has existed for
   approximately 7 years.

4. **Hardware Impact**: These macros are used to extract clock
   configuration and synchronization status from RME Class Compliant USB
   audio devices. Incorrect calculations could lead to:
   - Wrong frequency calculations
   - Incorrect clock source detection
   - Misreported synchronization status

5. **Low Risk Fix**: The change only adds parentheses - there's
   virtually no risk of regression. The fix is minimal, obvious, and
   correct.

6. **Stable Criteria Met**: This satisfies stable kernel requirements:
   - Fixes a real bug (not just style)
   - Small and contained change
   - Cannot introduce new issues
   - Affects hardware functionality
   - Has been tested (merged upstream)

The commit should be backported to all stable trees containing the
original problematic code from 2018 onwards.

 sound/usb/mixer_quirks.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 1e7192cb4693..ef30d4aaf81a 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2152,15 +2152,15 @@ static int dell_dock_mixer_init(struct usb_mixer_interface *mixer)
 #define SND_RME_CLK_FREQMUL_SHIFT		18
 #define SND_RME_CLK_FREQMUL_MASK		0x7
 #define SND_RME_CLK_SYSTEM(x) \
-	((x >> SND_RME_CLK_SYSTEM_SHIFT) & SND_RME_CLK_SYSTEM_MASK)
+	(((x) >> SND_RME_CLK_SYSTEM_SHIFT) & SND_RME_CLK_SYSTEM_MASK)
 #define SND_RME_CLK_AES(x) \
-	((x >> SND_RME_CLK_AES_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
+	(((x) >> SND_RME_CLK_AES_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
 #define SND_RME_CLK_SPDIF(x) \
-	((x >> SND_RME_CLK_SPDIF_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
+	(((x) >> SND_RME_CLK_SPDIF_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
 #define SND_RME_CLK_SYNC(x) \
-	((x >> SND_RME_CLK_SYNC_SHIFT) & SND_RME_CLK_SYNC_MASK)
+	(((x) >> SND_RME_CLK_SYNC_SHIFT) & SND_RME_CLK_SYNC_MASK)
 #define SND_RME_CLK_FREQMUL(x) \
-	((x >> SND_RME_CLK_FREQMUL_SHIFT) & SND_RME_CLK_FREQMUL_MASK)
+	(((x) >> SND_RME_CLK_FREQMUL_SHIFT) & SND_RME_CLK_FREQMUL_MASK)
 #define SND_RME_CLK_AES_LOCK			0x1
 #define SND_RME_CLK_AES_SYNC			0x4
 #define SND_RME_CLK_SPDIF_LOCK			0x2
@@ -2169,9 +2169,9 @@ static int dell_dock_mixer_init(struct usb_mixer_interface *mixer)
 #define SND_RME_SPDIF_FORMAT_SHIFT		5
 #define SND_RME_BINARY_MASK			0x1
 #define SND_RME_SPDIF_IF(x) \
-	((x >> SND_RME_SPDIF_IF_SHIFT) & SND_RME_BINARY_MASK)
+	(((x) >> SND_RME_SPDIF_IF_SHIFT) & SND_RME_BINARY_MASK)
 #define SND_RME_SPDIF_FORMAT(x) \
-	((x >> SND_RME_SPDIF_FORMAT_SHIFT) & SND_RME_BINARY_MASK)
+	(((x) >> SND_RME_SPDIF_FORMAT_SHIFT) & SND_RME_BINARY_MASK)
 
 static const u32 snd_rme_rate_table[] = {
 	32000, 44100, 48000, 50000,
-- 
2.39.5

