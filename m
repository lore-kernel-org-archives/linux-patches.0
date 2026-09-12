Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3B32D0C94;
	Sat, 12 Sep 2026 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210371; cv=none; b=ib1gDgEp3Y0f9m0siWSTlyhU0xmCj+7EZDerabVlA+vHApVwgVCkofbqES962SZOO+AJntvokUp0mcAQQeaJCuVXR7EJ+3M3Yfc0KqWm0eNvIuvK3Nmv4SGNirva2eGX0HuF308LJiAdEbMmkcfOf9ssAiMjCO1oLmoujVLQqp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210371; c=relaxed/simple;
	bh=wfYFMiQaaNuYuqr+l3jTzE0741VPUjL79bFz0o5YqDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=at7+PkJZU5X7GoChmWrgjyjocnFZHLjNmfggd85n8+/3ycj73ys+Oog5pk2dwrkGai7RlVY8PkJQGBPL2K/gisl6yLq/bEEQ840NRM48s1+xZymZ4FQk5T0R0iwGXzmS1GTO71Kry6+ytjMPSYtScTP4sf2PJ0qRR403kSQ5QNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4TFua8a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4TFua8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7161F000FF;
	Sat, 12 Sep 2026 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210369;
	bh=5+XagdkiN1FDaJBWSiI8CiMU/5egBTqkkTVznzjV0rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4TFua8ate7K1Vg7pTF9sM+CG0flZmFWrn1IS+GvYdEr3fAoZ3X/tG3os9/aSE+L/
	 9EaepS2Bpc1n9ZXbEEa16M8o4YawrRfO3YAVqck2pjPoxkFdyb+fCqod+cw4ZxjUOm
	 iNnDCjYQNhkvBAMNtRlDi4Zg+MgQiSCvwo217lcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0969/1518] coresight: Change syncfreq to be a u8
Date: Sat, 12 Sep 2026 08:52:18 +0200
Message-ID: <20260912065645.379650284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 012c52fd19338..0287d19ce12ed 100644
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



