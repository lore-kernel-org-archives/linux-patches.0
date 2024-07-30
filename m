Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6D918801B;
	Tue, 30 Jul 2024 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355755; cv=none; b=KTtpAWvjOWoIQtcfg74knC2y5KO4a3+cZZEecAAwOQF2JKcG5BS1FUH1mB4fLdWSS4mFLFU9HX5Y14A3P2Fnhni8ica9vAEmpJYZ/+kqCwz8RL1eMYyAAhN5kXzV2K25S8s6tv0IDK72pcFBVj4PLW8tJAvFB7nAagklpJYlaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355755; c=relaxed/simple;
	bh=WLRMG9Bnddhdmuc+CrJKvmbukXEySg0f+aaf1AIt2hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUX8KXZBvaDz3OgKHvrNbK+Zfi9HWiPdvqmzfgMVMP4dWwrvvOCCtuZz3GA9V5BjC9fhYfHzSesH3YZgliGeYeNhSG0kpjAvCeF5rM6pu2mpG2gRl+4cywnbfWpxtbo1srIWr/HcM661oBJmAvmzF+qxBrRXwj3yYQSwdf+ZlQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnQFgLJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnQFgLJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01955C32782;
	Tue, 30 Jul 2024 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355755;
	bh=WLRMG9Bnddhdmuc+CrJKvmbukXEySg0f+aaf1AIt2hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnQFgLJBPBLYlWZpakeiGZabz1oVctU2n4j0kK7Z9yeSbQpGTzycdaz0VLzLLqCyy
	 fK5ACVNpPIsNuo0BQKeHv7PLaycleF0LIzv0f5lbAOFFGK0Q4nDfJr3cw5zvBYtR7n
	 iNj76Ot7V7IQEhg0joUWLEFU75sU3fNAqCAwjobU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/568] arm64: dts: renesas: r9a07g044: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:43:14 +0200
Message-ID: <20240730151643.265440165@linuxfoundation.org>
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
index 081d8f49db879..a877738c30484 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -1288,6 +1288,9 @@ timer {
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



