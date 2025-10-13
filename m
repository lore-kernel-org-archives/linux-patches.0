Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271E315D32;
	Mon, 13 Oct 2025 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369255; cv=none; b=DatoRhN1gZYhExE2XqMqueHLuuUiDTq7xxNDfQ2FhSboxKQOsrrdArduk/wfYtEqAdKKkLB8OK1Rv89VDuQgTD5mvWZlJ7WxR6iWaUr1X4RbOFcdPS+enIdbWctOAR62O2MhtIU1rgkY9J/ZJ5BLnM/8Lq5rIrmWnGilKRr1eZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369255; c=relaxed/simple;
	bh=ITJgTnVW9GQ5H8IFjlF93sFyt54svXzqNBnNHg4emAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRfiKnzQlzZ/DHDw8y768em79zPrhHpWfR7aiO9E4YWQb2uI6lPdFZCsK6Yfie5hm0acpYUjFme1PdE5WOHZ2ZD+Y8aJgZq13UdpNkQRA5pw70Hr6I904GVrT8dbP7fU64UKRbz5iSF6qr4fwoLDjPUKl51BicKgj8t7hLGDm5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enaVKcje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enaVKcje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA043C116B1;
	Mon, 13 Oct 2025 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369255;
	bh=ITJgTnVW9GQ5H8IFjlF93sFyt54svXzqNBnNHg4emAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enaVKcjeAwQRZmTmyAM4gQ9+jiuJ4n2xOrqEjrJrzS+VJ0Qx3hddwRjel3vjFw6BU
	 /LJ8hD9I7vRkzlO70PuhmWdKA3kWupoTc3WT9lusbo2N5UVIwB8wAl34jvTN1uvqAS
	 T/Ke8cbXOSbwQh1kmY17GX3yzGyQjEXo090KI/so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 182/563] arm64: dts: apple: Add ethernet0 alias for J375 template
Date: Mon, 13 Oct 2025 16:40:43 +0200
Message-ID: <20251013144417.877733218@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit 6313115c55f44f7bee3f469c91d3de60d724eabd ]

The alias is used by the boot loader to fill the MAC address.

Fixes: aaa1d42a4ce3 ("arm64: dts: apple: Add J375 devicetrees")
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t600x-j375.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/apple/t600x-j375.dtsi b/arch/arm64/boot/dts/apple/t600x-j375.dtsi
index ed38acc0dfc36..c0fb93ae72f4d 100644
--- a/arch/arm64/boot/dts/apple/t600x-j375.dtsi
+++ b/arch/arm64/boot/dts/apple/t600x-j375.dtsi
@@ -12,6 +12,7 @@
 / {
 	aliases {
 		bluetooth0 = &bluetooth0;
+		ethernet0 = &ethernet0;
 		serial0 = &serial0;
 		wifi0 = &wifi0;
 	};
-- 
2.51.0



