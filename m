Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2C33939B3;
	Sat, 12 Sep 2026 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239826; cv=none; b=fkvNJjfnOemMbhqwozeryWx6DhfTaFuAp2/qS95ESACNjy3InB6hyzpMluraOojXOJoarF5HI09Q1RjyPm72FNj7Shypf/kiw78tkobBNrD5haaVkLPX7jPa9OmcxmMnq14IINIrDMZQvxTO/TVrgb40LAb1iwT7L/poHk4J8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239826; c=relaxed/simple;
	bh=mw/Vb9bduoFREA9CQ4cUg28L/EyqmyVfCGbrMn3ADow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIVyooC7UCx+kUkoDfKgX1O2OrZq9KtxNetx7r5etOSRSy9MSM+NOAGOaRhCHygVaHL460I1zRrG5lS+5DudK5eFEpPqP4GmbO73hQCapXma21EBK9Re8z2VxMBurulTEDLmc79KAm6hq29G6kx/iK3x35mz4/ooUjd4jFt9l8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfvi4oHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfvi4oHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9324A1F000FF;
	Sat, 12 Sep 2026 19:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239825;
	bh=LfUFekfN/AgoM6DC8nuXcUr/WEZ7+cIdeG0ibHTv7/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfvi4oHoMIB9VykRVrV9v3/9gzyOAO5hgCPVn7p59NMgXPoo82qri9/mFJzSsH7zK
	 9tNBn5q5nmRs3k3+N6LzUAqjYWvf/GtWHX91CP0FnZ2ENhNIa5XYeZqEiUDWzY8Y5o
	 +NCL8tlq2l1Lu3wxPMpQT2atH5q5QMnWrlbqCXG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 743/935] coresight: etm4x: Cleanup TRCIDR4 register accesses
Date: Sat, 12 Sep 2026 09:02:53 +0200
Message-ID: <20260912065543.874846470@linuxfoundation.org>
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

[ Upstream commit ea69dbb893d9f4446c2c66ebb11081af9269721f ]

This is a no-op change for style and consistency and has no effect on
the binary output by the compiler. In sysreg.h fields are defined as
the register name followed by the field name and then _MASK. This
allows for grepping for fields by name rather than using magic numbers.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20220304171913.2292458-5-james.clark@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 1674d9bff807 ("coresight: etm4x: fix underflow for usage of (nrseqstate - 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 12 ++++++------
 drivers/hwtracing/coresight/coresight-etm4x.h      |  8 ++++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index c6fbe3b76b5fc..4d4319fd49623 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1218,9 +1218,9 @@ static void etm4_init_arch_data(void *info)
 	/* number of resources trace unit supports */
 	etmidr4 = etm4x_relaxed_read32(csa, TRCIDR4);
 	/* NUMACPAIRS, bits[0:3] number of addr comparator pairs for tracing */
-	drvdata->nr_addr_cmp = BMVAL(etmidr4, 0, 3);
+	drvdata->nr_addr_cmp = FIELD_GET(TRCIDR4_NUMACPAIRS_MASK, etmidr4);
 	/* NUMPC, bits[15:12] number of PE comparator inputs for tracing */
-	drvdata->nr_pe_cmp = BMVAL(etmidr4, 12, 15);
+	drvdata->nr_pe_cmp = FIELD_GET(TRCIDR4_NUMPC_MASK, etmidr4);
 	/*
 	 * NUMRSPAIR, bits[19:16]
 	 * The number of resource pairs conveyed by the HW starts at 0, i.e a
@@ -1231,7 +1231,7 @@ static void etm4_init_arch_data(void *info)
 	 * the default TRUE and FALSE resource selectors are omitted.
 	 * Otherwise for values 0x1 and above the number is N + 1 as per v4.2.
 	 */
-	drvdata->nr_resource = BMVAL(etmidr4, 16, 19);
+	drvdata->nr_resource = FIELD_GET(TRCIDR4_NUMRSPAIR_MASK, etmidr4);
 	if ((drvdata->arch < ETM_ARCH_V4_3) || (drvdata->nr_resource > 0))
 		drvdata->nr_resource += 1;
 	/*
@@ -1239,15 +1239,15 @@ static void etm4_init_arch_data(void *info)
 	 * comparator control for tracing. Read any status regs as these
 	 * also contain RO capability data.
 	 */
-	drvdata->nr_ss_cmp = BMVAL(etmidr4, 20, 23);
+	drvdata->nr_ss_cmp = FIELD_GET(TRCIDR4_NUMSSCC_MASK, etmidr4);
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
 		drvdata->config.ss_status[i] =
 			etm4x_relaxed_read32(csa, TRCSSCSRn(i));
 	}
 	/* NUMCIDC, bits[27:24] number of Context ID comparators for tracing */
-	drvdata->numcidc = BMVAL(etmidr4, 24, 27);
+	drvdata->numcidc = FIELD_GET(TRCIDR4_NUMCIDC_MASK, etmidr4);
 	/* NUMVMIDC, bits[31:28] number of VMID comparators for tracing */
-	drvdata->numvmidc = BMVAL(etmidr4, 28, 31);
+	drvdata->numvmidc = FIELD_GET(TRCIDR4_NUMVMIDC_MASK, etmidr4);
 
 	etmidr5 = etm4x_relaxed_read32(csa, TRCIDR5);
 	/* NUMEXTIN, bits[8:0] number of external inputs implemented */
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 19f187cdaff0f..8321b92d93091 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -153,6 +153,14 @@
 #define TRCIDR3_NUMPROC_LO_MASK			GENMASK(30, 28)
 #define TRCIDR3_NUMPROC_HI_MASK			GENMASK(13, 12)
 #define TRCIDR3_NOOVERFLOW			BIT(31)
+
+#define TRCIDR4_NUMACPAIRS_MASK			GENMASK(3, 0)
+#define TRCIDR4_NUMPC_MASK			GENMASK(15, 12)
+#define TRCIDR4_NUMRSPAIR_MASK			GENMASK(19, 16)
+#define TRCIDR4_NUMSSCC_MASK			GENMASK(23, 20)
+#define TRCIDR4_NUMCIDC_MASK			GENMASK(27, 24)
+#define TRCIDR4_NUMVMIDC_MASK			GENMASK(31, 28)
+
 /*
  * System instructions to access ETM registers.
  * See ETMv4.4 spec ARM IHI0064F section 4.3.6 System instructions
-- 
2.53.0



