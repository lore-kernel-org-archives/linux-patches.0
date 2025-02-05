Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25AFDF71;
	Wed,  5 Feb 2025 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767418; cv=none; b=k0bSZXTk+1SIGHKiypznRDdXgU5dLa1oqnNfEwTLt4LqCMsgZ5NmwqTAvfZ5JbGfcIMQbtu9euATCXINp+UQoKeeeTqHNQ5mx9bGxmJXIQGavRTzw/25OmBOIiDxO4Qrmly9gGdn5KSe8j/xb++qiugfH5Mc9+hIhwzvl6fkxZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767418; c=relaxed/simple;
	bh=ItwwlZNLSS44IfjSbMqEShakSv47/Wh5IcBn/YVHRsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m27wPrcwzu4ispAZR6eJyYALrMeTIBs1fmVBuMHqSczZwiiMfQbFjDL7VxZWWXSafsUE5rjzFwFA/D/3jKM+JNdjVhh/SrMix/BRVkdlzgICzchRUeVNob6iXMVdARdwXMi8mtwhzPSekhkh3c5oJub16ppY4LRgHdfp8j1dvdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzusE/w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzusE/w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A57C4CED1;
	Wed,  5 Feb 2025 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767418;
	bh=ItwwlZNLSS44IfjSbMqEShakSv47/Wh5IcBn/YVHRsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzusE/w1E6rKlxBBFpOH5mSI6Pm/y0x2/xau2FfvvrzbyQs+KbPQQLw5r8dRt7ULq
	 dEXilgakRJYxmGSUR0sKTyVOcNLy78R4RrITvKnLkxNW03BMcN41z3LZk1PxlXSpBT
	 FooULAbw/yTpKJiIWI+7DcnJ9bAdtoodi/8SnbYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 393/623] arm64: dts: qcom: sm8650: Fix CDSP context banks unit addresses
Date: Wed,  5 Feb 2025 14:42:15 +0100
Message-ID: <20250205134511.256482177@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ff2b76ae689b71e2d7a2e70bfd8d71537c39164d ]

There is a mismatch between 'reg' property and unit address for last
there CDSP compute context banks.  Current values were taken as-is from
downstream source.  Considering that 'reg' is used by Linux driver as
SID of context bank and that least significant bytes of IOMMU value
match the 'reg', assume the unit-address is wrong and needs fixing.
This also won't have any practical impact, except adhering to Devicetree
spec.

Fixes: dae8cdb0a9e1 ("arm64: dts: qcom: sm8650: Add three missing fastrpc-compute-cb nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241104144204.114279-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 25e47505adcb7..1e2d6ba0b8c12 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5622,7 +5622,7 @@
 
 					/* note: secure cb9 in downstream */
 
-					compute-cb@10 {
+					compute-cb@12 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <12>;
 
@@ -5632,7 +5632,7 @@
 						dma-coherent;
 					};
 
-					compute-cb@11 {
+					compute-cb@13 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <13>;
 
@@ -5642,7 +5642,7 @@
 						dma-coherent;
 					};
 
-					compute-cb@12 {
+					compute-cb@14 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <14>;
 
-- 
2.39.5



