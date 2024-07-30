Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44F91A4B4C;
	Tue, 30 Jul 2024 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355734; cv=none; b=r2clnwUiGoKpQhuxCaPCU6qfjkxzW5+xuxG84Qod/x8ZYUe/04WZ8dmhxhmjSdSl6EcUO4FA2L2OJZ/0qHgfEaEOgdTkKPvCdd+Xn7D4Yhg7VnOWZupYTusT6FUZLJWtHuvsy16l8kl+vcdC5u45pSl4dYgZGZQoS3JiU+ZPsnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355734; c=relaxed/simple;
	bh=Nqof0UeOP5o6Wl+/224jxXViTVxWbSXxk5J7Nt8/ueU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zah0QkCKrUInAHx5DjlYA8jMtzAtvpDlrOaVbaAfHUYDvTfDxP5mMX7lYWmB6LYMsI9vJA2EtOl7cl2tbALDWpMR9245eqSd4/hqF+8VkXAWDA28TLiU6UsJ3zokBamCOWwFiRM5M6bkqWOY1NRiXRLdPpzR7Kj+NicvuCwpznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR+3DLjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR+3DLjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32407C32782;
	Tue, 30 Jul 2024 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355734;
	bh=Nqof0UeOP5o6Wl+/224jxXViTVxWbSXxk5J7Nt8/ueU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gR+3DLjKverxxsnKKmZoBSmMsk28zifj+wCMOSg8H0/yo/3IxrfbDF+tOKQhJpUxe
	 UJyiWB6sukhKqHnoW1MBfiNNkq+fIwtZ9xJ6jp1IUdZl+bQ53JwsO5aPBj6KJ4FWEg
	 erwYfaxkFfhevRqSkXYKRdOCKiNWX4v2xq0TIekM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/568] arm64: dts: renesas: r8a779g0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:43:12 +0200
Message-ID: <20240730151643.189044182@linuxfoundation.org>
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

[ Upstream commit 6775165fc95052a03acc91e25bc20fcf286910a7 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: 987da486d84a5643 ("arm64: dts: renesas: Add Renesas R8A779G0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/5eeabbeaea1c5fd518a608f2e8013d260b00fd7e.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
index d7677595204dc..87fbc53316906 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
@@ -2350,6 +2350,9 @@ timer {
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



