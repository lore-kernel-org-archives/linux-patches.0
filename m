Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9D4274B58;
	Mon, 13 Apr 2026 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096684; cv=none; b=Yhck+Dr6Qs08HhbeOMo+g24Ar0hXR1bPKpWIIDkA73fHOC1PIbvT4B6VRw1h8/neabqhA9xtD6YWtDr+LjBFSE2FfLNB8YIDs3s4cn82DCgtPCIHWLhck+Qfnx5ZoasDzIrVxwnIVlbeWWUbOM8spK12zHBlN5yQRoAJMHNSRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096684; c=relaxed/simple;
	bh=AUcFfsjoIC0pAjeFd+MS0TmUiWphBMMcOtOnhd4wQVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgIkyFHzrwwdshsdk4GQ2zj7VQL1hYgS/DTmpt56g7HVh0ahkGkhExaWtltTpDEkwSrf6yaGLfZ+JUat4i45Fwis6korknwKwNnqEQbCEt6FFlAtZNBI9x6Ps7PWtCt1a/6igiw9mH6kdV7JoWL+UYYaw9L/Ptpmwr5vA7F2XAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDQws/Nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDQws/Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFFDC2BCAF;
	Mon, 13 Apr 2026 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096684;
	bh=AUcFfsjoIC0pAjeFd+MS0TmUiWphBMMcOtOnhd4wQVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDQws/Nf8v5+OwshMNqKIEmi73ZD1H0vtLWId/9KLDrs+x0jwRe9ybbMOgJah9sMT
	 7TiPnduN1hdtuhv54XL49lVmfhr+rDlMFe9d+lkw25rYvdxSod0qPyiRoUDFyu7TqQ
	 1+C7mM+5OSsSpf5kNoMNHH48SXVtQScGtVFZ5d5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 6.12 23/70] arm64: dts: renesas: white-hawk-cpu-common: Add pin control for DSI-eDP IRQ
Date: Mon, 13 Apr 2026 18:00:18 +0200
Message-ID: <20260413155729.053333533@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 8219a455efd4ba11c1d30c1bbc9ce853466c19bf upstream.

When the DSI to eDP bridge was added, pin control for the IRQ pin was
left out, because the pin controller did not support INTC-EX pins yet.

Commit 10544ec1b3436037 ("pinctrl: renesas: r8a779g0: Add INTC-EX
pins, groups, and function") added support for these pins, so add the
missing pin control description.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/89bab2008891be1f003a3c0dbcdf36af3b98da70.1729240573.git.geert+renesas@glider.be
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/white-hawk-cpu-common.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/boot/dts/renesas/white-hawk-cpu-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/white-hawk-cpu-common.dtsi
@@ -239,6 +239,9 @@
 	clock-frequency = <400000>;
 
 	bridge@2c {
+		pinctrl-0 = <&irq0_pins>;
+		pinctrl-names = "default";
+
 		compatible = "ti,sn65dsi86";
 		reg = <0x2c>;
 
@@ -343,6 +346,11 @@
 		function = "i2c1";
 	};
 
+	irq0_pins: irq0 {
+		groups = "intc_ex_irq0_a";
+		function = "intc_ex";
+	};
+
 	keys_pins: keys {
 		pins = "GP_5_0", "GP_5_1", "GP_5_2";
 		bias-pull-up;


