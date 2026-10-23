Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774725;
	b=eEyemB+SBjwrFpaneAeF9Z/t0VuesJQ0cOVrCMJTwmenvnGtsZzJCiGyiDFE2w13NYuo
	 OnoQkWMJbox0rI30uEjN7dk0vJnWVu4Hk/TD2bm68QqdKZkdqpicFMAa/ow+j7Fe52art
	 nkdDVBWF6T+AecPL0YnZw6d4bocwFtY/4nhx/80qX8wUc0ppmja3PGrc3b70uxeW8a2s6
	 k7FlzRe89jd0a5mxrh+Ctv9Ias4cimXGLrBXyhMHLXdyKapnT81ykRLtSYmLjFTe1a+th
	 V1d2qUMalWr2T/2IXyH9/TFUiLY978ASXLApDDpyWkUG8Q3QcVEyrb4XwMGchTt2scg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KsM6Xepmw0uxOoDu7ByOgFQpNfAU7FBdYyxQTzlVtiU=;
	b=lzD2prdDbWVNPiPCQsXSOEUSIb/GxHzSjUfVljg0wLKCQ8kDMwYHDhBHqODi7D7F4ma+
	 5q4kipyh5pR6RR6fZmj933wKhwTsz3UU7pclV19Z2FtSNFHjLNb1/FCELue/1NLW7R67H
	 5gyMnNAa+Z3DGr45ubwm4SiWMRxTX1Iu2boO/zTgQvhH4FtFiTI799ag0rUxPPX9ZIhWm
	 AahAFa37X032uSUAwx6P2TmLaKa/pmsGLTG+g9RAoP/xul9Vn4k4NcNpyxJLU6ycJRVaJ
	 9oRPKokjsBR23szSnbbLh8jo0InfEPvlN+9i/jgjjKaQXsuslw/M/SQOZMFlmHxaIPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzgNxci9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5820606A31A;
	Fri, 23 Oct 2026 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzgNxci9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED9D1F01825;
	Fri, 23 Oct 2026 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774724;
	bh=KsM6Xepmw0uxOoDu7ByOgFQpNfAU7FBdYyxQTzlVtiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzgNxci91dnl5vql+hxN73KokqR4oJ8aa9Y1TBeLrWsckHtzpO6NLiGgbmHX4dAnE
	 wxBF5Xl+cWlldOEib0tntigbuy6egWs/iuwVrP4dfc1aUFVXHaapo46bRHA18JQ1OW
	 MpxeG99fRfle37pjfa9woYpYf/GE78gCI8fcLq38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 138/242] i2c: xiic: restore non-managed runtime PM to fix clk WARN flood
Date: Fri, 23 Oct 2026 18:39:40 +0200
Message-ID: <20261023163717.040806106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20261023163940.mHYDLBUxSYZz4cZgRL6XV5DNWmKQSIwmoGAeymfAezg@z>

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit d33373c565af9c8a28776af02bd20ba6e5724211 upstream.

The devres conversion replaced manual pm_runtime_enable()/disable() with
devm_pm_runtime_set_active_enabled() and dropped the remove-time runtime
PM teardown. The managed release tears runtime PM down in the wrong
order: it calls pm_runtime_dont_use_autosuspend() before
pm_runtime_disable(), i.e. while runtime PM is still enabled, and devres
is LIFO so the devm_clk_get_enabled() release runs afterwards.

At remove(), pm_runtime_put_sync() leaves the device active with the
autosuspend timer armed. Clearing use_autosuspend then makes rpm_idle()
suspend immediately, and xiic_i2c_runtime_suspend() clk_disable()s the
clock. The later devm_clk_get_enabled() release clk_disable_unprepare()s
the already-disabled clock, so clk_core_disable() WARNs ("clkN already
disabled") on every teardown.

Drop the managed helper and restore the non-managed runtime PM setup and
teardown, so runtime PM is enabled once in probe and disabled once in
remove and the clock enable count stays balanced.

Order the remove teardown so runtime PM is disabled before the usage
count is dropped: pm_runtime_disable() followed by pm_runtime_put_noidle()
instead of pm_runtime_put_sync(). Dropping the count first with autosuspend
still enabled arms the autosuspend timer, and a preemption before
pm_runtime_disable() lets it expire, suspend the device and clk_disable()
the clock, which the devm release then disables again - the same WARN.

Restore the non-managed IRQ request as well. The probe error paths now
unwind runtime PM by hand via goto, and a devm-registered handler is only
freed later during devres unwind, so it would stay live across the manual
teardown (and across any future failing step added after it). Request the
IRQ with request_threaded_irq() and free it explicitly in the probe error
path and in remove. The probe error path also clears use_autosuspend, to
match the teardown in remove().

Fixes: 50c63491ff26 ("i2c: xiic: switch to devres managed APIs")
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Cc: <stable@vger.kernel.org> # v7.1+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261014-i2c-xiic-restore-runtime-pm-teardown-v8-1-40668c270069@nexthop.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c | 49 ++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 5e397a7e63f6..ba560462d451 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -67,6 +67,7 @@ enum i2c_scl_freq {
  * @rx_pos: Position within current RX message
  * @endianness: big/little-endian byte order
  * @clk: Pointer to AXI4-lite input clock
+ * @irq: Interrupt number
  * @state: See STATE_
  * @singlemaster: Indicates bus is single master
  * @dynamic: Mode of controller
@@ -95,6 +96,7 @@ struct xiic_i2c {
 	int rx_pos;
 	enum xiic_endian endianness;
 	struct clk *clk;
+	int irq;
 	enum xilinx_i2c_state state;
 	bool singlemaster;
 	bool dynamic;
@@ -1506,9 +1508,17 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(dev, XIIC_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
-	ret = devm_pm_runtime_set_active_enabled(dev);
-	if (ret)
+	/*
+	 * Enable runtime PM by hand: devm_pm_runtime_set_active_enabled()
+	 * tears down in an order that races the devm-enabled clock release and
+	 * makes clk_core_disable() WARN (see xiic_i2c_remove()).
+	 */
+	ret = pm_runtime_set_active(dev);
+	if (ret) {
+		pm_runtime_dont_use_autosuspend(dev);
 		return ret;
+	}
+	pm_runtime_enable(dev);
 
 	/* SCL frequency configuration */
 	i2c->input_clk = clk_get_rate(i2c->clk);
@@ -1517,10 +1527,15 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	if (ret || i2c->i2c_clk > I2C_MAX_FAST_MODE_PLUS_FREQ)
 		i2c->i2c_clk = 0;
 
-	ret = devm_request_threaded_irq(dev, irq, NULL, xiic_process,
-					IRQF_ONESHOT, pdev->name, i2c);
+	/*
+	 * Request the IRQ non-managed: later probe steps unwind manually via
+	 * goto, so a devm handler could still be live after that teardown runs.
+	 */
+	i2c->irq = irq;
+	ret = request_threaded_irq(irq, NULL, xiic_process, IRQF_ONESHOT,
+				   pdev->name, i2c);
 	if (ret)
-		return ret;
+		goto err_pm_disable;
 
 	i2c->singlemaster = device_property_read_bool(dev, "single-master");
 
@@ -1537,14 +1552,16 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 		i2c->endianness = BIG;
 
 	ret = xiic_reinit(i2c);
-	if (ret)
-		return dev_err_probe(dev, ret, "Cannot xiic_reinit\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "Cannot xiic_reinit\n");
+		goto err_free_irq;
+	}
 
 	/* add i2c adapter to i2c tree */
 	ret = i2c_add_numbered_adapter(&i2c->adap);
 	if (ret) {
 		xiic_deinit(i2c);
-		return ret;
+		goto err_free_irq;
 	}
 
 	if (pdata) {
@@ -1557,6 +1574,15 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 		res, irq, i2c->i2c_clk);
 
 	return 0;
+
+err_free_irq:
+	free_irq(irq, i2c);
+err_pm_disable:
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
+	return ret;
 }
 
 static void xiic_i2c_remove(struct platform_device *pdev)
@@ -1568,6 +1594,8 @@ static void xiic_i2c_remove(struct platform_device *pdev)
 	/* remove adapter & data */
 	i2c_del_adapter(&i2c->adap);
 
+	free_irq(i2c->irq, i2c);
+
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
 		dev_warn(dev, "Failed to activate device for removal (%pe)\n",
@@ -1575,7 +1603,10 @@ static void xiic_i2c_remove(struct platform_device *pdev)
 	else
 		xiic_deinit(i2c);
 
-	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_dont_use_autosuspend(dev);
 }
 
 static const struct dev_pm_ops xiic_dev_pm_ops = {
-- 
2.56.0



