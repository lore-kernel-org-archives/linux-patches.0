Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060781;
	b=itHgg/zJ12uJAI1yYmjpv0grT+3D6LIO8FfgjMbXaQDbTi91VM+zVryfSS1MvW0HTdVu
	 DHTGcIUVOHWBqjV7BGlUPuODh/Y6cxRvUK8bgkAm/XEbfjAJUPsPRPwdpJkgW62hbFVrn
	 yQusNyjqw4w1FogfO/qWZzcD+2I7KftrxYp7W7qRE/EOI3aPUMPYs+sNA6BwE1m5Lv6DU
	 8WI6EbC+SnpT5jwciiN7is1ek3NDE417YaXo4CO4iyG5Cfteu0Rxmx7AkBd0ZSoMA2Yyo
	 SD/9lRDTiHRazuhj2wMB2JVLkrRyxHQcXC1Cd0CG0pchy7boKt6VqOVteA/v2vKxULA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPhDSvdilfngcWZKEADKMFqX1HUScg00i0+EDWaL0V8=;
	b=HzxKJuhiLx03481wGeG06LiOBemuwSV0i9bt1AEWF1WCsvMGA6jTh5B/jeyaz5BDRhYM
	 RgnZQv4aRKvxJY+fc0s5wOkkpWa30wYtNUDZ2bbCXzEHcwrL6ybsVguU77WqO8g8gPOea
	 zMgGtNg2VU2pj3cklfzjNvssJX9kvbwFKatxYBvE8b449cdUe5AArWPC/Aa85qhJVtmFE
	 KlGLGs4ebGn0y2p1P7bzyLAauHagm6KcvyI3klrUWnodEQGpvWof99nlKpPwob955DoTJ
	 7yM+bkUzXBs204CcxAOOeLpFP0JdHMO1YSH1bab5LBNekwZ52f+LXva5tVCPa6wtwWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNkoKq62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB51606A326;
	Sat,  7 Nov 2026 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNkoKq62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9F21F008A1;
	Sat,  7 Nov 2026 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060781;
	bh=IPhDSvdilfngcWZKEADKMFqX1HUScg00i0+EDWaL0V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNkoKq62/haI3WobRvyrUg9A9qDoUNLMQSXSLQSCURZCgCNRKQFDd2S5VbT1PN/Lp
	 YacaaCK+JFN3YYDsiR+vMGgMNYcslS712QSdmGhETYH5zuKcPC/YO1rxSume+H5GJD
	 sF9UQP0TbgkOsZtiXhFwVbKT6YdVS1qGl08RwqXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0187/1536] iommu/arm-smmu-qcom: Add SM8450 MDSS compatible
Date: Sat,  7 Nov 2026 08:36:43 -0500
Message-ID: <20261107135002.914574146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit d149c8b2c0146a01f1be326ddb1e182b55aee638 ]

Add the compatible for the MDSS client on the Snapdragon 8 Gen 1 so it can
be properly configured by the IOMMU driver.

Otherwise, there is an unhandled context fault, because the framebuffer is
already configured in UEFI.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 22586e986d8b3..d0844c95dd02e 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -272,6 +272,7 @@ static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,sm6375-mdss" },
 	{ .compatible = "qcom,sm8150-mdss" },
 	{ .compatible = "qcom,sm8250-mdss" },
+	{ .compatible = "qcom,sm8450-mdss" },
 	{ .compatible = "qcom,x1e80100-mdss" },
 	{ }
 };
-- 
2.53.0



