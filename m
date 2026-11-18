Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030773;
	b=OTa1rsBKLfiRel5jOw98DyHq0aAlVawLIwBSVxmvlLiUsct+rHZrewQW1ZvtGfanG6X3
	 1kZK13UBmbd/iPJJ6rzCUOJW3wuzDtr09Tf3oh5Xq4H8CgE0sb8CTwTxh12h+3YMn5+7e
	 CzAW/s1wJuzopnQQz5jPqdSLaLKSmmOMHb4XDdi0mve20N6PDj1duAO3N/REFNdF1sOrq
	 +YDwNe2+P/vjej9M+5E4Ov4Bogdn0U5NYpO0Tar916wkUbcHlE5tU/zPXzeiVkTb79o0+
	 BJJdPOTwRmGUolNO3lCHJ501wQHXNRrF0RsLBRM7SnwLN/+yrpJCIFBxEzgGOErQQbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kJMq8KeKMiIs2J9bbAYJWWKLYol7mCx+I2KaI2e5aJQ=;
	b=5VoQOBiKjrrw04Lnm1gEuSrBW8mLAdV2KSfvESA+D+g2dFvyLWmP6NioN4YETzw0NepF
	 YT7MFW89IAPy1iUk/wQvJexnmNAObAB3FvzsP8hOVy5ht4cIo4EOcrtwKY+OqT4r3osjF
	 2ufIa/aEmtDNNc3FBKDfvAUwLByRz0q/W/szXTrkK5YTcjek6hrZJzAUPioW9g3vn0Fi/
	 MY0FWFUJgmtlaIX5SfEPtdpnHZjGNl/L+U4JU15+rEP5TiZKLSnvgeWX5qTSkKPCNg3sn
	 lkxvhaUR8J6VYeBoMKwz+2j1NnzAzVB4gaKxGmLsQaIigRpMQx5SMKJxq2rVa+eVA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQ06YqcB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507CD606C703;
	Wed, 18 Nov 2026 19:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQ06YqcB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017721F000C4;
	Wed, 18 Nov 2026 19:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030772;
	bh=kJMq8KeKMiIs2J9bbAYJWWKLYol7mCx+I2KaI2e5aJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQ06YqcBuDmisC/cTcDcSpFVQd3WB9k/pKWAU5ZwF19rY6t+5CONnJ9utXRNb8ekf
	 9Bx/MRZt4FQB/1xQRgPsjgrc9X8pmQWDrdtDe4wFW6oBTJyXUY2SYL2N9aSB0M7zwI
	 Sga2l93S+CwyiiSFRR/Sv/Hj2J0sIToXFyZcWvUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0822/1756] perf/cxl: Dont log through pmu.dev in the overflow interrupt handler
Date: Wed, 18 Nov 2026 15:49:09 +0100
Message-ID: <20261118150042.282802871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 984920c893f0e6832351bc03deeb5ef9a42fbdbb ]

perf_pmu_unregister() frees pmu->dev without clearing the pointer, and
cxl_pmu_probe() orders its devm actions so that teardown runs it before
free_irq(). Nothing in between masks the interrupt, and
cxl_pmu_event_stop() leaves the overflow status bit set, so an overflow
taken just before teardown is still delivered and still reaches the
dev_dbg() in the !event branch - by which point info->pmu.dev is freed.

Log through info->pmu.parent instead, which is devm-managed and outlives
every teardown action.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index aec8bacd212c8..6a8201b704072 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -801,7 +801,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 		struct perf_event *event = info->hw_events[i];
 
 		if (!event) {
-			dev_dbg(info->pmu.dev,
+			dev_dbg(info->pmu.parent,
 				"overflow but on non enabled counter %d\n", i);
 			continue;
 		}
-- 
2.53.0



