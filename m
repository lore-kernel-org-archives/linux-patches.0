Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469539B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302576; cv=none; b=mQQy1mvVRxwIcjsgkYjC60veN4e1oKxCsFIbr9ZuJDUNOZeogbHMcMDFcsthlrLXeLsR3nQCxG7K9d13SPTx/biJNPwNK5jVQ/Zy/BzHix2XMnP8muf3103hKtllJS0J8yrBEQSM+BvcfWGIX8LizRkeP9EI9STPhfzemnZvUy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302576; c=relaxed/simple;
	bh=a6Hi1/LQNb1nk6kGzXOl02tFz5Q5sX0feyCelqo8NGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc8ST5w6b6JTOAuQROOMrpfkphbE4z63Seqek0mBX9e6hh5Z7NheWt14IR9OAFxHwgvtgzDcDNOfVBeKeL2stLErCStqh80vXTZyi9BWwkDfm/iWgkVHdDmYlTuwHsIc5xgewKtL7W8vJ8reGRCLXwCmyzCBHIP/2W7q7KsnVxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSpqn9gO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSpqn9gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BC4C19423;
	Sat, 28 Feb 2026 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302576;
	bh=a6Hi1/LQNb1nk6kGzXOl02tFz5Q5sX0feyCelqo8NGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSpqn9gOp1eRd5Pa2Ce3YOcW6IN0Rdly/wCJR4NnVzZnYHSia65Z68j51FibHe5xc
	 TelyurBkFPGSM8AhE9QH0QvzIA7I2C/astY9hfHvDjnY9G0nOwm+hRx8oEJsehKc/h
	 F9qEsqatMiUBgxxmlps2FED5fy/W5MJzLvfzvH+BsjIWhABg3B2toSn/wVEojSx07M
	 nwmMwTTzQZMSKPAId7tXj8FCu2IVb8chkeSGQU6NMV7DdiLm7B2tNVUq18dq+nBwCS
	 fVvUziM7XHoSbOyomz0Rl34ThekQ6LtEDCQ4vRAnbkfdQm8U+1p4uLr5Nuznqy3S96
	 ffLonoDEBQlIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hao Chen <chenhao288@hisilicon.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/164] net: hns3: add max order judgement for tx spare buffer
Date: Sat, 28 Feb 2026 13:13:43 -0500
Message-ID: <20260228181505.1600663-84-sashal@kernel.org>
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

[ Upstream commit a89cbb16995bf15582e0d1bdb922ad1a54a2fa8c ]

Add max order judgement for tx spare buffer to avoid triggering
call trace, print related fail information instead, when user
set tx spare buf size to a large value which causes order
exceeding 10.

Fixes: e445f08af2b1 ("net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6d2f142b1e4b ("net: hns3: fix double free issue for tx spare buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b907d693631c2..ac5d7ea206bb2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1044,6 +1044,12 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 		return;
 
 	order = get_order(alloc_size);
+	if (order >= MAX_ORDER) {
+		if (net_ratelimit())
+			dev_warn(ring_to_dev(ring), "failed to allocate tx spare buffer, exceed to max order\n");
+		return;
+	}
+
 	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
 				GFP_KERNEL);
 	if (!tx_spare) {
-- 
2.51.0

