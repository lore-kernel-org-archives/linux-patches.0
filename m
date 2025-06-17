Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEBC285070;
	Tue, 17 Jun 2025 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178108; cv=none; b=EbNdAfQUrlRf8bKkkfLHH2HfMf2Xz5owcZr6RpYvR4TpHMGzoZjhXzWEMNZB13UbKHvP+XHuaq8xtFqjCzno8h907Cg+tcV0V4fVEJGlXZTf0z/FToBSHTRMD6moftSd75YAIej2gUnCm1Oi4r4paokQDOh3rScmJdvtMOkB764=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178108; c=relaxed/simple;
	bh=yCAC+feIO4yA1Qsy4U82EtOjBwt+REb/X1IGys6UYws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPW7DED2cW34S/61RxoQExljpO615ItsZR43IbCnRf149FSQ4AB6yyvHZUXYHRWDroEhq0A6tYv9ZUacQ/b+WHgAj9CgdJBoBI/j1nauhkJ2FxucwiayzzS7rly+xwts9xmCuVxCFlcs01a8+Cf/eINp36+ifCHPCMeMvAm0QlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fb11luCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fb11luCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B7C4CEE3;
	Tue, 17 Jun 2025 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178108;
	bh=yCAC+feIO4yA1Qsy4U82EtOjBwt+REb/X1IGys6UYws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fb11luCgwN62ONHAVEbqDSjt7chg2BhQ/QaDYjwdIOzIN6JAj8GISrlOtKAG7lulU
	 rlTYh2dmmemDjGmN80MrjWG5i7+WHQZvnD8Xe1/O862Ris3uU/xCOMBOCMS8L8f5xX
	 zQDLVj/aBgp8T1n/MhLAEhi3okFC3BoEz/lm8sVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Massot <julien.massot@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 411/780] arm64: dts: mt6359: Rename RTC node to match binding expectations
Date: Tue, 17 Jun 2025 17:21:59 +0200
Message-ID: <20250617152508.201902841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Massot <julien.massot@collabora.com>

[ Upstream commit cfe035d8662cfbd6edff9bd89c4b516bbb34c350 ]

Rename the node 'mt6359rtc' to 'rtc', as required by the binding.

Fix the following dtb-check error:

mediatek/mt8395-radxa-nio-12l.dtb: pmic: 'mt6359rtc' do not match
any of the regexes: 'pinctrl-[0-9]+'

Fixes: 3b7d143be4b7 ("arm64: dts: mt6359: add PMIC MT6359 related nodes")
Signed-off-by: Julien Massot <julien.massot@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250514-mt8395-dtb-errors-v2-3-d67b9077c59a@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6359.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
index 0c479404b3fe3..467d8a4c2aa7f 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -300,7 +300,7 @@
 			};
 		};
 
-		mt6359rtc: mt6359rtc {
+		mt6359rtc: rtc {
 			compatible = "mediatek,mt6358-rtc";
 		};
 	};
-- 
2.39.5



