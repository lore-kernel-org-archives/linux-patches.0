Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416DC23A562;
	Wed,  4 Jun 2025 11:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749037854; cv=none; b=VPkeqy0tiALLDLwiVNTDiEJtzgBl2OZdP8g9dpOgyPfqgOmn8QDN5AzND+XesEn9MShQQV0No1KDZOX96WUWKLvY4NCITjKjks8EzA7KEt7R/ImMgNQGCFsy8XrpxZ89DARtmQMatwl/6YsyGCJHHsVJC7EE689xslEMdOaSh8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749037854; c=relaxed/simple;
	bh=F9N16TAMBxsonCFLJzyb2HtE5z9rIBeHoTfahj8tkO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eDCLGoSoxy6CgzdRQA3esbjTSmQmNMYeMjqnTX8RZqPHkvM7iPo61jxsWXrqwded3J9PJdVqPionpYc3SagIH5sIbzTNZTG/3uCe8fqTNoXElYQrFhkkFuN4yg0VIWwk8CqEbmORsgrLHnSqBKJMxuuvzoiVYhf0ZwCZSvYOzWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/tRP0fO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/tRP0fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3555EC4CEEF;
	Wed,  4 Jun 2025 11:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749037854;
	bh=F9N16TAMBxsonCFLJzyb2HtE5z9rIBeHoTfahj8tkO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/tRP0fOzv6g08K5+cQx9lQ+tEqZcf+L03PJBIlDkqw9D1SG54jDnCBUecqlcipgU
	 vWtqJ/GjfxrikInYk9FVPlfzex4uPyvM6tce53K2jXUfbqjss2fbFx+5KNDzxw4y7e
	 CSCyJviI9WXhjyqjDmcGcuMWwW2SU4bihWmWl1HgsA0iYeBeG64lanZVTGAarOX4wV
	 f1SNgZ34xxbk/H6FsNj3w7pYddhqpVw0KGO5NF9yQlaIXLC2DZxieOof5xHNzlLCTN
	 R2R//uYtOz1MVGsCs3tz8ikaG5UWkXuOgbuccplNI1T+HS7jHtADLeUYkNMuxngyoO
	 fzNLLUlgz8Nwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/5] bus: fsl-mc: increase MC_CMD_COMPLETION_TIMEOUT_MS value
Date: Wed,  4 Jun 2025 07:50:47 -0400
Message-Id: <20250604115050.209756-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604115050.209756-1-sashal@kernel.org>
References: <20250604115050.209756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit 23d060136841c58c2f9ee8c08ad945d1879ead4b ]

In case the MC firmware runs in debug mode with extensive prints pushed
to the console, the current timeout of 500ms is not enough.
Increase the timeout value so that we don't have any chance of wrongly
assuming that the firmware is not responding when it's just taking more
time.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250408105814.2837951-7-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the surrounding code context,
here is my assessment: **YES** This commit should be backported to
stable kernel trees. **Detailed Analysis:** **1. Bug Fix Nature:** This
commit addresses a real timeout issue where legitimate MC firmware
operations can fail due to an inadequate timeout value. The commit
message explicitly states that "In case the MC firmware runs in debug
mode with extensive prints pushed to the console, the current timeout of
500ms is not enough." **2. Code Change Analysis:** The change is minimal
and surgical: - Changes a single timeout constant from 500ms to 15000ms
(15 seconds) - Only affects `drivers/bus/fsl-mc/mc-sys.c:22` - No
architectural changes or new functionality added - The timeout is used
in both `mc_polling_wait_preemptible()` and `mc_polling_wait_atomic()`
functions that handle MC command completion **3. Risk Assessment:** The
change has minimal risk: - Increasing a timeout value is generally safe
and doesn't change behavior for successful operations - Only affects
systems with Freescale/NXP DPAA2 Management Complex hardware - The
original 500ms timeout was clearly insufficient for legitimate use cases
- Similar to successful backports in the reference commits (e.g.,
Similar Commit #1 and #3 which both increased timeouts) **4. Impact and
Importance:** - Fixes a real user-facing issue where MC commands fail
with timeouts during firmware debug scenarios - The FSL-MC bus is
critical infrastructure for DPAA2 networking architecture on NXP ARM
SoCs - Timeout failures can cause device initialization problems and
system instability - The `mc_send_command()` function is used
extensively throughout the FSL-MC subsystem for all hardware
communication **5. Comparison with Similar Commits:** - Very similar to
Similar Commit #1 (UCSI timeout increase from 1s to 5s) - **Status:
YES** - Very similar to Similar Commit #3 (MLX5 timeout decrease from 2
hours to 60s) - **Status: YES** - Both of these were timeout adjustments
that got backported successfully **6. Subsystem Scope:** The change is
contained within the FSL-MC bus driver subsystem and only affects NXP
DPAA2 hardware platforms, making it a safe candidate for stable trees.
**7. Explicit Stable Tree Criteria:** This meets the stable tree
criteria: - Fixes an important bug affecting real users - Small and
contained change with minimal regression risk - No new features or
architectural changes - Addresses a timeout issue that can cause system
functionality problems The commit represents a classic example of a
safe, important bug fix that should be backported to help users
experiencing MC command timeouts in production environments, especially
during firmware debugging scenarios.

 drivers/bus/fsl-mc/mc-sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/mc-sys.c b/drivers/bus/fsl-mc/mc-sys.c
index 3221a7fbaf0ad..24307ed59d777 100644
--- a/drivers/bus/fsl-mc/mc-sys.c
+++ b/drivers/bus/fsl-mc/mc-sys.c
@@ -19,7 +19,7 @@
 /**
  * Timeout in milliseconds to wait for the completion of an MC command
  */
-#define MC_CMD_COMPLETION_TIMEOUT_MS	500
+#define MC_CMD_COMPLETION_TIMEOUT_MS	15000
 
 /*
  * usleep_range() min and max values used to throttle down polling
-- 
2.39.5

