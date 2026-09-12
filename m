Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7534429000;
	Sat, 12 Sep 2026 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217529; cv=none; b=KY9hG+6QrGXZWZw4pe9UTvnyFn0yqjsgCLMxTtZtULh36ZYima6Liei760Ktyxt6d48rKjdZIFWezr9YdMYKoXeMwMSBIB/NP1jELX+ZDXx38BwPXJLv0bajPcUOD8B8tdLJhql6o3VGyRpfaQKSh2lBzNzmdPUa6blryydHMU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217529; c=relaxed/simple;
	bh=+Mfvvf7BNfP1R8jE4zr6QBA30WtXjruxkXz3EN/3ORE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka+lykjQoQAwB+E19fV+LluBxM1m0q3gv6NqpvCYMLCnmo7pYY21Gwpfski/zIY7T8WkFL0bXBuQpMJz5naUXw2e/a1usvs5cbaMUh9rU1aUrU61mOVvU+GTymDmqGUsZzXWsQF9mImwh+ySivVnGpidgdDoClExfich10zqlqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFTe7AXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFTe7AXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3401F000FF;
	Sat, 12 Sep 2026 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217527;
	bh=vjNZTMrhgrmJ6B4nwtCqSG8XLflGVMcOmx+JNTLf6Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFTe7AXNoSuYq3pJlsLosQ3YA8yS8fA30Bom0GbG2dcExqvzNc2Zmj5n/W/wEhNgZ
	 DmTpV82enpN2vn5aAOJ7/zumHMynCrkdR9A0xrs3R2VRIZyXSP3TE1M56bO/+qCYX/
	 K2plT/5r33HzIlOXbO+UDx/k5SMSuGjAGwSJSO68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0958/1376] coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()
Date: Sat, 12 Sep 2026 08:56:24 +0200
Message-ID: <20260912065628.911643639@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 0e1cd4270b42a257c139165622091e1e8c7104a7 ]

According to Embedded Trace Macrocell Architecture Specification
ETMv4.0 to ETM4.6 [0], TRCSSPCICR<n> is present only if all of
the following are true:

  - TRCIDR4.NUMSSCC > n.
  - TRCIDR4.NUMPC > 0b0000.
  - TRCSSCSR<n>.PC == 0b1.

Comment for etm4x_sspcicrn_present() is align with the specification.
However, the check should use drvdata->nr_pe_cmp to check TRCIDR4.NUMPC
not nr_pe.

Link: https://developer.arm.com/documentation/ihi0064/latest/ [0]
Fixes: f6a18f354c58 ("coresight: etm4x: Handle access to TRCSSPCICRn")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-2-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 05958827b3bbc..2762c1e429987 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -87,7 +87,7 @@ static int etm4_probe_cpu(unsigned int cpu);
 static inline bool etm4x_sspcicrn_present(struct etmv4_drvdata *drvdata, int n)
 {
 	return (n < drvdata->nr_ss_cmp) &&
-	       drvdata->nr_pe &&
+	       drvdata->nr_pe_cmp &&
 	       (drvdata->config.ss_status[n] & TRCSSCSRn_PC);
 }
 
-- 
2.53.0



