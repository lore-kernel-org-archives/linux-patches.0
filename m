Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD814DEC07;
	Thu, 17 Sep 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666823; cv=none; b=XxGg3SMxfsTkgokp9jWxD3dh8GfNXXlkDatpQm5kei9HH6MplQHJ0J8qa4qAz7GKZ2iz2P42ux5nnKnQfoaksvsrzRUm+9HvFYDxPM8Y+XJH3/bl53epS18QKxFu8lUtMeBeVrxvnKapd1QU1DNoipxw36JOZ/VQu4kNRWiCPJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666823; c=relaxed/simple;
	bh=QKLTyF1CNCbCpaBn2Y/3T/IZKxAxfmVbduNhz68S0Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1+0L6G339Wzub0RtM4WULOTDpyVoaMsHt04kzzJcmKQLiafHmA6p1NWXUAIXvEpV189bESq6MX/TGvXL5VbCc3bixJOmK5rpuH56yyJDkIqYAd30PFdyhxxCIL8KQxAWyWCcjeffX5v9/f+heuX2MYMqcy7kd8WOxPwFviThIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6qu3UBD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6qu3UBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8366E1F000FF;
	Thu, 17 Sep 2026 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666819;
	bh=V75l8YvSh7HVQfRQz2zWMp7V37gOUDog6WrE4VBRrLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6qu3UBDDxh1hbYNtzMvIttr02otiFsWLIOLpL9dWGMRcwejy73aE3Jywf4TgXfHa
	 rho7v5pfWNpsofN9NVux/f5E60YLHXBBdQgQbeTl1NplpCdmcrZpP86k7uhtevUy38
	 Lq3hGLKzywl6mBiYpHQllD3kK+ca1hINDSdeo6gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1134/1250] Revert "arm64: dts: qcom: talos: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:29 +0100
Message-ID: <20260917151622.985138526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 349752c7ab6be4cc86034d98976d305cd8d986cd.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6150.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6150.dtsi b/arch/arm64/boot/dts/qcom/sm6150.dtsi
index ff3ae5688f03e..a066ad5ffde57 100644
--- a/arch/arm64/boot/dts/qcom/sm6150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6150.dtsi
@@ -1175,8 +1175,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 					 &config_noc SLAVE_PCIE_0 QCOM_ICC_TAG_ACTIVE_ONLY>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0 &apps_smmu 0x400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x401 0x0 0x1>;
+			iommu-map = <0x0 &apps_smmu 0x400 0x1>,
+				    <0x100 &apps_smmu 0x401 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
-- 
2.53.0



