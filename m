Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B21B29CF;
	Thu,  6 Jun 2024 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683413; cv=none; b=jMRtbsw+QGIK6jfDpgUE0g5NXphW421upeoz5ZJoN8lctOBL1Por+HS+AP0Yd6T6eJs5PYgapxA0GkFoKZOmWN7YlRbu/6xm0HCTUUNeIBvnPXCNJp+SAU+ahFrivjWFX7Xv5Zk2Sj1W8miW6VcgOwFT+7aQolsu4YWSM74LMrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683413; c=relaxed/simple;
	bh=ZEtxmkSAL6xNzR0SHSS6AG1I/mvWWrzJcG5ez9eF5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd2N+RNRWsejW4sb/ekXny/e40XOJSel+BaGCr6yqzgH4ZnjJKYYtHVMMCNC+1q/1eVTyI/Ny1lKZXU3O+RdVl2uDJsMzdlPkiA6tczkVjhnEzfPVNQ2qA39eRGaX7DdRMYOxICL5KvwJZaeuIPfTmgNfVBrYTGojAkFbowtkh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlnYDp5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlnYDp5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0EBC32782;
	Thu,  6 Jun 2024 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683413;
	bh=ZEtxmkSAL6xNzR0SHSS6AG1I/mvWWrzJcG5ez9eF5Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlnYDp5qJdb1tsR+HXjI8A2Wv1+TjRIBVsH2G48fsfgumf7HawOPM23vZBUVbBUe3
	 q7b2Rjo/K9J7+APWdXqCaPQWoDZvuSRxW1WRCzQbgUI60fbALFWX5ax5LcfCev1qG9
	 M+wQifjbtuFqnzb+XHvxuRyx5HCciFDGOYJbUGuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/473] interconnect: qcom: qcm2290: Fix mas_snoc_bimc QoS port assignment
Date: Thu,  6 Jun 2024 16:03:45 +0200
Message-ID: <20240606131709.684556826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 82a2698ad66b1..ca7ad37ea6777 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -164,7 +164,7 @@ static struct qcom_icc_node mas_snoc_bimc = {
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



