Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEF61A6164;
	Tue, 30 Jul 2024 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356121; cv=none; b=aSL0qIkX9ACz1DHNB+8gntEz7MXi7fZaImyy2yPnXlxNqTmcTROzvsxJE7HVMuoXdrEi9wtXwj6heW3rXV41uS7GDqWMBtlWOQzzCAJJngyI98AoeehJr/dQZPTAR/NMJXRNg+rIVY9hxMQOmdk+wqdWgOTnFygNnnOfWmC7w8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356121; c=relaxed/simple;
	bh=C8U6BeeZMz1wQLIZM7gizI5p6kHLkBIo485F6PCxSMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcILWxbErI2RPSYrqsWRGq4xv/ZO4Baq4X5sMBe8qjN2kjdjXPoSB9W1U0dse9aJErNH9FwP5XFSQ1pft0cWFfO/8EGMYyBkTzDPFsCIJS41RIYJyFhVpR7mpemkZVEBH9Xnn9Mi+ydu+dGWQVEhK+jWU5rBuQ/vIWo8d2PX7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxVLAL6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxVLAL6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6937C32782;
	Tue, 30 Jul 2024 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356121;
	bh=C8U6BeeZMz1wQLIZM7gizI5p6kHLkBIo485F6PCxSMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxVLAL6Qys8N9JDcqw+be4L4U8rCI0RXyVraKnQSkc5XaJ0LQqWhQtsPHWSrm8Bay
	 ZbPwWE3j9D0S3xaWdHkCArSTFOWjBsOmolA4J4zJ0ljlYWXlgRg/xwQ5ypdUTt9FyF
	 pJOturDTkG/0H2qrQfDgj1o7LbEi3GK6fNOufLVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 121/809] arm64: dts: renesas: r9a07g044: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:39:57 +0200
Message-ID: <20240730151729.397170545@linuxfoundation.org>
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
index 88634ae432872..1a9891ba6c02c 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -1334,6 +1334,9 @@ timer {
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



