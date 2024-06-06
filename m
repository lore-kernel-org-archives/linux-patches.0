Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA4B19DF41;
	Thu,  6 Jun 2024 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683479; cv=none; b=PULLgYqZhWDrYXdTwKQ3dBRT4KHcSaglU99Ze9v5SruSev9Ay5sF1Z2nLz/dOxQ/LyXm96FfXi9Sg8xt91uuTi7go1JKud9ComXhHFqNEvOQdKtNDpA++9CTRM9BEAiJmPLk6ABAs3z5sQ7r7ofZrMlbzWlhNNp11jE9PqmcK5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683479; c=relaxed/simple;
	bh=OLLKE/IVk1KndQ1z2Veew+xLzShBjV6JJL6zuBSIDtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA96/LCp2BuXyrlObgwaqhAcNF5jqq5lbOjesg/jWT2Yvu35U6C/gPNz/AK9/esJsc8DgbMcb1hDwXecVndQ99Xer9EFRo1ymFHvjvFlsEofvQVg8g//Kb91rDv7X/+6tqCnflaTKfU4anZbMowykogRgs3TX/atm7XK/qAZXbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQBDN60J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQBDN60J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3DEC2BD10;
	Thu,  6 Jun 2024 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683479;
	bh=OLLKE/IVk1KndQ1z2Veew+xLzShBjV6JJL6zuBSIDtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQBDN60Jg2Xis16XIO0rMURhigCmbus9nelLBVtDAhdTCS0hjijkQbGtLvn7/fuAe
	 mywhn2/D7d9McOokFGtQ1i0qsUaztKzZHqnHpmxCBHF+FgrNc1rDC9waCx5W7hJ0h3
	 Sj4B9yesgOXyBKbfRwAsizI042/kUAV9dhAEF3hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 422/744] interconnect: qcom: qcm2290: Fix mas_snoc_bimc QoS port assignment
Date: Thu,  6 Jun 2024 16:01:34 +0200
Message-ID: <20240606131746.011016316@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 230d05b1179f6ce6f8dc8a2b99eba92799ac22d7 ]

The value was wrong, resulting in misprogramming of the hardware.
Fix it.

Fixes: 1a14b1ac3935 ("interconnect: qcom: Add QCM2290 driver support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240326-topic-rpm_icc_qos_cleanup-v1-2-357e736792be@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qcm2290.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/qcm2290.c b/drivers/interconnect/qcom/qcm2290.c
index 5bc4b7516608b..52346f7319acc 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -161,7 +161,7 @@ static struct qcom_icc_node mas_snoc_bimc = {
 	.name = "mas_snoc_bimc",
 	.buswidth = 16,
 	.qos.ap_owned = true,
-	.qos.qos_port = 2,
+	.qos.qos_port = 6,
 	.qos.qos_mode = NOC_QOS_MODE_BYPASS,
 	.mas_rpm_id = 164,
 	.slv_rpm_id = -1,
-- 
2.43.0



