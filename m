Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959C1C84C6;
	Mon,  4 Aug 2025 00:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267767; cv=none; b=upeDVLGn2cbiTYDQKVWfKbbtnSUaFbjQX5iy+UQ7n+bwhpCVFEwZLY+2aJsxdCNn1B3ITLqhpStf3xVeiezegH4ZnvUOxpP+dY0FLrs6M4rygC3FU2DrZfZx63808Ik5LXeEqYgDlm31PsiRE8UORrky4Kn5VsL9K2AmFnFIg6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267767; c=relaxed/simple;
	bh=ralCMjKy2/vdemwApL9OS0p4ByUYxtXDHpsZJTp4NUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGsgs5wHcpcn9KAILf4izrNIxgKZiKGz1Sqqptclfr6J4npr3dmWL26SAXytlN2FCxZelt2Zie7y7uAAmerupwiABG+AnBeynTfdwHayFNzxLQazsuRlE1x+hKwPBGOl7vBi4/B1OLfk9i5qUQw+auUg2Exh9SSJhPhAHIrgGwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxVCGfDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxVCGfDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38F5C4CEF8;
	Mon,  4 Aug 2025 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267767;
	bh=ralCMjKy2/vdemwApL9OS0p4ByUYxtXDHpsZJTp4NUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxVCGfDZS93Gyq30Yo+9oLdjhGIKJJwzWtKjb3pQyGuHkQP0zq8AZKQyTfMrm36cH
	 OY83Nsl7F3xO7OT/trcW6TiAs2lPlLiKru2PGxZpAYdD6t0A/bXn5892TvlkXP86H6
	 8K5Rfwh3WglEcCmHo1t614dvEAST6GXXTdoZkzNb7og9p4Yb7AiReBpuq6NkZIXOam
	 TEVddRjcodBSSY/AtZpRyQq4UTEnJwQIrnVis0TXlXoKv8RKeSqoGx4+FTPgZbgpLj
	 x/OFf0AuPgGc4yYpdcpe8sXO3pIIzNpamgHUqsTb8NyzFJ2ve0JDlDlJf3Blok/V8b
	 yucldPuq8Y0WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 46/59] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isn't present
Date: Sun,  3 Aug 2025 20:34:00 -0400
Message-Id: <20250804003413.3622950-46-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomasz Michalec <tmichalec@google.com>

[ Upstream commit df9a825f330e76c72d1985bc9bdc4b8981e3d15f ]

If pmc_usb_probe is called before SCU IPC is registered, pmc_usb_probe
will fail.

Return -EPROBE_DEFER when pmc_usb_probe doesn't get SCU IPC device, so
the probe function can be called again after SCU IPC is initialized.

Signed-off-by: Tomasz Michalec <tmichalec@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250610154058.1859812-1-tmichalec@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the kernel codebase, here's my
assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear Bug Fix**: The commit fixes a real probe ordering issue where
   `pmc_usb_probe` fails if called before the SCU IPC driver is
   initialized. The current code returns `-ENODEV` which prevents the
   driver from ever loading, while `-EPROBE_DEFER` allows the kernel to
   retry probing later.

2. **Established Pattern**: Looking at the codebase, other Intel
   platform drivers that depend on SCU IPC already use this pattern:
   - `drivers/watchdog/intel-mid_wdt.c`: Returns `-EPROBE_DEFER` when
     `devm_intel_scu_ipc_dev_get()` returns NULL
   - `drivers/mfd/intel_soc_pmic_bxtwc.c`: Returns `-EPROBE_DEFER` in
     the same scenario
   - `drivers/platform/x86/intel/telemetry/pltdrv.c`: Also uses
     `-EPROBE_DEFER`

3. **Small and Contained Change**: The fix is a one-line change
   (`-ENODEV` → `-EPROBE_DEFER`) that only affects the error handling
   path during probe. It doesn't introduce new functionality or change
   any existing behavior when SCU IPC is available.

4. **No Architecture Changes**: This is purely a bug fix that corrects
   incorrect error handling. It doesn't introduce new features or make
   architectural changes to the driver.

5. **Minimal Risk**: The change is extremely low risk - it only affects
   the error path when SCU IPC isn't yet available, and the deferred
   probe mechanism is a well-established kernel pattern designed
   specifically for handling driver dependencies.

6. **Real-World Impact**: Without this fix, users could experience USB
   Type-C functionality failures on Intel platforms if the drivers
   happen to probe in the wrong order. This is particularly problematic
   on systems where driver probe order is non-deterministic.

The commit follows the stable tree rules by fixing an important bug
(probe failure due to ordering) with minimal risk and no new features.
The fact that other Intel drivers already use this pattern confirms this
is the correct approach for handling SCU IPC dependencies.

 drivers/usb/typec/mux/intel_pmc_mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 60ed1f809130..a174ff7a9abd 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -730,7 +730,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5

