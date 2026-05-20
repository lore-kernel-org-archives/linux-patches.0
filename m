Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887C736EA8B;
	Wed, 20 May 2026 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302244; cv=none; b=kLgQsZcvKDcFPl6XcxI00xhEk7N1ymZ2ajBlKiIg0XEIh66csuVTX4WcwBlJyfQJ5zynUB3OcfU/CGDI4/AJBN3uE4z0o2UsZDhrIluH1rcN3V+LnoLVpBrRe6pNPo56CRyOjD1FQxqj+Io/mNP26hs/rl0PK1KOf11f5foShCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302244; c=relaxed/simple;
	bh=JuW3CCx2oYQNVmcdTw3soBrwIIr1VPfT4EI+emJGEA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RH5mC7mQtFPN7dYhOlv+e+ziQCAxjfXBgAHO5chs0P29FFBTMGG+Kcrn6b7yp+cxszKxNNGDwy26T47fvwK4Rzfd6iS1IxuQZm1kPlXB4NdAK1Q/L0YuWy72Ti6F65mTMh8i0gf3wXOdgVWpN4d5e86M39s1rwWy/R//wZB7U3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q122qxdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q122qxdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA051F000E9;
	Wed, 20 May 2026 18:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302243;
	bh=VbUG/U+v/qiGiEUdYHHy2wvU1njB8CjLh0DtDYMO67w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q122qxdTdCCIzAO65A4LUN+DrsTlWssuoleklCKW6t1N5cKkzmSNhER0h3S+qxDaw
	 I2eZfa0B49jg6H+eMeHBkMR3dwCkXETsCfp2HNdyzNIR+hE3ZYblC4fe1UIRkQLm8A
	 IAm6/WpO9grDbmGeicj7cmTbaZgT1haL64jjipsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/508] soc: qcom: ocmem: register reasons for probe deferrals
Date: Wed, 20 May 2026 18:20:16 +0200
Message-ID: <20260520162102.817315438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 697c8a6a400b1..b37f21793687c 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -195,10 +195,10 @@ struct ocmem *of_get_ocmem(struct device *dev)
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



