Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1904117A93F;
	Tue, 16 Jul 2024 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144949; cv=none; b=WU+tL8yqTuBNO01U4vpPQ4sktdKhgwjTIIoVVXPDUzd0gWzQwyY9psdeElo8LtBpHYUIcrZsaOGRfacY9J8FT+0GvjgseNMuLz0bYy/mQu5f9aOSi/yf2gYjoYoRtuOoFbOTcsxQqBAb9HudHA2s88dLf2Z+o9+Lz2fRDHWSCE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144949; c=relaxed/simple;
	bh=fJ1KWpDBOKFDnDv++7pqIwTTk1TB/dy4vR3jZnJqt1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Py64oneveHVCiif84gOAHN5q8L2lBoH3mnW1XiJ/2eOhQJPLjpouOasLjocybPm+T4KKKfy17uvyrwpeC/gbYU/Xewn3VfkQVEJt5h7gef/qDYV3kxyFCwrrvuNEdaJUt6bs8zdCvD7LnOSOOG1l0gP98DDwFMdfV86qaUAKskM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLW0YjeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLW0YjeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932CFC4AF0B;
	Tue, 16 Jul 2024 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144949;
	bh=fJ1KWpDBOKFDnDv++7pqIwTTk1TB/dy4vR3jZnJqt1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLW0YjeVt2MRQ0dKkdkclNosisA8G+qeAxGbqydl+6BhYhfS2cn8DPse1aj96CbyU
	 KQQNML24W5KSccvPoejziOBdEchi8Z9BqDeiJlFv3A+k+jJI2UZHWcLWdo5H30BtfZ
	 9jUi+SS24U3gQkpphqVnxBY9cxsvZypUaOXF/mpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 049/143] arm64: dts: qcom: sm6115: add iommu for sdhc_1
Date: Tue, 16 Jul 2024 17:30:45 +0200
Message-ID: <20240716152757.872905904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 94ea124aeefe1ef271263f176634034e22c49311 ]

The first SDHC can do DMA like most other peripherals, add the missing
iommus entry which is required to set this up.

This may have been working on Linux before since the bootloader
configures it and it may not be full torn down. But other software like
U-Boot needs this to initialize the eMMC properly.

Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240619-rb2-fixes-v1-1-1d2b1d711969@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index aca0a87092e45..9ed062150aaf2 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1090,6 +1090,7 @@
 
 			power-domains = <&rpmpd SM6115_VDDCX>;
 			operating-points-v2 = <&sdhc1_opp_table>;
+			iommus = <&apps_smmu 0x00c0 0x0>;
 			interconnects = <&system_noc MASTER_SDCC_1 RPM_ALWAYS_TAG
 					 &bimc SLAVE_EBI_CH0 RPM_ALWAYS_TAG>,
 					<&bimc MASTER_AMPSS_M0 RPM_ALWAYS_TAG
-- 
2.43.0



