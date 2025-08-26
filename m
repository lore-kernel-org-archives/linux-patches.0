Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31A81E51E1;
	Tue, 26 Aug 2025 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213016; cv=none; b=d0B7e8iXNA7U92a8KRYhleuavCvQx86nr7gidUCHLZq/hTqURAyetu7QvRayDfYfubmOb3ObM2EOzEPKgl0BqsR1jSmyOEgXpNs2ot7HBDuCs7z7+V/UxkCmRtJkcQkppB+53D8q40y+HXXEsH7/MIjTz36ofkM3Lx51ec3sIao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213016; c=relaxed/simple;
	bh=Pilra5kor0eTop2X9kn5H/vBed6lAASEmY/vAP2F+s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgBO4S/cSCm9rsHHv88L94evAmg7M3R2rjVqV44/wSmn2R1+RTQIaobRiJNTOnv8JFZGMrRPTRGVzd+aJtbybb2Dhwj8TLsiMT5rlUF6MOzXLAfSDAqX98daebbO6vx7tCws5SIqyCC7paw/ZKmXMI+pObQAJFAR6g1JaObBtgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9WDJU7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9WDJU7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5D9C4CEF1;
	Tue, 26 Aug 2025 12:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213016;
	bh=Pilra5kor0eTop2X9kn5H/vBed6lAASEmY/vAP2F+s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9WDJU7GMGzPg9BHLCAJ1DKk/RPL07FD08VVGcl+Dn34/L3NPbTIF21EHRPgVT2IT
	 slmZZlLfiDTqCYgKeHshR9GSuI3kqf1CjiX/S3si4sTF4Yp0nlpyFVd/dO++XgHTL3
	 0Y2Fz3X6sJ2hgyoaDJdFBN+ZIvGH+bTAq/2nyW9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/587] perf/cxlpmu: Remove unintended newline from IRQ name format string
Date: Tue, 26 Aug 2025 13:05:08 +0200
Message-ID: <20250826110956.991492165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 308c9969642e..c03df0f52889 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -881,7 +881,7 @@ static int cxl_pmu_probe(struct device *dev)
 		return rc;
 	irq = rc;
 
-	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow\n", dev_name);
+	irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_overflow", dev_name);
 	if (!irq_name)
 		return -ENOMEM;
 
-- 
2.39.5



