Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751CE263C6D;
	Tue,  8 Apr 2025 11:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110796; cv=none; b=jvQHi4kQqUcH22zND3HsXr3uMroV8GK7ltZNt3JUgfdaH9MIqY+ccDZy9uHJBf+Y0F33dSBRLua70BziqhkMSUHmme9WUynIIFweNBaQDR+GJVOMVt2F7FwMpxqEROveptp8PByD7V667W7AiJkUugfdAkvYW7AFQPVi/xbh1Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110796; c=relaxed/simple;
	bh=DkDSKqQn5IP5QYknT8I+INMcxsDmvmFMPGiwnNOBngg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbX+0ue09o4rfVpGPkNQGvWvGNCI6z89WtMJc33vka4xFesGLLrQqwr3vPbLtPPO/ffCjmzTxXmkd3M2qBHMWEMGRKNgtgXOarWZjixnPLbwgHgMkUqQg8d1eUCbIBKSfJFl5E/rXC+VqrOIdbgYg9VahfbCdlf93qNqmavywrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw9peOWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw9peOWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA0C4CEE5;
	Tue,  8 Apr 2025 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110796;
	bh=DkDSKqQn5IP5QYknT8I+INMcxsDmvmFMPGiwnNOBngg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw9peOWUkAkUlvGqg/9AV6pG9ZZAXvqX+kpjb4G9YczRfMDzLx4kjkQOO8Ub9sMUJ
	 VPaBZHlCtR5LSTkksYZkBmoDKjOUHk+VRlNqI/tqpWADp9xPkV7WifnUk9GHqH2cEY
	 X9VsOKpz3vv6chNVGloPMm1SxQoQIsNGMZrwI96o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Merchel <Max.Merchel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 170/731] ARM: dts: imx6ul-tqma6ul1: Change include order to disable fec2 node
Date: Tue,  8 Apr 2025 12:41:07 +0200
Message-ID: <20250408104918.230884609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Merchel <Max.Merchel@ew.tq-group.com>

[ Upstream commit 22d8f69c8ddcd036d6e81589e95a058b86272bd1 ]

TQMa6UL1 has only one FEC which needs to be disabled as one of the last
steps.
imx6ul-tqma6ul2.dtsi can't be included in imx6ul-tqma6ul1.dtsi as the
defaults from imx6ul.dtsi will be applied again.

Fixes: 7b8861d8e627 ("ARM: dts: imx6ul: add TQ-Systems MBa6ULx device trees")
Signed-off-by: Max Merchel <Max.Merchel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1-mba6ulx.dts | 3 ++-
 arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1.dtsi        | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1-mba6ulx.dts b/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1-mba6ulx.dts
index f2a5f17f312e5..2e7b96e7b791d 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1-mba6ulx.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1-mba6ulx.dts
@@ -6,8 +6,9 @@
 
 /dts-v1/;
 
-#include "imx6ul-tqma6ul1.dtsi"
+#include "imx6ul-tqma6ul2.dtsi"
 #include "mba6ulx.dtsi"
+#include "imx6ul-tqma6ul1.dtsi"
 
 / {
 	model = "TQ-Systems TQMa6UL1 SoM on MBa6ULx board";
diff --git a/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1.dtsi b/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1.dtsi
index 24192d012ef7e..79c8c5529135a 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ul-tqma6ul1.dtsi
@@ -4,8 +4,6 @@
  * Author: Markus Niebel <Markus.Niebel@tq-group.com>
  */
 
-#include "imx6ul-tqma6ul2.dtsi"
-
 / {
 	model = "TQ-Systems TQMa6UL1 SoM";
 	compatible = "tq,imx6ul-tqma6ul1", "fsl,imx6ul";
-- 
2.39.5



