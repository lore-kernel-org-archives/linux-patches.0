Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD9415A8;
	Mon,  4 Aug 2025 00:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267900; cv=none; b=KKr8J1dCwwBXW3boz7c7BRMO34bPxJiatfTw5wIoSgMpctBXG57zpGgWaH11hU888OghQ4crEUTzIlqpJjojVHTCw/44B+4h2YL5Dl4oF0o6csFvdEXtZzwdB1Z36Aj3tdlgBwi50/0qiGqQ4WKctPWYyeC1xvrORnP24V7MHFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267900; c=relaxed/simple;
	bh=QjozxAtGGi0yMJ9NOKaeGjGmsATS1b880Egg0Sgoozc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNv1C6YujJp+X5V9yNzrJH+6UmSclLX4pPvCC7jspbQ45UlpY+b96SCWE812bsIyC/JMwdiUiTFLH/3E/dvdfaONDuEf2wyX01w+0v20dtQQ1vg6Gh6qNXNKKryWlLNoWHz9IWkyFjcV507G9FZAW99atGGUbfXply1ulqDyULM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAkVSioj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAkVSioj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B46CC4CEF8;
	Mon,  4 Aug 2025 00:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267900;
	bh=QjozxAtGGi0yMJ9NOKaeGjGmsATS1b880Egg0Sgoozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAkVSioj9iVFOv7SO2c+PA8ygAfAYZug58mrRRzarmcCNmBNP9VAlR6SZO1kBG9kl
	 GAVCL/eiHVMtWM08TGj/0rdIkb2RQcbpJwEqjsodMk05Xyo/rtSvGIcjyN/YuJzT+g
	 a3qmUG9uixLwcoIjO2cF/qjn4ROlWRZxwcZHzQ0C+eDbfV2SLyDvoNFmTcuTG/GmfF
	 W/lPViIUmJ0agrs0/XGzLJcV5Y9cIpTSLhpygX04uCL9aM1Xa/oh2KY9y8s2yj3Jw2
	 9XVdFgGMrJYPcU1htfUQrFPVqjNkSETkboCJ5OleHF5ZFXyZgoZhBXXEZfOOzZ2ZNX
	 Q6K3FVceSxknA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 41/51] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isn't present
Date: Sun,  3 Aug 2025 20:36:33 -0400
Message-Id: <20250804003643.3625204-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003643.3625204-1-sashal@kernel.org>
References: <20250804003643.3625204-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.147
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
index 87e2c9130607..a6936fc59d1e 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -667,7 +667,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5

