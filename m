Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADBA1FAC51;
	Tue,  3 Dec 2024 15:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240481; cv=none; b=VbMbeg54OJsgTeR9bA9lWmdjLTb+z9Nc74wY5UCleLdw+1X5iMJYkTT0rhl1Gj8TWB2aoPkejtqzXFfMORilAaZCjQwu83nv2AwLDNXaEbZ348l9tBzSpEYJqJgOIPwBPh1T5h1GBxSCfqvL4TkWmx6XK3qGPWwA/Svq5JdnGkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240481; c=relaxed/simple;
	bh=+zEm9ecQ3LMcocloYRAiqjPXg9aXvkNHtNh73OHRp9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFiUA9cSmkZa7CghSfcRN4PGEX99iAf5CG2W7XnxBsQUgDkPgGXY1OZh03qSzSQ7EJS5g/2X0LwC3rQkUaWCMfqj9K7mmzpjC+1nLPaiCZ+nhmP3Yu0hs1wOGyHBBIqGjvudsjKv5PxpXcbH3ZiAIb8G21RMt2atkG46qCPzLIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD96b+lP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD96b+lP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B19C4CECF;
	Tue,  3 Dec 2024 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240481;
	bh=+zEm9ecQ3LMcocloYRAiqjPXg9aXvkNHtNh73OHRp9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD96b+lPjKepHOCbHNe2mBRwvCZeUe6tEC+obg+PBtRa82GfeVJ9HPmqJ4l5uO6x7
	 cGYSp4Lxj1/voL41f7/nFfldcv+Q3OfPu0GnnJLM1c5SNV7SeBEMQn53b2a20eurci
	 tlJ49Y1933moeuUYAG8TE+n4hmndcgmy1TniMRIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/826] arm64: dts: ti: k3-j721e: Fix clock IDs for MCSPI instances
Date: Tue,  3 Dec 2024 15:37:56 +0100
Message-ID: <20241203144749.558411627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit ab09a68f3be04b2f9d1fc7cfc0e2225025cb9421 ]

The clock IDs for multiple MCSPI instances across wakeup domain
in J721e are incorrect when compared with documentation [1]. Fix
the clock ids to their appropriate values.

[1]https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721e/clocks.html

Fixes: 76aa309f9fa7 ("arm64: dts: ti: k3-j721e: Add MCSPI nodes")

Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Link: https://lore.kernel.org/r/20241023104532.3438851-3-a-dutta@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 3731ffb4a5c96..6f5c1401ebd6a 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -654,7 +654,7 @@ mcu_spi0: spi@40300000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 274 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 274 0>;
+		clocks = <&k3_clks 274 1>;
 		status = "disabled";
 	};
 
@@ -665,7 +665,7 @@ mcu_spi1: spi@40310000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 275 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 275 0>;
+		clocks = <&k3_clks 275 1>;
 		status = "disabled";
 	};
 
@@ -676,7 +676,7 @@ mcu_spi2: spi@40320000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 276 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 276 0>;
+		clocks = <&k3_clks 276 1>;
 		status = "disabled";
 	};
 
-- 
2.43.0



