Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B68C1FECA4;
	Wed,  5 Feb 2025 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767004; cv=none; b=Uk2hNDOXrBH1mPzaHLx09tCJASpnT1r6wKSPtfwuKRdkedyIrE91dgrLItqPqonQIGW1xpUdEKMBI6IahM+8xBuq6E1+2s3t1jHYV6geRQrmEG3FcZxmRV1nx1ZssNaMR3KWDd7Z7/zoWYkNqQgUdTA+iL2mopdqKnrwgac+hQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767004; c=relaxed/simple;
	bh=aNX0fuDF746VP4IBKhSJXeUxfxi7wsWLod5QY5YLB60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuZ9gYee0+fj7W2JWbw83uS3ZuSMi+QVfDuEffFviSb7170cfn1i00CQzfi4j670nCWI2wzq8GuDUi24K85h9a77pL8IgR7Rlk+E47YViF4iig3FrI36YvXUCWabUERxeMZO1ky73YZyH/+lgKUeKg1PaO5vN5klU2hrTAxLaKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkiJFUeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkiJFUeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4E5C4CED1;
	Wed,  5 Feb 2025 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767004;
	bh=aNX0fuDF746VP4IBKhSJXeUxfxi7wsWLod5QY5YLB60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkiJFUeO65TKoEI/rGC3RAysA0Ke5c/i4SH77uimbNmr1LbYZEzplq/UnxApN/NYv
	 Z8C8byv/ibRt+maZDQSCbhgA5feAbRDfvIKlTB/jBBE6J63R+WEVHIJmISF/uMY/R3
	 1HUlANJYVBtIs1cP1Gq9PLZEvtalMd9HHRG2L8rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 340/623] ARM: dts: stm32: Sort M24256E write-lockable page in DH STM32MP13xx DHCOR SoM DT
Date: Wed,  5 Feb 2025 14:41:22 +0100
Message-ID: <20250205134509.235858827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 41e12cebd9c39c9ef7b6686f2c4e8bc451a386fc ]

Move the M24256E write-lockable page subnode after RTC subnode in
DH STM32MP13xx DHCOR SoM DT to keep the list of nodes sorted by I2C
address. No functional change.

Fixes: 3f2e7d167307 ("ARM: dts: stm32: Describe M24256E write-lockable page in DH STM32MP13xx DHCOR SoM DT")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi b/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
index 34a7ebfcef0ee..6236ce2a69684 100644
--- a/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
@@ -201,17 +201,17 @@
 		pagesize = <64>;
 	};
 
-	eeprom0wl: eeprom@58 {
-		compatible = "st,24256e-wl";	/* ST M24256E WL page of 0x50 */
-		pagesize = <64>;
-		reg = <0x58>;
-	};
-
 	rv3032: rtc@51 {
 		compatible = "microcrystal,rv3032";
 		reg = <0x51>;
 		interrupts-extended = <&gpioi 0 IRQ_TYPE_EDGE_FALLING>;
 	};
+
+	eeprom0wl: eeprom@58 {
+		compatible = "st,24256e-wl";	/* ST M24256E WL page of 0x50 */
+		pagesize = <64>;
+		reg = <0x58>;
+	};
 };
 
 &iwdg2 {
-- 
2.39.5



