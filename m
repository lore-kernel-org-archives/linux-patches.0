Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181A630C60F;
	Sat, 12 Sep 2026 12:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217575; cv=none; b=uzcQAPUHEKid5wAEakgNpbSHw8+VAd5UAAB6/dTKGl5Jddc0MvFazgXmv1kH0Jv7+AlrgnZ/bOnBFl/9XS0BbCQpV5kj2U07Ja5g5nNFX59kWZzSWsMDOySktPLK1w2dFlBk2lRXAEASrTvyVou1+CUfWrkt2vn4nZpRzkVRFhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217575; c=relaxed/simple;
	bh=LDsBB8xAOzR5ZS7r/hwK7KiK99LXLdNGD/eGzORUVIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkYruAUYqOWJUN39PhWGExa5/CV1VuPTqFvObF0FeHG7XnY4R2FDTv6/5KSFUJtGXOsa2Gy39qEEnYWu+Qn0HRv8bZFYl27+gnYzUydG6gx2BHkN9hyIyFqhdtT6xeZWYpa//g1W70ngFhErSMpvgBRUJ+um87LmWQGukWGIGBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wprODQZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wprODQZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E726D1F000FF;
	Sat, 12 Sep 2026 12:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217573;
	bh=aEZ5dlGM01fwesC++2T3ry0RxkQFn70zAVPTlOPaPP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wprODQZtGjXGkHv9G4Eo7KdnTSP75BrkZULNJOhX3j/8oMDwhyprw2FGjoP6lEzGR
	 O6SIaS3tSWF8LLEEYNXKzM6Mnnc7ySC1cWiEszTIb+hH2JyeX6zIfKE9wDSHx9idQ6
	 1NVPLOSy+pB/6sMjLfO+OhycVxKvsrNQb4++JioA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0959/1376] coresight: Change syncfreq to be a u8
Date: Sat, 12 Sep 2026 08:56:25 +0200
Message-ID: <20260912065628.933354738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3683966bd0603..b2ee6f771cf76 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -825,7 +825,6 @@ struct etmv4_config {
 	u32				eventctrl1;
 	u32				stall_ctrl;
 	u32				ts_ctrl;
-	u32				syncfreq;
 	u32				ccctlr;
 	u32				bb_ctrl;
 	u32				vinst_ctrl;
@@ -833,6 +832,7 @@ struct etmv4_config {
 	u32				vissctlr;
 	u32				vipcssctlr;
 	u8				seq_idx;
+	u8				syncfreq;
 	u32				seq_ctrl[ETM_MAX_SEQ_STATES];
 	u32				seq_rst;
 	u32				seq_state;
-- 
2.53.0



