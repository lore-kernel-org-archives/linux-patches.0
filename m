Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73835201252;
	Tue, 30 Jul 2024 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355274; cv=none; b=AuLP4+YOwEF61KtWoFKgBh8pFZbM2lfLXlkT2czmIbdEJS70/x29AKsu3rP3dEpR6Yv9zIU4bxGkqIHwrVsGS3ALkrZDc3JoMYQjRyZWiV1+LiT5PbarvVbc2XwyZYTPlN7it4GP+yUiUZ124oJVmM0j/905sljzUGT0DuPs42U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355274; c=relaxed/simple;
	bh=SevQD5Ci2B1NeXTUFBZBWrQVx1TSnT018elmfh6+4VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wexnesm3Vy7NM6UUJDHmLCUYgqYi/PB7NvsJxu4X3fR3duM11mwBm5p6MDp6NQm7sB50wbFlOS9qjRc+dn5Hdyq82U7rpQebX3kncmV7HMi9M9ooxv1pziZp1wI5V6ibY+YNsdHIiAhoF3OZc4NK1X2o7CYOQ5Lx8ToXNlKHvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PI09oAax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PI09oAax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9723AC4AF0C;
	Tue, 30 Jul 2024 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355274;
	bh=SevQD5Ci2B1NeXTUFBZBWrQVx1TSnT018elmfh6+4VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI09oAaxxjepqCP1juzE3dOh2gMSYhYmANisyBA1DGpTX42FqYeXR4Kp6Qxbev7Yd
	 oKym5gcxWFFGjVfP4oY3tPuUebpuOcnUAQciOlpZDvgNZoWKl8s5HuabNV4RGDbnfB
	 l2Qp3MuzHJx21mj2OUIMk1CJKXOyy9Il6S5aQqW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/440] arm64: dts: renesas: r9a07g054: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:45:04 +0200
Message-ID: <20240730151618.538732275@linuxfoundation.org>
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

[ Upstream commit 2918674704aad620215c41979a331021fe3f1ec4 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: 7c2b8198f4f321df ("arm64: dts: renesas: Add initial DTSI for RZ/V2L SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/834244e77e5f407ee6fab1ab5c10c98a8a933085.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
index 0e319cc2460c5..60a20a3ca12e3 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
@@ -1100,6 +1100,9 @@ timer {
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



