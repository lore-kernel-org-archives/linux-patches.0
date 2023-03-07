Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98BEBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDCAC433EF;
	Tue,  7 Mar 2023 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212216;
	bh=r/rVsISyE3bvhuY8PUUV6pO28kZM/uuRg+sbzeVUbSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0+LCEDEtXbkUtdMEkgvxLAjMRbYNQevzwvXDpLnILGhN5rpDsRo8y8p4wH1fNxx2
	 PUx52fjfComgHnr6+GXmbX40OOSRa7MY3VFJgF6z+EyimooUDzldI6GVEE9unpvd6Q
	 55dNx8J30cOxtyIz1NhJ3uUaNPU/8im0IVByH3QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Delaunay <patrick.delaunay@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/885] ARM: dts: stm32: Update part number NVMEM description on stm32mp131
Date: Tue,  7 Mar 2023 17:50:18 +0100
Message-Id: <20230307170005.461145166@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrick Delaunay <patrick.delaunay@foss.st.com>

[ Upstream commit 366384e495511bea8583e44173629a3012d62db0 ]

The STM32MP13x Device Part Number (also named RPN in reference manual)
only uses the first 12 bits in OTP4, all the other bit are reserved and
they can be different of zero; they must be masked in NVMEM result, so
the number of bits must be defined in the nvmem cell description.

Fixes: 1da8779c0029 ("ARM: dts: stm32: add STM32MP13 SoCs support")
Signed-off-by: Patrick Delaunay <patrick.delaunay@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp131.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32mp131.dtsi b/arch/arm/boot/dts/stm32mp131.dtsi
index dd35a607073dd..723787f72cfd9 100644
--- a/arch/arm/boot/dts/stm32mp131.dtsi
+++ b/arch/arm/boot/dts/stm32mp131.dtsi
@@ -405,6 +405,7 @@ bsec: efuse@5c005000 {
 
 			part_number_otp: part_number_otp@4 {
 				reg = <0x4 0x2>;
+				bits = <0 12>;
 			};
 			ts_cal1: calib@5c {
 				reg = <0x5c 0x2>;
-- 
2.39.2



