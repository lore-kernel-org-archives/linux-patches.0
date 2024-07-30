Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B711C68A7;
	Tue, 30 Jul 2024 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355239; cv=none; b=jRrASulBah6kR2KXCzLcSKZCe4u/XhI2y20jVuReAphHhiNYJrURGtkt9UpfKebcC5f8MGBTnVrWVRNVSFgY63WEeFFbrALvPpbFbti+T52TjzVLeve5BR4TWstRuVGjombC0vbcVXv0n0JRtFSfsXTamWzrx9L8wenFvoDc6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355239; c=relaxed/simple;
	bh=jACGj7FsjjvnavEzz5y2X7HcGmYSfATm655GKP+Vf6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSQdFwQ5G+mYwuR4rPsxTnSHYp+QR03akKqkftP65lanOJkvdYQIx0QomIYHy9tqSoTccN184BcVI6RmqCGWAN4fXpwdMk2ympssW8DaRct8a/qN/8YFFXNa9P+4O9Hvt/h9TRC8nxtY6bV/Dav+ZOc7fBdTCJcSyyERt+ooqMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1AL3W3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1AL3W3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D223C4AF0C;
	Tue, 30 Jul 2024 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355238;
	bh=jACGj7FsjjvnavEzz5y2X7HcGmYSfATm655GKP+Vf6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1AL3W3E4sRGJ/xOaTvujtNl2FaEZgW/yhjb+yLOJwGuHpxBzxUHkq0oqisZJJgbR
	 zHTAVUKeRAjYNjyPR5kG57rfoYZi2cBiL7di2no3zx93UeKKXqZ/b3knCq1dN3HyO3
	 sXhKv/MKdYUd+wwcKmZTVZ13YahNCfm8odm9o3Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/440] arm64: dts: renesas: r9a07g044: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:45:03 +0200
Message-ID: <20240730151618.499568972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ecbc5206a1a0532258144a4703cccf4e70f3fe6c ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: 68a45525297b2e9a ("arm64: dts: renesas: Add initial DTSI for RZ/G2{L,LC} SoC's")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/21f556eb7e903d5b9f4c96188fd4b6ae0db71856.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
index 4a74906061dd8..4703fbc9a8e0a 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -1094,6 +1094,9 @@ timer {
 		interrupts-extended = <&gic GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>,
+				      <&gic GIC_PPI 12 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "sec-phys", "phys", "virt", "hyp-phys",
+				  "hyp-virt";
 	};
 };
-- 
2.43.0



