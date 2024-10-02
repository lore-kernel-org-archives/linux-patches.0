Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF616F84F;
	Wed,  2 Oct 2024 13:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875640; cv=none; b=eZ3xMfDQGt2Wtp7/IygEeC5zKppYpT9cF4b39uSrgRNjPuGDfYrZ9Ip02IkEhmI9ExNSlx84X/MhEM8neYIUxmMK6juN901iXo5M4ziXlZuK1vOfHm83WbWwNpMs5YVhqXxvA/W/yRrjrssu4Y/gdi28FE1yWu6r0XeIirRtPQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875640; c=relaxed/simple;
	bh=Vi2M/WLaUcxj+96UyUh/jWJ28EQoTLMyTqVJYEQOxtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejgWNf8HvlNHTwoD3xhhlpdbpFZc/Xh+U3rqoFE+fWs2pA7VCG/sUc/R/53FQPI0s8ERZ1xeKgnrfXVLd2jGbYQzWvi4Ehzy1vaUenc3lrPdhyUhgieO7hwmtZZsZR+Zp8ZTXQMZcUwMEF8lU3DHvwEatDJ2P6ePLdP9hyCeBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwsLt85w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwsLt85w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F043CC4CECD;
	Wed,  2 Oct 2024 13:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875640;
	bh=Vi2M/WLaUcxj+96UyUh/jWJ28EQoTLMyTqVJYEQOxtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwsLt85wm49qDLIEhQCJmsPsWzjPHiOvI1/f4R2k6hnZZ+X8OyHazXFNqSx58s3ZW
	 chmAl7dkLJlo2MfkFttbNijz8kx89+o/aKi9CpSqHlOdRL6LSjQGXQoKDYkC6a81ur
	 Fbh58gprCxqmu7AYt/Q8r4qaT499pmKbM+xfDDlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 153/695] arm64: dts: ti: k3-am654-idk: Fix dtbs_check warning in ICSSG dmas
Date: Wed,  2 Oct 2024 14:52:31 +0200
Message-ID: <20241002125828.587602519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 2bea7920da8001172f54359395700616269ccb70 ]

ICSSG doesn't use mgmnt rsp dmas. But these are added in the dmas for
icssg1-eth and icssg0-eth node.

These mgmnt rsp dmas result in below dtbs_check warnings.

/workdir/arch/arm64/boot/dts/ti/k3-am654-idk.dtb: icssg1-eth: dmas: [[39, 49664], [39, 49665], [39, 49666], [39, 49667], [39, 49668], [39, 49669], [39, 49670], [39, 49671], [39, 16896], [39, 16897], [39, 16898], [39, 16899]] is too long
	from schema $id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
/workdir/arch/arm64/boot/dts/ti/k3-am654-idk.dtb: icssg0-eth: dmas: [[39, 49408], [39, 49409], [39, 49410], [39, 49411], [39, 49412], [39, 49413], [39, 49414], [39, 49415], [39, 16640], [39, 16641], [39, 16642], [39, 16643]] is too long
	from schema $id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#

Fix these warnings by removing mgmnt rsp dmas from icssg1-eth and
icssg0-eth nodes.

Fixes: a4d5bc3214eb ("arm64: dts: ti: k3-am654-idk: Add ICSSG Ethernet ports")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20240830111000.232028-1-danishanwar@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am654-idk.dtso | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am654-idk.dtso b/arch/arm64/boot/dts/ti/k3-am654-idk.dtso
index 8bdb87fcbde00..1674ad564be1f 100644
--- a/arch/arm64/boot/dts/ti/k3-am654-idk.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am654-idk.dtso
@@ -58,9 +58,7 @@
 		       <&main_udmap 0xc107>, /* egress slice 1 */
 
 		       <&main_udmap 0x4100>, /* ingress slice 0 */
-		       <&main_udmap 0x4101>, /* ingress slice 1 */
-		       <&main_udmap 0x4102>, /* mgmnt rsp slice 0 */
-		       <&main_udmap 0x4103>; /* mgmnt rsp slice 1 */
+		       <&main_udmap 0x4101>; /* ingress slice 1 */
 		dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
 			    "tx1-0", "tx1-1", "tx1-2", "tx1-3",
 			    "rx0", "rx1";
@@ -126,9 +124,7 @@
 		       <&main_udmap 0xc207>, /* egress slice 1 */
 
 		       <&main_udmap 0x4200>, /* ingress slice 0 */
-		       <&main_udmap 0x4201>, /* ingress slice 1 */
-		       <&main_udmap 0x4202>, /* mgmnt rsp slice 0 */
-		       <&main_udmap 0x4203>; /* mgmnt rsp slice 1 */
+		       <&main_udmap 0x4201>; /* ingress slice 1 */
 		dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
 			    "tx1-0", "tx1-1", "tx1-2", "tx1-3",
 			    "rx0", "rx1";
-- 
2.43.0



