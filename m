Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDFF221FAC;
	Tue, 12 Aug 2025 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020830; cv=none; b=JMn1Qfkma6f/a1qHoX3/+cOOkYZycjo58tlBL7D+spFdo+22hJo1jZgfm+N5N898D8/9MtAu1ld8OevWfXan0QelB0d4YXL/U4hHTN9T/Qx745plK1ENB6t5ZM/7nHl9lzroLpQxKQz/jSISHnWA/ex2CH+3niLo0b/+Hb4s1AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020830; c=relaxed/simple;
	bh=f01Aoh/q5P53rmq3KQ5k6uAXAcflYLIzYW6HDdUQC3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WS5udDnKOCsunjhKPNidh0KdhIKCLBfJQjv70uuQY8ylfGSJmF2JfM9h7WN0Q6HCp1d2h5HuBjju6nVIk2gtVn+EAXU4e4MXcR1uSoZbxRjfML9bQxzqEAp//mW6v4t/Qd1Y1oKcgyJXscoRpRf6zjYyXvfq8xnj3tnOJEpaeMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJ+wSDHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJ+wSDHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C8DC4CEF0;
	Tue, 12 Aug 2025 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020829;
	bh=f01Aoh/q5P53rmq3KQ5k6uAXAcflYLIzYW6HDdUQC3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJ+wSDHiAh2ArMKdEEr9VEMKTJyivCS1LFpEah7sHuobonLBo9RcczgT+r9Kv2n+n
	 wtxStDTt/gWawEc64WMka6STKFs5lyxKxTWdt7Uu2O1H0woMGyKYxbnakC1OEZzfHp
	 GXGKc8acPNdRoeTsz1lmBqO3PNjMrX36/MFLMRxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/262] arm64: dts: qcom: sc7180: Expand IMEM region
Date: Tue, 12 Aug 2025 19:26:49 +0200
Message-ID: <20250812172953.875407769@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 965e28cad4739b11f1bc58c0a9935e025938bb1f ]

We need more than what is currently described, expand the region to its
actual boundaries.

Fixes: ede638c42c82 ("arm64: dts: qcom: sc7180: Add IMEM and pil info regions")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250523-topic-ipa_mem_dts-v1-3-f7aa94fac1ab@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 7758136d71d6..9dc00f759f19 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3435,18 +3435,18 @@ spmi_bus: spmi@c440000 {
 			#interrupt-cells = <4>;
 		};
 
-		sram@146aa000 {
+		sram@14680000 {
 			compatible = "qcom,sc7180-imem", "syscon", "simple-mfd";
-			reg = <0 0x146aa000 0 0x2000>;
+			reg = <0 0x14680000 0 0x2e000>;
 
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			ranges = <0 0 0x146aa000 0x2000>;
+			ranges = <0 0 0x14680000 0x2e000>;
 
-			pil-reloc@94c {
+			pil-reloc@2a94c {
 				compatible = "qcom,pil-reloc-info";
-				reg = <0x94c 0xc8>;
+				reg = <0x2a94c 0xc8>;
 			};
 		};
 
-- 
2.39.5



