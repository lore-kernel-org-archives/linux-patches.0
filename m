Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C10F17BED0;
	Sat, 17 Oct 2026 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253478; cv=none; b=bi97sdn9bXcw+Ei/qFGlGRQbl1iqUqvFKtape9fJZKonqOi430BkX8pUyTy57FsMvamBm1dtka1CF+gPDmmWE3sFrpJ5Ej5QOZd1FLZ3oicVPQoK0PpxQNenM413iCgEzphB7b0M5ANCiylBw8uXFRofo3XfC+nDcrLcqh7FJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253478; c=relaxed/simple;
	bh=KaxpjIfm+jwfbpq0hpa2g6e4cT3dgJacZhXLPLmZGRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyLn3f6hC5aWBvCDk6onM9qdGz2JAHG7SiNi9MTlTXQosahu08IR7iZdZKUW5/wEgEQZvH7WpcFlu1MiVzNuCcTX6UdAx+5PsNbCRIAHzCm1V9KHgwOMOALZAPRLyU+h1grfXSmeK7hWVpfGfgRT46hfLjb4gWAvDZNQj5iEyRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaG8Mqub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaG8Mqub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EEF1F000C4;
	Sat, 17 Oct 2026 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253477;
	bh=J1ehWbAu2w9XkoGp3gwKHr0B0kdmcfQ3TRR2VgHkLGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaG8MqubqEYfiqjQl8gh+Gi0tDyImoLrafxoc6Q5glp+xBywNi8JkSuVN61UkDJmB
	 bqsP6p/7GPJGnmb/G/NCx6jhtqSuvf1ZBzPzJnHViHjEQb0S0u2xHb8/XFES3LTxX8
	 8iPcTg67xgS8dw/Jl+vA8JeYetVDfaqRtDkAN40E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/869] remoteproc: qcom: pas: Make remoteproc name human friendly
Date: Sat, 17 Oct 2026 17:49:32 +0200
Message-ID: <20261017160040.404790015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit b64b1266d6195d9bbfa75a93b4265fba2d447c86 ]

The remoteproc "name" property is supposed to present the "human
readable" name of the remoteproc, while using the device name is
readable, it's not "friendly".

Instead, use the "sysmon_name" as the identifier for the remoteproc
instance. It matches the typical names used when we speak about each
instance, while still being unique.

Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Link: https://lore.kernel.org/r/20241022-rproc-friendly-name-v1-1-350c82b075cb@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 142964960c7c ("remoteproc: qcom: pas: Shutdown lite ADSP DTB on X1E")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index bc1d56a2684e6..c3a634454d53d 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -714,7 +714,7 @@ static int adsp_probe(struct platform_device *pdev)
 	if (desc->minidump_id)
 		ops = &adsp_minidump_ops;
 
-	rproc = devm_rproc_alloc(&pdev->dev, pdev->name, ops, fw_name, sizeof(*adsp));
+	rproc = devm_rproc_alloc(&pdev->dev, desc->sysmon_name, ops, fw_name, sizeof(*adsp));
 
 	if (!rproc) {
 		dev_err(&pdev->dev, "unable to allocate remoteproc\n");
-- 
2.53.0



