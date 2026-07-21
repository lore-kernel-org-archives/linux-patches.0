Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F542B32A;
	Tue, 21 Jul 2026 19:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661546; cv=none; b=hufdMCXQt3l36INQHMFVufImacCWl9MbNXylOqcWCJkyEa5WfCfxxtXjr0lvgF63+JrlxBDYY7PD2ihRc9/Ji2cUTACAnRjSf+tGkQTebd3rLywfSA2GMrDomZjaxwYfzVwuPi4VtHWc62Xam0Qvk3D7Kass/qikcVyoXsi7Tw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661546; c=relaxed/simple;
	bh=gbkJD5Ks1PqardJLqaSKGKhp2rxgIQKYN75DVvwfM/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGz95DNZJ+L+ZfYm6lPWOrAocvx62LVLGgIk4LlmxY6zrM7wY8tYY7jJz6Nfvy9exYulv/jy4iT2BgR9rE56vxxWv0jP713AbvbiUNoFxC9ZAVQL48CpDaRc4GCqC/TSt5zMyU69mVaoOpRPxBAniRjRRFmxEVDhAuaHvp4A9yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGwxx84j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGwxx84j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D11F000E9;
	Tue, 21 Jul 2026 19:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661545;
	bh=JOpEv4fDeuZx4QeRmMqtZjs+nTLZJM1lfzD+4Qy8je0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGwxx84jcH/v0MVwhHb8UgoE4DxMHnf/FVX6M1i/lvzyPBQvop+p/SaNQxUdXr5ve
	 EcInSCnzs2dwtkf6JGmsDezFCB5R9OCNIuhZqvmWl1hROZkr0RvJP8jF6YtoOsy5GE
	 k9nLeeBsj1/vlUw2n2pDkbxGFcYrwumkJCxomLkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0108/1276] arm64: dts: qcom: kodiak: Fix ICE reg size
Date: Tue, 21 Jul 2026 17:09:11 +0200
Message-ID: <20260721152448.515411069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit fa9c7403af64d3e56a6c20dedc60e0a55b527509 ]

The ICE register region on Kodiak is currently defined as 0x8000 bytes.
According to the hardware specification, the correct register size is
0x18000.

Update the ICE node reg property to match the hardware.

Fixes: dfd5ee7b34bb ("arm64: dts: qcom: sc7280: Add inline crypto engine")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260402-ice_dt_reg_fix-v1-1-74e4c2129238@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 8fbc95cf63fe7e..8b525198667519 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2394,7 +2394,7 @@ ufs_mem_phy: phy@1d87000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



