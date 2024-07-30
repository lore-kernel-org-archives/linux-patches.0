Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCD71E86F;
	Tue, 30 Jul 2024 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359143; cv=none; b=bWQW5nTpYKImlYTzhKMMl7eLpbOgfe6gT4a01Gk+qr/mH8rAjnqtd4WW6i07QnOG+d5ZujEF5F58ly1hwrDk1DZRX7dftmLM2O7Ep7lZqUSFnBHAxX9h6S3X5n0JjgavD4YJVkMtTLp9CatxL74p2q6EvEkKFrIennjJpJDTUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359143; c=relaxed/simple;
	bh=Fm5NsUkbYtcVtH1C2B2zgKSC545EJro4SeJ+bkRyfxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaorbZ/FrfWSR16CA65/UBSwiVBGBsZxIQZv7+kcwyQV3fJI/VJvfF2+Ou2LWaP75Ah4GUrRyAFcWOmCxqqQ7y7Kn9mqlcElCnBeA5ZKnzSvIqsovv9nfTUB3/q2cQIEcyZ/nKiiWTBo59dN95qM+3Y4UwVQR069+hkc/oL0lUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LobD7arE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LobD7arE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304A8C32782;
	Tue, 30 Jul 2024 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359142;
	bh=Fm5NsUkbYtcVtH1C2B2zgKSC545EJro4SeJ+bkRyfxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LobD7arEx3WtrIN57b327LEW72iGPGEfREiO9ZOt6kfwIk0BvZHS/5c8Pk05Kwh29
	 2VxcpnKhbN4zxrSkni8jmlRhGT89IUCCZYEGzmsYJoD5+Wr5VIoXQmXHV1C9vNWyFU
	 x+YIi3GnFukBa+TErvbVS0iCun6D8BEuLHZnWnOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 417/809] interconnect: qcom: qcm2290: Fix mas_snoc_bimc RPM master ID
Date: Tue, 30 Jul 2024 17:44:53 +0200
Message-ID: <20240730151741.166452356@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ba4cc08684d63..ccbdc6202c07a 100644
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



