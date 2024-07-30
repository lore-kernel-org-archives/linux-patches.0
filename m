Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05E319F467;
	Tue, 30 Jul 2024 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355191; cv=none; b=qeOgpemga15vD8Ai+TtOYGEVF9JjqKpBTWvGqNYvTION7hbvHfrkn9Bu+hdF0lU33m+asDAM48xgIvGslUz3oJCOCcMeN/Kpn3QY14nDDdN0E+iMjA1LUnrtBfYypXoBDe9WMgu70C9wBKyE7AwGPGurtxzzIGWuyOJ0YXLDDpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355191; c=relaxed/simple;
	bh=ziNMF+rCNCW1Oc1xJibcaZxTIuBrQVp28szqirFBkPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqvJ2vO9fgaq8SoiHUfxRGTTW1bKXQvA3Jk+zypR+N6fjtX6TKcGAtCqGRrQMQ9zT3z8VwTor9Kknnx/G1KYDxBOvlFl0vPfGPSBRyWCYiEsi2hMHrNxutXxmUmIYGL0DrsS8fVQHBPsvhUszjiI2cH98CU3FwROrKo8e5qS8Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztyTVuEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztyTVuEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141DBC4AF0A;
	Tue, 30 Jul 2024 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355191;
	bh=ziNMF+rCNCW1Oc1xJibcaZxTIuBrQVp28szqirFBkPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztyTVuENUAj2rGPCLZBu1P7ZtCz1tOg/lxhbf63K8WiAnSKdHzEzDjEpWKHdoHZEP
	 IUS72t1O+o/VbN99Q5HUe1rOnXey5L1sfkansIUOSGgXjuH2fblLApuWcbZIEFGfy3
	 WNutfzQEIrIPN+ZHzIs1egzZbxPXxYAeZbtF6PpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/440] arm64: dts: renesas: r8a779a0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:44:59 +0200
Message-ID: <20240730151618.342060170@linuxfoundation.org>
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
index fa76827c81c93..158c99b1a7b79 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -2859,6 +2859,9 @@ timer {
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



