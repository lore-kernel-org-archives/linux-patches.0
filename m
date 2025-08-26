Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6523A34F495;
	Tue, 26 Aug 2025 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218633; cv=none; b=F6EiGb5kdwk40SZq9p8CKNGeBTLk5IeGMatlvKS375TP2EqFTVqoawcFOosHvqt3ZgH148l5pNhQ6blAGVFTZwTYmxyRS4si0QwW2CPzbR5fE1BY/x+tB9yUWxqZ4xLeNLlFRjKNN2eJMaZzgBI77uTzbKNBS7JilEq6TLfWCws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218633; c=relaxed/simple;
	bh=+EKYlxVaUaYcET/vOiqAthkRl8FRIbTcfshEHuqCvR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN7KK/i+WePsERjb7Sbv4TGdcFbFDTgVQuVvXfve7962aoCGePTNnuROYGMBburtnbw6gfv13yudTUjgVJ+BvukllzVhopRlPqvJItE+LULbefOo62Usts4t2yFVaiaBXvdskHrCLLnVzlXV7FeuWfxUouimsayzCXpVvvaSmwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTnRmn3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTnRmn3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE95C4CEF1;
	Tue, 26 Aug 2025 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218633;
	bh=+EKYlxVaUaYcET/vOiqAthkRl8FRIbTcfshEHuqCvR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTnRmn3a0at2v3YNT+YMrwCzyFVn2MW5GERjKazSygBmtmEbKhP7Jt1JqpkuLLy+2
	 +lFEVgQ7fpGhaP8/AN6aHBvOHeyPEtgYxs4y9PZnybVM0U5WXsKSGrtBOFuBsrF+NE
	 hCb5pwraKMReKhag9sZ7fSYpKHWmgBNDOu2k6Nr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/403] ARM: dts: vfxxx: Correctly use two tuples for timer address
Date: Tue, 26 Aug 2025 13:06:40 +0200
Message-ID: <20250826110908.439078561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f3440dcf8b994197c968fbafe047ce27eed226e8 ]

Address and size-cells are 1 and the ftm timer node takes two address
spaces in "reg" property, so this should be in two <> tuples.  Change
has no functional impact, but original code is confusing/less readable.

Fixes: 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer node.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index fa248066d9d9..3679922bbabc 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -617,7 +617,7 @@ usbmisc1: usb@400b4800 {
 
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				reg = <0x400b8000 0x1000>, <0x400b9000 0x1000>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH>;
 				clock-names = "ftm-evt", "ftm-src",
 					"ftm-evt-counter-en", "ftm-src-counter-en";
-- 
2.39.5



