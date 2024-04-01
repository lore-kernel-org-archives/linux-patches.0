Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3123FE2D;
	Mon,  1 Apr 2024 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986546; cv=none; b=Z8WfIl2x7+k0YnSN3RsRgSugSkHDEoYYm1u/N9/JlSXad0fsLZ3+Wa/sl08KcTrW9TAFDmL9vfzq0Gl8Nl0G4f1jppOkAEwPxtkzIhFzX4Y5ymWn9EYaCpvbP0wOpMvuOLN5WQ6goIx7Wt30x0hglRip9FZINb626KOrO69FHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986546; c=relaxed/simple;
	bh=OEjRXZFMZy3ACAdAPS6yK2ay60ZZUfgFckc2OARlCHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rRmbtIV6w1UxtOEbklmJthwPpn4+FKFjwoE/97rUH+WOYyOcDMAyHZFvTB7XOxPZNWENAfLxF/gxWymEl2NoLlzH/c55Q1Zw8dQlyu1LCk6b255CGExXVzqQwWX+XLIpYt6pVACdAdXYLHowvNbIhnRrJBtbNLnMES4S8lUAej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiAnpK5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiAnpK5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80553C433F1;
	Mon,  1 Apr 2024 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986546;
	bh=OEjRXZFMZy3ACAdAPS6yK2ay60ZZUfgFckc2OARlCHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiAnpK5iG5SqikoYBce84MUy5QniWkhx1XDG22vap4Nha4mgY/hi/8ATz9FDOSUCi
	 8eEwCQjO5lN1G2FFVP3GXk+EDHJpIwcc3wg0vu6b/iic022L43CgDkEc7c+Og67Wck
	 j9/xt/AnT9wsxB1iGSKSNAbXE+Lze7km/mAHhSZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 010/399] arm: dts: marvell: Fix maxium->maxim typo in brownstone dts
Date: Mon,  1 Apr 2024 17:39:36 +0200
Message-ID: <20240401152549.456086463@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



