Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30B830DD13;
	Tue, 16 Dec 2025 12:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887517; cv=none; b=T/ErdWyMUyjPecBid4IdBtI9TIgjVnNTAcfIO7PWtzzsy36AamMHSJtS+TBGCvx0s7vPjWeSBjCnVvNW1Qrl6101uvxJIB9wtBrdjXZYvyrM5dJNTvBCOi726Wsl0qH2rdqDrQOJVzJF9EqolJcU52SQZSngI03mPgs3DGXb5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887517; c=relaxed/simple;
	bh=K5NsbN469r2UudrGbyKYZusHV1LOrtxXBCCjQuhkoU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWSSmmT20whGkjlwL4kjxE3sE/xJe6toGbPz2gm3LcswXxhoWHn00sk8y4664QE4ziD8nft24TBZGHSbPKwHD1U/NpWaQSuEIJctAeBvJ3fdZI6bnXuNWm50unrhBR7y08JQGQD34dejpN1MmJPJb9+0lb6IqsIhhk6QMvOBoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIU8LJje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIU8LJje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575DAC4CEF1;
	Tue, 16 Dec 2025 12:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887516;
	bh=K5NsbN469r2UudrGbyKYZusHV1LOrtxXBCCjQuhkoU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIU8LJjeMq3AwazyrvsJv6cYTho8CMLmea524TLH0c3wXg7/PKPlimugT7/92S6Uo
	 EbD3CsJPCKbN2Q0DHtVRfAiWSONwltFcp5knwuZ1hkmWbvn6HKgGFCpubXtBs+44E5
	 W+TFF+c4p229SgZaotBmRRe6iMnb8O1vs1Blzy2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/614] coresight: etm4x: Correct polling IDLE bit
Date: Tue, 16 Dec 2025 12:10:22 +0100
Message-ID: <20251216111410.613614726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 4dc4e22f9536341255f5de6047977a80ff47eaef ]

Since commit 4ff6039ffb79 ("coresight-etm4x: add isb() before reading
the TRCSTATR"), the code has incorrectly been polling the PMSTABLE bit
instead of the IDLE bit.

This commit corrects the typo.

Fixes: 4ff6039ffb79 ("coresight-etm4x: add isb() before reading the TRCSTATR")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-4-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 1324b40d54210..c562f82985192 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1924,7 +1924,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trcpdcr = etm4x_read32(csa, TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
-	if (etm4x_wait_status(csa, TRCSTATR_PMSTABLE_BIT, 1)) {
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 1)) {
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 		etm4_os_unlock(drvdata);
-- 
2.51.0



