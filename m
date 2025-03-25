Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4268826B2BA;
	Tue, 25 Mar 2025 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906253; cv=none; b=i2yMrECIZeDWY09UB0FWDt1lh+UetCkv8QgenEvqy+QlU6yWSqEFYGbE2CogFQGezx8qJpIID1JGRCa2NbEaxpX0Ea8QA3wFF/PTmnKbmn/utVaaqRUd5CMHGcs45XaaNANYn22KRFiC/UB8Yicsg0SAw97Rw2XT1YbbxSt2avA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906253; c=relaxed/simple;
	bh=/0HG64hFgr01Ng9P7Is/1tg6t1y1Ae3VA5OU09CizLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ+qJZbyX57napCy+esRokbzF1KvHj56MauX8ysYrimLo46WLnUrBkGWsfcXTqVzzV9q/ZrWCuwLqT5hwBn1Ia7yTbAQvHZnDnD3Vk8Em68sHXb+vVoYTo3R1H+Ksgu6DVAn3TOek+KUADHwv9HoLpc2RBEF/GF7fw8LVboplww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ck9KY5Vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ck9KY5Vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0DDC4CEE4;
	Tue, 25 Mar 2025 12:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906252;
	bh=/0HG64hFgr01Ng9P7Is/1tg6t1y1Ae3VA5OU09CizLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ck9KY5VrEG1HYMhG+YhxanEBRFTc/VpT5pIWGbEIfwLAAbyUsYLaZUTsysJm5CG+7
	 5HrVW3rpDn/e2ek5tyr/GD9UlnkcZVdcqYukTXajADPb8YzGqFPSTBdpBROkAzmxN6
	 6FqengxbIzG7TeahDFr5xsBkjNalkCmOv3zbBkh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/116] ARM: dts: bcm2711: Dont mark timer regs unconfigured
Date: Tue, 25 Mar 2025 08:21:46 -0400
Message-ID: <20250325122149.710661697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit c24f272ae751a9f54f8816430e7f2d56031892cc ]

During upstream process of Raspberry Pi 4 back in 2019 the ARMv7 stubs
didn't configured the ARM architectural timer. This firmware issue has
been fixed in 2020, which gave users enough time to update their system.

So drop this property to allow the use of the vDSO version of
clock_gettime.

Link: https://github.com/raspberrypi/tools/pull/113
Fixes: 7dbe8c62ceeb ("ARM: dts: Add minimal Raspberry Pi 4 support")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250222094113.48198-1-wahrenst@gmx.net
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm2711.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2711.dtsi b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
index 4fd0732a34d32..c06d9f5e53c80 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
@@ -451,8 +451,6 @@ IRQ_TYPE_LEVEL_LOW)>,
 					  IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>;
-		/* This only applies to the ARMv7 stub */
-		arm,cpu-registers-not-fw-configured;
 	};
 
 	cpus: cpus {
-- 
2.39.5



