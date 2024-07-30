Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086BB188006;
	Tue, 30 Jul 2024 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355442; cv=none; b=J4d8EybG4Oo1zyjDkO9lig25dt/IjZS50cDsOAX6pZVdVme32eIvoFr7z7Q1x3ubOK35PeNAsSrtQc11y0ZJwPz8IZuKFxtEUrzyIOP4hOGrtdJFtp4QwR4WkKcr3KDJXbMiwYEbX7vty1ihylnIVjGKIe7iSqByGw9vLPkkZNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355442; c=relaxed/simple;
	bh=OXj9XmOEUHjam04WHPEFIVywM70TsfQ6IQYwYkc4rOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skaQMCbwWm9m3ORegZVGe+T3jSLqOkmuGR2Z0Eyc4GtfQuE7hcH5b0Pup6ThwFdV+JxjAIgdb1L5sHrLShPQTo8f4ysPhqUq+vJTSmpLOzumXWzT/VVD2NKenNk4wug+47cwnS7ra4rIaOt6ETDfIAbe9Nnf/wcEeq3DtoPEcCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gghLdWIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gghLdWIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7015DC32782;
	Tue, 30 Jul 2024 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355441;
	bh=OXj9XmOEUHjam04WHPEFIVywM70TsfQ6IQYwYkc4rOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gghLdWIkXSL4A0tCNkkoQKM7dx0KKIRtEAz5+Eh3QpJAVdyKAIiYJvYYX+IK3S8Lu
	 cKZDnJs0SQErtYnFC7UoBCmib/Xdc6QcSFzcKlRbslJDO4YPcPNlC6eQFeCNkZfCnB
	 rqmbCOYSzdaRon7Eze5Q+u0FNwC1lSUYWS/IWnUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/440] arm64: dts: renesas: r9a07g043u: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:45:02 +0200
Message-ID: <20240730151618.460023600@linuxfoundation.org>
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

[ Upstream commit 4036bae6dfd782d414040e7d714abc525b2e8792 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: cf40c9689e5109bf ("arm64: dts: renesas: Add initial DTSI for RZ/G2UL SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/15cc7a7522b1658327a2bd0c4990d0131bbcb4d7.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g043u.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
index beab2bfd253b8..2e7db48462e1f 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
@@ -44,7 +44,10 @@ timer {
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



