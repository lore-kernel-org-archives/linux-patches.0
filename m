Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D932222B7;
	Tue, 30 Dec 2025 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767100989; cv=none; b=pO04slhCFQR6S5bqcer9tX80rIZ+YCz/lBMpd1U+wXahTtNgz5tdYYp3vNYJHdRqii/ltbc/JDur1FXignAjTQEzXZCeDjtkUmBXBHrhzywOhX/GAmV1rSpwglZA7YRdIoDjtStD8akXjgfrXOmQDo37BLy9qI5WYx4yKwmh3Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767100989; c=relaxed/simple;
	bh=7geZIghIcY1yJz9R9cpVVLgWXJKY9cFBsUAacqWbWFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/msLyMVVSN5VAUMG9m6uZbb3fNBX6YNPWsefbgYPrGX/5sBds+laQP7AEVkb6pdYSd/pGQ40jWrmy4p2xknqsui2W6egOd0RrB/yEttntW+ca8qob1XzuIcN+yFaXn/sgejCNF0ynG+7dACmIyc+XYjFFjideJg3r6DoId4sIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWbk0UzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWbk0UzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C955C4CEFB;
	Tue, 30 Dec 2025 13:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767100989;
	bh=7geZIghIcY1yJz9R9cpVVLgWXJKY9cFBsUAacqWbWFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWbk0UzZyUXrI9xyZzuF34VXgw7PHElGDYrPo/q8mfM1Y3vI+iie3s83RD73ikpRl
	 9U1BcLHdkEFGfRVKObtsCiLPAotrgVStlP+NHB8IIEoA1FTqfayV4Nlvm/a5Y06O7H
	 AJEWETl+V6IDlf2VsHLLC60RzB6Ms5HxjaEiUMizRBKaMw24IHk3qmtI365czQd4EK
	 u4r1HykJbTIhW7g6N/ABcOOYhCQivvAOFPgxHV1IeAIJHfVj4MYrvrlwqTzNFBycfr
	 rbQ1GjiN5/ixXVM7xBCzgGRaczU3PHujgDfuwNJYCFdsCEgEOdNdF0jyxOpxIpFAy8
	 X2M3k8O8rNqCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Elantsev <elantsew.andrew@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	syed.sabakareem@amd.com,
	yuzuru_10@proton.me,
	keenplify@gmail.com,
	queler@gmail.com,
	talhah.peerbhai@gmail.com,
	ravenblack@gmail.com,
	santesegabriel@gmail.com,
	alex.andries.aa@gmail.com
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025
Date: Tue, 30 Dec 2025 08:22:56 -0500
Message-ID: <20251230132303.2194838-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251230132303.2194838-1-sashal@kernel.org>
References: <20251230132303.2194838-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Transfer-Encoding: 8bit

From: Andrew Elantsev <elantsew.andrew@gmail.com>

[ Upstream commit e2cb8ef0372665854fca6fa7b30b20dd35acffeb ]

Add a DMI quirk for the Honor MagicBook X16 2025 laptop
fixing the issue where the internal microphone was
not detected.

Signed-off-by: Andrew Elantsev <elantsew.andrew@gmail.com>
Link: https://patch.msgid.link/20251210203800.142822-1-elantsew.andrew@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Looking at this commit, I'll analyze it systematically to determine if
it's appropriate for stable backporting.

## 1. COMMIT MESSAGE ANALYSIS

- **Subject:** ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025
- **Problem:** Internal microphone not detected on this laptop model
- **Solution:** Add a DMI quirk entry to enable proper audio detection
- Has proper sign-offs from author and Mark Brown (ASoC maintainer)

## 2. CODE CHANGE ANALYSIS

The change is extremely simple - adding one new entry to the
`yc_acp_quirk_table[]` DMI system identification table:

```c
{
    .driver_data = &acp6x_card,
    .matches = {
        DMI_MATCH(DMI_BOARD_VENDOR, "HONOR"),
        DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
    }
},
```

This follows the **exact same pattern** as all other entries in this
table (System76, MSI, etc.). No new code logic is introduced - it just
adds a hardware identifier to an existing quirk mechanism.

## 3. CLASSIFICATION

This is a **hardware quirk/workaround** - one of the explicitly allowed
exception categories for stable trees:
- Adds DMI identification for a specific laptop model
- Uses existing driver infrastructure (`acp6x_card`)
- Enables hardware that would otherwise not function

This is NOT:
- A new feature
- A new driver or API
- Any kind of refactoring or cleanup

## 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~7 lines (one struct entry)
- **Files touched:** 1 file
- **Complexity:** Trivial
- **Risk:** Extremely low
  - Only affects Honor MagicBook X16 2025 laptops
  - Cannot possibly break other systems
  - If wrong, only that specific device is affected

## 5. USER IMPACT

- **Affected users:** Honor MagicBook X16 2025 laptop owners
- **Bug severity:** Medium-high - internal microphone completely non-
  functional
- **Real-world impact:** Yes - this is a fix for actual shipping
  hardware where a core feature (microphone) doesn't work

Without this quirk, users cannot use video conferencing, voice
recording, or any audio input on this laptop.

## 6. STABILITY INDICATORS

- Maintainer signed off (Mark Brown, ASoC maintainer)
- Follows established pattern used by dozens of other entries in the
  same file
- The AMD YC audio driver has been stable for years

## 7. DEPENDENCY CHECK

- No dependencies on other commits
- Uses existing `acp6x_card` structure that already exists in stable
- The acp6x-mach.c driver has been in the kernel since 5.x series

## CONCLUSION

This commit is a textbook example of what **should** be backported to
stable:

1. **Obviously correct:** Simple table entry following existing pattern
2. **Fixes a real bug:** Internal microphone doesn't work without it
3. **Small and contained:** 7 lines, single file, no logic changes
4. **No new features:** Just enables existing driver for new hardware
5. **Zero risk to other systems:** Only affects one specific laptop
   model
6. **Falls under quirk exception:** Hardware quirks are explicitly
   allowed in stable

DMI quirk additions like this are routinely backported to stable trees
because they provide significant user benefit (making hardware work)
with essentially zero risk to existing functionality.

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f210a253da9f..bf4d9d336561 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -661,6 +661,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7UCX"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0

