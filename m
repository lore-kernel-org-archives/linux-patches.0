Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447AD156F30;
	Tue, 30 Jul 2024 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355202; cv=none; b=ath02jgMzE+uIkedJUezqtePOsOkd3pbRfmCp62A1pzcgqQERlmv5vu3Iun4YpG/vzbZWu/trmpDzsy6Kt8xF/xvllE+1OaV1X+ca2DoiUdg+471I13JieUBpXNHyc+XJCjsnyU9lVl33F3s6fNVsoJ9r4VT6POg6WGWQ7OHvpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355202; c=relaxed/simple;
	bh=KgzSUmFHCOzbRSdtApdei1r0QUWbogZZDakd2KiHyLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx3zb5cw+HAa1/6YbzF4dsxhWxcu9hrVKGVMCDjgDI4YaJR40iXl3+ovVdemRELTaAuJ1bWJaS214K4TGMKLprt0q870KUONoV+8yQeuWJd1CQb36VURLqNGa4ZRaUdVE8ik2GYycvWnShjxcOIkCwjGcLrL98MjdlMcbCQMXxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjM+7CiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjM+7CiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668FBC32782;
	Tue, 30 Jul 2024 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355201;
	bh=KgzSUmFHCOzbRSdtApdei1r0QUWbogZZDakd2KiHyLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjM+7CiKJguZTsSn4v1rhKD8M7Av5slOg3CP0CzQW3iio+5DjyD+YNUqE3wsfScLj
	 P/vOMC9SZlBNfL7ENvsRtWUKJ8fzBLDzVukrJGZnWz9sW/CPRMePv5EkNrU1h+ixHF
	 W0JWb79IoWNdamjbFWIgkiT2GX1S0i/MRm4VeBsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/440] arm64: dts: renesas: r8a779f0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:45:00 +0200
Message-ID: <20240730151618.380263969@linuxfoundation.org>
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

[ Upstream commit b1c34567aebe300f9a0f70320eaeef0b3d56ffc7 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: c62331e8222f8f21 ("arm64: dts: renesas: Add Renesas R8A779F0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/46deba1008f73e4b6864f937642d17f9d4ae7205.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
index ba94e4d31cc8d..140c4672ff5b0 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -993,7 +993,10 @@ timer {
 		interrupts-extended = <&gic GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>,
+				      <&gic GIC_PPI 12 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "sec-phys", "phys", "virt", "hyp-phys",
+				  "hyp-virt";
 	};
 
 	ufs30_clk: ufs30-clk {
-- 
2.43.0



