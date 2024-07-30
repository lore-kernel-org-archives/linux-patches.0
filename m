Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43F1A6188;
	Tue, 30 Jul 2024 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356131; cv=none; b=KfrQPA2NFZz5UXuS/qrILC0+3bnWNi6i0NIvU52YzqvMv8wO7v+ABOiGO0qG/h2TlIFrI1Col+Vk6+XzVcCxILEF1TdnS8CvjY6noaA0fk4UvjRaVarSXIx5XVGsnOGQi+uSkPr0Zn1HCcL1ICzby/hoCly+P4I96mFbyvgBQ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356131; c=relaxed/simple;
	bh=gsdhbjtmuGIf9wbCibC1eXWR8uHzexmL9PI/Ci9V7ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGNnKLf2bEODoiwXgnq41PNk+3XtVwUHVAd1Dr0VGrl24OfRyJKCiKYuhn+4inwEN9fMztJAf0YyX3rtFr3vOjPmiPql82YOjYqVQzid+YQCMBVOGdPskSLHCJvnKxGWlXi+GdOyZWx+WO4vbb3zcIDKAZRzA285rB6MAkDcUlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSL0Eazo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSL0Eazo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F10C32782;
	Tue, 30 Jul 2024 16:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356131;
	bh=gsdhbjtmuGIf9wbCibC1eXWR8uHzexmL9PI/Ci9V7ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSL0EazoQyOc1vuOH/peiAY8UWKr8KF10Bg81iPGDQz7r1vsoXxFeRWZDpz1YIdIA
	 BtY1dJU6pRqa6oGtTlQCrfG/9vzEzoLa8Qx/WT7zXvJi75T+tmBj0sHU7Dc3yZk+kY
	 i17MMDAQgSi1FjtDl82VU1UFkJagu/iYU3N+bvAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 122/809] arm64: dts: renesas: r9a07g054: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:39:58 +0200
Message-ID: <20240730151729.436904668@linuxfoundation.org>
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
index e89bfe4085f5d..a2318478a66ba 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
@@ -1342,6 +1342,9 @@ timer {
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



