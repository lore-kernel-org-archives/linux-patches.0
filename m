Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08742446AC;
	Mon,  1 Apr 2024 16:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987953; cv=none; b=bQnRbPVPYzlFk6m9OB0DAkBGMAyDD3JTXb8SvtKPp4nrrr05tNA4XWaRM8z8YyB9rqkJrlAD4DBeRzvbd11XXAz/jOmJlrlpmzyVqU2YAujbHJowH/6F9g5Ld3Kle5rty1REUqGWFCbmM2j2w2wk6Skbs6MdPd4+Vq2kPHdcVjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987953; c=relaxed/simple;
	bh=sgxFuLlwx2+7L9o+n2oy/Xx7bFn14WDMcNjx6kUMSlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jy+GUkPzCTcJaH2j9m8Fr5zepr7NoG3hxTykP2cjTj27ocsvXAWBEKZd2Jup39KyHkpDH/szhaQTLiXQroscOTVtvWkGsjbJwPyvH8dD2t8lX06ASIhYRa/2UJM7ULNkPG23QdWraraDBDK4B/7xg+5DM2FmA8rR7cv/NUxnMyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP8Dgim1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP8Dgim1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7514BC433F1;
	Mon,  1 Apr 2024 16:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987952;
	bh=sgxFuLlwx2+7L9o+n2oy/Xx7bFn14WDMcNjx6kUMSlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP8Dgim1Ma/1wd/AYR5Qpv+FzVhlmaxLOE3LnNI42McD/foD/OtAVcoBexbVO0FIG
	 zysetVTEvNm7rHsMi9tgMmqf03IEGl3uX9QmtkssIAN1vKbiSA7YGlRRBFJpIPkxAH
	 dY5aAnvruHEVWNqA6JwWZIqfrmECL5UzthiOgC2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 012/432] arm: dts: marvell: Fix maxium->maxim typo in brownstone dts
Date: Mon,  1 Apr 2024 17:39:59 +0200
Message-ID: <20240401152553.494467800@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duje Mihanović <duje.mihanovic@skole.hr>

[ Upstream commit 831e0cd4f9ee15a4f02ae10b67e7fdc10eb2b4fc ]

Fix an obvious spelling error in the PMIC compatible in the MMP2
Brownstone DTS file.

Fixes: 58f1193e6210 ("mfd: max8925: Add dts")
Cc: <stable@vger.kernel.org>
Signed-off-by: Duje Mihanović <duje.mihanovic@skole.hr>
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Closes: https://lore.kernel.org/linux-devicetree/1410884282-18041-1-git-send-email-k.kozlowski@samsung.com/
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240125-brownstone-typo-fix-v2-1-45bc48a0c81c@skole.hr
[krzysztof: Just 10 years to take a patch, not bad! Rephrased commit
 msg]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/mmp2-brownstone.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/mmp2-brownstone.dts b/arch/arm/boot/dts/marvell/mmp2-brownstone.dts
index 04f1ae1382e7a..bc64348b82185 100644
--- a/arch/arm/boot/dts/marvell/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/marvell/mmp2-brownstone.dts
@@ -28,7 +28,7 @@ &uart3 {
 &twsi1 {
 	status = "okay";
 	pmic: max8925@3c {
-		compatible = "maxium,max8925";
+		compatible = "maxim,max8925";
 		reg = <0x3c>;
 		interrupts = <1>;
 		interrupt-parent = <&intcmux4>;
-- 
2.43.0



