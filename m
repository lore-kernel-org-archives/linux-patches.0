Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B37829A1;
	Tue, 17 Feb 2026 20:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361383; cv=none; b=syNlU0DBWCyxMwQI0dcvlBuxnTEjp93n7k48ApqcTgF0D1YPzemQk1xOFK84ZgLuwoplVDbb89OKiKfd8z6Dr+GcpJVvGL4GE4L5fboV3XvaYRH2FHTzdxEWTK10cbn/q+bLWWku91VQs3/VpvcCgYz7Z+biRkJ2qV7XpHdSqRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361383; c=relaxed/simple;
	bh=5tVJWhKLvhSHo0sNyEk9lbw4MHbiG8WdaRh/IXiAPKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ykf/64WW/4LfmK4Lumn6sKkULLXvclocXkRErIOrZKhE3Hlst6wGBwUM65gT79P9nUq/0VDWmAd+QN7USmwRh+gMDqmsLDP0Ad4KP1wJhUJT6Bp/ev8/jp+q30Rp/QparPGmgYhRLHn7VO1LsTYcHsDpX6fUUMK8VUf/E6boXRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gO+7luyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gO+7luyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84506C4CEF7;
	Tue, 17 Feb 2026 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361383;
	bh=5tVJWhKLvhSHo0sNyEk9lbw4MHbiG8WdaRh/IXiAPKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gO+7luyyajI9GArr4uGkepNAuIBD+xmoZiMXcRvrr8DWwKgfK6M0VVA4ng4VOXobx
	 X9SifHMWDDo4nT5BzK5CXFIUMPDqlWGhmWpaG4VeN1aJGnjfx6KdyV3OpuJQnvoVZn
	 ylr/u2QkbdVgM+AMJP+yHUNa4Ev7dFjkoHACmt7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evans Jahja <evansjahja13@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	=?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [PATCH 6.19 02/18] arm64: dts: mediatek: mt8183: Add missing endpoint IDs to display graph
Date: Tue, 17 Feb 2026 21:31:58 +0100
Message-ID: <20260217200002.781804097@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


