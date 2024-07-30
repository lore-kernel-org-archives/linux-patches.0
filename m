Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2CD1A3020;
	Tue, 30 Jul 2024 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355720; cv=none; b=gtpCRiflDztC5fAwkKy0f6whRWmChSBjkfnJ66JOtlt7VAQc5vM9HwIWa1RZB7vbV5uOtqr2X/AVdXg1Sy8xcshD60uaPOVkXoOWGgpJNIJAANAsG51CgN5ULOkMe8fbWhduZmks6V7HLXWGLsKYWjVBzMsV5k0YN+JelH7Q7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355720; c=relaxed/simple;
	bh=uvObUKRLVFk6TYmqSxnFk1qzbdcKvgL9TwH02JDuaHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Axa5CR8Cpenqn7elvg4zLRtJp5vghFx2ssr0IgevsSz1P45C2uVLE4J1afsB3c6LdbEy1iE0KrBs73QjuAEXPpYjs0sgNW6I6gCSq5W/hhcDR7hMFYmYD7x5Z6w+4Xvgk9AEEXj7eio1baB+f+q3FnSksIxF7CZwpF7Lb3no8TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayNYMU7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayNYMU7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B77C32782;
	Tue, 30 Jul 2024 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355720;
	bh=uvObUKRLVFk6TYmqSxnFk1qzbdcKvgL9TwH02JDuaHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayNYMU7rDLshM44eW//fhIPkeOT01fYW3GNZCLa9O+7i3T1n3C5bVOI7EwWsj2G7K
	 uRkx+B9ZVwjd7IEBNEQXYLjcQz14SCoWtKbz1wd8v6FdLT2GTfgWoAjDRwBnrlg2Z/
	 7tadyRRAfdsW/qcy9joZSwvlQetFWcIIq4T8bG5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/568] arm64: dts: renesas: r8a779f0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:43:11 +0200
Message-ID: <20240730151643.148523387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b1c34567aebe300f9a0f70320eaeef0b3d56ffc7 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: c62331e8222f8f21 ("arm64: dts: renesas: Add Renesas R8A779F0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/46deba1008f73e4b6864f937642d17f9d4ae7205.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
index ecdd5a523fa34..555fff9364e35 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -1181,7 +1181,10 @@ timer {
 		interrupts-extended = <&gic GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>,
+				      <&gic GIC_PPI 12 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "sec-phys", "phys", "virt", "hyp-phys",
+				  "hyp-virt";
 	};
 
 	ufs30_clk: ufs30-clk {
-- 
2.43.0



