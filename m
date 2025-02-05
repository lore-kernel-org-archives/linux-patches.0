Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137851632DA;
	Wed,  5 Feb 2025 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766320; cv=none; b=TSmUqOcVjMA8jKU0DU7GQxwHEPs2XVtjkraP3pscCY4wKqCzxEvs/CzECRcdsb5ChqWZw8lsufsYT3OWHTReI/u2lIcuxhOny0OSeApc12XL+1UgPZbJBzArZ6SDSGPDJ9EhSMmtUkyVCzVbulwTAYbE2SSB47RnSegTEJT8+ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766320; c=relaxed/simple;
	bh=xTradLnApEBA6Q05SK2SEvYdeM/gD8bV7HJl5Ci9Jo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWRsn7YaFqNQUY7X+xGORVwdxdnCv5iqGnQwcCpY2sTVK8J63SGrMYs3F9LDmtCIdbRsnvlFLpPM4OTHto/4NWd1sGM/vaRNPs5KQ5EYKsHLt1Ft8EfPjHzROHWoBM3Vo98Gq6zPaiJdfw3w9biyyOYVgLWDowrxjJFgzR2mIYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu6wk6kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu6wk6kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A074C4CEDD;
	Wed,  5 Feb 2025 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766319;
	bh=xTradLnApEBA6Q05SK2SEvYdeM/gD8bV7HJl5Ci9Jo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hu6wk6kQmR238Oqf9nWZwJQX7ahKkyROau0urJ7G/u09OHFamx2gf/FOdulPtNVxz
	 Xiof0RrCAmn6OKpxdyZGzUBqqBJ7jnabWDO00qPKzGkTU5RHHoUwysKF7IdFBuxRvX
	 Pqsl3OssrnqSzsp3gz+oNsECdjwV3nQW+eHQdKsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/590] ARM: dts: stm32: Increase CPU core voltage on STM32MP13xx DHCOR SoM
Date: Wed,  5 Feb 2025 14:41:05 +0100
Message-ID: <20250205134507.135083139@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit a4422a9183278162093d4524fdf4b6bbd7dd8a28 ]

The STM32MP13xx DHCOR DHSBC is populated with STM32MP13xx part capable
of 1 GHz operation, increase the CPU core voltage to 1.35 V to make
sure the SoC is stable even if the blobs unconditionally force the CPU
to 1 GHz operation.

It is not possible to make use of CPUfreq on the STM32MP13xx because
the SCMI protocol 0x13 is not implemented by upstream OpTee-OS which
is the SCMI provider.

Fixes: 6331bddce649 ("ARM: dts: stm32: Add support for STM32MP13xx DHCOR SoM and DHSBC board")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi b/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
index ddad6497775b8..ffb7233b063d2 100644
--- a/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi
@@ -85,8 +85,8 @@
 
 			vddcpu: buck1 { /* VDD_CPU_1V2 */
 				regulator-name = "vddcpu";
-				regulator-min-microvolt = <1250000>;
-				regulator-max-microvolt = <1250000>;
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
 				regulator-initial-mode = <0>;
 				regulator-over-current-protection;
-- 
2.39.5



