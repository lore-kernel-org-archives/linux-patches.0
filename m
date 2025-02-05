Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD6518A6D7;
	Wed,  5 Feb 2025 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767228; cv=none; b=gsmyEDzIKmZTpbgHNq6jK3AHqaMuvIRD2pFlyKy7mh+HrzawXihGuQ2Ulw3bb8n5pjYoFqVMOO2qID45oIgiqXCmc+3m8alsRsANgi+kxPmA6eMRjT98SXuEDaKdkGCuk2oCuSkqry5M1/jc2DY31sM3ehmAdWVKw0eJrEPWxBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767228; c=relaxed/simple;
	bh=IvHLA+JBW9+ikkUX+Ciyx21sAbmvfr+rTAooO3Obifo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GC3510TsIi/p74ifYoE58a4P/0910KV5B3LUvwjufK1ONghzhSCMlK4V7WLv9bXESjiv9tsH5+17PyXf+qCvTFWp6FS5yxH+feToQ2H3tcszY0zZ4U55YQ1C3t5Wa6DY84UtYAKJfeUEldmszALmeW+aJ6QwagzGlBTh3tmcyvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTmNFYKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTmNFYKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E199CC4CED1;
	Wed,  5 Feb 2025 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767228;
	bh=IvHLA+JBW9+ikkUX+Ciyx21sAbmvfr+rTAooO3Obifo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTmNFYKwlTf+PZsKCBwThWgO9cH2PdnMWadoKpmvPPo2V1ybU865MskIwrpuzhPYL
	 SmndZPA7I1Kv0ibSP/jWDMx2McvI74K5X2tHAQgmo9OUED8xy1IU7GTrj3afLA+rMN
	 uzKd8NCbsE0HUXE8lAXS0b4rONKIrN5RxqY4Gey8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 375/623] arm64: dts: qcom: sm7225-fairphone-fp4: Drop extra qcom,msm-id value
Date: Wed,  5 Feb 2025 14:41:57 +0100
Message-ID: <20250205134510.566669420@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 7fb88e0d4dc1a40a29d49b603faa1484334c60f3 ]

The ID 434 is for SM6350 while 459 is for SM7225. Fairphone 4 is only
SM7225, so drop the unused 434 entry.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-fp4-msm-id-v1-1-2b75af02032a@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 2ee2561b57b1d..52b16a4fdc432 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -32,7 +32,7 @@
 	chassis-type = "handset";
 
 	/* required for bootloader to select correct board */
-	qcom,msm-id = <434 0x10000>, <459 0x10000>;
+	qcom,msm-id = <459 0x10000>;
 	qcom,board-id = <8 32>;
 
 	aliases {
-- 
2.39.5



