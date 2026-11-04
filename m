Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830809;
	b=Fp1OmfFe2Uke9CiXYrSca6T2bGrQDuK2j8SmLWKBdmgRpFyb95UP6NxdhoBxYfMaNrc/
	 nBw3M7ysyGaXgv8/eNv/tGTV/7ly4TE1W/9zRwUjlRBRGhX8cc7UNA0upkM9DBHJ8r0wk
	 XjRDkNbKaqQmGPNVjeIZPWeqkhYwbfoQoFFUjB3OCMQ74l/dRUw4zThjuuFvcBOXOrWbU
	 DKIUAF+8VD5i9+J+iAZqjNcYbatkrIG0WAkbpr9xtSH0i7X27ep7WRWU/u03R2syvEh2s
	 o/40gGzlkxZnx7iEVi14LGFZqn4ykcTTbQ+MnqRYNKH+0zowd14tB4Pdfm9lia7zJ+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JWXREubcndyQSrN5M+njTbQOkvMq7ixfY1S1Vrs1hY8=;
	b=GoFHUkkSJMhFnTbQ9prWMUZEiYFj7ama6PafLBDLYEWoyBmB0749xgDTIJsFTfldBWAg
	 CudQKRsAjttXC2x2PhSgXU/D3wgTpr+Ny8phhhonjoQIyeUMuSooNFbZC74duJEiCcNAg
	 TUteXfVlK46wTiVl2TNFH82A1D58LQf8XkK4lEyEzCkkjs+ekH97YF4db2ox2qFYumP8z
	 hmxdX6z2GlOODNqRUhkTK8Knj9mS+F6QjYKVUJVGoMBj7m9OEecPuSWeInFFnc0yScub2
	 o8JmQoRcSJi5kRudK7LZGfHdI7H938T5fKd/y+dwZZJx2JyHu3ixQVzRkqliwevXYBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5irOyyq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384FE606A32E;
	Wed,  4 Nov 2026 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5irOyyq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3171F00A2B;
	Wed,  4 Nov 2026 22:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830809;
	bh=JWXREubcndyQSrN5M+njTbQOkvMq7ixfY1S1Vrs1hY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5irOyyqSTNhLWM/vbxdGD/9IP1Z7Eh3HGTcAuOAuUsvzgqhrlmdZObGjzli1qOzn
	 f8Yjfs9+FErLvK5R9MwE7YOfLFB+GG0XEOJPx+GwHooF5SmmpqoUoF3Vzgo3XQA84i
	 GPrfM0XYR6TRwJprJxHv9OLmA8j1doHvpkOPLywk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sre@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0332/1005] opp: Use clk_get_optional() to avoid leaving opp_table->clk as an error pointer
Date: Wed,  4 Nov 2026 16:01:05 -0500
Message-ID: <20261104211053.253427977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 84f05af0975c9f9c8ffee0361d6f7cbb1f289231 ]

_update_opp_table_clk() uses clk_get(dev, NULL) to acquire the
device's clock. On platforms where the perf domain device has no
Linux clock and is instead managed entirely by firmware via
devm_pm_opp_of_add_table() (through
of_genpd_add_provider_simple()/onecell()), clk_get() returns
-ENOENT. That case is treated as valid (the OPP table can still
have entries sourced from firmware), but opp_table->clk is left
holding ERR_PTR(-ENOENT) rather than being reset to NULL:

	opp_table->clk = clk_get(dev, NULL);
	ret = PTR_ERR_OR_ZERO(opp_table->clk);
	...
	if (ret == -ENOENT) {
		opp_table->clk_count = 1;
		return opp_table;   /* opp_table->clk is still ERR_PTR(-ENOENT) */
	}

Consumers that only check IS_ERR(opp_table->clk) treat this as a
valid clk and pass it straight into the clk consumer API. In
particular, dev_pm_opp_set_rate() calls
clk_round_rate(opp_table->clk, target_freq), and clk_round_rate()
only guards against a NULL clk, so it dereferences the error pointer
to read clk->exclusive_count and crashes:

  Unable to handle kernel NULL pointer dereference at virtual
  address 000000000000002e
  ...
  pc : clk_round_rate+0x3c/0x188
  ...
  Call trace:
   clk_round_rate+0x3c/0x188 (P)
   dev_pm_opp_set_rate+0x114/0x33c

Rather than teaching every clk consumer API to special-case
ERR_PTR(-ENOENT), fix it at the source: use clk_get_optional()
instead of clk_get() in _update_opp_table_clk(), which already
translates -ENOENT into a NULL clk. This documents that the clock is
genuinely optional for such devices, and keeps opp_table->clk holding
either a valid clk or NULL, never a lingering -ENOENT error pointer.
_opp_config_clk_single() is only wired up via opp_table->config_clks
when a clk was actually found, and every other opp_table->clk
consumer already tolerates NULL through the standard clk API (which
treats a NULL clk as a no-op), so no other call site needs to change.

Suggested-by: Sebastian Reichel <sre@kernel.org>
Reviewed-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 54 +++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index a179d57a5a150..a41ad136e90e0 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1579,8 +1579,6 @@ static struct opp_table *_update_opp_table_clk(struct device *dev,
 					       struct opp_table *opp_table,
 					       bool getclk)
 {
-	int ret;
-
 	/*
 	 * Return early if we don't need to get clk or we have already done it
 	 * earlier.
@@ -1589,39 +1587,35 @@ static struct opp_table *_update_opp_table_clk(struct device *dev,
 	    opp_table->clks)
 		return opp_table;
 
-	/* Find clk for the device */
-	opp_table->clk = clk_get(dev, NULL);
+	/*
+	 * There are few platforms which don't want the OPP core to manage
+	 * device's clock settings. In such cases neither the platform
+	 * provides the clks explicitly to us, nor the DT contains a valid
+	 * clk entry. The OPP nodes in DT may still contain "opp-hz" property
+	 * though, which we need to parse and allow the platform to find an
+	 * OPP based on freq later on.
+	 *
+	 * This is a simple solution to take care of such corner cases, i.e.
+	 * make the clk_count 1, which lets us allocate space for frequency
+	 * in opp->rates and also parse the entries in DT. Use
+	 * clk_get_optional() instead of clk_get() so opp_table->clk stays
+	 * NULL for such devices, instead of holding an ERR_PTR(-ENOENT) that
+	 * consumers must remember to special-case.
+	 */
+	opp_table->clk = clk_get_optional(dev, NULL);
 
-	ret = PTR_ERR_OR_ZERO(opp_table->clk);
-	if (!ret) {
-		opp_table->config_clks = _opp_config_clk_single;
-		opp_table->clk_count = 1;
-		return opp_table;
+	if (IS_ERR(opp_table->clk)) {
+		dev_pm_opp_put_opp_table(opp_table);
+		dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
+		return ERR_CAST(opp_table->clk);
 	}
 
-	if (ret == -ENOENT) {
-		/*
-		 * There are few platforms which don't want the OPP core to
-		 * manage device's clock settings. In such cases neither the
-		 * platform provides the clks explicitly to us, nor the DT
-		 * contains a valid clk entry. The OPP nodes in DT may still
-		 * contain "opp-hz" property though, which we need to parse and
-		 * allow the platform to find an OPP based on freq later on.
-		 *
-		 * This is a simple solution to take care of such corner cases,
-		 * i.e. make the clk_count 1, which lets us allocate space for
-		 * frequency in opp->rates and also parse the entries in DT.
-		 */
-		opp_table->clk_count = 1;
-
-		dev_dbg(dev, "%s: Couldn't find clock: %d\n", __func__, ret);
-		return opp_table;
-	}
+	if (opp_table->clk)
+		opp_table->config_clks = _opp_config_clk_single;
 
-	dev_pm_opp_put_opp_table(opp_table);
-	dev_err_probe(dev, ret, "Couldn't find clock\n");
+	opp_table->clk_count = 1;
 
-	return ERR_PTR(ret);
+	return opp_table;
 }
 
 /*
-- 
2.53.0



