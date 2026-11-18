Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040273;
	b=0AaBj7ID5XPmnR+4y2vk+ZOCoQhxVd7BsngSGz1Om46m+yaNalvewW6f7oBUk7eCkG7J
	 xnxzfeGCRoM1ki78EyriRzDTa0rGU0bkgi/zFcUi+04KOAsGIiBKZYrjKTE6cIS+YerTc
	 rYxgYR6iE5VwdJVIKQqD18cDwLA3nOlFArnTiWY1f3GXvNrikyb4ynNaELXSLIoXUVqQs
	 RaKCArLu6zJNmgZpjyfRy9C3B96DlTM8piNXuhyO7wD5uMaFkcwIlkGCuwoDQHKAznWKt
	 iApQhMKMuuoqwuCaX/grZWMn5LmK3kBGa/S2ebCfS1HemFfTIimCm7woyZbThb5kEZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JhfO8pb2h5dwXViZ1t0YZhU/u4827aRb51QtIh301hg=;
	b=klUV2mcp4MZe3hOJajbav8UJqKX79h2+Zm7/7FQuv3HfSQgt29l8snZ7zPaYgRjlGZT5
	 evYpXCoRcz0YrM8MbW/TLLWH2We8AEJHuz5tpQiRbcImCCm8fedey/+Zrn1nROiw11lYa
	 FDU0hFMbBc5F6S1kpmhEJiOZ4vNMAKf88qYOUq8Y5wmqRkVXH8UAHAw/7GYVNJmB9kS2W
	 igl55TG6nfwJlHD5T7xdid6P0IES5SnfU8gJnwu2vfCBMB4QptLBBTJ/EpFxNkpTdEFvx
	 EA5Hvwn9qBM+6W672obkb5J6M0VVCL0buPe/AhiWXW0yjGPmxWHjEhdNzHgsI/CD18A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opHSiBx1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C487606A330;
	Wed, 18 Nov 2026 22:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opHSiBx1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EDD1F000C4;
	Wed, 18 Nov 2026 22:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040273;
	bh=JhfO8pb2h5dwXViZ1t0YZhU/u4827aRb51QtIh301hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opHSiBx1npd6ORJIS7m2ZAjjyKcELFZTRINaqpKL+88qj+SVpqrQFNsDbuAeyEHyH
	 hx0habZqoeZa9hiT3lx4UW9c3NYpLjlFMu3QSKpDWrllj2K+cJ0ap3Dy7/tZv49fZn
	 Zf9nYKK5FFK4XTkTorDBFZPzryXcQ8slZFH9v0f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2397/3318] arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain
Date: Wed, 18 Nov 2026 15:50:19 +0100
Message-ID: <20261118150433.419515226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 73ef228ff2689..a2ca4e0174358 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3519,7 +3519,7 @@ sdhc_2: mmc@8804000 {
 			iommus = <&apps_smmu 0x6a0 0x0>;
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
-			power-domains = <&rpmhpd 0>;
+			power-domains = <&rpmhpd SM8150_CX>;
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			status = "disabled";
-- 
2.53.0



