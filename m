Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E613659E7;
	Tue, 16 Dec 2025 12:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887056; cv=none; b=XyhT6XN20xdHTEYCpn0dU/UIoD9jmbfaSeZ8fQndHoK1FvF+T79aqNewZ+udcIchIv6Z4swLdLkclZ0nFBuhfcNZIyAG5AYFz3ZWAH3I3rQPpGq79oZO9qWNY9O38AvFz+mLZ51D2lCV1kLcYgYYzwwr8c1lqRGZwHkHU7ST9nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887056; c=relaxed/simple;
	bh=1OMHyFLZu1STVhNJUdYJjUf/tnqNE6aIglU9uGmMyjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mocfWUZhhhtF7G+ubUptz0PD+vVOZs1uV2gj0a27qh2Ik6lVULHpHdLcP9I68iUg9UJgat1juk74xRIkE3pBHM5imo0n+QqJcbpvkpZzhXLFp9ArrApWvyNIVMKaoLk2SZGxbBNRD+j3vxKhrgV4UTTiVAn+kt1kKvyu/XXEzIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWl1V01y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWl1V01y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3E5C4CEF1;
	Tue, 16 Dec 2025 12:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887056;
	bh=1OMHyFLZu1STVhNJUdYJjUf/tnqNE6aIglU9uGmMyjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWl1V01ypVr5sVtXDiIJ4F6jPEL6St62f9ZUH+17Xpq+4jzpohxoEQ/+7MJtS8rVM
	 IV+OeHuK9veaiCrW+pD/lI5ShBUOV6LOmYIFvawA6dxJb0/gDZOfLrlGr+h87h/czI
	 tBr+8aLKuGh8yfOUWAaPDvrXGV96BaRdVD81qkgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/614] arm64: dts: qcom: sdm845-starqltechn: remove (address|size)-cells
Date: Tue, 16 Dec 2025 12:08:01 +0100
Message-ID: <20251216111405.467059248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 4133486382364f60ea7e4f2c9070555689d9606e ]

Drop the unused address/size-cells properties to silence the DT
checker warning:

pmic@66 (maxim,max77705): '#address-cells', '#size-cells' do not
match any of the regexes: '^pinctrl-[0-9]+$'

Fixes: 7a88a931d095 ("arm64: dts: qcom: sdm845-starqltechn: add max77705 PMIC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250926-starqltechn-correct_max77705_nodes-v5-1-c6ab35165534@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 75a53f0bbebd0..45c7aa0f602d8 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -606,8 +606,6 @@ pmic@66 {
 		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-0 = <&pmic_int_default>;
 		pinctrl-names = "default";
-		#address-cells = <1>;
-		#size-cells = <0>;
 
 		leds {
 			compatible = "maxim,max77705-rgb";
-- 
2.51.0



