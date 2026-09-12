Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D0331EAE;
	Sat, 12 Sep 2026 16:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231054; cv=none; b=bmLsRdkxV0XvubwhY/c+fqaTKfcz82+M8DJ3uXKeU8h+AWifWcZPdWh8Yg28HHZvhPSlhpnPmjEBZj+nDYjRxp29xwi6NSfG/EnuK6hClzL7ToIXj0OU1yMHzfMOICHzcVgsXzNSMxJxKaQ+HqDdV36FHAQKezXtTXAgrJO39GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231054; c=relaxed/simple;
	bh=DBVHj+OkRMNIr1Uv/VqXUGqJG7hw+rkuh6FoX07a/dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljYC1zeX7NMIsCXgFAms8toHJ8RSXMh5VMTt1NNFWB596xWPV3g0UqEa5moP/jOqd4TAfrrRVu6hhC51OtyQsyC/fCzOI2stfqKgSiAcQxGzrUJkJL58D5fiN18IQLt+HFq2DDyyHvnL+c9ApX9P00t/NkaoyiPLUzT3uZR9+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+dcWdz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+dcWdz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828B51F000FF;
	Sat, 12 Sep 2026 16:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231052;
	bh=54spDOc5Pb4lOSsa6ev75dQeWfm703xFhpvogZ6qemU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+dcWdz0N/jFBp2kUeQDgLtVIjwFkh5jb6MBeIJ7r7qIpBW2A2oLB//4B6aGhe7Ar
	 k8phQBiXqJ4khA2N7tCFWhcp+RwqvU9maRjzU8moV2Z7zKjDhWoApSHj/LYAi/z8Vk
	 A7DWyeMj/7UC0Vb/Dpf61ldkdPL75VbJds4G9TGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0918/1191] coresight: Change syncfreq to be a u8
Date: Sat, 12 Sep 2026 09:00:46 +0200
Message-ID: <20260912065608.852474874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b183d1d12f129..bfc7ce8106230 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -823,7 +823,6 @@ struct etmv4_config {
 	u32				eventctrl1;
 	u32				stall_ctrl;
 	u32				ts_ctrl;
-	u32				syncfreq;
 	u32				ccctlr;
 	u32				bb_ctrl;
 	u32				vinst_ctrl;
@@ -831,6 +830,7 @@ struct etmv4_config {
 	u32				vissctlr;
 	u32				vipcssctlr;
 	u8				seq_idx;
+	u8				syncfreq;
 	u32				seq_ctrl[ETM_MAX_SEQ_STATES];
 	u32				seq_rst;
 	u32				seq_state;
-- 
2.53.0



