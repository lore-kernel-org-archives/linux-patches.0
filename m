Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A94311953;
	Mon, 13 Oct 2025 15:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368174; cv=none; b=GFBv2zuQzaaoFj2MX1JWbMx9SAt7pmDa3IB2S6oexeO6tNHRVrWGcemulXLwiZVGSKw8lNRvPakiFAeHp2BLJ3GkGFa1nQDEZ5irDFIbFrty/kk7OuuXKsbLjsPvOqlxlsB+fMgHDhoYTRzI9z/RIAFZOtuMtpRzwCEHnhvD0dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368174; c=relaxed/simple;
	bh=yevQA/WqChuG1Zo0ClfRr6/DjXJuanv71k5hbKnsAMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMepKtyFRJ9iJGrP8S33ziKMSBke2fTsQgrqhykTbl88pu/gbDROQqEEyPj3QoIyiJGlAGTAsseMpZz7xmoG0nQPCbBOU6qheGzsFI4hjyxDb1FdM9gtuAhTz8duyPK7MZCTbpdG+YNDEGbIaX/WeUDYIyQEpJAn2jUhSGH0Dl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUE7Ml1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUE7Ml1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC52C4CEE7;
	Mon, 13 Oct 2025 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368173;
	bh=yevQA/WqChuG1Zo0ClfRr6/DjXJuanv71k5hbKnsAMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUE7Ml1lSUUcxsTbmzx/WwJ0QtZeZZpNdgx49wX770DSzVGsFrVNe225lBSZCSpno
	 ycgkHc6s9Hx1SscMk4FQhRygjjoesdL7KOd9T3Oq5qQvzNkADwfDaizh3WVMdwhxAI
	 sMlKb5RHgzA+rosO8przgcj0lSWmqBXiJSD0dGFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/262] arm64: dts: apple: t8103-j457: Fix PCIe ethernet iommu-map
Date: Mon, 13 Oct 2025 16:42:58 +0200
Message-ID: <20251013144327.432400092@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



