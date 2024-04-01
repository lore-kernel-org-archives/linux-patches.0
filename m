Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0481C0DE7;
	Mon,  1 Apr 2024 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989221; cv=none; b=UHwQfGZ0VTRtsDHIPb6H0GgG+XiCjdfaJ0OVMszKczSb7giKiIhPjkKbQAmSCsAPZr/UmlzQBSiy1f9D1USvAhwVed2Tsb0/liPXouWlZoAiPyopdRgtFxeCrwMSasfNT9VVRxlIJn/cX/T9lu2zQ9OYzJjdkqHAYSoLkDH2aDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989221; c=relaxed/simple;
	bh=sHKIn+dzk7gxoZUar1BwuJSRhTULBVt1fHBC4t1RQLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwwbN6I2EwniC9gDGNMNZ2YoGLTx/V6i6YEDcSWTdDO0/fL9cpp3pM3+40yuIOm6kaQB6RNuyXKbDGZ+GTcjZlugLP1Szn9KhYfpmDas03t34lRFV0ZyFW7+M30h3HfYdeDRr16kuXOOXVMS2njsYAqIWjKKu9zY9Co/mqMG0EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9/1D2T2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9/1D2T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5998C433C7;
	Mon,  1 Apr 2024 16:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989221;
	bh=sHKIn+dzk7gxoZUar1BwuJSRhTULBVt1fHBC4t1RQLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9/1D2T24LxGqRbEZC/YdZVRF3B+YT+oo3EWNblSGgYTZ284I8aMiIyssga1Gvm3B
	 Xt8+Fn2MacgNGlY0veXyRCPmOsIV+I/LQWiQb1y02ICLl4vy77HIIBcTOQybpjYdmq
	 Lf5DcBz9LJSkaKPvPELaMAU+WUMkpIcKzvTFaCd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 389/432] scsi: ufs: qcom: Provide default cycles_in_1us value
Date: Mon,  1 Apr 2024 17:46:16 +0200
Message-ID: <20240401152604.922088100@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 81e2c1a0f8d3f62f4c9e80b20270aa3481c40524 upstream.

The MSM8996 DT doesn't provide frequency limits for the core_clk_unipro
clock, which results in miscalculation of the cycles_in_1us value.  Provide
the backwards-compatible default to support existing MSM8996 DT files.

Fixes: b4e13e1ae95e ("scsi: ufs: qcom: Add multiple frequency support for MAX_CORE_CLK_1US_CYCLES")
Cc: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: stable@vger.kernel.org # 6.7.x
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240218-msm8996-fix-ufs-v3-1-40aab49899a3@linaro.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1397,8 +1397,10 @@ static int ufs_qcom_set_core_clk_ctrl(st
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk) &&
-			!strcmp(clki->name, "core_clk_unipro")) {
-			if (is_scale_up)
+		    !strcmp(clki->name, "core_clk_unipro")) {
+			if (!clki->max_freq)
+				cycles_in_1us = 150; /* default for backwards compatibility */
+			else if (is_scale_up)
 				cycles_in_1us = ceil(clki->max_freq, (1000 * 1000));
 			else
 				cycles_in_1us = ceil(clk_get_rate(clki->clk), (1000 * 1000));


