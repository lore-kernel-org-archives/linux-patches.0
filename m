Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3001E1E1DF6;
	Wed,  7 May 2025 19:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644823; cv=none; b=h3WqfockBl1/RaT95LM5zcYKRQgHEcxVeLT4IKsExnEWDw75nK5jC1x3vnaE4+6zxcuYqZd3/tUR4AEiPRFnlaHrO9SZMugVs8HocHo0N9MfpI7+iOXjZd+pAZHzP1hVpdvoKnmiQQCz4IvwRCxZDHchvKsE/CZll2C5vnXwlMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644823; c=relaxed/simple;
	bh=r4wdhBHAOtVRSsyrqtBA4xat4rBd50eIE0ydHORCXkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVVq3cycJ8SrD9Kxqdvhh0gnSaV7eELuWAKOwS5SXJIfQM8aD40roaq3tBG+LB6XKwCLNOq+333KIG82pX8lt50pD2au4itW5LPXFnZPxe5ER6nVAC7ZweKNMw3YJX1g4WC138KXuYf3uzDKMlaHAeGPtZE9y8Wq/N0L5XarZmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Z9eqjYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Z9eqjYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9D9C4CEE2;
	Wed,  7 May 2025 19:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644823;
	bh=r4wdhBHAOtVRSsyrqtBA4xat4rBd50eIE0ydHORCXkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Z9eqjYd02Hrv0SLPfxrqfqlhSZvCYeg2DJyDm68wDAE8KPrlKyr5PRsyhydB/mwz
	 lO4zLrWowzTGqKrH20svUJGGdM9eCi+jUaPP+yVuFtIqYoeI+Yqx2K17Pv9g+F8YLI
	 VqU/zz+1ugIEb5vY3kYjeJgglYA4i9O7eY0Pbf0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Christian Bruel <christian.bruel@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/164] arm64: dts: st: Use 128kB size for aliased GIC400 register access on stm32mp25 SoCs
Date: Wed,  7 May 2025 20:40:43 +0200
Message-ID: <20250507183827.361193454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 06c231fe953a26f4bc9d7a37ba1b9b288a59c7c2 ]

Adjust the size of 8kB GIC regions to 128kB so that each 4kB is mapped 16
times over a 64kB region.
The offset is then adjusted in the irq-gic driver.

see commit 12e14066f4835 ("irqchip/GIC: Add workaround for aliased GIC400")

Fixes: 5d30d03aaf785 ("arm64: dts: st: introduce stm32mp25 SoCs family")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20250415111654.2103767-3-christian.bruel@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 896d92032284b..cd9b92144a42c 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -118,9 +118,9 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x0 0x4ac10000 0x0 0x1000>,
-		      <0x0 0x4ac20000 0x0 0x2000>,
-		      <0x0 0x4ac40000 0x0 0x2000>,
-		      <0x0 0x4ac60000 0x0 0x2000>;
+		      <0x0 0x4ac20000 0x0 0x20000>,
+		      <0x0 0x4ac40000 0x0 0x20000>,
+		      <0x0 0x4ac60000 0x0 0x20000>;
 	};
 
 	psci {
-- 
2.39.5



