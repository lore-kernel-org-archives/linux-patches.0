Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048794;
	b=wxOlkztGxZ+zSzvAIGrsHZFaKuY1ARVG7yG/1DnfNJ7WnrcAFKbqK7UM7QnzS2FFobU9
	 IgBoryIFQ/AWiO8MnYd17NX45i2cTX19x3qUECllkeM+GimDCUyL9Ef0NoUD+3eNhhjmU
	 mry3+nYMpDpQLLYX7teWFrrzD44nDiV0ZlaN9jAZbKvyytnEOxpr0frYXKBwKee0/l/G8
	 hEMtQUHBd74G6Q6jMesWGgi6f9qnOh8aziSk1HHBnT4Sukh1zxG3PVwpF9/9faw7QeLD7
	 j/D4Wf3K205x4tn0pjdlhVv1SJFZaLQDgaGVKTgtG14c8pBRqGPBGkZiTRKKVngtaPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LWeWilg+9u1IgI8PHRElWGCqpsoKQaFBmLMb+0T8QXI=;
	b=FQ8A/EgKSqtR4N0heS5tMCOJ7dKWSXmvdxc8/w7AGcfLmdMAMNfpy+v7jIlEXhmlgtD2
	 TI8/jZNr/eTwQgK8pX1ANvcs4EUVzioX3Y+XhZeErAnQm62VxsyBdQlfvHNAse9U14OcV
	 cUzZruLmOC/Otq59rUoX8lG2zplh5hZWMMJJNvdE+sHkyuZqcTrKkR7PmV8SderD+Z7KG
	 dabmkfMYglB/atRvORBQHZlkv3kvZM+x7ElPN98mm4oSxVuLeRCUbpZCax8EToq4w4vT3
	 NPoz44fXOGcd5BACNuaKAe6SoNONxSDJQD1gZC/tDLAxxrwNUTQMxCBq/sEU6veZ6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhsBpFnI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A671606A320;
	Thu, 19 Nov 2026 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhsBpFnI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27F91F000C4;
	Thu, 19 Nov 2026 00:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048794;
	bh=LWeWilg+9u1IgI8PHRElWGCqpsoKQaFBmLMb+0T8QXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhsBpFnI3o3ojtCjpJKiz63IyoeFhPQjMnAEyCgsIirZq0bw1jdvY4Q5nbF4BWsyZ
	 cA7ofmRpF/wp0hlEmgrQkCLQdDxK5rFpZFihlS7G8MCdM+51cjBd+M/HofX7f14AQQ
	 rDnuXArREC/2dCMsTJEVuGSmwzwQvl6ZhRQUYoco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2081/2857] arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain
Date: Wed, 18 Nov 2026 15:51:55 +0100
Message-ID: <20261118150316.335429396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 475aab59d9870d250f521e202d191899c50a3ded ]

Replace the raw power-domain index of SDHC2 with the SM8150_CX binding
constant, which is the correct power domain in this case.

Fixes: 876644c76034 ("arm64: dts: qcom: sm8150: Add support for SDC2")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260914-qcom-tie-cx-to-gcc-v4-0-9d5a606ada33@oss.qualcomm.com?part=45
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-dts-qcom-sm8150-sdhc-use-mss-for-pd-index-v2-1-a8610199483d@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 9168173dd0e3e..9fb8a537b879e 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3436,7 +3436,7 @@ sdhc_2: mmc@8804000 {
 			iommus = <&apps_smmu 0x6a0 0x0>;
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
-			power-domains = <&rpmhpd 0>;
+			power-domains = <&rpmhpd SM8150_CX>;
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			status = "disabled";
-- 
2.53.0



