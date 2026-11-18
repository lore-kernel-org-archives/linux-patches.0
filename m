Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033417;
	b=gOv8GrWixYad9yiQOhdxTHF5M/V/rWlLgAKHW3XcEsymrnwmPGzN9CDYMHLBav5s5ZuV
	 TwfRN+sMCL064gxI02/8ojil/pTr+MFQm9SPI80yCbKe6mpvM/bQEw0M2Hxa81m1RxFYa
	 bgMN/LunuSspt9PHr/khYkQjB2uqxyeRHOCp1iN+ArhKT8eC6ma8w+1PtdrtMC7gYo7+4
	 FbkGLnC8Xh6vVi3y/OpmI4uRk+JpeY+mntvcEjrHEb9XfvAqBYrGp5yAFrb3n5IZ01SDC
	 5jBozLwhE6uVNqApuy5V4CSMaOvxCT3b1K9DXuym/IV3TXCIo+gyt5cTOWiZB61jfew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbsZwGlpd6eoKfm0D6B1kAqahRH1dH4xfNKdw0zeYhg=;
	b=anIT8XHePr2NS7KPbxaeIvMZUHWXTgezUpVLZBAAR/O9VgswfsdyfefWrXM6Yf09GTfS
	 wLnHm7NwUxDl4KzkwiYLxskohFFCvMOosxlF/qqc1+5+Vw0ppiYwK5qON3OjSqykpQx7+
	 mFSWF/JrLNn5DJjfA5gFtrF/H+4z+MlZGIqFdKmq9tCeLHIFLxazz0Vn7zPhEvKxuqcMs
	 NSVV5DC6czsqy+Jh4Pmd6Rir4wNhBm7AW7wZNi1oUuu5t+a7yqWRdcxsKvGaHNei/4SeI
	 BvDD2Yq0ABPk8qkXHF501sgOp1yNYu5fb817NoFTmwI+UK1557ntHXdli7ghJQaWieg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BfYg/aSK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38C606A320;
	Wed, 18 Nov 2026 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfYg/aSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60CC1F000C4;
	Wed, 18 Nov 2026 20:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033417;
	bh=PbsZwGlpd6eoKfm0D6B1kAqahRH1dH4xfNKdw0zeYhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfYg/aSKaRdujz0NgA09EiWq2kBEa0FR2riUz1H4B0xNihRExPPjc79DJ2JcoTV/4
	 DvFkgFcnqLR1ZSiw8HiptmhOU6JrHs1kyr2hxkAFzv2pbxglV3suZqLtH6KweoBxlQ
	 xc2t4Yb8mDW1Ocqq+P4LDgbqDd2PSgcJyef5lao0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Christian Bruel <christian.bruel@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.12 1743/1756] arm64: dts: st: Use 128kB size for aliased GIC400 register access on stm32mp23 SoCs
Date: Wed, 18 Nov 2026 16:04:30 +0100
Message-ID: <20261118150118.927007389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

commit 2ef5c66cba6171feab05e62e1b22df970b238544 upstream.

Adjust the size of 8kB GIC regions to 128kB so that each 4kB is mapped 16
times over a 64kB region.
The offset is then adjusted in the irq-gic driver.

see commit 12e14066f4835 ("irqchip/GIC: Add workaround for aliased GIC400")

Fixes: e9b03ef21386e ("arm64: dts: st: introduce stm32mp23 SoCs family")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250415111654.2103767-7-christian.bruel@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/st/stm32mp231.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/st/stm32mp231.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp231.dtsi
@@ -1203,9 +1203,9 @@
 		intc: interrupt-controller@4ac10000 {
 			compatible = "arm,gic-400";
 			reg = <0x4ac10000 0x1000>,
-			      <0x4ac20000 0x2000>,
-			      <0x4ac40000 0x2000>,
-			      <0x4ac60000 0x2000>;
+			      <0x4ac20000 0x20000>,
+			      <0x4ac40000 0x20000>,
+			      <0x4ac60000 0x20000>;
 			#interrupt-cells = <3>;
 			interrupt-controller;
 		};


