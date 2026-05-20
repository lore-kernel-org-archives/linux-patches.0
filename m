Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A821369D67;
	Wed, 20 May 2026 17:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298390; cv=none; b=c7FT5v0sBv23HotrZwifnqTPzYc+mN06iBhX9C7Jik2KOMQrVQv0D2RXwgWCs4Mq8lmVDhO3x1FEtHPQgU525uZ6PcQDECB9YssKRwtKvKFtLS5IqlSP4giGmwvysv0LtzUX4KHot8GhTRNTXkqXbQZQ9luXeoqM11UuWTlIVDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298390; c=relaxed/simple;
	bh=viMUc4S/OzxsLBXwaLcTxN0lIqgb9ooogmloGePkgnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo/qfpefDb9GYKOynFF4Bcs51jr7J02hSr9bhQradNFjFRkDYdpBu2M4Qf4tq2ryFL28e2bAeFr1HjcvVCpTba1MaSYERQl8HuRjEB/52cCAfDYSdCdsx92DGCYbM6UTSvL5F946pw6mlhi2NVEvV6GeR893tWzZ0/qOzWHAFO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGcHA2ci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGcHA2ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B881F000E9;
	Wed, 20 May 2026 17:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298389;
	bh=g0r38tT7tWD4g92K1drxfYT11MK181D009kNvj36PHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGcHA2ciidRwY/uLahA63O1WANMU47eX2XXwan9xYrux65efrpaGoaUZBgotggHkZ
	 jt0mTEymQGGKDap1Z+vVdpeF2o4s4UjAPZMe9B6f2PdZ3yVgq25p2B1vRJaXMDA7vh
	 zRXuwZAO2Q0m2hECDDS7vmhAxDxpCHtK5UGxyl9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/957] soc: qcom: ocmem: register reasons for probe deferrals
Date: Wed, 20 May 2026 18:14:33 +0200
Message-ID: <20260520162142.985833370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 9dfd69cd89cd6afa4723be9098979abeef3bb8c6 ]

Instead of printing messages to the dmesg, let the message be recorded
as a reason for the OCMEM client deferral.

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-2-ad9bcae44763@oss.qualcomm.com
[bjorn: s/ERR_PTR(dev_err_probe)/dev_err_ptr_probe/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 7bcd0c71d7f64..ed77fdc76c9b2 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -196,10 +196,10 @@ struct ocmem *of_get_ocmem(struct device *dev)
 	}
 
 	pdev = of_find_device_by_node(devnode->parent);
-	if (!pdev) {
-		dev_err(dev, "Cannot find device node %s\n", devnode->name);
-		return ERR_PTR(-EPROBE_DEFER);
-	}
+	if (!pdev)
+		return dev_err_ptr_probe(dev, -EPROBE_DEFER,
+					 "Cannot find device node %s\n",
+					 devnode->name);
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-- 
2.53.0



