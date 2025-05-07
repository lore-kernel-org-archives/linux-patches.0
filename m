Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FD0214813;
	Wed,  7 May 2025 19:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645146; cv=none; b=pMsmkbBR7C3pJyxp4j5t2wun/EziOHIsRxC39ujBA/kAgb+Igw1Qz8z/MXUI/Jasq5fjfoFOUThXpFmi+Jy3rkAmFm8h/ZZ1HseTmp1OkmORIcmfkzJJwt5fPM1yXupbxoIjDgOu3Ywe+C6saHvEo945KrnkpUU3slRjwccmgrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645146; c=relaxed/simple;
	bh=/UhNn1C+dUmHMu9rm3z34kk3sFfhehuhJJ4X0SudKJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkGgpBSuv9r5+gkjjeJJ1UUe838u1zV8YfLffaL6ZO2NRJA/ciClIwpZpYAIrhgsCzvQrAn0xvHB6VzoctHOzUWn97kA9NEOSZ/Qhj9qWI2OAmeVNyW3AaRMsD0AoEc5eDi2Ncquz+ykcI4zr/3xVm9gI5VJhRhJAIaRt+r4zVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsHROpsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsHROpsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C5FC4CEE2;
	Wed,  7 May 2025 19:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645146;
	bh=/UhNn1C+dUmHMu9rm3z34kk3sFfhehuhJJ4X0SudKJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsHROpsWQ+mc+4B1zkDkhAs20eTlvbKX0NrgsX6YIgMi9UDGjqPEkrFF9KaxFAhoE
	 0LjFVfD13wUPj84p9r6/kTR0fAkX9gD9KVFrCW0pU6UZl1TD86DaKYkxnNp465jo6k
	 YLZGwK6eUoqn4FEfP5nx6R4fc299Q5BeNGy7OBxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Christian Bruel <christian.bruel@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/129] arm64: dts: st: Use 128kB size for aliased GIC400 register access on stm32mp25 SoCs
Date: Wed,  7 May 2025 20:40:44 +0200
Message-ID: <20250507183817.869716242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3219a8ea1e6a7..ce5409acae1ce 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -77,9 +77,9 @@
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



