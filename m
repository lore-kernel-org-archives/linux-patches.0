Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F2D284B3B;
	Tue, 17 Feb 2026 20:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361473; cv=none; b=rX9/zBNUM5t1pyc6K/HTVV/FN/lT4QK1xR41OgArCc3BP+yMIyBttuSi9iitecbfYUMzOPCJP3rR+4ivLThqYBLTTACBaly5umM1DDZJGFNgB9UkIzuNGKMjL7b8wWtgCdyjmfDCOr578AFCgzYOqgqeYyeXK2xQ3tiTNUCHCuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361473; c=relaxed/simple;
	bh=X5nB7p5eVdYT+ylSop4RE2EUDcuQ9oLOYFGIkzoSK0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AOzOFxefz7qz1Z6oiwpELhwBReDoce4CbU0b5kb0AXqbHiA0VAgG3mDEGSP6anqeTrXm/Q9XPj8B109kzJIyRKjHT7+paLR8SgVSLi/GrEccfrKtG9IqSPPy6yLZELgrIjClmq0cpDgZJ2ZJW/Ojy8VGY/YNQ5zNyvz/wH3rtkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGP1bIAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGP1bIAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DDFC4CEF7;
	Tue, 17 Feb 2026 20:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361472;
	bh=X5nB7p5eVdYT+ylSop4RE2EUDcuQ9oLOYFGIkzoSK0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGP1bIAUNHIKDrsVjNFru8BQyl4No4E7Q7JyIxM6PrQ+IVpq+yo4VR3C60bBhCDLd
	 voOxOA1mf2QkwiY4oONvE8EBdEv6bIsHM7Y5O1i7SMtd/m3X18PgLyojobbgQQ2Cl6
	 z7Sr0fsOe78Iyp+8YRMZxaWGf0CgabWchp5RGmSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evans Jahja <evansjahja13@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	=?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [PATCH 6.18 26/43] arm64: dts: mediatek: mt8183: Add missing endpoint IDs to display graph
Date: Tue, 17 Feb 2026 21:32:06 +0100
Message-ID: <20260217200007.474729104@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Otto Pflüger <otto.pflueger@abscue.de>

commit be0b304eeb8c5f77e4f98f64e58729d879195f2f upstream.

The endpoint IDs in the display graph are expected to match the
associated display path number, i.e. all endpoints connected to
mmsys_ep_main must have reg = <0> and all endpoints connected to
mmsys_ep_ext must have reg = <1>.

Add the missing ID to all endpoints in the display graph, based on
mt8365.dtsi as an existing example that does this correctly.

Fixes: e72d63fa0563 ("arm64: dts: mediatek: mt8183: Migrate to display controller OF graph")
Reported-by: Evans Jahja <evansjahja13@gmail.com>
Closes: https://lore.kernel.org/linux-mediatek/CAAq5pW9o3itC0G16LnJO7KMAQ_XoqXUpB=cuJ_7e3-H11zKd5Q@mail.gmail.com/
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Otto Pflüger <otto.pflueger@abscue.de>
[Angelo: Fixed dtbs_check issues]
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi |   37 +++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1812,15 +1812,23 @@
 				#size-cells = <0>;
 
 				port@0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
 					reg = <0>;
-					ovl_2l1_in: endpoint {
+
+					ovl_2l1_in: endpoint@1 {
+						reg = <1>;
 						remote-endpoint = <&mmsys_ep_ext>;
 					};
 				};
 
 				port@1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
 					reg = <1>;
-					ovl_2l1_out: endpoint {
+
+					ovl_2l1_out: endpoint@1 {
+						reg = <1>;
 						remote-endpoint = <&rdma1_in>;
 					};
 				};
@@ -1872,15 +1880,23 @@
 				#size-cells = <0>;
 
 				port@0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
 					reg = <0>;
-					rdma1_in: endpoint {
+
+					rdma1_in: endpoint@1 {
+						reg = <1>;
 						remote-endpoint = <&ovl_2l1_out>;
 					};
 				};
 
 				port@1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
 					reg = <1>;
-					rdma1_out: endpoint {
+
+					rdma1_out: endpoint@1 {
+						reg = <1>;
 						remote-endpoint = <&dpi_in>;
 					};
 				};
@@ -2076,15 +2092,24 @@
 				#size-cells = <0>;
 
 				port@0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
 					reg = <0>;
-					dpi_in: endpoint {
+
+					dpi_in: endpoint@1 {
+						reg = <1>;
 						remote-endpoint = <&rdma1_out>;
 					};
 				};
 
 				port@1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
 					reg = <1>;
-					dpi_out: endpoint { };
+
+					dpi_out: endpoint@1  {
+						reg = <1>;
+					};
 				};
 			};
 		};


