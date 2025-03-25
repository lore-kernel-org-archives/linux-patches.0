Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAA82571AC;
	Tue, 25 Mar 2025 12:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906224; cv=none; b=T7sqTanHlP62Na1goHdusJLUIaVlG37y8XIHyZp1Uq9D0yCIvw//JuSXa5YYgva2Kj8eXpjjyjbAP9NCf/kIIL1EjH/+o/DshO/oxcZSCO4pq58I/xFhpDpoDQKOx+JLN2i0qQYHA8WVifXc5dtWCYoSTTeUF3mgqqBAaie1CKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906224; c=relaxed/simple;
	bh=zwhcf/oYL9jPOOJ3qTp2gGLJ/cJTc1ptN9OB/HwBTxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIoaoq3NA8ewftjs4mw0NiGKwGDYYX6qG9Xi+6RQ0+GrdN//NH/uTs5A8shNUueNW6h6SfUKBsChSByH3PLf0mw2MDyFG/6XvGJPbyI5UvY4gbAoJjibrXvfnKOieohsCcqhOtNdp8xuffewZmNlqN5ZU4F47D6AquAAwXM/ai0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eGq7IDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eGq7IDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06626C4CEED;
	Tue, 25 Mar 2025 12:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906224;
	bh=zwhcf/oYL9jPOOJ3qTp2gGLJ/cJTc1ptN9OB/HwBTxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eGq7IDSvrz9zoYqcXdvFndD5kJIlJRUd/PjaBGi7gpcObWseZa3BezCsNFOVc5Dg
	 DmGSopc9uC2p94ccjL4Ft4uDp9M3vJmD9+Y/UfhXce7Z6Sg07Y1WzGjyI1+6akk9F/
	 CmInSjvKtPMENd5WVVBAUzg5AON8owtdxTnqaxck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Klaassen <justin@tidylabs.net>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 71/77] arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S
Date: Tue, 25 Mar 2025 08:23:06 -0400
Message-ID: <20250325122146.264132758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Justin Klaassen <justin@tidylabs.net>

commit 38f4aa34a5f737ea8588dac320d884cc2e762c03 upstream.

The u2phy1_host should always have the same status as usb_host1_ehci
and usb_host1_ohci, otherwise the EHCI and OHCI drivers may be
initialized for a disabled usb port.

Per the NanoPi R4S schematic, the phy-supply for u2phy1_host is set to
the vdd_5v regulator.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Klaassen <justin@tidylabs.net>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250225170420.3898-1-justin@tidylabs.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
@@ -117,7 +117,7 @@
 };
 
 &u2phy1_host {
-	status = "disabled";
+	phy-supply = <&vdd_5v>;
 };
 
 &uart0 {


