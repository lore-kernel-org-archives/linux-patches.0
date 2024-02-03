Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCF7F9CE;
	Sat,  3 Feb 2024 04:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933537; cv=none; b=NwZGfn3iEgeNpTUVCmQOuFQTLKFH8juy8nM3TK5/yjbMhGj5kqu0SrLnR/u0lSqd4M1K8RWoZONsNmGJSywqufMqkQj3iJe8c6jrIQ/GAOibr3gSqdHLNvyWFcrDURhDPeYbJCGolO+smmAI53M5DnKtTRQLFHfdRyJ9xWIQGlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933537; c=relaxed/simple;
	bh=dx6Kwvxt1ZCyxF32jhAvCQKfibJHxaEOIGUc9GnnNFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/FcWDTDYBu+tPQGZMM+8eMjF2415PXgctLBPRpBDfBg5Ek6HEjV/nH/rYa4ytdXlJoF9M+saGDHKi15EJHPxDGuIjuWvqqOTqMYQD4W6G8mq8KwTzmsRpp2t85Vl5tUveg100sxWYYplfcTBLaH4twKCExX40urCRK0u0/vnJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wp50SZFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wp50SZFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4A1C433F1;
	Sat,  3 Feb 2024 04:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933536;
	bh=dx6Kwvxt1ZCyxF32jhAvCQKfibJHxaEOIGUc9GnnNFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wp50SZFpymN8Hn88Hj/ZqLwi3OYOubuK6DvuDeD1crZzMuG/IgwyyGlIHOfq7Vzrq
	 w77aZOBFjmuVl4Zp1DQvErrBDTweeaz8TLjQMyVqmEh1AUMA0sGdBkWwCY7AA16bUg
	 j3fIxqCGe43R25A2578NaqxrYPwzKN4CxTyXFByo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/322] ARM: dts: imx7d: Fix coresight funnel ports
Date: Fri,  2 Feb 2024 20:02:59 -0800
Message-ID: <20240203035401.810873534@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 0d4ac04fa7c3f6dc263dba6f575a2ec7a2d4eca8 ]

imx7d uses two ports for 'in-ports', so the syntax port@<num> has to
be used. imx7d has both port and port@1 nodes present, raising these
error:
funnel@30041000: in-ports: More than one condition true in oneOf schema
funnel@30041000: Unevaluated properties are not allowed
('in-ports' was unexpected)

Fix this by also using port@0 for imx7s as well.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7d.dtsi | 3 ---
 arch/arm/boot/dts/nxp/imx/imx7s.dtsi | 6 +++++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7d.dtsi b/arch/arm/boot/dts/nxp/imx/imx7d.dtsi
index 4b94b8afb55d..0484e349e064 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7d.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7d.dtsi
@@ -217,9 +217,6 @@
 };
 
 &ca_funnel_in_ports {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
 	port@1 {
 		reg = <1>;
 		ca_funnel_in_port1: endpoint {
diff --git a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
index bc79163c49b5..2e3513b7111e 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
@@ -190,7 +190,11 @@
 			clock-names = "apb_pclk";
 
 			ca_funnel_in_ports: in-ports {
-				port {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
 					ca_funnel_in_port0: endpoint {
 						remote-endpoint = <&etm0_out_port>;
 					};
-- 
2.43.0



