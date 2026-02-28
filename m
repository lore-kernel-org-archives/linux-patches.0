Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BFE37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302573; cv=none; b=D/09sFAbmtdXQHqaq0nyACW4qz0l1jPLAsKfz1x0ramSzCUkYa5ZSq9hWy4TAIqRYijF/n9XvxE3pXu51LrtyInz2xDE9/jgmN/maECq3xAQ1IY9+zTdPltFRxLdTdH0gGUQW24JKWO1MsRxjkjPJe+1xACK6yh1ESEfc+nXU98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302573; c=relaxed/simple;
	bh=1lUshCcUMEv+PeNLgc2pLOdOS5n0wW/PSegKxl5fbLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DM+kp1jMyCCbw0M9JskSJMfNhTOx13As22TBXb9LVGx5tpdnXLlBOoLfyR9uQa7Y9WLYkHHjTIatYRi43N81nAKzyjlyE4flMxJwVkxqSPniqbY31MzWGNWc70jeXyETZeRK7WHJMlJFHnlXp6YHrWQWkkLmwwu/DGd++XpqfeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkFJB8X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkFJB8X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593DBC19423;
	Sat, 28 Feb 2026 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302572;
	bh=1lUshCcUMEv+PeNLgc2pLOdOS5n0wW/PSegKxl5fbLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkFJB8X4X3xOFdWste3YMo7U+w4qe3p9Uq+76ozb+u5uBFbkttPPJ/lUIEhUsb4hA
	 6w7eGqYtX+EbSGCn8Jo1DpjaWUwS6VIBzCNWiWhF4OfHbZtyhX9qIvVc3nBiMveF3f
	 nr+w5hNDsqjOaMiD0lLlZINLt+FRSLbXE90IrO6EKakpKDG6iecgtuLYEXavQxTTrd
	 gLVxY1Bs++3HULUomPPbCiLmOAb8xjMCV9gdGqZbvDImGgNdu9l63aPHv4JkBLXswM
	 n+jVOi+sHkYrcCE8PQiXSXmcQuPCCmlneTTw+Koyq5ccf4U7+GuJcy5orCc8/iBtBE
	 E3qy/01o7EcNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hao Chen <chenhao288@hisilicon.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/164] ethtool: add support to set/get tx copybreak buf size via ethtool
Date: Sat, 28 Feb 2026 13:13:39 -0500
Message-ID: <20260228181505.1600663-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit 448f413a8bdc727d25d9a786ccbdb974fb85d973 ]

Add support for ethtool to set/get tx copybreak buf size.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6d2f142b1e4b ("net: hns3: fix double free issue for tx spare buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/ethtool.h | 1 +
 net/ethtool/common.c         | 1 +
 net/ethtool/ioctl.c          | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index b6db6590baf0a..266e95e4fb33d 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -231,6 +231,7 @@ enum tunable_id {
 	ETHTOOL_RX_COPYBREAK,
 	ETHTOOL_TX_COPYBREAK,
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
+	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
 	 * tunable_strings[] in net/ethtool/common.c
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index c63e0739dc6ac..0c52100159111 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -89,6 +89,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
 	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
 	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
+	[ETHTOOL_TX_COPYBREAK_BUF_SIZE] = "tx-copybreak-buf-size",
 };
 
 const char
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 8f44bdae78bf7..fd26baf6e6ea8 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2432,6 +2432,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 	case ETHTOOL_TX_COPYBREAK:
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
 		if (tuna->len != sizeof(u32) ||
 		    tuna->type_id != ETHTOOL_TUNABLE_U32)
 			return -EINVAL;
-- 
2.51.0

