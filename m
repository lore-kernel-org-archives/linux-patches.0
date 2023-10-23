Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2825916405
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f06QagxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98265C433C9;
	Mon, 23 Oct 2023 11:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061418;
	bh=4wtzIQfvaH+QTIAmbf7dvtKXC5HvoKvUplVDLqmTSNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f06QagxFRlMU2b9tfK6Fdz9fJdQDK73NSVGIo7kZi3RUqVRRhZhBZzsHPfjDNU4ZW
	 rF8sgpo4YByT89jmAhNTWefsd8qEUYa753Gl6Bw6p3pRPiUdLQrBZCFOZRutFr839L
	 exN+kc/RWfRvG3FiWIfdEu6NMxhHoAkbCHiPfBUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/202] perf/arm-cmn: Fix the unhandled overflow status of counter 4 to 7
Date: Mon, 23 Oct 2023 12:55:11 +0200
Message-ID: <20231023104826.709189963@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Zhang <renyu.zj@linux.alibaba.com>

[ Upstream commit 7f949f6f54ff593123ab95b6247bfa4542a65580 ]

The register por_dt_pmovsr Bits[7:0] indicates overflow from counters 7
to 0. But in arm_cmn_handle_irq(), only handled the overflow status of
Bits[3:0] which results in unhandled overflow status of counters 4 to 7.

So let the overflow status of DTC counters 4 to 7 to be handled.

Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/1695612152-123633-1-git-send-email-renyu.zj@linux.alibaba.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 36061aaf026c8..ac4428e8fae92 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1177,7 +1177,7 @@ static irqreturn_t arm_cmn_handle_irq(int irq, void *dev_id)
 		u64 delta;
 		int i;
 
-		for (i = 0; i < CMN_DTM_NUM_COUNTERS; i++) {
+		for (i = 0; i < CMN_DT_NUM_COUNTERS; i++) {
 			if (status & (1U << i)) {
 				ret = IRQ_HANDLED;
 				if (WARN_ON(!dtc->counters[i]))
-- 
2.40.1



