Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5399135A3A0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300971; cv=none; b=nneXyEV5xt2lTTmNKKtH65fec2MbOgMV1O26VkWYqRXlDwfcIpVLNWPqjnKHjpu/Jx4NN/fwiYGIriSvKJpBM2GI4bXdwUmOIQEAkqe/HpP8/+U4lhmVTahF3M98EKY5pwRxuhivZRssv3Ixzy/o0LbGAmtw0hYBDaBUT+K2FIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300971; c=relaxed/simple;
	bh=npRQ0tXYpgs62t84J3RGWsOTLTpkojqnwhv4hiqG08s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQKiVz1pC3J9ekk7L/OOX9ImMCq52I5QEMRhwZpsdUiXADYd1HB/vLPdkwRslGbiKuKbm/qr0i3PAVU5eLp0Mn8pUYF2DYwGJw+/vMC2blrJ+WPVxoeCvAmDlhOXBOOmKe4WdTvvWcS1O/DonLy9t2hER/2PQyncAc4CNC76Ku4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pi8m8WuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pi8m8WuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8296C19423;
	Sat, 28 Feb 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300971;
	bh=npRQ0tXYpgs62t84J3RGWsOTLTpkojqnwhv4hiqG08s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi8m8WuHk9N0KGXx5vqpCUhw5Xbw7BTqJnJ7PIFREqSWyaH7FV3MS/GBn8YDFHE1n
	 7RN4ZlUT1uy2PEkzEPwyGVx+wcMMu+fnzkd5vG03Qo+FIQsn/9SJZ/G2qp6k8eBoG+
	 T0Y5Cmv7rgZMCVqWiaNSP1muW8NtP0xj3GrmoCoUtWrpP7GoqM/PG7IOSlg3KO1FSF
	 ec3CvAAsYEzA45bwuixjHKIYGNq4VLxREHBf44dLA0SJSZNCtJ7rB7Hy4HUFaU6qRi
	 7mv5KMWX+50J2MJGYORiXS/buedzEOdBzZlAFgMAqQjoWbUMkoqiB01DiCwzuP9k5J
	 1b1ZXyAFhiNFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tomas Melin <tomas.melin@vaisala.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/752] Revert "arm64: zynqmp: Add an OP-TEE node to the device tree"
Date: Sat, 28 Feb 2026 12:36:49 -0500
Message-ID: <20260228174750.1542406-98-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tomas Melin <tomas.melin@vaisala.com>

[ Upstream commit c197179990124f991fca220d97fac56779a02c6d ]

This reverts commit 06d22ed6b6635b17551f386b50bb5aaff9b75fbe.

OP-TEE logic in U-Boot automatically injects a reserved-memory
node along with optee firmware node to kernel device tree.
The injection logic is dependent on that there is no manually
defined optee node. Having the node in zynqmp.dtsi effectively
breaks OP-TEE's insertion of the reserved-memory node, causing
memory access violations during runtime.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20251125-revert-zynqmp-optee-v1-1-d2ce4c0fcaf6@vaisala.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 938b014ca9231..b55c6b2e8e0e1 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -192,11 +192,6 @@ psci {
 	};
 
 	firmware {
-		optee: optee  {
-			compatible = "linaro,optee-tz";
-			method = "smc";
-		};
-
 		zynqmp_firmware: zynqmp-firmware {
 			compatible = "xlnx,zynqmp-firmware";
 			#power-domain-cells = <1>;
-- 
2.51.0

