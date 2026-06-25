Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97097288530;
	Thu, 25 Jun 2026 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392979; cv=none; b=mumX/CV2iN3ZHyL/Th1DrSVVFv9fvttscahVqDPty+AU3vSSmDsMY4W9ApsxEmD9JKwP9sZgvzf4GaEXJEPuugGzOdwDdlYswlqIGO3x8frxzEn2P3EW+XhUvQIVAqSsgI7LcwHMtH4G+jfdIhS/Bi4pwAXXgb1UVoa+mze62w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392979; c=relaxed/simple;
	bh=aoCZ+43GAQd2LyDccMoh7Fn3kU3u70MnwSW8RA0xbXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYnHX0UPNycgSm+5orvHErJSZdu1dCuoEcph2zRsU5oQMuulehEFiU2i6CLnYeNC9d10t7unMyMLkJ3cOLm3pS2izEpPXz5Ykt8Ry0VWY885cNL+3X2sbdheb7n0fUlpRRYA3QhCnqnEFDcV8Osywq8fc9975CIB2Gb8BUtQfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DD7sa7QN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DD7sa7QN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40731F00A3A;
	Thu, 25 Jun 2026 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392978;
	bh=ZUasuZUbTUR3GR/lrVUIjLWBFY39GfJOKB4GXSg/2+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DD7sa7QNgM1pIFy65FqcR7GPW0aFN4qabkHUsaDLKQuCi1RcRMOhw6Qd02BT2I3FE
	 lAb+lP6G/u3sN4GyMDGn/fsHai1xaWS754Ab0LtIVOqqgOXoKpAIthsOVN1ui/bR3C
	 eDKEepdSX263fLdT8Qjm65kxWtQGFR4ltiz8J7Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 05/49] firmware: exynos-acpm: Count acpm_xfer buffers with __counted_by_ptr
Date: Thu, 25 Jun 2026 14:03:17 +0100
Message-ID: <20260625125638.258941246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 951b8eee0581bbf39e7b0464d679eee8cb9da3e0 ]

Use __counted_by_ptr() attribute on the acpm_xfer buffers so UBSAN will
validate runtime that we do not pass over the buffer size, thus making
code safer.

Usage of __counted_by_ptr() (or actually __counted_by()) requires that
counter is initialized before counted array.

Tested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260219-firmare-acpm-counted-v2-3-e1f7389237d3@oss.qualcomm.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Stable-dep-of: f133bd4b5daf ("firmware: samsung: acpm: Fix cross-thread RX length corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm-dvfs.c |    4 ++--
 drivers/firmware/samsung/exynos-acpm.h      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/firmware/samsung/exynos-acpm-dvfs.c
+++ b/drivers/firmware/samsung/exynos-acpm-dvfs.c
@@ -25,12 +25,12 @@ static void acpm_dvfs_set_xfer(struct ac
 			       unsigned int acpm_chan_id, bool response)
 {
 	xfer->acpm_chan_id = acpm_chan_id;
-	xfer->txd = cmd;
 	xfer->txcnt = cmdlen;
+	xfer->txd = cmd;
 
 	if (response) {
-		xfer->rxd = cmd;
 		xfer->rxcnt = cmdlen;
+		xfer->rxd = cmd;
 	}
 }
 
--- a/drivers/firmware/samsung/exynos-acpm.h
+++ b/drivers/firmware/samsung/exynos-acpm.h
@@ -8,8 +8,8 @@
 #define __EXYNOS_ACPM_H__
 
 struct acpm_xfer {
-	const u32 *txd;
-	u32 *rxd;
+	const u32 *txd __counted_by_ptr(txcnt);
+	u32 *rxd __counted_by_ptr(rxcnt);
 	size_t txcnt;
 	size_t rxcnt;
 	unsigned int acpm_chan_id;


