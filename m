Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEE939EF1E;
	Mon, 23 Mar 2026 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277019; cv=none; b=tmnJgAUL0Ayj5VFzDFJGpOWZ2lJSXmvTfWJmuDns5nb9jzdzMtHjz7ZobYK/RnHO6A9w8ZlXzksQb5+KbvBS8wO8wQsakGTTzFyE6fcN7Ic4uMHXRROE80L3QET9ar8VCTyi5HpJNxI68H5Cjsi72w5hAaHT8ciZLVsC8CF/7yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277019; c=relaxed/simple;
	bh=3r85FM79r8VvIMm/lL2RzBClF5vT5nK/6w897MvIBOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsPpgqKGNUcg5b03O8hKGAFxVa+IENk98wDjIk9tfQd3WfmASVsto9U8k3paPEP54H7Icgon9egvR/RSt8VMllZ0GlI8v/rgmwOS2u9N/OkU8VpSTaixSdYzBaZOXR/fBTW4SXXU0oMrm/a37kg8XBQ5HKBHYgzLDe32ckdQOyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVrRm4Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVrRm4Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307BFC4CEF7;
	Mon, 23 Mar 2026 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277019;
	bh=3r85FM79r8VvIMm/lL2RzBClF5vT5nK/6w897MvIBOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVrRm4DkkoxM6X3iN7rpX7/jWlVW2ibbSw4dkeGQSEtpwCjTTF35Q23lUsUw5kUcl
	 p6qGtRaiIQ66xs/pw+eqj7Ny+DyLAPPl472BH7flPz6Tr12reomXsQBXCuIxukwgeH
	 7hsqhRH6Sm9XlaH+1uT6cEz6w4HEx/+dQN7yobzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/460] mmc: dw_mmc-rockchip: use modern PM macros
Date: Mon, 23 Mar 2026 14:44:03 +0100
Message-ID: <20260323134532.567489090@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 4b43f2bcc84dd550c1a847318db02165d2829573 ]

Use the modern PM macros for the suspend and resume functions to be
automatically dropped by the compiler when CONFIG_PM or
CONFIG_PM_SLEEP are disabled, without having to use #ifdef guards.

This has the advantage of always compiling these functions in,
independently of any Kconfig option. Thanks to that, bugs and other
regressions are subsequently easier to catch.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20250815013413.28641-39-jszhang@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 6465a8bbb0f6 ("mmc: dw_mmc-rockchip: Fix runtime PM support for internal phase support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-rockchip.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -568,11 +568,8 @@ static void dw_mci_rockchip_remove(struc
 }
 
 static const struct dev_pm_ops dw_mci_rockchip_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				pm_runtime_force_resume)
-	SET_RUNTIME_PM_OPS(dw_mci_runtime_suspend,
-			   dw_mci_runtime_resume,
-			   NULL)
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+	RUNTIME_PM_OPS(dw_mci_runtime_suspend, dw_mci_runtime_resume, NULL)
 };
 
 static struct platform_driver dw_mci_rockchip_pltfm_driver = {
@@ -582,7 +579,7 @@ static struct platform_driver dw_mci_roc
 		.name		= "dwmmc_rockchip",
 		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
 		.of_match_table	= dw_mci_rockchip_match,
-		.pm		= &dw_mci_rockchip_dev_pm_ops,
+		.pm		= pm_ptr(&dw_mci_rockchip_dev_pm_ops),
 	},
 };
 


