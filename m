Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5FB1C0DFD;
	Mon, 14 Oct 2024 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917586; cv=none; b=dcWF+VLtV98zyBOXD7gqCmxGr4vQPHsNQjN+nqftaZZ0pWFmyBc0/4SRdYMg/j4WmZaHvqOeBo+mcnjzos8jR6AXLwDyDKhPnsjdRkqQM5RFHx+fFyeDPSCE/g4u/ohIUvDBcEPv1pqJ8NKdy1KR5B+jN3/gf1mGp0/+Wh5HuSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917586; c=relaxed/simple;
	bh=kppagHi9kquASq/wq4jkIrgpMbLY4VhtQymK0uIgVmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9QKHyFq40n5B67Clbec67IOwMCsxNq0gPRDQI4LREFOvu7aWMi9n5xzYRDRY/ZyHkFe+lk+XE4NRqh0r/Ue21jVJs+DcfRishtCFHVhXqng9lh7l8D4rP+v0FcnwOZeMKcr6KGG/JMjugmLJxPPLSPbv5pOCWuteXaRTaFRTxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpwNtrhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpwNtrhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCACC4CEC3;
	Mon, 14 Oct 2024 14:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917586;
	bh=kppagHi9kquASq/wq4jkIrgpMbLY4VhtQymK0uIgVmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpwNtrhYoQzl3WVtaa3e+PvgYA1NJf6MuYFywN6tQOVVKMNeILCSd1icS1GuugWjW
	 3ZRhJyczYUIVE89xjNoei6Sv+92JJeDmOBdj9SBps7PNWiJ5OKhyMBE7cHTsu+ApwW
	 aGtQrcCvolF0hfVMymT7q4938nAnIkhdDe4ckH7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/798] arm64: dts: renesas: r9a07g054: Correct GICD and GICR sizes
Date: Mon, 14 Oct 2024 16:10:28 +0200
Message-ID: <20241014141220.845499289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 45afa9eacb59b258d2e53c7f63430ea1e8344803 ]

The RZ/V2L SoC is equipped with the GIC-600. The GICD is 64KiB + 64KiB
for the MBI alias (in total 128KiB), and the GICR is 128KiB per CPU.

Fixes: 7c2b8198f4f32 ("arm64: dts: renesas: Add initial DTSI for RZ/V2L SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
index 60a20a3ca12e3..7a50d1432cc07 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
@@ -794,8 +794,8 @@ gic: interrupt-controller@11900000 {
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x11900000 0 0x40000>,
-			      <0x0 0x11940000 0 0x60000>;
+			reg = <0x0 0x11900000 0 0x20000>,
+			      <0x0 0x11940000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 
-- 
2.43.0



