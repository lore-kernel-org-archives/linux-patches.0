Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1944146A5F6;
	Tue, 21 Jul 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648750; cv=none; b=YFmDqzRTSnoGzS53zr0LxYqrPzBU8Rl56nn9AXA3m759huP0QFpRAdoTvopwlCzZ0o8wRX5/SDSK8KC8VOkpIVbw1QoEkATohgGeWvCOx8eTNRUDCuEm4bWzjodZzG3+4OHrSNQC1v4Kt2/lpqHEL1pvPf90WE61NELcOhHzaFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648750; c=relaxed/simple;
	bh=rpEkQbLEtV35L1+sKwk28NmkumXRWPKzb6/TxvjfQPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIW77dnwAWqhViMxIyPFVLY8UUs5kbuKTCaTJlZvVYcgkX6XCcBY55E+hLPB+uPNimL+L7kNZ8PBzcNFAIn5Q4Kx6Bo2C5MaD7tsWL0j18NCPsTO6hlWic6qDvosfJyBC0HsuAZUt4jHIV2l/OgamBI7w0irZlSIGeUg7VLJ/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCbRw+Z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCbRw+Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2C21F000E9;
	Tue, 21 Jul 2026 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648749;
	bh=S47uKMwAYBzg9UJW8Wc8WhXe6mkYproK2vvaXwXxaNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCbRw+Z+TfbUZJsGx3XfUpAmftc+UrSPQT/2AMNjDZ5RmXsMgMFqvQZnXyjAzOE5r
	 KBRmxg9D7bd448HVyOqi0RsIpUYRwxp0UhVt4DL6wUo7fejgpo2KvIHtXVsDjSNQEu
	 m5flLi1/ZyarOEbiRd8An+LuymdpNm2L3kl16dFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritesh Kumar <quic_riteshk@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0274/2077] arm64: dts: qcom: lemans: Add eDP ref clock for eDP PHYs
Date: Tue, 21 Jul 2026 16:59:07 +0200
Message-ID: <20260721152559.142255263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Kumar <quic_riteshk@quicinc.com>

[ Upstream commit 4bd073e00fd79c0aead74ad64ade48c904221245 ]

The eDP PHY nodes on lemans were missing the reference clock voting.
This initially went unnoticed because the clock was implicitly enabled
by the UFS PHY driver, and the eDP PHY happened to rely on that.

After commit 77d2fa54a945 ("scsi: ufs: qcom : Refactor phy_power_on/off
calls"), the UFS driver no longer keeps the reference clock enabled.
As a result, the eDP PHY fails to power on.

To fix this, add eDP reference clock for eDP PHYs on lemans chipset
ensuring reference clock is enabled.

Fixes: e1e3e5673f8d7 ("arm64: dts: qcom: sa8775p: add DisplayPort device nodes")
Signed-off-by: Ritesh Kumar <quic_riteshk@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260128114853.2543416-3-quic_riteshk@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index bf3b13be3af0a8..3cd8d68cc4f910 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -5658,9 +5658,11 @@ mdss0_dp0_phy: phy@aec2a00 {
 				      <0x0 0x0aec2000 0x0 0x1c8>;
 
 				clocks = <&dispcc0 MDSS_DISP_CC_MDSS_DPTX0_AUX_CLK>,
-					 <&dispcc0 MDSS_DISP_CC_MDSS_AHB_CLK>;
+					 <&dispcc0 MDSS_DISP_CC_MDSS_AHB_CLK>,
+					 <&gcc GCC_EDP_REF_CLKREF_EN>;
 				clock-names = "aux",
-					      "cfg_ahb";
+					      "cfg_ahb",
+					      "ref";
 
 				#clock-cells = <1>;
 				#phy-cells = <0>;
@@ -5677,9 +5679,11 @@ mdss0_dp1_phy: phy@aec5a00 {
 				      <0x0 0x0aec5000 0x0 0x1c8>;
 
 				clocks = <&dispcc0 MDSS_DISP_CC_MDSS_DPTX1_AUX_CLK>,
-					 <&dispcc0 MDSS_DISP_CC_MDSS_AHB_CLK>;
+					 <&dispcc0 MDSS_DISP_CC_MDSS_AHB_CLK>,
+					 <&gcc GCC_EDP_REF_CLKREF_EN>;
 				clock-names = "aux",
-					      "cfg_ahb";
+					      "cfg_ahb",
+					      "ref";
 
 				#clock-cells = <1>;
 				#phy-cells = <0>;
-- 
2.53.0



