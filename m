Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89040187FF6;
	Tue, 30 Jul 2024 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355387; cv=none; b=p9kLd1vq8UgfB19s8mwKlLh45pj+GKECJC3nMGmCS1IBKSIUHWvGzliJvt7KKXFVbI7EYn9n3wG9WvDQB7JBU+uqM9zzSgNN8Hbh8TzEeheLwR0DXgBPmoeSYujhSW6+Tb38jM9sAbCjXtoncgmn38FRbQLJZiVwdv+QtsEqMzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355387; c=relaxed/simple;
	bh=u6nbbH8ypNhDrsF9jfK1ISievzvKKwDNEqdyMq1lz1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8+KbAhjjXW/wqdOYYG/apuNGjVRBE+kQTY0PaSJa9/TqXosr+UOmijmqIH+ytr5YdyyR8lmsPxfRmjWsyvNghjHp4GtdX3DOgMgdTxg/ESWsP/h5um1YLldzrObPrCyZqIussEGuwAQG0xVR9Ttnf2+9HHMmm2rESv5ytUwZsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NM8GNOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NM8GNOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33D6C32782;
	Tue, 30 Jul 2024 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355387;
	bh=u6nbbH8ypNhDrsF9jfK1ISievzvKKwDNEqdyMq1lz1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NM8GNOQR1jT5bc/slgpN/xb9yXj4a3LNq7Uq6JNtj6ML8jSxugUx1S+/xnGQ7z1f
	 39YpQeloXctgWftViRKXlO53mbwoi6gwOovLRcptVZmncYHmsvSy+Kk+oUrIAIPDYF
	 +AHYZYY3S3/W3Y3AS4G1cULYLxGGza44NCMbZmUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 046/809] arm64: dts: qcom: sc8180x: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:42 +0200
Message-ID: <20240730151726.471621846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 9a80ecce60bd4919019a3cdb64604c9b183a8518 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 8575f197b077 ("arm64: dts: qcom: Introduce the SC8180x platform")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-5-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 456ec81327021..da69577b6f09b 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2245,6 +2245,8 @@ ufs_mem_phy: phy-wrapper@1d87000 {
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			#phy-cells = <0>;
 
 			status = "disabled";
-- 
2.43.0



