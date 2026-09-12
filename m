Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB996331EA8;
	Sat, 12 Sep 2026 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239822; cv=none; b=etNm2QiR8Icd6oVEHOIl/GdmEGlQz41aQ8h9nnhXMfUSk1VpBm1KtScK5wK9ud9/s+IfOM591K8EPBVONyfaY22oXO2dIIZTD/Zmo4QQxfrqBxqT1xN02vR+0sg45urO2yD2uPqIZZTRHYA17Y7VnRzcuKMgm2YgPK2Zqkn0j8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239822; c=relaxed/simple;
	bh=jhymS4h94sIKM7io8aVNzjXKFa2JhRV0dcu5o8zcV5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kew19OXRgYpnlHg9pSadJ/+iUX3+LTM4Sv96Qbusdy/8x81nNQVh2pYRzKd1mEK+neqOKadFLz8Js2I/O/0/0poQpu5nz+XADVlAABxvwN/Sx65wxxZV1xcCNoiFl8zPXEqw7RZNYo6YF9KJ8xRupqYOxDpLtVlqyA9VLszUHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm9p+14J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm9p+14J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B80A1F000FF;
	Sat, 12 Sep 2026 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239820;
	bh=YMYLfwZbZDhZFaLPp/Z3r2p289PdC+dfIu/ww4DeDZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vm9p+14JlzZu48oLlQV0JiH+qtS+Q124JYYq57rXhn3RDSu92URr4j0FbTblsacfe
	 ygyz+rUDxgFhwIjrLq7HQEBWhHgUa91J+evw2Jo5Yk2zfkGVpuqOlX6e9ZiyxzDw81
	 wx9OpxZO25/WtXFlFH5KyCmSULPLU5W9DN7GD4o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 742/935] coresight: etm4x: Cleanup TRCIDR3 register accesses
Date: Sat, 12 Sep 2026 09:02:52 +0200
Message-ID: <20260912065543.850994749@linuxfoundation.org>
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

[ Upstream commit f4d1f2142a608667a1849894b48b9c6e3343210c ]

This is a no-op change for style and consistency and has no effect on
the binary output by the compiler. In sysreg.h fields are defined as
the register name followed by the field name and then _MASK. This
allows for grepping for fields by name rather than using magic numbers.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20220304171913.2292458-4-james.clark@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 1674d9bff807 ("coresight: etm4x: fix underflow for usage of (nrseqstate - 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 40 +++++--------------
 drivers/hwtracing/coresight/coresight-etm4x.h | 10 +++++
 2 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index de967a4cbb51c..c6fbe3b76b5fc 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1187,53 +1187,33 @@ static void etm4_init_arch_data(void *info)
 
 	etmidr3 = etm4x_relaxed_read32(csa, TRCIDR3);
 	/* CCITMIN, bits[11:0] minimum threshold value that can be programmed */
-	drvdata->ccitmin = BMVAL(etmidr3, 0, 11);
+	drvdata->ccitmin = FIELD_GET(TRCIDR3_CCITMIN_MASK, etmidr3);
 	/* EXLEVEL_S, bits[19:16] Secure state instruction tracing */
-	drvdata->s_ex_level = BMVAL(etmidr3, 16, 19);
+	drvdata->s_ex_level = FIELD_GET(TRCIDR3_EXLEVEL_S_MASK, etmidr3);
 	drvdata->config.s_ex_level = drvdata->s_ex_level;
 	/* EXLEVEL_NS, bits[23:20] Non-secure state instruction tracing */
-	drvdata->ns_ex_level = BMVAL(etmidr3, 20, 23);
-
+	drvdata->ns_ex_level = FIELD_GET(TRCIDR3_EXLEVEL_NS_MASK, etmidr3);
 	/*
 	 * TRCERR, bit[24] whether a trace unit can trace a
 	 * system error exception.
 	 */
-	if (BMVAL(etmidr3, 24, 24))
-		drvdata->trc_error = true;
-	else
-		drvdata->trc_error = false;
-
+	drvdata->trc_error = !!(etmidr3 & TRCIDR3_TRCERR);
 	/* SYNCPR, bit[25] implementation has a fixed synchronization period? */
-	if (BMVAL(etmidr3, 25, 25))
-		drvdata->syncpr = true;
-	else
-		drvdata->syncpr = false;
-
+	drvdata->syncpr = !!(etmidr3 & TRCIDR3_SYNCPR);
 	/* STALLCTL, bit[26] is stall control implemented? */
-	if (BMVAL(etmidr3, 26, 26))
-		drvdata->stallctl = true;
-	else
-		drvdata->stallctl = false;
-
+	drvdata->stallctl = !!(etmidr3 & TRCIDR3_STALLCTL);
 	/* SYSSTALL, bit[27] implementation can support stall control? */
-	if (BMVAL(etmidr3, 27, 27))
-		drvdata->sysstall = true;
-	else
-		drvdata->sysstall = false;
-
+	drvdata->sysstall = !!(etmidr3 & TRCIDR3_SYSSTALL);
 	/*
 	 * NUMPROC - the number of PEs available for tracing, 5bits
 	 *         = TRCIDR3.bits[13:12]bits[30:28]
 	 *  bits[4:3] = TRCIDR3.bits[13:12] (since etm-v4.2, otherwise RES0)
 	 *  bits[3:0] = TRCIDR3.bits[30:28]
 	 */
-	drvdata->nr_pe = (BMVAL(etmidr3, 12, 13) << 3) | BMVAL(etmidr3, 28, 30);
-
+	drvdata->nr_pe =  (FIELD_GET(TRCIDR3_NUMPROC_HI_MASK, etmidr3) << 3) |
+			   FIELD_GET(TRCIDR3_NUMPROC_LO_MASK, etmidr3);
 	/* NOOVERFLOW, bit[31] is trace overflow prevention supported */
-	if (BMVAL(etmidr3, 31, 31))
-		drvdata->nooverflow = true;
-	else
-		drvdata->nooverflow = false;
+	drvdata->nooverflow = !!(etmidr3 & TRCIDR3_NOOVERFLOW);
 
 	/* number of resources trace unit supports */
 	etmidr4 = etm4x_relaxed_read32(csa, TRCIDR4);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 20396b998b7c1..19f187cdaff0f 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -143,6 +143,16 @@
 #define TRCIDR2_VMIDSIZE_MASK			GENMASK(14, 10)
 #define TRCIDR2_CCSIZE_MASK			GENMASK(28, 25)
 
+#define TRCIDR3_CCITMIN_MASK			GENMASK(11, 0)
+#define TRCIDR3_EXLEVEL_S_MASK			GENMASK(19, 16)
+#define TRCIDR3_EXLEVEL_NS_MASK			GENMASK(23, 20)
+#define TRCIDR3_TRCERR				BIT(24)
+#define TRCIDR3_SYNCPR				BIT(25)
+#define TRCIDR3_STALLCTL			BIT(26)
+#define TRCIDR3_SYSSTALL			BIT(27)
+#define TRCIDR3_NUMPROC_LO_MASK			GENMASK(30, 28)
+#define TRCIDR3_NUMPROC_HI_MASK			GENMASK(13, 12)
+#define TRCIDR3_NOOVERFLOW			BIT(31)
 /*
  * System instructions to access ETM registers.
  * See ETMv4.4 spec ARM IHI0064F section 4.3.6 System instructions
-- 
2.53.0



