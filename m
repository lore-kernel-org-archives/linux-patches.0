Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D772A221FBF;
	Mon,  2 Jun 2025 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872228; cv=none; b=iMpdEtxQP9Voktxx7OfruQnG0BUXxtySudBhgfsFUMGwRSdwQmiqkCg0hcAlwbbQ9Bs7sV51XjQS8oHgEigw9QJh0OKD5hHHNQXT0C04/fPxUjvgmsiMOLp1ouCDdQb7Ui3gP3Hgm4xKYF/aJLg1c4dxCu7dnO1eUSKAIwb3zOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872228; c=relaxed/simple;
	bh=mVCZeY6NnvTUzCBV4GiRN9MQ8FhatX/VDZJhylXUra4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4YDkOAiEyc7JnK6hDReJPrliQ9p/UEOA1ydeTA5kYcCSe80nTHg0CJ0PhRcEl1OPp6LH73P1qWcH5ueKy7G9GnFQh22ZIz4n4Npjkc8qoJol57txIGa4E54JavLwWm0Ow4msZpe+y/Fqpz92Ijd0IIREKxibxHtLT3KTsaQTxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SfCRv/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SfCRv/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE4BC4CEEB;
	Mon,  2 Jun 2025 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872228;
	bh=mVCZeY6NnvTUzCBV4GiRN9MQ8FhatX/VDZJhylXUra4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SfCRv/akCDH4aKXGIAaI3oVHrIogHahOCxXXGQIQEYce7LNCNdXRCAJdr6JpRolx
	 0I7KwVEv/oxSdqRRh/D/qljP3m+WlFucvGyJDyjxzHabbA+5QNIbH/FA7xR4LemfV0
	 3kComYXI06msx+NIdZhbR/NeEOHfcFd2ro1/JVCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 39/49] arm64: dts: ti: k3-j722s-main: Disable "serdes_wiz0" and "serdes_wiz1"
Date: Mon,  2 Jun 2025 15:47:31 +0200
Message-ID: <20250602134239.476843080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 320d8a84f6f045dc876d4c2983f9024c7ac9d6df upstream.

Since "serdes0" and "serdes1" which are the sub-nodes of "serdes_wiz0"
and "serdes_wiz1" respectively, have been disabled in the SoC file already,
and, given that these sub-nodes will only be enabled in a board file if the
board utilizes any of the SERDES instances and the peripherals bound to
them, we end up in a situation where the board file doesn't explicitly
disable "serdes_wiz0" and "serdes_wiz1". As a consequence of this, the
following errors show up when booting Linux:

  wiz bus@f0000:phy@f000000: probe with driver wiz failed with error -12
  ...
  wiz bus@f0000:phy@f010000: probe with driver wiz failed with error -12

To not only fix the above, but also, in order to follow the convention of
disabling device-tree nodes in the SoC file and enabling them in the board
files for those boards which require them, disable "serdes_wiz0" and
"serdes_wiz1" device-tree nodes.

Fixes: 628e0a0118e6 ("arm64: dts: ti: k3-j722s-main: Add SERDES and PCIe support")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250417123246.2733923-3-s-vadapalli@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-main.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-j722s-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j722s-main.dtsi
@@ -32,6 +32,8 @@
 		assigned-clocks = <&k3_clks 279 1>;
 		assigned-clock-parents = <&k3_clks 279 5>;
 
+		status = "disabled";
+
 		serdes0: serdes@f000000 {
 			compatible = "ti,j721e-serdes-10g";
 			reg = <0x0f000000 0x00010000>;
@@ -70,6 +72,8 @@
 		assigned-clocks = <&k3_clks 280 1>;
 		assigned-clock-parents = <&k3_clks 280 5>;
 
+		status = "disabled";
+
 		serdes1: serdes@f010000 {
 			compatible = "ti,j721e-serdes-10g";
 			reg = <0x0f010000 0x00010000>;


