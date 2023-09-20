Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674182AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8DDC433C9;
	Wed, 20 Sep 2023 12:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211339;
	bh=46iFbIhIHx1jUto79uOcOBnqC8WJg9FGrb6SQy2dWGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjD2T4ymaUf5BeqDdOy85GHa43BcGXqFcou6IHWCv1KM/KxmTILpCPcrL7MXYTJ3F
	 Snty0/bCBgMIkNWWjQoZtvM2SXvVwtJSDOfhkvkYWjM/zLhFHTYbjOqiWW/o+FSEyl
	 LvtfqlqNgtqNpYhKyHElgmlCZzsF/x7B7bGhcXeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 057/186] ARM: dts: samsung: s5pv210-smdkv210: correct ethernet reg addresses (split)
Date: Wed, 20 Sep 2023 13:29:20 +0200
Message-ID: <20230920112838.966500045@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 982655cb0e7f18934d7532c32366e574ad61dbd7 ]

The davicom,dm9000 Ethernet Controller accepts two reg addresses.

Fixes: b672b27d232e ("ARM: dts: Add Device tree for s5pc110/s5pv210 boards")
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20230713152926.82884-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
index 75398318ed57c..4e17023684c91 100644
--- a/arch/arm/boot/dts/s5pv210-smdkv210.dts
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -36,7 +36,7 @@ memory@20000000 {
 
 	ethernet@18000000 {
 		compatible = "davicom,dm9000";
-		reg = <0xA8000000 0x2 0xA8000002 0x2>;
+		reg = <0xa8000000 0x2>, <0xa8000002 0x2>;
 		interrupt-parent = <&gph1>;
 		interrupts = <1 4>;
 		local-mac-address = [00 00 de ad be ef];
-- 
2.40.1



