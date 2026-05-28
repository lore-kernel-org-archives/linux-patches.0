Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590F30C15B;
	Thu, 28 May 2026 20:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999734; cv=none; b=SeEHOswM5E8coSamCge+sl2ebQoDl0h0Goqf7vNa3l6muLfJG+H95JxHhq9nOo01a38s75uIGOCcDCYZwAtDk/S2jH2QBJePV6Ozq6y2UHuF3VceizpLxoOvQB1qomft/c19GgmZip2AXaQMCs2Kdb+y8tCKLZ7KRCysZmMRlp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999734; c=relaxed/simple;
	bh=nBdi2k6g3y1hTMiVT7jhaP5lDreqoIaeVOXYDiIv8gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqepEGASf73lO/FTiPwSFcdSoSbwDP0h9hjopE88m94HqYn8D8oi4inT6IKoPwDXa8CfT1jQy+qJRxTMGjXJC1jUnemo6l6xN0ViDtBzerznR/8z/5GBbgs25Firt92YGiv8ra5pke4ldgisnVSurB4aqtKHqArTzbL9VfqBfm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAp52enl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAp52enl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200B21F000E9;
	Thu, 28 May 2026 20:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999733;
	bh=h+O5WZZuClhXYuiTTv9Y05W4Ss58c7QS8oYCqtH6MZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAp52enlds0Dfq9gkBdw93HnbzT1tqDrLTTsuw6iMr23w30caFw7OI8ANbMbYTKeU
	 yXiLFlN153jaRWH7fRbCFs+hAm1bbvQj3XU3U2JUJVJLgPbt8sKoVikOSRn+MtF27f
	 9vLIFAqQ9yVk8gzr4KAIloSBRurqnsvXbPxesljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/377] ARM: dts: renesas: rskrza1: Drop superfluous cells
Date: Thu, 28 May 2026 21:46:50 +0200
Message-ID: <20260528194643.411117241@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit ab83176d3cf1cf1c1f6e604432905bda4515d17f ]

Drop superfluous address-cells and size-cells to fix DTC W=1 warning:

    arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts:32.17-72.4: Warning (avoid_unnecessary_addr_size): /flash@18000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Fixes: 98537eb77d3ef185 ("ARM: dts: renesas: rskrza1: Add FLASH nodes")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260327234244.91707-7-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts b/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
index 91178fb9e7210..3306bc9b7bc37 100644
--- a/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
+++ b/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
@@ -36,8 +36,6 @@ flash@18000000 {
 		power-domains = <&cpg_clocks>;
 		bank-width = <4>;
 		device-width = <1>;
-		#address-cells = <1>;
-		#size-cells = <1>;
 
 		partitions {
 			compatible = "fixed-partitions";
-- 
2.53.0



