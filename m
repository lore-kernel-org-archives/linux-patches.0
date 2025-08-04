Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEB112FF69;
	Mon,  4 Aug 2025 00:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267168; cv=none; b=gh0BkaMdLyMqdK4vpWyW40IqEtRAY8dxNSMuI0dbIRGF9PTQgYSSGZfmuKo6GepPlziNb3hyroJ00ff1XRTaaIbAGAevq2BA5lswFCV8osHgSaQAiSQwH8onuJxIrNP5Nf9sBIjKZl0DeO2MnyXXpPCIxKo0lXsqpgg256iaG7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267168; c=relaxed/simple;
	bh=swTZ1CegOsW3PbwQOV/KPcDl8K6aCmADC2VNGJgX7XY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tTq7xzT0hR+2uiLa/Lg7ayIIEKasI+wCEafN0ANEHqbxb8OjWRWV2npT71DsuZ3S9ijB6kWliLtPBtDDhkzF9Pux8WpdD1D9Rs4zQ4c+Db9TW9Y8n+1DzaXVZEs/okZ6scHncDrSU39aufAY6aARfrv/RRalgJUHFUIv47Xk6rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=babcwdvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="babcwdvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6CCC4CEEB;
	Mon,  4 Aug 2025 00:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267168;
	bh=swTZ1CegOsW3PbwQOV/KPcDl8K6aCmADC2VNGJgX7XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=babcwdvyL0nAPlM45wENBAUz71i+bQSoT9AVmFYhwdtKNUgHWN5oo11eU+Nk4RbVa
	 qbRICy+HAq4dX3FZuCxuYmtKAZLQzp85ikJEwZ5/JNoV+K/xqfxX/u6K7GkVx/UQ1g
	 /q7f1oeNxwkWqJFhkloTwfSIX8SVrrB6DaFb71md25+nkzHve9+T3hdODkkXhIa40M
	 ZxP6ylsyhYETgA04aY2MDCMTCMPUExIP+y9lTE0r3GXYtoc3Z+YEgr0LXfa0Qq0or+
	 nFkXHweZrhfaAsTkHejb5W0UyhnWXVFMGJ55+inojAPHpFsO5ukQ8AxRQUWzft2Wsr
	 vlTgq52IOfp5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mstrozek@opensource.cirrus.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.16 53/85] ASoC: SDCA: Add flag for unused IRQs
Date: Sun,  3 Aug 2025 20:23:02 -0400
Message-Id: <20250804002335.3613254-53-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 775f5729b47d8737f4f98e0141f61b3358245398 ]

Zero is a valid SDCA IRQ interrupt position so add a special value to
indicate that the IRQ is not used.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250624122844.2761627-6-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture of the issue. Let me provide my analysis:

**Backport Status: YES**

This commit fixes a subtle but important bug in the SDCA (Smart Digital
Class-D Amplifier) subsystem's interrupt handling. Here's why this
should be backported:

1. **It fixes a real bug**: Without this change, when the `mipi-sdca-
   control-interrupt-position` property is missing from the device
   tree/ACPI, the `control->interrupt_position` field remains
   uninitialized (even though memory is zero-initialized with
   `devm_kcalloc`, it's still 0). Since 0 is a valid interrupt position
   in SDCA, this causes the code to incorrectly treat controls without
   interrupts as having interrupt position 0.

2. **The bug has functional impact**: Looking at the interrupt handling
   code in `sdca_irq_populate()` (added in commit b126394d9ec6), it
   checks:
  ```c
  if (irq == SDCA_NO_INTERRUPT) {
  continue;
  }
  ```
  Without this fix, controls that should have no interrupt (property
  missing) would be incorrectly processed as having interrupt position
  0, potentially causing:
   - Incorrect interrupt registration
   - Conflicts with legitimate interrupt position 0 handlers
   - Runtime errors when the interrupt framework tries to handle non-
     existent interrupts

3. **The fix is minimal and safe**: The change simply adds:
  ```c
  else
  control->interrupt_position = SDCA_NO_INTERRUPT;
  ```
  This ensures that when the interrupt position property is missing, the
  field is explicitly set to -1 (SDCA_NO_INTERRUPT) instead of remaining
  0.

4. **It follows stable tree rules**:
   - Fixes a clear bug (uninitialized/incorrectly initialized field)
   - Small, contained change (2 lines added)
   - No architectural changes or new features
   - Low risk of regression
   - Only affects SDCA subsystem

5. **The bug exists in stable kernels**: The interrupt handling code
   that depends on this distinction was added in commit b126394d9ec6
   ("ASoC: SDCA: Generic interrupt support"), so any stable kernel that
   includes that commit needs this fix.

The commit message clearly states the problem: "Zero is a valid SDCA IRQ
interrupt position so add a special value to indicate that the IRQ is
not used." This is a classic initialization bug where the absence of a
value (property not present) needs to be distinguished from a valid zero
value.

 include/sound/sdca_function.h   | 2 ++
 sound/soc/sdca/sdca_functions.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/sound/sdca_function.h b/include/sound/sdca_function.h
index eaedb54a8322..b43bda42eeca 100644
--- a/include/sound/sdca_function.h
+++ b/include/sound/sdca_function.h
@@ -16,6 +16,8 @@ struct device;
 struct sdca_entity;
 struct sdca_function_desc;
 
+#define SDCA_NO_INTERRUPT -1
+
 /*
  * The addressing space for SDCA relies on 7 bits for Entities, so a
  * maximum of 128 Entities per function can be represented.
diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index de213a69e0da..dd503acc0c77 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -911,6 +911,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 				       &tmp);
 	if (!ret)
 		control->interrupt_position = tmp;
+	else
+		control->interrupt_position = SDCA_NO_INTERRUPT;
 
 	control->label = find_sdca_control_label(dev, entity, control);
 	if (!control->label)
-- 
2.39.5

