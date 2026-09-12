Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B1C383C88;
	Sat, 12 Sep 2026 19:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239816; cv=none; b=rbqaDDaaj4o2pPXEHwjJNwAeNjM5z80c87HGlVDzVZf8d/dL8r2TA0n4/oWd2SuiXUhjXzsbYOc6CuGFGIGAKUjjq/LO3BcEKOhG/87/3zybYPqLuZ1p+ec6nG91l7oxuAEN/P6//m5Uul1/84FmXH2FaFNPvwckOb+H4yOD3Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239816; c=relaxed/simple;
	bh=VZfuO+qCfl88JD7Tsc28e6vaY6MP98XPvyIS7P7NCa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeLRKc9eXrIrEN6KndFD5AX9HMMUx0OWnSS7Xcwwy0ps2XM3FZTlFpbCJlKLKbX2iO0EgneHfffbj2YvazsUyotsyBwoPfiWpsZCZbsqca435GvCqqVB1lBhXiBAXiLuzKftUXsE3GM3rSNa5CDTiNctMii7qUHGF7CSMp/woks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQQARenq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQQARenq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE211F000FF;
	Sat, 12 Sep 2026 19:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239815;
	bh=VwJ3nAvjdWJ4Croyqb1A2Lwtklk+kCJlL79gWoMvs1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQQARenqxRblQQ963j4WnEjn8NLthkRRWzpBhXjFT87eO/ZpR/yuLwQwfWy225MOs
	 1hLkBpIsUiHyNhkcHdP7m/z+qW+KA4p9frOLAni4GdlGq1CE8Bzk8x9ulFTcPr8PzC
	 su8+b4J1n22osx4SMsLEurobyHYbsA1swrCkj3qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 741/935] coresight: etm4x: Cleanup TRCIDR2 register accesses
Date: Sat, 12 Sep 2026 09:02:51 +0200
Message-ID: <20260912065543.827337230@linuxfoundation.org>
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

[ Upstream commit cf0c7f18d30eb9bba44ac04a87fef5035953b283 ]

This is a no-op change for style and consistency and has no effect on
the binary output by the compiler. In sysreg.h fields are defined as
the register name followed by the field name and then _MASK. This
allows for grepping for fields by name rather than using magic numbers.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20220304171913.2292458-3-james.clark@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 1674d9bff807 ("coresight: etm4x: fix underflow for usage of (nrseqstate - 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 6 +++---
 drivers/hwtracing/coresight/coresight-etm4x.h      | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 149fbed92a9da..de967a4cbb51c 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1179,11 +1179,11 @@ static void etm4_init_arch_data(void *info)
 	/* maximum size of resources */
 	etmidr2 = etm4x_relaxed_read32(csa, TRCIDR2);
 	/* CIDSIZE, bits[9:5] Indicates the Context ID size */
-	drvdata->ctxid_size = BMVAL(etmidr2, 5, 9);
+	drvdata->ctxid_size = FIELD_GET(TRCIDR2_CIDSIZE_MASK, etmidr2);
 	/* VMIDSIZE, bits[14:10] Indicates the VMID size */
-	drvdata->vmid_size = BMVAL(etmidr2, 10, 14);
+	drvdata->vmid_size = FIELD_GET(TRCIDR2_VMIDSIZE_MASK, etmidr2);
 	/* CCSIZE, bits[28:25] size of the cycle counter in bits minus 12 */
-	drvdata->ccsize = BMVAL(etmidr2, 25, 28);
+	drvdata->ccsize = FIELD_GET(TRCIDR2_CCSIZE_MASK, etmidr2);
 
 	etmidr3 = etm4x_relaxed_read32(csa, TRCIDR3);
 	/* CCITMIN, bits[11:0] minimum threshold value that can be programmed */
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 85bf733a21bab..20396b998b7c1 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -139,6 +139,10 @@
 #define TRCIDR0_QSUPP_MASK			GENMASK(16, 15)
 #define TRCIDR0_TSSIZE_MASK			GENMASK(28, 24)
 
+#define TRCIDR2_CIDSIZE_MASK			GENMASK(9, 5)
+#define TRCIDR2_VMIDSIZE_MASK			GENMASK(14, 10)
+#define TRCIDR2_CCSIZE_MASK			GENMASK(28, 25)
+
 /*
  * System instructions to access ETM registers.
  * See ETMv4.4 spec ARM IHI0064F section 4.3.6 System instructions
-- 
2.53.0



