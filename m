Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836D1E5B63;
	Sat, 14 Feb 2026 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031254; cv=none; b=VFLgmfzttbswdOA1QC5pc+Tpcg/abezB58FcJjEYQlMEsCPCbyKBuIxtbZHuT+rA1kz1VzyYxWq8FJfftsrwWEg2hwgs5yhlQt3xECP9x5lgpblYxdl+LWMrsf+pOLnF/6hd5Fekj9fqyLdRcRiRMm5lzZS9ZNnIPMrAhnoFDn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031254; c=relaxed/simple;
	bh=AOhoK7iaQfSvFBn6Bfj98kL+WvUmkWg8zJklNjmc44Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV6WlVy2iKCt4SmiiU3pEaq2t6aM4XwApfI1+g9S6TnMPrC3O5IGpmWbkJkKGLNXlFHFP0L3R9QZSEPB1cfOxgYck2tsGMeVK4WFyoMz7YFg2ym2IDOghdUJYCnRtA5tDE2NHlIZra1zLYuvvzv5Acnd4ksv/+te3wFsQ/BFTBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTSGFlUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTSGFlUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB41C16AAE;
	Sat, 14 Feb 2026 01:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031254;
	bh=AOhoK7iaQfSvFBn6Bfj98kL+WvUmkWg8zJklNjmc44Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTSGFlUHO7aysFGIXp3gp93nKV5Vz/UYi2M/nKEVwHhI/SeUKhKTODmsX0ZYmaoV7
	 M6Fbn0HJraaByjgDS7WaAJRyiIbp9fk0hAR4EH79e3tJ/icis2NudwMJy3+gYy1Hd8
	 i6lwheJsrhmL2fdgkBMnZKCXX+KyKDr3pc/EPQY85ReRZLE03TpQYiU+mR4evSPKt/
	 iXj322sHsKvxNAUn+/8ZPLYBDr3g8CFIlaif1xT/xL5gxkqw2xLSncox5LkYpo1fga
	 oP0nXjtlUAiub8ixd/sVxGDp6AFAqFvdZV21L4CZAZUpJKHMY5kyoLi8bNMCQa0iS6
	 7vo2MkSGag8vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	fengzheng923@gmail.com,
	wens@kernel.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-sound@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.1] ASoC: sunxi: sun50i-dmic: Add missing check for devm_regmap_init_mmio
Date: Fri, 13 Feb 2026 20:00:02 -0500
Message-ID: <20260214010245.3671907-122-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 74823db9ba2e13f3ec007b354759b3d8125e462c ]

Add check for the return value of devm_regmap_init_mmio() and return the
error if it fails in order to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260127033250.2044608-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit adds a missing error check for `devm_regmap_init_mmio()` in
the sun50i-dmic audio driver's probe function. The message is
straightforward - it's adding a return value check that was missing.

### Code Change Analysis

The change is a 3-line addition:
```c
if (IS_ERR(host->regmap))
    return dev_err_probe(&pdev->dev, PTR_ERR(host->regmap),
                         "failed to initialise regmap\n");
```

This is inserted right after `devm_regmap_init_mmio()` returns into
`host->regmap`. Without this check, if `devm_regmap_init_mmio()` fails,
`host->regmap` will contain an ERR_PTR value. The driver then continues
execution and eventually uses this regmap pointer in subsequent
operations (regmap reads/writes), which would cause a NULL pointer
dereference or other crash since the ERR_PTR would be interpreted as a
valid pointer.

### Bug Mechanism

If `devm_regmap_init_mmio()` fails (e.g., memory allocation failure
inside regmap), the error pointer gets stored in `host->regmap`. Later,
when the driver tries to use regmap APIs with this invalid pointer, it
will crash. This is a real bug - a missing error check that leads to use
of an error pointer as a valid pointer.

### Severity Assessment

- **Trigger**: `devm_regmap_init_mmio()` would need to fail, which is
  uncommon but possible (memory pressure, internal regmap errors)
- **Consequence**: Kernel crash/oops when the invalid regmap pointer is
  subsequently used
- **Likelihood**: Low probability but non-zero, especially under memory
  pressure

### Stable Kernel Criteria

1. **Obviously correct and tested**: Yes - this follows the exact same
   pattern as all surrounding error checks in the same function. It's a
   textbook missing error check fix.
2. **Fixes a real bug**: Yes - missing error check on a function that
   can fail, leading to use of an ERR_PTR as a valid pointer.
3. **Important issue**: Moderate - it's a potential NULL deref/crash,
   though the trigger condition is uncommon.
4. **Small and contained**: Yes - 3 lines added, single file, no
   behavioral change on success path.
5. **No new features**: Correct - purely defensive error checking.
6. **Applies cleanly**: The change is self-contained with no
   dependencies.

### Risk Assessment

- **Risk**: Extremely low. The change only affects the error path. On
  the success path, behavior is identical.
- **Benefit**: Prevents a kernel crash if regmap initialization fails.
- **Pattern**: This is a very common type of stable fix - adding missing
  error checks in driver probe functions.

### Concerns

This is a fairly minor fix for an uncommon failure path in a specific
ARM SoC audio driver. The user base is limited to Allwinner sun50i
platforms. However, the fix is trivially correct, has zero risk of
regression, and prevents a real (if unlikely) crash.

### Decision

The fix is small, obviously correct, follows existing patterns in the
same function, prevents a potential crash from using an ERR_PTR, and has
essentially zero regression risk. It meets all stable kernel criteria.

**YES**

 sound/soc/sunxi/sun50i-dmic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sunxi/sun50i-dmic.c b/sound/soc/sunxi/sun50i-dmic.c
index bab1e29c99887..eddfebe166169 100644
--- a/sound/soc/sunxi/sun50i-dmic.c
+++ b/sound/soc/sunxi/sun50i-dmic.c
@@ -358,6 +358,9 @@ static int sun50i_dmic_probe(struct platform_device *pdev)
 
 	host->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 					     &sun50i_dmic_regmap_config);
+	if (IS_ERR(host->regmap))
+		return dev_err_probe(&pdev->dev, PTR_ERR(host->regmap),
+				     "failed to initialise regmap\n");
 
 	/* Clocks */
 	host->bus_clk = devm_clk_get(&pdev->dev, "bus");
-- 
2.51.0

