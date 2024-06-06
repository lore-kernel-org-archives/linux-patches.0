Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBDB1974FC;
	Thu,  6 Jun 2024 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682907; cv=none; b=mjw1s/S0IhpX68oBrWIgeSs442Pc52f0rXKeBNqGSOak7aEVR+Qg9dRohWjE/DOobQHRgR3qMq3JWZh5XKgPu/r+0N9w9zgXjvov+Rq5T4kXXykdMlB+fYAdUGIdhppMYIJ5xHB0WgJC9NPDs5yGtzu9asAVQuEahljCBzku1GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682907; c=relaxed/simple;
	bh=U1rI5+O751TTacosV3WS5tZl9xbgQRH7uvrkMmNCQSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1lRUUniQH4lS5/mMSYteRcfX/ALob3H7jQ8K13LSiVRlVh+twXI5gGLoIvHw2DL+PuQe4+XWXIhCCwJV3iHnEsM8Q3HmtTf2atWVGXVQ0Hg6c6UvESAMPczoknXGq+Yv5nBthJX2Mo2G9oRzoUlCX4xKTeLG8bBy2JRAw++1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlfMlE0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlfMlE0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F9CC2BD10;
	Thu,  6 Jun 2024 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682907;
	bh=U1rI5+O751TTacosV3WS5tZl9xbgQRH7uvrkMmNCQSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlfMlE0sJ/GyKK119ko0t9DDdaM27ySYa1gArf7MDOsJLL+4mwuAtAA6TQwFFnF5d
	 5USnZ1Y+7is7SjbDodU9Ez83OqoMKCMNd2NVIU/Vh1zHymONEAn9Lwg1rF7xM+N8MU
	 WP3KTkmAEBf2+wHfg9VqEPPb7gUu2F3eWlC9o9LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 032/374] interconnect: qcom: qcm2290: Fix mas_snoc_bimc QoS port assignment
Date: Thu,  6 Jun 2024 16:00:11 +0200
Message-ID: <20240606131652.900193421@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 96735800b13c0..ba4cc08684d63 100644
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



