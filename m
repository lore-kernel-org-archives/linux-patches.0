Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9773189505;
	Tue, 30 Jul 2024 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356489; cv=none; b=QdczuhNHHwHpwSxXcFg/iBXyQbRV30hte3tDKOEHHgjDKrmKp9sUDOS1sU6wo03+mVCe42Y0lNwiTPXcAodtc2yQOPzniBPzAMGaGWBGMdWh2bt6KUj3h/m7HFjNV2AfcBRpAfCao/bhvlvPChhAH7mHxsTedgyglkWiZPbRMvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356489; c=relaxed/simple;
	bh=kNE1Ncy0zvQLXcjlBzsMTxOJe87Cl6pHZJE1sAYfZMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaEQuB6FcFRxTqPKfvIsrr9SQc6HrptzyrhjVvgnM+dRpSK1zP7Rpi8AGJy4vz/RxQ7fJVj6GMIQC8Qq90HhTYYpH+Ek3EPI2uYHT/U/Whzb8LP/2ZBoaufUh/yiliuoj5XaDumUKa1xniv6bh4rl2w2nafpATc3ygyTlsv4YSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz2QNrRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz2QNrRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC39C4AF0F;
	Tue, 30 Jul 2024 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356489;
	bh=kNE1Ncy0zvQLXcjlBzsMTxOJe87Cl6pHZJE1sAYfZMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz2QNrROpT2aJxhUChh8KL8ExldfA0bl6z/icTN4zWC5rsxrNbEfZTdnKXceJnKUY
	 Z3MmixlDROr+CjsB/fqYdxZWhqMryEfvzlvIB3RQireI8IAL0dujreo+1//VKXUSOP
	 nzHLVYvRHc4jH3is28U/8/ATpa200wETreGO4cSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/440] interconnect: qcom: qcm2290: Fix mas_snoc_bimc RPM master ID
Date: Tue, 30 Jul 2024 17:47:09 +0200
Message-ID: <20240730151623.528023286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

[ Upstream commit cd5ce4589081190281cc2537301edd4275fe55eb ]

The value was wrong, resulting in misprogramming of the hardware.
Fix it.

Fixes: 1a14b1ac3935 ("interconnect: qcom: Add QCM2290 driver support")
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Closes: https://lore.kernel.org/linux-arm-msm/ZgMs_xZVzWH5uK-v@gerhold.net/
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240618-topic-2290_icc_2-v1-1-64446888a133@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qcm2290.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/qcm2290.c b/drivers/interconnect/qcom/qcm2290.c
index ca7ad37ea6777..d75bb918e1bb7 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -166,7 +166,7 @@ static struct qcom_icc_node mas_snoc_bimc = {
 	.qos.ap_owned = true,
 	.qos.qos_port = 6,
 	.qos.qos_mode = NOC_QOS_MODE_BYPASS,
-	.mas_rpm_id = 164,
+	.mas_rpm_id = 3,
 	.slv_rpm_id = -1,
 	.num_links = ARRAY_SIZE(mas_snoc_bimc_links),
 	.links = mas_snoc_bimc_links,
-- 
2.43.0



