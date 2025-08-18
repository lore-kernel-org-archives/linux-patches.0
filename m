Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA857262D;
	Mon, 18 Aug 2025 13:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522029; cv=none; b=QDvbwEEjNglhg5bz4Cwd8lgwXFW5SBq4+Uc0XXRwAgyQzD9WCFA/maVYDXulFly29XBMsGgsL7MS0HGxFkxBFRiSPOif7sNoi3khlUgz7y0VDzDlPS9dcBgNHtmbddgpZI04n0ymgHeEuWpwd2cT1FLZZS0CCoK3Q31VbHcG/jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522029; c=relaxed/simple;
	bh=FC6jCL67rZh7kzWBy4b1xfhBXY9u21wzzDDxoO5M04o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSoCE/HzqPIilRTPcYJnBVCikSgIeuRcWZ4RkE6Whb5j6iucvNRUIju2lAG4+X5gdpQ5NvvY6UphDCMzz4VEzgOw/saYRubPW1Ui7DO9euxkg364nF/rRCs81FzIt6wfKfgdPyxYpQTGurhR6SEY1yvEiKhi1X7WiJk+dFH2wMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSnvog6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSnvog6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07422C4CEEB;
	Mon, 18 Aug 2025 13:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522029;
	bh=FC6jCL67rZh7kzWBy4b1xfhBXY9u21wzzDDxoO5M04o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSnvog6bzzYO8V/AvItz/GxuXg74qoSwceX+ojR9Hs1BSK5bhxbx/XeonfIy1eI79
	 i5wD0r4qxMSaWfbvv3Em3Qyg8dzn9xgaDcSFHE6r3nkKqfHuRm2Fqhb29r63ZLZJm1
	 0RqhQEIEfe2Wl2feNNVMrfgli96dXKP7Vn4eHFSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/444] perf/cxlpmu: Remove unintended newline from IRQ name format string
Date: Mon, 18 Aug 2025 14:43:40 +0200
Message-ID: <20250818124456.142647115@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 3e870815ccf5bc75274158f0b5e234fce6f93229 ]

The IRQ name format string used in devm_kasprintf() mistakenly included
a newline character "\n".
This could lead to confusing log output or misformatted names in sysfs
or debug messages.

This fix removes the newline to ensure proper IRQ naming.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://lore.kernel.org/r/20250624194350.109790-3-alok.a.tiwari@oracle.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 43d68b69e630..16328569fde9 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -870,7 +870,7 @@ static int cxl_pmu_probe(struct device *dev)
 		return rc;
 	irq = rc;
 
-	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow\n", dev_name);
+	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow", dev_name);
 	if (!irq_name)
 		return -ENOMEM;
 
-- 
2.39.5



