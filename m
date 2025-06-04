Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C89524BBE4;
	Wed,  4 Jun 2025 11:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749037794; cv=none; b=lSFYiQw/j8Jn5/GOTlTpGuTJ0nuyHNg9JcliLzQXqki10tz33jQq12hhUtf9OvaTUSjNvOh+PAmhFRqoygGWl4yeAtyoeaalayKSjXkjhOMmnCJnqTzMEwiQxcpCShjSoTIR8ilcopm05zDtJ+ZrqV/ncq2H19RQAyT73T6zmKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749037794; c=relaxed/simple;
	bh=LWoCnVWu9kyApgL0kLFdiS1HexGeNKcPhWj+9WD/Kfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gomj5UmTXUFkpp5NrsjdLRz7w3NbK2zHftl0Uptz2xL9kY6iGOsVh38M1MdsxQNP6TYk5XU/e1TSB3DBI4dX3gRq3sJ73FgMiso8DcKxFL+2DoO+mUyVYEbhw4b6R4sLApatEBfwHAPLsCLWq9eU6G/9TDI44dtZvAPEOb5wbk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD1+vIdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD1+vIdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F0AC4CEE7;
	Wed,  4 Jun 2025 11:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749037793;
	bh=LWoCnVWu9kyApgL0kLFdiS1HexGeNKcPhWj+9WD/Kfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD1+vIdlvALfa654LyRw7iwQtzrVx4c5UTxu1fsr3/qFEU2EQAh5zxPuSeiZLogza
	 5EdH9kBuU2R3zN8nPhYcZv5r4q7rIMwP6mAmzMLByhBxTwklCCxMaTp9iwUH/JfVLj
	 //Zo1sHvaA3KiElX6e+UhROfdXPTpkzXVgE0LAj7s0b/t6F7bUaSIWnxCUvHq1+FhO
	 Btkx+Yp+dHFR4/gszF35OfGlVWy73boOATwxqOVwvzVH20uOxHL/mK4oAAMgGBMt7k
	 yEB6ijCtTUxRbvSVGIxx5TSnKAoDe+m4eLdEsXkTYDOu5Vv85HFTMxH9CVCXC8k2R3
	 sSYBsUttWiDXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 5/8] bus: fsl-mc: increase MC_CMD_COMPLETION_TIMEOUT_MS value
Date: Wed,  4 Jun 2025 07:49:40 -0400
Message-Id: <20250604114944.208828-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604114944.208828-1-sashal@kernel.org>
References: <20250604114944.208828-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index f2052cd0a0517..b22c59d57c8f0 100644
--- a/drivers/bus/fsl-mc/mc-sys.c
+++ b/drivers/bus/fsl-mc/mc-sys.c
@@ -19,7 +19,7 @@
 /*
  * Timeout in milliseconds to wait for the completion of an MC command
  */
-#define MC_CMD_COMPLETION_TIMEOUT_MS	500
+#define MC_CMD_COMPLETION_TIMEOUT_MS	15000
 
 /*
  * usleep_range() min and max values used to throttle down polling
-- 
2.39.5

