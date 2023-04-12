Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C472F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCF1C433EF;
	Wed, 12 Apr 2023 08:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288998;
	bh=Nu44ymle03dOZ7+jAaV71SrqUhCT+O1lzsq1ySYOKDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJie+wHkgyd0G+7LugA/Y5hqSJVy9rr2PVKmdUcSWEuiZ8wbigJXpCBZHFc/hmmWx
	 i3YHfqILOZJ6uYcAqEbb2REjLBGKleraOse5entIEmKl2OFt20DViIQXBjsaIQ0uQ9
	 J7mOUVsccbgA2ysOnOnyAe06hb1oQHf/caQ3kv2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Clevenger <scclevenger@os.amperecomputing.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.1 097/164] coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug
Date: Wed, 12 Apr 2023 10:33:39 +0200
Message-Id: <20230412082840.786756421@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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
@@ -451,7 +451,7 @@ static int etm4_enable_hw(struct etmv4_d
 		if (etm4x_sspcicrn_present(drvdata, i))
 			etm4x_relaxed_write32(csa, config->ss_pe_cmp[i], TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		etm4x_relaxed_write64(csa, config->addr_val[i], TRCACVRn(i));
 		etm4x_relaxed_write64(csa, config->addr_acc[i], TRCACATRn(i));
 	}


