Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C8E1A6192;
	Tue, 30 Jul 2024 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357565; cv=none; b=qy6tKh3Gf3p5ixeCRMfaNTc6uFyO/JNu8dzybxv/GWSRBoDNAtIAK9f9NIwunkRuX9LWelxYehLv6X9XNb1t1/vF6ea1H1NRevBwU81EYiWncUuje7M72lxfEewA8kFUBQsCFaVVEiNCkHLZvm6YAZcIrJF8Z6F7Vvqc1Uz6bFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357565; c=relaxed/simple;
	bh=TL1hP2IJmFTf8+YpbN5ktuNCp6Gg3kkLmFrji+72w70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0lideAdXWd0kH6UE0H3do7dhvmYF9p82MYYxLrdUpHSWdi4oPZYMJexX3oZG3Isve0XDlMA6TN2MonAsP7AuA8uWVs9Dq94tRVekkTCHuZU+LAMpQibceNuiDAPTHRhCaq2zdcoSkaThszzR02CnElwqzE6jbEfeI0t4KxgGSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZMnqzQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZMnqzQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE24DC32782;
	Tue, 30 Jul 2024 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357565;
	bh=TL1hP2IJmFTf8+YpbN5ktuNCp6Gg3kkLmFrji+72w70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZMnqzQYlBO+yk92KLi3T6U1zzLHCGIlROPC6ChSUrUCLNbZizbeVa3errT5Duit7
	 RMPWypiLnJDaH3Xsr1jpPwQEl4hDOF/N8zPvuuWeOmpRIp58wwz2reVaI8OTknN/me
	 TCwUxQuA6XKIG/78fg7hcaklhRY6CA4u2TI65GjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/568] interconnect: qcom: qcm2290: Fix mas_snoc_bimc RPM master ID
Date: Tue, 30 Jul 2024 17:46:17 +0200
Message-ID: <20240730151650.433024205@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 52346f7319acc..69960a357a682 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -163,7 +163,7 @@ static struct qcom_icc_node mas_snoc_bimc = {
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



