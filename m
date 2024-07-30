Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2331BBBE5;
	Tue, 30 Jul 2024 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355157; cv=none; b=ct8vfu5w/PjQ5UKt/6E/ZU582ts1teKeVMcDs8hpAcHQ2b6QhrwcOdljNM1+XSkAcMLPr/nFHeO9iQTAjulBF+OZfNP4pNtbEPjc1HwgZpWH5lObjM6HlY+96RTETBj8hTLRWUGarJSk+4geb2ikd9GWs5/oqjlq7t+42crxK0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355157; c=relaxed/simple;
	bh=+l1qB5LZ56181m4lfgWIJvGvC9ri9XAC1muRsr/ZeBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+GoVaQ5p2BAsH6ORGGb5YJTg838zlZt+3lsSdJa4nkfyTi6wM0Els66MyEhfIahgOaAfZPZ8gf7uQadO7Wcmh+NJbzsmDutvL8iPLBgK1G+IMxVgIDAZ2E6PS69XFWnTQQgVhET6vJJaKY6TlLUhBD26TX9lm08218it1IaGns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oL7NlgAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oL7NlgAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FFFC32782;
	Tue, 30 Jul 2024 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355156;
	bh=+l1qB5LZ56181m4lfgWIJvGvC9ri9XAC1muRsr/ZeBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oL7NlgAGpCifg/7gQIpizROVyCqkx2p+5wRlbtIdq29WhFRuXSvvIpi1FC4xepA2C
	 CkqJ8ulICpp2+L5Ika+tsMEIGiEqZsG2SM/Rfa/U2OVIH8i1t7yuZPuRyL3dYR3Fek
	 WTCGBK64mmh2h5z5Oa+H4o7uX1hWCkCsfIgdmWtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/440] arm64: dts: renesas: r8a779g0: Add L3 cache controller
Date: Tue, 30 Jul 2024 17:44:56 +0200
Message-ID: <20240730151618.225964140@linuxfoundation.org>
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

[ Upstream commit f08407210db921a4c9eaeaa92d0c434858b9c6c4 ]

Describe the cache configuration for the first Cortex-A76 CPU core on
the Renesas R-Car V4H (R8A779G0) SoC.

Extracted from a larger patch in the BSP by Takeshi Kihara.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/dfd743b32198295afb78bc0ac337ef283fa3879a.1668429870.git.geert+renesas@glider.be
Stable-dep-of: 6fca24a07e1d ("arm64: dts: renesas: r8a779a0: Add missing hypervisor virtual timer IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
index 868d1a3cbdf61..9f6a30cf315f2 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
@@ -23,6 +23,14 @@ a76_0: cpu@0 {
 			reg = <0>;
 			device_type = "cpu";
 			power-domains = <&sysc R8A779G0_PD_A1E0D0C0>;
+			next-level-cache = <&L3_CA76_0>;
+		};
+
+		L3_CA76_0: cache-controller-0 {
+			compatible = "cache";
+			power-domains = <&sysc R8A779G0_PD_A2E0D0>;
+			cache-unified;
+			cache-level = <3>;
 		};
 	};
 
-- 
2.43.0



