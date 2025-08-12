Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C6B2F7461;
	Tue, 12 Aug 2025 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020404; cv=none; b=B9Qu7OJd76JYWKEE1u3izmZXZXz1zaVO1ku6v80uRIidelPSlKeLOfWSTzlWKJxGwdLOKVqbwtU1d8EzH+J6F9akFVabHSWVeJiSHB1cDjSKMKPYWuU46Z/lWQy2JtKhHiVGHx+wFXhJDjO2OJZYpH6dhS/04tg78lCdfV/Hbys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020404; c=relaxed/simple;
	bh=hXMdRze6KijIvA0XZYm+rYaqJWsJJKAhrbuNBoU7LZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRL+cchq9YcS9pQVPy840ZIq5e4NmWwvsMC656PxTqw4iN448au0ZVfyRBna9OABauqI1yyFeUy/56EhcPriRFQoy21ZzH1ldPnV71hQV6+p71wfuvkjFrRzJehYJMmz9kLIo1Av14YBmpxEwhTec70o6xvM5BNVxEsrFJNqnQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rm9MZHdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rm9MZHdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B1CC4CEF0;
	Tue, 12 Aug 2025 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020404;
	bh=hXMdRze6KijIvA0XZYm+rYaqJWsJJKAhrbuNBoU7LZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rm9MZHdmPqb1fuZcjPMU8inCI5fOR4LGEKM3lJ3ffiwiDLDY+f4ufOMpUk2yLBbaU
	 Jy1Uvnpxut2x19eoxWRBsIMwyiAxyD5geQTaeGLXN1m5XBHeYBXCZa7EpPYHbmB9W/
	 KUeVnV+85Woj8yowoc4g3HoPQsM4RJaHANZj+UzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/253] arm64: dts: qcom: sdm845: Expand IMEM region
Date: Tue, 12 Aug 2025 19:27:40 +0200
Message-ID: <20250812172951.796191585@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 81a4a7de3d4031e77b5796479ef21aefb0862807 ]

We need more than what is currently described, expand the region to its
actual boundaries.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 948f6161c6ab ("arm64: dts: qcom: sdm845: Add IMEM and PIL info region")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250523-topic-ipa_mem_dts-v1-2-f7aa94fac1ab@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index a5df310ce7f3..b77f65a612a1 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4915,18 +4915,18 @@ spmi_bus: spmi@c440000 {
 			cell-index = <0>;
 		};
 
-		sram@146bf000 {
+		sram@14680000 {
 			compatible = "qcom,sdm845-imem", "syscon", "simple-mfd";
-			reg = <0 0x146bf000 0 0x1000>;
+			reg = <0 0x14680000 0 0x40000>;
 
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			ranges = <0 0 0x146bf000 0x1000>;
+			ranges = <0 0 0x14680000 0x40000>;
 
-			pil-reloc@94c {
+			pil-reloc@3f94c {
 				compatible = "qcom,pil-reloc-info";
-				reg = <0x94c 0xc8>;
+				reg = <0x3f94c 0xc8>;
 			};
 		};
 
-- 
2.39.5



