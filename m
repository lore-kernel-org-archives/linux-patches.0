Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA3A1F4C8E;
	Tue, 30 Sep 2025 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246184; cv=none; b=jVNA/bbGJC4IjaYfz017CZ8RFurGEdmxD2WxOtw90JqmgF/F4lrAvDiuG4MUYQPYgUN/3dVdnK1hQ5tpV8zNgKdMH4VodInzfgsWB3xV3cnYWBpyHTKFkzWqd5khYroXQ6gSp1A+Kvp1Q+c7WHXLEDn/meyUOtNFTHuzX+PKrEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246184; c=relaxed/simple;
	bh=4cf1PIToJlDNbtFgri2wTvOt1uFTtU3N++CdoCTX5h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkG1afwxLTsg8e5CtglehLsjHLzLBaIGlVWh2+uiJTvkrQUm1XJVuXoTIkh13mU83j2Sij2gPX3u/wKbcgF73QXezFl+YNaT0nWEEaMJVGAFgU6t+2f99gr4KMizKDYeCusABw7LwwiXwMV7bjXgWPg3Yu5FMBOvG2Xn4n3dJi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0K9vU8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0K9vU8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAADC4CEF0;
	Tue, 30 Sep 2025 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246183;
	bh=4cf1PIToJlDNbtFgri2wTvOt1uFTtU3N++CdoCTX5h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0K9vU8yGpJFxmun/hCV6ysA/eu+UlwdBZtKrn5ODeFsJEeotiwFXzeec9KY1faDu
	 MBU81yccdA/fINj+bqaAWteotOzNRQOiUQpusP9u1G4e0NymgN3wF22K4hJPWOHxfx
	 VKBvIE08/aT+J8pl9OAPLppa20EDlm3Q3mdKL56Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.12 79/89] arm64: dts: marvell: cn9132-clearfog: fix multi-lane pci x2 and x4 ports
Date: Tue, 30 Sep 2025 16:48:33 +0200
Message-ID: <20250930143825.166640091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Josua Mayer <josua@solid-run.com>

commit 794a066688038df46c01e177cc6faebded0acba4 upstream.

The mvebu-comphy driver does not currently know how to pass correct
lane-count to ATF while configuring the serdes lanes.

This causes the system to hard reset during reconfiguration, if a pci
card is present and has established a link during bootloader.

Remove the comphy handles from the respective pci nodes to avoid runtime
reconfiguration, relying solely on bootloader configuration - while
avoiding the hard reset.

When bootloader has configured the lanes correctly, the pci ports are
functional under Linux.

This issue may be addressed in the comphy driver at a future point.

Fixes: e9ff907f4076 ("arm64: dts: add description for solidrun cn9132 cex7 module and clearfog board")
Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/cn9132-clearfog.dts | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts b/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
index 115c55d73786..6f237d3542b9 100644
--- a/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
+++ b/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
@@ -413,7 +413,13 @@ fixed-link {
 /* SRDS #0,#1,#2,#3 - PCIe */
 &cp0_pcie0 {
 	num-lanes = <4>;
-	phys = <&cp0_comphy0 0>, <&cp0_comphy1 0>, <&cp0_comphy2 0>, <&cp0_comphy3 0>;
+	/*
+	 * The mvebu-comphy driver does not currently know how to pass correct
+	 * lane-count to ATF while configuring the serdes lanes.
+	 * Rely on bootloader configuration only.
+	 *
+	 * phys = <&cp0_comphy0 0>, <&cp0_comphy1 0>, <&cp0_comphy2 0>, <&cp0_comphy3 0>;
+	 */
 	status = "okay";
 };
 
@@ -475,7 +481,13 @@ &cp1_eth0 {
 /* SRDS #0,#1 - PCIe */
 &cp1_pcie0 {
 	num-lanes = <2>;
-	phys = <&cp1_comphy0 0>, <&cp1_comphy1 0>;
+	/*
+	 * The mvebu-comphy driver does not currently know how to pass correct
+	 * lane-count to ATF while configuring the serdes lanes.
+	 * Rely on bootloader configuration only.
+	 *
+	 * phys = <&cp1_comphy0 0>, <&cp1_comphy1 0>;
+	 */
 	status = "okay";
 };
 
-- 
2.51.0



