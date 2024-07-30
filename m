Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953501A6190;
	Tue, 30 Jul 2024 16:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356311; cv=none; b=pZz9mQOCLM4v0A7gehQy3ObKZy33K/g+FP50G42gm7atHpGJfG7QCYenJGBsNhfvFjmrg5r6GkRTO01zS59xAwrYPTtm/U58kYT/rRqxtemxgisXjXyooqj8Sbj+QK2Yvc248+GROvuYEX5ZrCErH0XwvN0jgHjMPLJK/1LdaMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356311; c=relaxed/simple;
	bh=+vF8Mv5HvWQnI6gADP0lI1JOnguAmK0s/tNYZV4PSao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUdSDu2QvuNskbiLLri8D1+8z7HpBmvFbUz/5+YAuot+lBbTqRIUzuj7nNOgtFLrfPfZhPXRDHXjILEu6n/BLJ8YFZorsOnXtxVLue/gCTIcmMcO+2kSjDAx2/VrQ7hc3UkBhz0sOlcOteFRxje8jQEs7+1xLuRb3MakOlEldhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HyY6E7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HyY6E7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AE4C4AF10;
	Tue, 30 Jul 2024 16:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356311;
	bh=+vF8Mv5HvWQnI6gADP0lI1JOnguAmK0s/tNYZV4PSao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HyY6E7x0evVw32ecQey+5FbzGhvFHA7Ej79wM8t/0SSx1XanJDg8NOgMpZSAXfuY
	 08zIwCjsfBZ1ExZzLXCTyM64a7mgiHPZ60bv8smhkvixtUMAWoTBsRV5/BJUiQqXb0
	 bzd9nDOofCTBXKcPEzpXzPAoiCyjvu65Ge2ZprzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 120/809] arm64: dts: renesas: r9a07g043u: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:39:56 +0200
Message-ID: <20240730151729.357312660@linuxfoundation.org>
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
index 165bfcfef3bcc..18ef297db9336 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g043u.dtsi
@@ -50,7 +50,10 @@ timer {
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



