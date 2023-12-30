Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F4579DC;
	Sat, 30 Dec 2023 12:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMi6IweA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1227C433C8;
	Sat, 30 Dec 2023 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937674;
	bh=dCo58GCm1R/opRgxbjpr0m1axxBzity5HmgCGUgaTt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMi6IweArKGOod0toOERKmKnqKwy1C6zzY0J1KpiswfvGwBmsozVg8UouBsmqKxLv
	 tF+15bNvn0w7cKLOH8plXcGDr9UQOLIl5HcZG8RYcaL7OnvPDcBeS5mxH2K4NIezFY
	 F4AbPp0w+x+sLfJQ3APmJGmxcVRD2z5kudcy+hIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajvi Jingar <rajvi.jingar@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/156] platform/x86/intel/pmc: Fix hang in pmc_core_send_ltr_ignore()
Date: Sat, 30 Dec 2023 11:57:53 +0000
Message-ID: <20231230115813.002035492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajvi Jingar <rajvi.jingar@linux.intel.com>

[ Upstream commit fbcf67ce5a9e2831c14bdfb895be05213e611724 ]

For input value 0, PMC stays unassigned which causes crash while trying
to access PMC for register read/write. Include LTR index 0 in pmc_index
and ltr_index calculation.

Fixes: 2bcef4529222 ("platform/x86:intel/pmc: Enable debugfs multiple PMC support")
Signed-off-by: Rajvi Jingar <rajvi.jingar@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231216011650.1973941-1-rajvi.jingar@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 84c175b9721a0..e95d3011b9997 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -472,7 +472,7 @@ int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value)
 	 * is based on the contiguous indexes from ltr_show output.
 	 * pmc index and ltr index needs to be calculated from it.
 	 */
-	for (pmc_index = 0; pmc_index < ARRAY_SIZE(pmcdev->pmcs) && ltr_index > 0; pmc_index++) {
+	for (pmc_index = 0; pmc_index < ARRAY_SIZE(pmcdev->pmcs) && ltr_index >= 0; pmc_index++) {
 		pmc = pmcdev->pmcs[pmc_index];
 
 		if (!pmc)
-- 
2.43.0



