Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54F1F669E;
	Tue,  3 Dec 2024 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238739; cv=none; b=f/TRQGfzMFg/oXFQcCJADaxU7ZXMrh+sQVj7Ue8+FSRPih7cmiToaFjm82OnPhaFDfGpVeZko6P5n4tp6Pt4bbkrcbjCLW+fVDcyRizSc9jEmAhdx4DXPN+BDsiP6AaVqGs6+9qZcbbTGjshxv0JN1dw2wJHsQJtIC9Z29SECnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238739; c=relaxed/simple;
	bh=lpFHcQnGXEFBeFjTXzs0aQUZGphEspnQQktPTVotopE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VX81+IaCCQ7jyaxElbKUeafMNPpJCd2B47rrg8ulrAcUyoBo5mcXUM/rqqZqFyzV6g4VvpXe19crHQBOGnx2CXso48TcjWsWZc42WkiYRGRLqKyG7o2OQVbsSNat8V2s/PBA/t4AraFDgjzhZnUFeQaYbmIzVtaDaJQHzdOZU5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdmHnk9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdmHnk9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265EDC4CECF;
	Tue,  3 Dec 2024 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238739;
	bh=lpFHcQnGXEFBeFjTXzs0aQUZGphEspnQQktPTVotopE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdmHnk9HWoyxIUQlzmi2v5Mxa8CPJ5pIyH2RAuMEz4w6HXZfQztf/vJcDRj1LtF/y
	 tqZYQo65p52ke3TX+CslyFdWvoBeNG/m59rYExlQVV1YmpaMek/UnJ5bbxJ28MvITK
	 7DdA/ZTjvMtRaT+BGYU9HwKfReXGH0ImtORGFh6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 382/817] clk: qcom: videocc-sm8550: depend on either gcc-sm8550 or gcc-sm8650
Date: Tue,  3 Dec 2024 15:39:14 +0100
Message-ID: <20241203144010.753840834@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit aab8d53711346d5569261aec9702b7579eecf1ab ]

This driver is compatible with both sm8550 and sm8650, fix the Kconfig
entry to reflect that.

Fixes: da1f361c887c ("clk: qcom: videocc-sm8550: Add SM8650 video clock controller")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241005144047.2226-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 11ae28430dadb..8e1b7f63e95a1 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -1203,11 +1203,11 @@ config SM_VIDEOCC_8350
 config SM_VIDEOCC_8550
 	tristate "SM8550 Video Clock Controller"
 	depends on ARM64 || COMPILE_TEST
-	select SM_GCC_8550
+	depends on SM_GCC_8550 || SM_GCC_8650
 	select QCOM_GDSC
 	help
 	  Support for the video clock controller on Qualcomm Technologies, Inc.
-	  SM8550 devices.
+	  SM8550 or SM8650 devices.
 	  Say Y if you want to support video devices and functionality such as
 	  video encode/decode.
 
-- 
2.43.0



