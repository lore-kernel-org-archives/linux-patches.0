Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5039C2F1FEE;
	Thu,  9 Oct 2025 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025545; cv=none; b=Tcf+lP9Y0+bfaKPh61VTJpF7iUZ62RB4NSzpImYjZkwsTid20S+aYs2jQ+WXt4rXEO4Vyzk4UufPWVsPdkdkhVGrqeEyt42He2X/o4IdtF+7XkjzGRstmi/yJW9EwBNlkj81ZENXNrhxvyQPp2Jt2MyPEYZEEkO6B+D3kCWOT4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025545; c=relaxed/simple;
	bh=CD3UaiplXwCAXudyGmhhZvpteFNi3RC7+1ZFFBBPEjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qi89EpG6HulvA6tmO1fx7Jk2aVjE5DDiFaqB6voGh0nDvR6s74ocXVBFWI3xQRcAn30Mz2xMqwu5hwsXAfpMzePOPOYYgTi7n580mnqwpLRlj/SrEKTu2rYw5av+pc8Mxbig3ro4yycQbm1AUoPrfNRNzakRSs5yRLW/pfXQnn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqYgUHXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqYgUHXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71070C4CEE7;
	Thu,  9 Oct 2025 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025543;
	bh=CD3UaiplXwCAXudyGmhhZvpteFNi3RC7+1ZFFBBPEjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqYgUHXRfq2Bn3TZ45DUQ8UvPQ2m3wC+zbntF9QPuCszrvfjG2HxFefwcwX2BpcFY
	 fo9quhYJDdxHp59cPvYtOmOYQlteUvkIf65Exm8kpgCQI2UR70zqJcVS8bvR53YEmg
	 eSRpMzJ7xzqMdnT9ZdqIBIvzj8CgOv3OuD4MCGUy4d+hC4rqIUMLgKm3XigMu46Np9
	 PjdE0KHiR5ZgWlCjhc0GuldnQjerA2JL87AiRTWpEY/d6tQ1VHbOYQ9KEX7Wduk0EO
	 zKhR4wUeSHYrTbQ5J7W4A64n1jfO62lr30Zz5OUR/NJgvZGA0/00QvHw1O1gZcI3Hd
	 +TSdDaY54AlqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	wsa+renesas@sang-engineering.com,
	Shyam-sundar.S-k@amd.com,
	quic_msavaliy@quicinc.com,
	jorge.marques@analog.com,
	xiaopei01@kylinos.cn,
	sakari.ailus@linux.intel.com
Subject: [PATCH AUTOSEL 6.17-6.16] i3c: dw: Add shutdown support to dw_i3c_master driver
Date: Thu,  9 Oct 2025 11:55:04 -0400
Message-ID: <20251009155752.773732-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manikanta Guntupalli <manikanta.guntupalli@amd.com>

[ Upstream commit 17e163f3d7a5449fe9065030048e28c4087b24ce ]

Add shutdown handler to the Synopsys DesignWare I3C master driver,
ensuring the device is gracefully disabled during system shutdown.

The shutdown handler cancels any pending hot-join work and disables
interrupts.

Signed-off-by: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
Link: https://lore.kernel.org/r/20250730151207.4113708-1-manikanta.guntupalli@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What Changed
  - Adds a platform shutdown callback and handler that runs on system
    shutdown, `dw_i3c_shutdown()` in
    `drivers/i3c/master/dw-i3c-master.c:1740–1760`. It:
    - Powers the controller for safe register access via
      `pm_runtime_resume_and_get()` (1745–1751).
    - Cancels pending hot-join work to avoid races/UAF,
      `cancel_work_sync(&master->hj_work)` (1753).
    - Disables all interrupts by clearing the controller’s enable masks,
      writing `(u32)~INTR_ALL` to `INTR_STATUS_EN` and `INTR_SIGNAL_EN`
      (1756–1757).
    - Balances PM with `pm_runtime_put_autosuspend()` (1759).
  - Hooks the handler into the driver so it actually runs at shutdown:
    `.shutdown = dw_i3c_shutdown` in the platform driver struct,
    `drivers/i3c/master/dw-i3c-master.c:1774–1784`.

- Why It Matters
  - Prevents hot-join work from running while the system is shutting
    down:
    - Hot-join IBI detection queues `hj_work` (see `queue_work(...,
      &master->hj_work)` at
      `drivers/i3c/master/dw-i3c-master.c:1451–1453`; initialized at
      1595). Without canceling it, shutdown/kexec can race with work
      that touches device state, risking use-after-free or undefined
      behavior. This complements the prior “remove” path fix that
      already cancels `hj_work` before unregister (see
      `dw_i3c_common_remove()` cancel, 1617).
  - Ensures the controller won’t assert or signal further interrupts
    after the OS is going down:
    - Normal operation explicitly enables only needed IRQs (see
      `dw_i3c_master_set_intr_regs()` programming `INTR_STATUS_EN` and
      `INTR_SIGNAL_EN` with `INTR_MASTER_MASK` at 533–534), but
      previously there was no explicit “all-off” step for system
      shutdown.
    - Disabling IRQs in the shutdown path removes a common source of
      stray interrupts that can disturb kexec/kdump or
      firmware/bootloader takeover.
  - Uses runtime PM to guarantee clocks/resets are up before touching
    registers (1745–1751), mirroring existing, consistent patterns
    elsewhere in this driver (e.g., CCC, DAA, xfers), minimizing risk of
    register access with clocks off.

- Scope, Risk, and Backport Considerations
  - Scope is small and contained to a single driver: one new function
    and one platform_driver hook. No API/ABI changes, no architecture-
    level changes, and it runs only during shutdown.
  - The logic is defensive and mirrors established patterns in this
    driver:
    - Work cancellation mirrors the removal path (1617) and addresses
      the same class of race, now for the shutdown path.
    - Interrupt gating aligns with how the driver sets them during
      resume/init (516–540) and the ISR’s gating on `INTR_STATUS_EN`
      (1463–1470).
  - Dependencies: relies on runtime PM support and hot-join work being
    present in the driver (introduced in recent kernels). Backport is
    straightforward for stable series that already include:
    - Hot-join support (hj_work/IBI HJ queuing).
    - The driver’s runtime PM support.
    - For older trees lacking those pieces, the patch either won’t apply
      or would need adaptation; it’s most appropriate for newer stable
      lines (e.g., v6.11+ where PM support landed, v6.10+ for HJ work).
  - Commit message has no explicit “Cc: stable” or “Fixes:” tag, but
    this is a classic shutdown-path robustness fix preventing race and
    stray IRQ issues; it fits stable rules: it fixes a real shutdown
    bug, is minimal and low risk, and is confined to the I3C DW master
    driver.

Conclusion: This is a targeted, low-risk shutdown bugfix that prevents
pending work races and disables interrupts cleanly. It is suitable for
backporting to stable trees that already include the DW I3C hot-join and
runtime PM infrastructure.

 drivers/i3c/master/dw-i3c-master.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 974122b2d20ee..9ceedf09c3b6a 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1737,6 +1737,28 @@ static const struct dev_pm_ops dw_i3c_pm_ops = {
 	SET_RUNTIME_PM_OPS(dw_i3c_master_runtime_suspend, dw_i3c_master_runtime_resume, NULL)
 };
 
+static void dw_i3c_shutdown(struct platform_device *pdev)
+{
+	struct dw_i3c_master *master = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(master->dev);
+	if (ret < 0) {
+		dev_err(master->dev,
+			"<%s> cannot resume i3c bus master, err: %d\n",
+			__func__, ret);
+		return;
+	}
+
+	cancel_work_sync(&master->hj_work);
+
+	/* Disable interrupts */
+	writel((u32)~INTR_ALL, master->regs + INTR_STATUS_EN);
+	writel((u32)~INTR_ALL, master->regs + INTR_SIGNAL_EN);
+
+	pm_runtime_put_autosuspend(master->dev);
+}
+
 static const struct of_device_id dw_i3c_master_of_match[] = {
 	{ .compatible = "snps,dw-i3c-master-1.00a", },
 	{},
@@ -1752,6 +1774,7 @@ MODULE_DEVICE_TABLE(acpi, amd_i3c_device_match);
 static struct platform_driver dw_i3c_driver = {
 	.probe = dw_i3c_probe,
 	.remove = dw_i3c_remove,
+	.shutdown = dw_i3c_shutdown,
 	.driver = {
 		.name = "dw-i3c-master",
 		.of_match_table = dw_i3c_master_of_match,
-- 
2.51.0

