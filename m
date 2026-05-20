Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E30334C1D;
	Wed, 20 May 2026 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295662; cv=none; b=JL3z/FTUNN0ShxkYXgk1aEX4ffBjZG3Ntz29NHyAArK+ECQXvMQXObDpRnSHGAKRvn/SGALUAtjS36TGEzHBOywGFdh2lzFam/qNCHQuU/S0mDP5BBs2XYcObfxt/nLHMNMR86jcu6uHR7nL7sD0e9smnzG53LW6wBtNqdj8sSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295662; c=relaxed/simple;
	bh=SjC98U0+yjIssBg1p6FCSE7dtTcxoYujcSP+13JuhIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv3OJAp8y5VFB7FxfSm269lqZt/IfXIHul5yZPjv1x6GO5UsJimQunD8nYtGD4Ql2LTPDhUg0p1oz+90JvPr+Ar8WXUiCW8vWup5N4d/lSkLQtwX4437c6hCe6ei0qqkKPGTwLq7c/S+Ex1OhnjQP6IhGq0ZOqQtz3OPlVM9FWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ox1OH2k5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ox1OH2k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713BA1F00893;
	Wed, 20 May 2026 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295660;
	bh=RgaihKdFFEzKrpQvT14Lu7W9erNFpWEQwmBvvRvZIMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ox1OH2k59OYKsl0PTrA4nJkGqvTNBvG3fA0/wMB2covMfoKZYI9yBK2/8KNq92Pjw
	 2ytWO3fi1eLZ1I+RV0KIUtepW0Z8nscy2pFPa/tV4CTUNsBBRLsDxU6SynYKdreEgx
	 CT+Ew5Oj7kVIdEZdToYK43TCbOQDNt9JumghmA4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0503/1146] soc: qcom: ocmem: register reasons for probe deferrals
Date: Wed, 20 May 2026 18:12:33 +0200
Message-ID: <20260520162159.573687365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index dd46bb14b7be3..d47ce5707fd88 100644
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



