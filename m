Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8404715665D;
	Mon,  6 Jan 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177110; cv=none; b=FOOLtQgSY2+g+YBCIKb2BMmirUHfrcvoKW92qSDWsvWAFwrj1J+CDtj43ICbTLRoNP4lm4vQHix+bbHNyEfZI1dTfVY/0YSKua7v6WN+o/cQrRqzmL5i9LdVhjQnYfNQ64BsoBpVdSIb0z7DgasJuX4r21UFpgz9CeqGG9Tkajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177110; c=relaxed/simple;
	bh=aZ6tGUiOEtOgHDzRrHOSSL/LnxMEawuBl6VHU5l1Wtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ2p4YBqi3TJCSMudUFis5Mupw4MaMbm2/HzxtaEMZv3TMsp1tR0dqEWmINNTz4Ye4OapB+XoBU96W5CnN0WM0Qsp0bosUcIs/Yy2cDKLL9Knw6CtuIwQIvGs1sPDb2xl9zn0qzy2SsYK3BAlXU1BOnurGl1QSQgnazIosJu8jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/z8l9/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/z8l9/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E563FC4CEDF;
	Mon,  6 Jan 2025 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177110;
	bh=aZ6tGUiOEtOgHDzRrHOSSL/LnxMEawuBl6VHU5l1Wtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/z8l9/nTJVn5RRi1XI30gLZ0vvde09wRj4zVQ1okeQgPP4bG+Ij/PWeuY6U/aQQs
	 dV9hZmmMVCUhiNdiI91QIhjsWk8KDAybG/wfEKOdPR/B1D/3sxZ/3kaNoHy94/Bvbu
	 lDYulqzi8+Ca/VZ3982tho4NzVFNFIsCHNNwLUcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/222] remoteproc: qcom: pas: Add sc7180 adsp
Date: Mon,  6 Jan 2025 16:14:17 +0100
Message-ID: <20250106151152.612180337@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit 8de60bbab994bf8165d7d10e974872852da47aa7 ]

sc7180 has a dedicated ADSP similar to the one found in sm8250.
Add it's compatible to the driver reusing the existing config so
the devices that use the adsp can probe it.

Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230907-sc7180-adsp-rproc-v3-2-6515c3fbe0a3@trvn.ru
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 009e288c989b ("remoteproc: qcom: pas: enable SAR2130P audio DSP support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 6235721f2c1a..fd66bb8b23f8 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1163,6 +1163,7 @@ static const struct of_device_id adsp_of_match[] = {
 	{ .compatible = "qcom,qcs404-adsp-pas", .data = &adsp_resource_init },
 	{ .compatible = "qcom,qcs404-cdsp-pas", .data = &cdsp_resource_init },
 	{ .compatible = "qcom,qcs404-wcss-pas", .data = &wcss_resource_init },
+	{ .compatible = "qcom,sc7180-adsp-pas", .data = &sm8250_adsp_resource},
 	{ .compatible = "qcom,sc7180-mpss-pas", .data = &mpss_resource_init},
 	{ .compatible = "qcom,sc7280-mpss-pas", .data = &mpss_resource_init},
 	{ .compatible = "qcom,sc8180x-adsp-pas", .data = &sm8150_adsp_resource},
-- 
2.39.5



