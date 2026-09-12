Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912A9383C88;
	Sat, 12 Sep 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239830; cv=none; b=l+bYTjfV4lzaLlJ0rWVpPOg+kMKDRyQRLI0ttAZ+QlCaflgN1/DptK4djVc0lgP31J80MS0N0LokAm5gWy7jm3G0tnZU37UcbF84I+okwffHIKeTvZIM0BPQpgO7DmumvOxK7p7YtIJUd287z6QJkjWRgpHI8I0uAmXsuCjEWu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239830; c=relaxed/simple;
	bh=Qn/3qGGmUseC5PR6a6BLCaSBSyHqpBnREvbNEHszhY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+iS5G8hMwm0fICsnK/U+RHpC/j2sMSYn/lzDnJQb8ZxY142iV6jPUOFzME9ma0Hh+No1vGl9Xt5ZP4snDNtkLRRSYB7i5/S6sMehkwnGmqBwPeBg2b2cp0mOYjN5NgSO/VRb7u9oEbDNrwHxKrjVcT2XkN3+L7vUPi9l+t/q5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmtoO7RF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmtoO7RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654E21F000FF;
	Sat, 12 Sep 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239829;
	bh=TmdsaoyZt+p7HC888vez2SjIVun1WeH5IrFnfBle+Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmtoO7RF43FZWXTmdPx0GnLC8066b0/+mIJheUYnzpptQ5WjN9+z+QV/rFYKKq+Xq
	 UK3OoZaXzKvoS7jTzeX3toF+dq/KRh7g3yhJ1I5tokiAcccM8Zs9SMDqXY2+gvY7Nh
	 +fxml0sEiJXJoY5CLnCP6qSASPVA3c223sChjp3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 744/935] coresight: etm4x: Cleanup TRCIDR5 register accesses
Date: Sat, 12 Sep 2026 09:02:54 +0200
Message-ID: <20260912065543.898069857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 028e5460915afd4a3067e380eb4d03cb4500acdc ]

This is a no-op change for style and consistency and has no effect on
the binary output by the compiler. In sysreg.h fields are defined as
the register name followed by the field name and then _MASK. This
allows for grepping for fields by name rather than using magic numbers.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20220304171913.2292458-6-james.clark@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 1674d9bff807 ("coresight: etm4x: fix underflow for usage of (nrseqstate - 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm4x-core.c | 18 ++++++------------
 drivers/hwtracing/coresight/coresight-etm4x.h  |  7 +++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 4d4319fd49623..96cbead6049b9 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1251,26 +1251,20 @@ static void etm4_init_arch_data(void *info)
 
 	etmidr5 = etm4x_relaxed_read32(csa, TRCIDR5);
 	/* NUMEXTIN, bits[8:0] number of external inputs implemented */
-	drvdata->nr_ext_inp = BMVAL(etmidr5, 0, 8);
+	drvdata->nr_ext_inp = FIELD_GET(TRCIDR5_NUMEXTIN_MASK, etmidr5);
 	/* TRACEIDSIZE, bits[21:16] indicates the trace ID width */
-	drvdata->trcid_size = BMVAL(etmidr5, 16, 21);
+	drvdata->trcid_size = FIELD_GET(TRCIDR5_TRACEIDSIZE_MASK, etmidr5);
 	/* ATBTRIG, bit[22] implementation can support ATB triggers? */
-	if (BMVAL(etmidr5, 22, 22))
-		drvdata->atbtrig = true;
-	else
-		drvdata->atbtrig = false;
+	drvdata->atbtrig = !!(etmidr5 & TRCIDR5_ATBTRIG);
 	/*
 	 * LPOVERRIDE, bit[23] implementation supports
 	 * low-power state override
 	 */
-	if (BMVAL(etmidr5, 23, 23) && (!drvdata->skip_power_up))
-		drvdata->lpoverride = true;
-	else
-		drvdata->lpoverride = false;
+	drvdata->lpoverride = (etmidr5 & TRCIDR5_LPOVERRIDE) && (!drvdata->skip_power_up);
 	/* NUMSEQSTATE, bits[27:25] number of sequencer states implemented */
-	drvdata->nrseqstate = BMVAL(etmidr5, 25, 27);
+	drvdata->nrseqstate = FIELD_GET(TRCIDR5_NUMSEQSTATE_MASK, etmidr5);
 	/* NUMCNTR, bits[30:28] number of counters available for tracing */
-	drvdata->nr_cntr = BMVAL(etmidr5, 28, 30);
+	drvdata->nr_cntr = FIELD_GET(TRCIDR5_NUMCNTR_MASK, etmidr5);
 	etm4_cs_lock(drvdata, csa);
 	cpu_detect_trace_filtering(drvdata);
 }
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 8321b92d93091..f68ef25756b35 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -161,6 +161,13 @@
 #define TRCIDR4_NUMCIDC_MASK			GENMASK(27, 24)
 #define TRCIDR4_NUMVMIDC_MASK			GENMASK(31, 28)
 
+#define TRCIDR5_NUMEXTIN_MASK			GENMASK(8, 0)
+#define TRCIDR5_TRACEIDSIZE_MASK		GENMASK(21, 16)
+#define TRCIDR5_ATBTRIG				BIT(22)
+#define TRCIDR5_LPOVERRIDE			BIT(23)
+#define TRCIDR5_NUMSEQSTATE_MASK		GENMASK(27, 25)
+#define TRCIDR5_NUMCNTR_MASK			GENMASK(30, 28)
+
 /*
  * System instructions to access ETM registers.
  * See ETMv4.4 spec ARM IHI0064F section 4.3.6 System instructions
-- 
2.53.0



