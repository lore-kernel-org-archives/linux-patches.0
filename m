Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56F41662EF;
	Wed,  5 Feb 2025 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767369; cv=none; b=ejy7JthVuzpahPvTs5/fdsOoN5Zj5ALLltoal3RpWTqU9nTEXl+XfLxc/XPjucRYdnVaxPSUymsyww7AGLKQiDs4oJzN3rd2/REnNOguKjnghypBnzQVg6DeaAnYuAnz/oQ9AS7oMQ1KnoPbY/af93rT2FdXMNmGTsLL/NJiELg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767369; c=relaxed/simple;
	bh=wckgUhJ+odXv28uQvaMwVjs4vMuHpz0ifQfX64jPhm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnJHyzcF7sgqQiHRz8A6TYknduHtSUb7imwc5OevSMJGFDmKjE2ogLLUxOgKu6BZDa/GCdfbWNgKVYJSJRvmS/40Efe1t3aOtGJ2cWT8YwvhjDFYVNGhar9uzb0y3/PJGE3T0LjmLDPdBZSFB7P0dt8k5GgDNYUWyORPvCIMcUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmciQYLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmciQYLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B278C4CED1;
	Wed,  5 Feb 2025 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767368;
	bh=wckgUhJ+odXv28uQvaMwVjs4vMuHpz0ifQfX64jPhm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmciQYLx44wchLGZ2LTh9SmOFYKkbiXtvj/YvstSyslNpddY/knLmuJh1KzP0fGmQ
	 fDAqjMneq2govcahG7w5x5f4FjDCiK/eDEln2kORPTXBPvwL/N1Y/kDAt/9XWX/ugP
	 B3/oZfyFfPhLzXzK7oXvRommb9Xl1AGXXvlQpBrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 371/623] arm64: dts: qcom: sa8775p: Use valid node names for GPI DMAs
Date: Wed,  5 Feb 2025 14:41:53 +0100
Message-ID: <20250205134510.414649020@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 86348c7587f556d3f0a3f117c3f5b91a69c39df6 ]

As pointed out by Intel's robot, the node name doesn't adhere to
dt-bindings.

Fix errors like this one:

qcs9100-ride.dtb: qcom,gpi-dma@800000: $nodename:0: 'qcom,gpi-dma@800000' does not match '^dma-controller(@.*)?$'

Fixes: 34d17ccb5db8 ("arm64: dts: qcom: sa8775p: Add GPI configuration")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411080206.vFLRjIBZ-lkp@intel.com/
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241107-topic-sa8775_dma-v1-1-eb633e07b007@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 97c85a3db3019..b4726c0bbb5b2 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -870,7 +870,7 @@
 			#mbox-cells = <2>;
 		};
 
-		gpi_dma2: qcom,gpi-dma@800000  {
+		gpi_dma2: dma-controller@800000  {
 			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00800000 0x0 0x60000>;
 			#dma-cells = <3>;
@@ -1361,7 +1361,7 @@
 
 		};
 
-		gpi_dma0: qcom,gpi-dma@900000  {
+		gpi_dma0: dma-controller@900000  {
 			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00900000 0x0 0x60000>;
 			#dma-cells = <3>;
@@ -1786,7 +1786,7 @@
 			};
 		};
 
-		gpi_dma1: qcom,gpi-dma@a00000  {
+		gpi_dma1: dma-controller@a00000  {
 			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00a00000 0x0 0x60000>;
 			#dma-cells = <3>;
@@ -2241,7 +2241,7 @@
 			};
 		};
 
-		gpi_dma3: qcom,gpi-dma@b00000  {
+		gpi_dma3: dma-controller@b00000  {
 			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00b00000 0x0 0x58000>;
 			#dma-cells = <3>;
-- 
2.39.5



