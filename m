Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3214C18800F;
	Tue, 30 Jul 2024 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355680; cv=none; b=F4RX/kvGlo0pCwJlokKmeew8kSHkc87X9dQIe4MEnOxIOEM4IKXv2OeoIl0jk2AGPRk2C5I+1NmZ2Go9TxU0xvkq62ejfAyBolf3BYwIFPb0/3JWOMtoH3ViZNxbcCvHyO9Oc1HmHeofPcZYd4wmkf8cUFyfgyByCXaPfTrRQk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355680; c=relaxed/simple;
	bh=RoU9LU1keF9Hx4LtzQLJuwySzc1hSjoVeZeSRxQmmxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfsLsntFhJ1kznt6B3LIBvw3otjUXP0mvR+DzRWHPWHJ0LLUbI6rpcwt9EK6B84ghbBE/JOZSwCXrWO5CxLY1YC23iCA4Bj7klQzunKMXtAMvhfyL0+mDoC8gaZvERM8V14mpoxYU1+2AxTAGOzJPzsLNeXX8Ihp8nzvUAG4DGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqsAvuzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqsAvuzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAA8C32782;
	Tue, 30 Jul 2024 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355679;
	bh=RoU9LU1keF9Hx4LtzQLJuwySzc1hSjoVeZeSRxQmmxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqsAvuzum5TlHqpd7+CSLvlj7Ga7wdJJtCLI+CFdbs+4Oxn+D8WirwPPaqe7YLwWI
	 cVgvmEydOGBrWHxg1kZRilKgny5L2cboHU64DseR53wyAIKHOonNkX7KPaozTMBh+D
	 whkNQZBw0DXBELbp9KuhTBhX+c+41N/aJ0LajI+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 079/809] arm64: dts: ti: k3-j722s: Fix main domain GPIO count
Date: Tue, 30 Jul 2024 17:39:15 +0200
Message-ID: <20240730151727.760973584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaishnav Achath <vaishnav.a@ti.com>

[ Upstream commit 2cdf63e73415ce6c8f6b3397cdc91d5f928855f9 ]

J722S does not pin out all of the GPIO same as AM62P and have
more number of GPIO on the main_gpio1 instance. Fix the GPIO
count on both instances by overriding the ti,ngpio property.

Fixes: ea55b9335ad8 ("arm64: dts: ti: Introduce J722S family of SoCs")

More details at J722S/AM67 Datasheet (Section 5.3.11, GPIO):
	https://www.ti.com/lit/ds/symlink/am67.pdf

Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Link: https://lore.kernel.org/r/20240507103332.167928-1-vaishnav.a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s.dtsi b/arch/arm64/boot/dts/ti/k3-j722s.dtsi
index c75744edb1433..9132b0232b0ba 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j722s.dtsi
@@ -83,6 +83,14 @@ &inta_main_dmss {
 	ti,interrupt-ranges = <7 71 21>;
 };
 
+&main_gpio0 {
+	ti,ngpio = <87>;
+};
+
+&main_gpio1 {
+	ti,ngpio = <73>;
+};
+
 &oc_sram {
 	reg = <0x00 0x70000000 0x00 0x40000>;
 	ranges = <0x00 0x00 0x70000000 0x40000>;
-- 
2.43.0



