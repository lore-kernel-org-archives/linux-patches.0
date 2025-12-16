Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77329340DB7;
	Tue, 16 Dec 2025 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884059; cv=none; b=kJ+ZSHGZTXnKbGuBSat6vAjIeFZ210NVwiaYsR0Hzr0cZ4EKZq2MmC9AJ+0v7qqRGg3i1BuKoaCY6Zaw009Om+lxoGVTW11vOHo1keLcVbQgyEXitEzqhbqwfkbR4Itqck4RdXMe+BCbAOehSg9UCXif0rL0hD4t4Zgdqt2MbzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884059; c=relaxed/simple;
	bh=I1IL/GHyjsREwf9GgtRZyvPXhg0ttMze6t6fI1CR8IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpYbOwGivHWbfbZRuPLklUJNNzpWL9tCpVZr2Y9jqJrfRkclSuqZI8RQ6fWwbIrapBOHpA8cEA7sFMn6U0f8gKQYWfeO+PTDIJYs62jSyA+0CdLzOzG9pyikkcFZ69KcjtfTGzqSvCzebtJlXofnDodktoPT5At7cBBquebMbRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYGjEqav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYGjEqav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE7CC4CEF1;
	Tue, 16 Dec 2025 11:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884059;
	bh=I1IL/GHyjsREwf9GgtRZyvPXhg0ttMze6t6fI1CR8IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYGjEqav4C0GIMpiHizLsrH8ec9VNx6LoBcCxmyDwg6912qpCUm0iFesabveac84g
	 +kyuqhZSIxnvRV1yg2CBF3i/VPtGT+C0++Dw9pw3x7VLdqlL6eOr9HQP4zbo0uHa8j
	 qeVnYP9LPunwFYjFHasq2S/gZVmeaAZQJ7M2Kz6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/354] ARM: dts: renesas: r9a06g032-rzn1d400-db: Drop invalid #cells properties
Date: Tue, 16 Dec 2025 12:10:48 +0100
Message-ID: <20251216111323.859198886@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ca7fffb6e92a7c93604ea2bae0e1c89b20750937 ]

The 'ethernet-ports' node in the SoC DTSI handles them already. Fixes:

    arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dtb: switch@44050000 (renesas,r9a06g032-a5psw): Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
	    from schema $id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#

Fixes: 5b6d7c3c5861ad4a ("ARM: dts: r9a06g032-rzn1d400-db: Add switch description")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251007104624.19786-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts b/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts
index 31cdca3e623cd..5fa7acce47149 100644
--- a/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts
+++ b/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts
@@ -126,8 +126,6 @@ &rtc0 {
 
 &switch {
 	status = "okay";
-	#address-cells = <1>;
-	#size-cells = <0>;
 
 	pinctrl-names = "default";
 	pinctrl-0 = <&pins_eth3>, <&pins_eth4>, <&pins_mdio1>;
-- 
2.51.0



