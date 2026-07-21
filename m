Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB7946E01C;
	Tue, 21 Jul 2026 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656053; cv=none; b=A37b441BIQdicwotEHYhZl6Gexd+7J0WIuhPEd4yYg6ylU6PIc4l+vdnGHBbHe+k5H+HowdHznj3M4I87ggVDcCr15QRIsllXsMZ4UFXj221rS7Gtv/sMXTnXZSIM0ycP5kwcolbai2/dBYQIjNwcd42styXlR3U9MlTg0yQTC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656053; c=relaxed/simple;
	bh=Lf3iL7NZlvfVhDEAYE1aBSfKHufbqM/+0esdczBNa14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j48lsedXfEMi2UXQ9afmJ6a3dOPZYT2gBT9q5cLN7Pgz2zfMJyryBKH2kFVbDHAmF1oy+lljJk1U2gTDnzk0V9kAb0thNG5kBw3ydPeZkDlf8RW53+qu0BEz0mvRvg4iyhn8ucSIWoDVYi1WBMIijxl6N/wCUdyJUv4YHB8saPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ju/Y2laE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ju/Y2laE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE9F1F00A3D;
	Tue, 21 Jul 2026 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656051;
	bh=+YQD1Q1ZwZePzKZok+scj0v00zFXAX8UTZmZ9PAUkok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ju/Y2laEwKPCerBUjJu4yYlGkEdHwENXSMPa9chdoyFF9JTdCAXZOaZ5kUUb4pon+
	 AImb1iRGXeBC6oaf9LDO4RalsF23zSgLY2Pt0nDPZXNcXwMHTXfOmi4zQ2QEESHJsa
	 si6tVKWthiSA8+Kw5mnXLgz1DVyJp6ZYYdkEV4rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0188/1611] arm64: dts: qcom: sm8550: Add power-domain and iface clk for ice node
Date: Tue, 21 Jul 2026 17:05:04 +0200
Message-ID: <20260721152519.168599359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Harshal Dev <harshal.dev@oss.qualcomm.com>

[ Upstream commit 52696dbbe7bbe0c8fc8c17133ffb5133b8cf37a6 ]

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8550.

Fixes: b8630c48b43fc ("arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-9-5ccf5d7e2846@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 118a626dfcff54..479c94f5066f3e 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2414,7 +2414,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {
-- 
2.53.0



