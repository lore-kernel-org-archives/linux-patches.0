Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDA81A4B2F;
	Tue, 30 Jul 2024 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355710; cv=none; b=YjawFUBtXTzWvY2V4hTkFTS4J7nR55tp63gM6++SjrzfTFO0HudOGxYfhNlG8LsZTzV8vCNeOiDLN6iPYrtEvTq2n1dGmEjmufdNLxAV6UXcnMCS73PSQN9Jf/1j/XZPE/bFCxIQZKArexrBmS53aPYo7L3lQaagA9WLM+Kj1bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355710; c=relaxed/simple;
	bh=F9VXQst0UnRVJ0S8MQTh/KcSZ8pmR/79NTBfMFKTJ7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojRPD0jo45+W2hqud3yuqHIoki1hP1tnQYOW/KcPUiVr49T2jnIWtIxTxZBocNBOHK5u6zgiP0UFVaT5w5SphPJWDYO106mXNML8FXumhYFzYFbH1LHN6EmLvliOPT7FffhDbAElL7DeZSB10Z77G0H2db5kJamKo/qu+8ZD06k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5Dcsbud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5Dcsbud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE57C4AF0A;
	Tue, 30 Jul 2024 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355710;
	bh=F9VXQst0UnRVJ0S8MQTh/KcSZ8pmR/79NTBfMFKTJ7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5Dcsbuda2Dmt+z73W76QCmNMfqggxkZ6lQN4Wt/AEqn26G+8tBvoFp69RmL8bBoh
	 cahjxeuU1mexBK/Ks5ZDL8SqjzRQSjiSuZHGchzD2Kt8mE9AETA4x5T4yocdn5w5bB
	 BVl6HZY4+8TGfqrlmaXWIeHw4XPqr3i9STuWBhKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/568] arm64: dts: renesas: r8a779a0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:43:10 +0200
Message-ID: <20240730151643.108097643@linuxfoundation.org>
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

[ Upstream commit 6fca24a07e1de664c3d0b280043302e0387726df ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: 834c310f541839b6 ("arm64: dts: renesas: Add Renesas R8A779A0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/671416fb31e3992101c32fe7e46147fe4cd623ae.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index 504ac8c93faf5..84e0eb48a1b8a 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -2910,6 +2910,9 @@ timer {
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



