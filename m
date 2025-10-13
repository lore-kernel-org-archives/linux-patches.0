Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB012367B5;
	Mon, 13 Oct 2025 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367479; cv=none; b=iODaDaCH4XKa4mGkOB92UX4yYb+SwoY0LDMUmTb2tK8tfbuQV+jdUCzzu3VrnM7CR+nf9OI1CSjDZh6d+RLnS6o9ym83Tep7AbxQDvWWupJwPpJ6Ot78VrtJdizpP89XnkqRjoMyQtIzod/Jcc+2zSPW3PnSXA+bFAnRtfATTXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367479; c=relaxed/simple;
	bh=MDKcgoSxMKJMXpLag1LrLI5K6+EDyjSNEQ1ir+EW2bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbf06I3pSQSYK8tQncrIp5MgFnw7ngIqVXt+C3N7+t5Q6oBj4xAK1optpuoPfIJ0IxdzY9c4kEjAuFfTRVsPuj5mHPsf1W/aoBpyQx8NmNQSO4AwG1YYpp/YoEPgl1+Qcx7KWCO7JuixfAjttId3MQ/OwYIYOqUlPLcdc5i5cuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iNKA5So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iNKA5So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E804C19424;
	Mon, 13 Oct 2025 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367479;
	bh=MDKcgoSxMKJMXpLag1LrLI5K6+EDyjSNEQ1ir+EW2bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iNKA5SoePSs/t59oa+nZXDtxDh+WQiMKYpRZn88pCNZp6sN41srkpP4raR8Kerg7
	 xDxpbiAdWJ24f9K09B6AGOsjCCYYXeHrVysF7B1aNpoIMK9YkHB2J7+UPKIHhNvAiz
	 boKM5Czmdzni14uSSeF4xLOoeV0RM0RqWD9smHcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/196] arm64: dts: apple: t8103-j457: Fix PCIe ethernet iommu-map
Date: Mon, 13 Oct 2025 16:43:37 +0200
Message-ID: <20251013144316.142028659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit 6e08cdd604edcec2c277af17c7d36caf827057ff ]

PCIe `port01` of t8103-j457 (iMac, M1, 2 USB-C ports, 2021) is unused
and disabled. Linux' PCI subsystem assigns the ethernet nic from
`port02` to bus 02. This results into assigning `pcie0_dart_1` from the
disabled port as iommu. The `pcie0_dart_1` instance is disabled and
probably fused off (it is on the M2 Pro Mac mini which has a disabled
PCIe port as well).
Without iommu the ethernet nic is not expected work.
Adjusts the "bus-range" and the PCIe devices "reg" property to PCI
subsystem's bus number.

Fixes: 7c77ab91b33d ("arm64: dts: apple: Add missing M1 (t8103) devices")
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20250823-apple-dt-sync-6-17-v2-1-6dc0daeb4786@jannau.net
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8103-j457.dts | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/apple/t8103-j457.dts b/arch/arm64/boot/dts/apple/t8103-j457.dts
index 152f95fd49a21..7089ccf3ce556 100644
--- a/arch/arm64/boot/dts/apple/t8103-j457.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j457.dts
@@ -21,6 +21,14 @@ aliases {
 	};
 };
 
+/*
+ * Adjust pcie0's iommu-map to account for the disabled port01.
+ */
+&pcie0 {
+	iommu-map = <0x100 &pcie0_dart_0 1 1>,
+			<0x200 &pcie0_dart_2 1 1>;
+};
+
 &bluetooth0 {
 	brcm,board-type = "apple,santorini";
 };
@@ -36,10 +44,10 @@ &wifi0 {
  */
 
 &port02 {
-	bus-range = <3 3>;
+	bus-range = <2 2>;
 	status = "okay";
 	ethernet0: ethernet@0,0 {
-		reg = <0x30000 0x0 0x0 0x0 0x0>;
+		reg = <0x20000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
 		local-mac-address = [00 10 18 00 00 00];
 	};
-- 
2.51.0



