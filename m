Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520BB1898E9;
	Tue, 30 Jul 2024 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356263; cv=none; b=WYckk/Z9YsiKI6Q/FWxwj+WWfFCJisWZ2dWvJJcTaIjGr6C2c9eF6TKUyHT1CN9SQXnm8IcUcrIy3lxyp0ofoKv9s7cmL7DM3P8vJZqaf7gV4Uvkv6vFE2xYpX5S95eZ1KE1eB0B4Xa0/fabwIMuBGf/wsM5AijdpmwglRJ823g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356263; c=relaxed/simple;
	bh=C2m3fvzqMzNwPH5dTUK4wmoFcuvoH/t+NmUsEPh9VYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndDbC5xgCFAxc67A5wK4k+8OqcycwNwqq8XyiG9lWezYIVJmP8QjH+Hsp6ORT0/wmkBt5pgT6vakrIVDuvyvHnukcMEL3XJIgk1GrjENDL1UYAZMNHbfi0avUcWEw5i9bPoR+HYxPEXnBCFZezgjflvjc1drUHUVSDS3thuZ1a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8jJKR7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8jJKR7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626BBC32782;
	Tue, 30 Jul 2024 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356262;
	bh=C2m3fvzqMzNwPH5dTUK4wmoFcuvoH/t+NmUsEPh9VYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8jJKR7p9kstyxdWE8nd30ww17wp/5EizCn5XqdDvibAKu936totWnX+ase5+xio7
	 7lppds7hfaCExTVXIiopQ1KLR3Fu/z/eSlN0EpuoKWXCEbdGuPdE4hMxRtLTQ7MRJy
	 6rBw0MOdtz8T6pCqpR+G2G36+o7i/Rv4I4XoLbY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 119/809] arm64: dts: renesas: r8a779g0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:39:55 +0200
Message-ID: <20240730151729.318711060@linuxfoundation.org>
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
index 9bc542bc61690..873588a84e15f 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
@@ -2359,6 +2359,9 @@ timer {
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



