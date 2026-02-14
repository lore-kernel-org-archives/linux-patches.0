Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6499DDF59;
	Sat, 14 Feb 2026 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030710; cv=none; b=JmlbTstPFgOEW9xuflmeM3+uVlvof2zERJQh2tJpNUo2vTjD/sSl9jwVCC+ajYFdlVIB1ugBwImtr9UsyULtcB9haHTD9Icvzixuj7qY+khEpljG6J49i1LOQCr4+IXDZjj6vAQ6Nno1nxCvlqOlROLEW8fyaEY56WLc63p+/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030710; c=relaxed/simple;
	bh=NEWEBH7sq+zU2qhpQKKuTK0qk9D0GCwG/6uIPj/b1Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1wovtVlNb+3LOtp/sCYFKZfDIYQ+z/FAkgPRKBXKxhyUN7tVnrbgWbXTEGpN51bGgwIv8XbwNI9+yP0GhvhuE8F1O3XsGIq3Di0j9KijmF8bTmzspXIHrBLeeiE0bjHzLYIqSxiv1HHqUK+YfeoGH9JAX+rMyNqX+1/cqgfItE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQacjNJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQacjNJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88F0C16AAE;
	Sat, 14 Feb 2026 00:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030710;
	bh=NEWEBH7sq+zU2qhpQKKuTK0qk9D0GCwG/6uIPj/b1Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQacjNJqTN9vCo8aKrgcjCirDzQfC3X1DShrc8qFEHjXH7+t4FNGgic77si4k2/R2
	 Y7tRTLeBpOYIGuHEFWzzCKX8YZUKI5pT1ngcdVmMpRmcC8OZGXztgNhOIgBmf8sdfk
	 K+un3D/ApRtP5xlCApe9GKaegZTDdRMRfX4iD7PuZzh5sTLiHfoAHB5rsQ57jhnu9j
	 eWH1uKn0gAag8j7oUo8K4Z5xcIUmaur+ny+sigkR8ye7eTdysXToe3m1t+d1w0INWh
	 XPWJH/jtulXCXYBl+p3Ym+KwWWP8+5Rep3C2YTDDxbYMK9SLr6+plyHA+XKliZQNNo
	 kVMbHgyY/1Hqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peng Fan <peng.fan@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.18] soc: imx8m: Fix error handling for clk_prepare_enable()
Date: Fri, 13 Feb 2026 19:58:08 -0500
Message-ID: <20260214005825.3665084-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214005825.3665084-1-sashal@kernel.org>
References: <20260214005825.3665084-1-sashal@kernel.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f6ef3d9ff81240e9bcc030f2da132eb0f8a761d7 ]

imx8m_soc_prepare() directly returns the result of clk_prepare_enable(),
which skips proper cleanup if the clock enable fails. Check the return
value of clk_prepare_enable() and release resources if failure.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202601111406.ZVV3YaiU-lkp@intel.com/
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Interesting - in v6.15 and earlier, `clk_prepare_enable()` was called
without checking its return value at all, but the code continued with
proper cleanup on the success path. The v6.15 code has a different
(arguably less severe) issue - it doesn't check `clk_prepare_enable()`
return value but doesn't leak resources on normal exit.

Now I have a complete picture. Let me write the analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit title explicitly says "Fix error handling for
clk_prepare_enable()". The message clearly describes the bug:
`imx8m_soc_prepare()` directly returns the result of
`clk_prepare_enable()`, bypassing the `err_clk` cleanup label when the
clock enable fails. This is a resource leak bug.

**Reporters:** Kernel test robot (lkp) and Dan Carpenter (well-known
Smatch/static analysis developer). This means the bug was found via
static analysis (Smatch), not a runtime crash report. The presence of
"Closes:" link to a kernel test robot report confirms this.

**Reviews:** Two Reviewed-by tags (Marco Felsch and Daniel Baluta),
indicating the fix was validated by subsystem developers.

### 2. Code Change Analysis

The bug is in `imx8m_soc_prepare()`:

```131:156:drivers/soc/imx/soc-imx8m.c
static int imx8m_soc_prepare(struct platform_device *pdev, const char
*ocotp_compatible)
{
        // ... setup code ...
        drvdata->ocotp_base = of_iomap(np, 0);    // resource 1: iomap
        // ...
        drvdata->clk = of_clk_get_by_name(np, NULL);  // resource 2:
clock ref
        // ...
        return clk_prepare_enable(drvdata->clk);   // BUG: if this
fails, ocotp_base is leaked!

err_clk:
        iounmap(drvdata->ocotp_base);
        return ret;
}
```

**The bug mechanism:** When `clk_prepare_enable()` fails, the function
returns directly with the error code, skipping the `err_clk` label which
calls `iounmap(drvdata->ocotp_base)`. This leaks:
1. The `ocotp_base` iomap mapping (definite leak)
2. The clock reference from `of_clk_get_by_name()` (also leaked, since
   `clk_put()` is not called - this is arguably still not fully fixed,
   but the `err_clk` label was designed for the `of_clk_get_by_name`
   failure case where `clk_put` should not be called)

**The fix:** Check the return value, jump to `err_clk` on failure, which
properly unmaps `ocotp_base`:

```diff
- return clk_prepare_enable(drvdata->clk);
+       ret = clk_prepare_enable(drvdata->clk);
+       if (ret)
+               goto err_clk;
+       return 0;
```

**Note:** There is a subtlety - when `clk_prepare_enable()` fails, the
`err_clk` label only calls `iounmap()` but not `clk_put()`. The clock
reference obtained from `of_clk_get_by_name()` is still leaked. However,
this is a separate (pre-existing) concern. The fix as written is still
an improvement: it's strictly better than the old code.

### 3. Dependency/Prerequisite Analysis

This is **critical** for the backport decision:

- The function `imx8m_soc_prepare()` was introduced in commit
  `390c01073f5d0` ("soc: imx8m: Cleanup with adding
  imx8m_soc_[un]prepare"), which first appeared in **v6.16-rc1**.
- This means the **buggy code does NOT exist** in v6.15 or any earlier
  stable tree (v6.14, v6.13, v6.12, v6.6, v6.1, 5.15, etc.).
- The bug was introduced in v6.16 and the fix only applies to
  **v6.16.y** stable and newer (v6.17.y, v6.18.y if applicable).
- I confirmed the buggy code exists identically in v6.16.12 (latest
  v6.16 stable), so the fix would apply cleanly.

### 4. Scope and Risk Assessment

- **Size:** 5 lines changed (+5/-1) in a single file - extremely small
  and surgical.
- **Risk:** Essentially zero. The fix only changes the error path
  behavior (adds proper cleanup). The success path (when
  `clk_prepare_enable()` works) is unchanged (returns 0 instead of the
  return value of `clk_prepare_enable()`, but those are equivalent on
  success).
- **Subsystem:** SoC driver for NXP i.MX8M family, a widely-used
  embedded platform.

### 5. User Impact

- **Affected hardware:** All i.MX8M family SoCs (i.MX8MQ, i.MX8MM,
  i.MX8MN, i.MX8MP) - very common in embedded/industrial/automotive use.
- **Trigger likelihood:** Low in practice. `clk_prepare_enable()` for
  the OCOTP clock is unlikely to fail on real hardware under normal
  conditions.
- **Severity if triggered:** Resource leak (iomap + clock reference).
  Not a crash, not security-critical, not data corruption. On repeated
  failures (e.g., in a test environment or if the clock framework has
  issues), could contribute to resource exhaustion.
- **Detection method:** Static analysis (Smatch/kernel test robot), not
  a user report.

### 6. Classification

This is a **real bug fix** - it fixes a resource leak on an error path.
It falls into the category of "error path changes that fix resource
leaks," which is explicitly identified as backport-worthy material
despite being described as a "cleanup."

### 7. Stable Criteria Check

| Criterion | Assessment |
|---|---|
| Obviously correct and tested | Yes - trivially correct, reviewed by 2
developers |
| Fixes a real bug | Yes - resource leak on error path |
| Important issue | Moderate - resource leak, not crash/corruption |
| Small and contained | Yes - 5 lines in 1 file |
| No new features/APIs | Correct |
| Applies cleanly | Yes - to v6.16.y |

### Conclusion

This is a small, obviously correct fix for a resource leak in the i.MX8M
SoC driver's error handling path. The fix is surgical (5 lines), well-
reviewed, and applies cleanly to v6.16.y stable (the only stable tree
that has the affected code). While the bug is unlikely to trigger in
practice (it requires `clk_prepare_enable()` to fail), the fix has
essentially zero regression risk and properly handles an error path that
should have been handled from the start. The fix was reported by kernel
test robot and Dan Carpenter, two well-known automated and manual static
analysis sources, and was reviewed by two subsystem developers.

The fix is appropriate for v6.16.y stable backport. It does NOT apply to
older stable trees (v6.15.y and below) because the affected function was
introduced in v6.16.

**YES**

 drivers/soc/imx/soc-imx8m.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 04a1b60f2f2b5..8e2322999f099 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -148,7 +148,11 @@ static int imx8m_soc_prepare(struct platform_device *pdev, const char *ocotp_com
 		goto err_clk;
 	}
 
-	return clk_prepare_enable(drvdata->clk);
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto err_clk;
+
+	return 0;
 
 err_clk:
 	iounmap(drvdata->ocotp_base);
-- 
2.51.0

