Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFC0245002;
	Mon, 24 Feb 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408761; cv=none; b=WlQ3TTytpL5uas4Qpc5OTIR0P18lKrt0LI1mdR7A1D7WXx6PN0jljJAyHV8gQsYGZx6jM/AubzBhr0U4frJoMdkDPdW7BryvBRmh+6sdqTqruu/CpNcH5gii0BO2QbMac4Y/SbhgEIfnDAjVTrp4/1aXLKqWvQ/OhLGM/pH7ShU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408761; c=relaxed/simple;
	bh=V0xjJcGQzLb/gbh8DZsHBNI7iD6oSQckPjYnVncfD40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1YInoGgSEe/94LeupgMIzKU8MQy5rUNUEJxj9bh4dnKh92jUQ51JYLMkZ5jucGYuOa84y+XT02eaxQRfFVEzM++BD1dDJRrUS1HiWihWaoZA05ZOrpVnBjQS2wCzefXX3bAzy1kxKr+N3yDbKtgz/1ilJsEfDoUtmrIasq+si8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQjivjxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQjivjxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168E5C4CED6;
	Mon, 24 Feb 2025 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408761;
	bh=V0xjJcGQzLb/gbh8DZsHBNI7iD6oSQckPjYnVncfD40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQjivjxioaKK6e5c+id32u2+8vEllntEYyB9cqHlJT+BOVijtKAuDM9vkAHA30Rrl
	 xgEyWrqvouZ1IN/VHZqjB8vbZDGn6Iyg9vbwDHu9QjRNdwlpZna1LEdlWgMBWOxwxJ
	 NiypqBdORFT3H+mzLOviggrGe9JKSq6cAGsIfJtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianling Shen <cnsztl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 152/154] arm64: dts: rockchip: change eth phy mode to rgmii-id for orangepi r1 plus lts
Date: Mon, 24 Feb 2025 15:35:51 +0100
Message-ID: <20250224142612.995547337@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


