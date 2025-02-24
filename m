Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DDF7F7FC;
	Mon, 24 Feb 2025 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408247; cv=none; b=VNP3qzb7wrWO66idjGufAW0PjgKXkc01MIZANqPFdpnLyDZRN4qChqpNpsp0cszIRFQ8VxYanW0xkPjglz1xXCuqzoyVo8N8/LDMx+JIXErSwNRa6aFVpg9DagXaAwYsTdWNP2YnBYB4R60P1PxoYCV3Eekd19NVUkFjFCXyesc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408247; c=relaxed/simple;
	bh=HUaX786H7MX8zLuAK7orJQVe3u/AiPNPvRXZFo7Ll3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjCwWMzx3l972jG1iph/w21FGgC0ZvXcF9F+VK0Arh7RBzBJzCIsPIGhJs3SCGG+p+RISz62qEk3evu5X62z+drFoRjqDbUq1NC8NBaV0iLjUNIcsoYXcAq9KItfamSieuami495NTrqwaNqW//5i39brXbdHb3SrATXXsxeXkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qE71x+FL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qE71x+FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE4C4CED6;
	Mon, 24 Feb 2025 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408247;
	bh=HUaX786H7MX8zLuAK7orJQVe3u/AiPNPvRXZFo7Ll3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE71x+FLVsBSHJJbFrdVm9EYEp7IaQ9YD3XNW2NI2tdipXHJSU+EOqnXOzXllun7d
	 1RXKRPkWRWZu4rYXR0uwxGXF6a/XSYQ2RuUU1kKnMcijcbZBJEpXpEa3IbZ0LT0tFH
	 vV30ihyZbxM5M1ZGRy+4qQ2n0LDFdIt3e/wxGRhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianling Shen <cnsztl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 135/140] arm64: dts: rockchip: change eth phy mode to rgmii-id for orangepi r1 plus lts
Date: Mon, 24 Feb 2025 15:35:34 +0100
Message-ID: <20250224142608.314985722@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianling Shen <cnsztl@gmail.com>

commit a6a7cba17c544fb95d5a29ab9d9ed4503029cb29 upstream.

In general the delay should be added by the PHY instead of the MAC,
and this improves network stability on some boards which seem to
need different delay.

Fixes: 387b3bbac5ea ("arm64: dts: rockchip: Add Xunlong OrangePi R1 Plus LTS")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Tianling Shen <cnsztl@gmail.com>
Link: https://lore.kernel.org/r/20250119091154.1110762-1-cnsztl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
[Fix conflicts due to missing dtsi conversion]
Signed-off-by: Tianling Shen <cnsztl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts
@@ -15,9 +15,11 @@
 };
 
 &gmac2io {
+	/delete-property/ tx_delay;
+	/delete-property/ rx_delay;
+
 	phy-handle = <&yt8531c>;
-	tx_delay = <0x19>;
-	rx_delay = <0x05>;
+	phy-mode = "rgmii-id";
 
 	mdio {
 		/delete-node/ ethernet-phy@1;


