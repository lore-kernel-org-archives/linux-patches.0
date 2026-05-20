Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904B1CDFCA;
	Wed, 20 May 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295664; cv=none; b=mgKeGZzfJ7LoKd6K8g0/9AiaOnxLD6XLLwjXjvtPRi1/vkE0DW7/NCZJfgPeUJztnJTyT65zaBu5NqT89mZgl7Pri8Sk1cRsDaOrkwvHaZJeg0MZMg1v3OjqW34HyxxKYu6yqCYIYbqjskL4fLzvdhnj/qc16N1OFiBHOHz7xUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295664; c=relaxed/simple;
	bh=3OwL5JnoSqYdMAXwxPQm6/+SpJ0IMszBGAjoe8x4eXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDpLLSfvUIgins9253nnKQ5tJ81iXhf0GIz/G/IpHi+MjSexRx8GWI0S8/JwkpSEyDVXy/PNf5N/Doa6FZSo8W0tGqS/Q2/A+M2M/KH6UP3tbLOW4H+SVV87odRymQZh/ByBRj2BkdJPegi/PgueHZPaDJPWslUzy9kAOkkEFhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVvSo3OP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVvSo3OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D5F1F000E9;
	Wed, 20 May 2026 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295663;
	bh=N/ZRI+VrtTvjfqAGTajASkVDdTMSiT0InIeYtVk/3pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVvSo3OPNFdMlYwtyLKOznkyoASm98vTCBHYnE/j6HCtm/K+0SyQZMhvly0Mi3uVp
	 icz4b86y4lNQ+8P7WctsuW8lcsBzcfVdFY+lX9UaB2GfjDkLl1IOL4XkB+ME3/3IhJ
	 yJ9nJ8HsF3uoAC/HpFXfwfuu9NdXuj7FHi/ITQF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0504/1146] soc: qcom: ocmem: return -EPROBE_DEFER is ocmem is not available
Date: Wed, 20 May 2026 18:12:34 +0200
Message-ID: <20260520162159.595459634@linuxfoundation.org>
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

[ Upstream commit 91b59009c7d48b58dbc50fecb27f2ad20749a05a ]

If OCMEM is declared in DT, it is expected that it is present and
handled by the driver. The GPU driver will ignore -ENODEV error, which
typically means that OCMEM isn't defined in DT. Let ocmem return
-EPROBE_DEFER if it supposed to be used, but it is not probed (yet).

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-3-ad9bcae44763@oss.qualcomm.com
[bjorn: s/ERR_PTR(dev_err_probe)/dev_err_ptr_probe/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index d47ce5707fd88..96ca0b87bfc48 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -203,10 +203,9 @@ struct ocmem *of_get_ocmem(struct device *dev)
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-	if (!ocmem) {
-		dev_err(dev, "Cannot get ocmem\n");
-		return ERR_PTR(-ENODEV);
-	}
+	if (!ocmem)
+		return dev_err_ptr_probe(dev, -EPROBE_DEFER, "Cannot get ocmem\n");
+
 	return ocmem;
 }
 EXPORT_SYMBOL_GPL(of_get_ocmem);
-- 
2.53.0



