Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EEE13DDDD;
	Thu, 11 Apr 2024 09:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829516; cv=none; b=n5PcaU3Mwtg0ycGmqaQyrPuwLGC6ASqnrVE+Z6VAQVqasNyx2XIqQ2k4ZjH4Qiq5CKSJC5zso7vQGS1TkhJ8enxCEKnb/kt5DOmRprdVLXNVJpTYq7XPn/AcnUOwQOX4q1JOGPyvtmOpV0ZsMUGjZvswmKiZo2yEuI2WkFC2pXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829516; c=relaxed/simple;
	bh=TO3EZxnJEeUGUrKyp8V5mTUU3gA9nKvmUbiLYj1BGFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5LrQYs4Ijwapd+VevW30t9cgBEKi4Oh2Wqwo/NJengFZ+yM+mS7edCetLKs9ArdKYY/PUu/achLaDGXVp+sEoo0cusG9lUNPc3stY0fVgUdu4VMKNSPcgaPtkhz/5T9cAiyGli6GgP+sP5Y5B9M3YbXZKHeEDWMPNTRFxQTzKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHHjdfqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHHjdfqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07750C433C7;
	Thu, 11 Apr 2024 09:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829516;
	bh=TO3EZxnJEeUGUrKyp8V5mTUU3gA9nKvmUbiLYj1BGFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHHjdfqk4zoYXokv+p5COf+N1esSvN979rstTJcRVEIswAFJpAC2zSKHEtyX7BT8t
	 qzOwrmgNTR1PRb/WTLDru/R9cAVOSfWxw56SPoAavON7Psirb8mZZ5npBdGTOoXc39
	 v3p0oXNB/47S2umQf336lk10DfVYgVTwQQGdNFi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/175] arm: dts: marvell: Fix maxium->maxim typo in brownstone dts
Date: Thu, 11 Apr 2024 11:53:57 +0200
Message-ID: <20240411095419.974143060@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/mmp2-brownstone.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index 0fdcc2edcf4b6..f12d5aa773f30 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -30,7 +30,7 @@ &uart3 {
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



