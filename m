Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3312566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42718C4339B;
	Tue, 18 Apr 2023 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821411;
	bh=4xr1XZArObM+crzBG5lcvdijzoG8rYv0Mqgdj1ghbaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB9n1zTaJYuEiF93vfE/D1QLv3AyGNZLFXiXBZG7ZASzV9jE6WqiFFhmECr2L60wS
	 ekE2TTKFy2aRAC7rZ1fhhoCsaNSmFAjE9a52Qd3Fmr2OcHeWRrrPXEQCUV3xER/9pB
	 Or2cWxWSMox4HIbu48g1+8coIdtblnSxgKvSZUb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Clevenger <scclevenger@os.amperecomputing.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 116/124] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug
Date: Tue, 18 Apr 2023 14:22:15 +0200
Message-Id: <20230418120313.999417668@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve Clevenger <scclevenger@os.amperecomputing.com>

commit bf84937e882009075f57fd213836256fc65d96bc upstream.

In etm4_enable_hw, fix for() loop range to represent address comparator pairs.

Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Clevenger <scclevenger@os.amperecomputing.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/4a4ee61ce8ef402615a4528b21a051de3444fb7b.1677540079.git.scclevenger@os.amperecomputing.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -179,7 +179,7 @@ static int etm4_enable_hw(struct etmv4_d
 		writel_relaxed(config->ss_pe_cmp[i],
 			       drvdata->base + TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		writeq_relaxed(config->addr_val[i],
 			       drvdata->base + TRCACVRn(i));
 		writeq_relaxed(config->addr_acc[i],


