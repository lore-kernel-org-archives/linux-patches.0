Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2A72F2341;
	Tue, 17 Jun 2025 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176443; cv=none; b=W1AFJmAKvUBj7tnzPZNjYv4MS6g3KwT0ypUIKnpZ4aNmr9o6NKkXHyv9YoA4NRKwAJQPtl96mepUIx/4FS+j9gvvyz/pSMyQ0OV40f0l1Hfgb90uUrJpFG4owsGJpN+j82pkrr4o0C8dcnvuzg/dhlEQFDA+KX8ts8FNqCK2nWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176443; c=relaxed/simple;
	bh=Ecms4bNEd7LGBj0iEGjWTOs/mXdpjpBZWkas7KrNudQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBzrrd6nBlkcaK98PcEs5odSCeo8UNHp0EHrLW6c5u+6Ct14egBmpcoppq64atpAbjWdYkD1UOrCRTeLlrsoz9O0Ccz8mSwsypPMfA0I4dqwJNdgCHdXRtyp6BdWS9DqDIVJIhndKd9xFP+vkDtzd0dIIV4mEEL3fTdNB1yh9HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk38m1nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk38m1nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E929C4CEE7;
	Tue, 17 Jun 2025 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176443;
	bh=Ecms4bNEd7LGBj0iEGjWTOs/mXdpjpBZWkas7KrNudQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rk38m1nAd58Wi1k5Txnhxkh+v0o989jIymCxaLDXSqQ6VBVJxFVrw1ndypIjcmvco
	 SXAF8LMja7Zu9GrqHtm0DLKDMJvbEmENbo4UIE8cYiD4C7OmZRr6bi9oR/F4tLq1Qu
	 HMEMsFPBe45WkrTyHZfKQ//O4rCIKqtBuYApuKwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/512] arm64: dts: rockchip: Move SHMEM memory to reserved memory on rk3588
Date: Tue, 17 Jun 2025 17:23:16 +0200
Message-ID: <20250617152428.951499721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 8ecd096d018be8a6bd3bd930f3a41a85db66a67d ]

0x0 to 0xf0000000 are SDRAM memory areas where 0x10f000 is located.
So move the SHMEM memory of arm_scmi to the reserved memory node.

Fixes: c9211fa2602b ("arm64: dts: rockchip: Add base DT for rk3588 SoC")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20250401090009.733771-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 83e7e0fbe7839..ad4331bc07806 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -428,16 +428,15 @@
 		#clock-cells = <0>;
 	};
 
-	pmu_sram: sram@10f000 {
-		compatible = "mmio-sram";
-		reg = <0x0 0x0010f000 0x0 0x100>;
-		ranges = <0 0x0 0x0010f000 0x100>;
-		#address-cells = <1>;
-		#size-cells = <1>;
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
 
-		scmi_shmem: sram@0 {
+		scmi_shmem: shmem@10f000 {
 			compatible = "arm,scmi-shmem";
-			reg = <0x0 0x100>;
+			reg = <0x0 0x0010f000 0x0 0x100>;
+			no-map;
 		};
 	};
 
-- 
2.39.5



