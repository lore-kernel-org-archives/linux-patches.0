Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DFB2D9792;
	Sat, 12 Sep 2026 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239835; cv=none; b=UXy1xi3I1GxV/jPxFkQ973HrTteuzPVsUQBc/U29SuwL2XZQ0bIzeoCjQWCn95/kCZnmUZiYvvRdG5gB5HvjQDWUpv7DHa1cKZfCHY4msI7EJKvrmXhtPjLrFHfuBKJH+HlCaxGkmqmYcm3PRRV3tcr0WSibQ89O1S5ns1EeKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239835; c=relaxed/simple;
	bh=jgcutgFVkydFl/IIWSBU3gQOjFLVuZoQsu3mQEE7+A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTm62xPS2Huafiupq1P32l7vHF222YwKkmgv1tblq421jXw409IP0qZeWHNFbmIL93VFDxsoRITRfr17UkcLEPepEhVLlXE4NpevDetFBIn2pBUhRNlo+2rSEgtjnvN81dhrLEqS2CRbUSjhG+rGaM6c2MTRACMTYpVNUFoLdKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al940sGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al940sGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDE61F000FF;
	Sat, 12 Sep 2026 19:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239833;
	bh=LcGuMc/R0m8XjHf/9dALGjH1n92UFUZYnpLXGegTtCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al940sGE1yQVLd5+2oQEvNExNz+WCrwSvXqHcBiYumNY68+eBQ9kWF8l4+zW7jhmW
	 X34Ve9RpZzln/4bWHArG9EPdO5ng+mVhXo1nwDzxyBgjlqIGlLeFp+tczmTWENh7S4
	 qIYf2X4Y2juDUuDPvUknWhheOfQHtYMgdMtDwQmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 745/935] coresight: Change syncfreq to be a u8
Date: Sat, 12 Sep 2026 09:02:55 +0200
Message-ID: <20260912065543.920768307@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 10d4dbdc8fbce586b17be07b8138e025381453dd ]

TRCSYNCPR.PERIOD is the only functional part of TRCSYNCPR and it only
has 5 valid bits so it can be stored in a u8.

Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251128-james-cs-syncfreq-v8-1-4d319764cc58@linaro.org
Stable-dep-of: 1674d9bff807 ("coresight: etm4x: fix underflow for usage of (nrseqstate - 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index f68ef25756b35..11bf212a69078 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -780,7 +780,6 @@ struct etmv4_config {
 	u32				eventctrl1;
 	u32				stall_ctrl;
 	u32				ts_ctrl;
-	u32				syncfreq;
 	u32				ccctlr;
 	u32				bb_ctrl;
 	u32				vinst_ctrl;
@@ -788,6 +787,7 @@ struct etmv4_config {
 	u32				vissctlr;
 	u32				vipcssctlr;
 	u8				seq_idx;
+	u8				syncfreq;
 	u32				seq_ctrl[ETM_MAX_SEQ_STATES];
 	u32				seq_rst;
 	u32				seq_state;
-- 
2.53.0



