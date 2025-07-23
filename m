Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2445223A6;
	Wed, 23 Jul 2025 00:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232318; cv=none; b=tW83CWrDwj9Z7kkSRgJwY6/ZYXkE4UO5ZJxzgXRjTbRwGRIgWXqHaATVMkLwJZHioj9rEXO8pwcV3cN0qgkCWoswviDdYZmra7ObeHNwf7uZ5pX61HdcDZoEXQsiKncZt81D0Y4be0LWfRepr41wm+y4cRt38vd3hS9nxDLrX94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232318; c=relaxed/simple;
	bh=cp0AYlgp6+j2l8Hmf7dW3HPkQuyZNkpKebCps9bXrf4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RwJDU9lIzARO5aw9RxLKWtJs7KAx8eJ7wP3r2SK4ndmQsnzv/b2/llnHMvdEkC0U2sPDgcIIu74iHyFyBHhhP/LQsKtWtpfg89rMTcazdncBPRYJDQmtzZbwBFdlxdyTJRA6ahxT6tUZbfgBG3RjGRCfXK/UDx/+EOSW4QOCIk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msAmV7aY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msAmV7aY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE01EC4CEEB;
	Wed, 23 Jul 2025 00:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753232318;
	bh=cp0AYlgp6+j2l8Hmf7dW3HPkQuyZNkpKebCps9bXrf4=;
	h=From:To:Cc:Subject:Date:From;
	b=msAmV7aYseKrLcNZJS2jf4mGP+CFHZO+/eVw1JA055PPgmjsOmx+kDWoWvqY8Zx+X
	 hMkeiDcegpmVv9ZFOB2nRRMPFpLPsGIjp6Ps7mS61oqwWAzJ89xQRaqEi0TwTOc6sU
	 qwtKcvdbJGwrvvgb3f8O5pcWuubwd83wAeJe3Hy0fOpKyb/TFW0rba0w2AQ6whoDFX
	 /RxqmsLhkChwxX55MrqB3aHo2oADbjVHLlWrhtN1RieIKf3ttmciA+wpqIeihIRZaw
	 PbiobHvKTxiiJs3Qk6OlJrRtMa+1uKBJlJswzMJVjH6UaRKd1kKRe28z+1OlLAHmHm
	 8Eyfy77Im26Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lane Odenbach <laodenbach@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	venkataprasad.potturu@amd.com,
	tiwai@suse.de,
	mario.limonciello@amd.com,
	lachlan.hodges@morsemicro.com,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.6 1/5] ASoC: amd: yc: Add DMI quirk for HP Laptop 17 cp-2033dx
Date: Tue, 22 Jul 2025 20:58:27 -0400
Message-Id: <20250723005833.1023337-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.99
Content-Transfer-Encoding: 8bit

From: Lane Odenbach <laodenbach@gmail.com>

[ Upstream commit 7bab1bd9fdf15b9fa7e6a4b0151deab93df3c80d ]

This fixes the internal microphone in the stated device

Signed-off-by: Lane Odenbach <laodenbach@gmail.com>
Link: https://patch.msgid.link/20250715182038.10048-1-laodenbach@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for Hardware Functionality**: The commit fixes a non-
   functional internal microphone on the HP Laptop 17 cp-2033dx. This is
   a hardware enablement bug fix that prevents users from using a core
   functionality of their laptop.

2. **Minimal and Contained Change**: The change is extremely minimal -
   it only adds 7 lines to the DMI quirk table:
  ```c
  +       {
  +               .driver_data = &acp6x_card,
  +               .matches = {
  +                       DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
  +                       DMI_MATCH(DMI_BOARD_NAME, "8A81"),
  +               }
  +       },
  ```
  This is a simple DMI match addition with no algorithmic changes or
  side effects.

3. **Low Risk of Regression**: DMI quirk additions are inherently safe
   as they only affect the specific hardware model being added. The
   change cannot impact any other system that doesn't match the exact
   DMI strings.

4. **Follows Established Pattern**: All five similar commits provided as
   reference (for HP models with board names 8BD6, 8A3E, 8A22, 8A27, and
   other manufacturers) were marked as "Backport Status: YES". This type
   of commit has a well-established history of being backported.

5. **User-Impacting Issue**: Without this quirk, users of the HP Laptop
   17 cp-2033dx cannot use their internal microphone, which is essential
   functionality for video calls, recording, and voice commands. This
   significantly degrades the user experience.

6. **Consistent with Stable Tree Rules**: The commit meets the stable
   kernel criteria:
   - It fixes a real bug that bothers users (non-functional microphone)
   - It's obviously correct and tested (standard DMI quirk pattern)
   - It's small (7 lines)
   - It doesn't add new features, only fixes existing functionality

The AMD Yellow Carp (YC) audio driver uses DMI quirks to enable the
internal microphone on specific laptop models. Without these quirks, the
DMIC (Digital Microphone) won't be properly initialized on affected
systems. This is a common pattern in the Linux kernel for handling
hardware-specific configurations.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 66ef8f4fd02cd..74f8e12aa7107 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -577,6 +577,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A7F"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A81"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5

