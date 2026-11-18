Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017538;
	b=G7uIBb5IOQ3ijFHGKDIafXiSblbyJNVtyQlzVVQm13LV5gWGRg3ZLVPhWJe/4K0LMwKL
	 WrgDNON80jEXygVLU/ljOPoJOjYW3fM+0ie7/zqHlHyb1hENqseeHVzkAOWJ3OFZfT5Pp
	 C0cu15r7Y/SXiSXnFoI7eh9dmMCbCl7I7ysz5PhUgHSJIJYZr8hDYTrPFsg0P7dptR9d6
	 Fnub7acezmqQ8sEPrSTWFNJoo/05AeuGiO1kUw2EQEo7nTUdLWq+z4KAwkENx0NsESziD
	 ETLRATMjMb6oRG13JIK9otfgMlK6630qDrO2jBvE/Poisn/h/+muqvk3jSmzg0ujBXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wc4AyFY9edVHf59DrflA0WVKA9s6ahgqe+ZHERXy7Wc=;
	b=zf8xjgbggZ4suq465ss0ffsCMiTA8hIbI4sxpfcdlcEFGUweO/C4xwwYr+Ra30u0sQGT
	 LryFMofH1qjqMzap+vQM6BXcEBgkM7PCdnjU1kx7YzLmmP6qVXoHoL+Bf9BkYZHYH7w/8
	 zxxgO+xB9BRHG8Uebq+3Vk+MZLCHUIdqPEgJvchwh3WtQbrGcUxrslOzH88/dt7a2nRbJ
	 Jn9hd4KKTOCo5Xrv7F9uUPC/5e3vv8iNl3uYUtRxTIidxmE9V4Y5ygtsTCNN8vQRYiZsT
	 m/zlDWg8BjJfpqoeBWgITCRwAgAQMsDkbEOkbx75WlVCtzdIhQPLMoEnztplcZ7STiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjcRfyu+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576DB606A338;
	Wed, 18 Nov 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjcRfyu+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE97C1F000C9;
	Wed, 18 Nov 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017538;
	bh=wc4AyFY9edVHf59DrflA0WVKA9s6ahgqe+ZHERXy7Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjcRfyu+ritjxGO0IqR4V/1OneNLMTM3xqZtYQMxc2Tv7V5nZeUyab9smcVBPF2Jn
	 B6fzpkYKMgOiLec6ovweCpVBPYBGHrzwP+o4tXYmy1LwhJe47dvLUw8mWQhhYRYHDG
	 q0TLcad8LMBg2e+0DvgKkR9PZBNG69ORfHJknEuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ociepka <greg@ferrisoft.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0921/2651] arm64: dts: qcom: glymur-asus-zenbook-a16: Remove RTC-through-EFIvars
Date: Wed, 18 Nov 2026 15:36:01 +0100
Message-ID: <20261118150321.049429700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 37e8a61bf7214306889777edd8bd3df53b52d287 ]

This machine, unlike older Snapdragon laptops, doesn't feature an EFI
variable to denote the system time. Remove the property that suggests
it does.

Fixes: e8fbbca94db7 ("arm64: dts: qcom: glymur: Add Asus Zenbook A16 (UX3607OA)")
Reported-by: Greg Ociepka <greg@ferrisoft.com>
Closes: https://lore.kernel.org/linux-arm-msm/20260821181148.1642208-1-greg@ferrisoft.com/
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260911-topic-remove_uefivar_rtc_a16-v1-1-0967d8d4b3a6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts b/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts
index 40433dc2d6cf9..95da35125d754 100644
--- a/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts
+++ b/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts
@@ -861,7 +861,6 @@ nvme_reg_en: nvme-reg-en-state {
 };
 
 &pmk8850_rtc {
-	qcom,uefi-rtc-info;
 	qcom,no-alarm;
 };
 
-- 
2.53.0



