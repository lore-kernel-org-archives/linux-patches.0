Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B03C465;
	Tue, 30 Sep 2025 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246032; cv=none; b=INW2TcxGd1CxqafTc00hRyLjSCdLJ9IeTnpN93QcoobHyEYhJvZrgMb1T7gjvQuVlgb6W40iC66MU8Ce8dmhIhWLH9XlYz7ncuHP4rYUS/wBvJ3Sdt9b1YTkCetd6OPM0LpGTafyQsxfB3lpIEDxubelDziFVilGcZ4izdWx5Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246032; c=relaxed/simple;
	bh=67WgSn2xbZDCGkvt5BpBsbu1/pLsw0viTp2LMjvVz8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVfp75mMnQ9TaXzc1kbhDv9lMyEn3tyZfunElRRdZKloTza/uckfm5l+l4xSJ9GCvvsBn2Bi1zJdFNLxMPsD15cXA1iR2wQHRnsjiJw52PoEXAno3Xw0viMmLWAoridT50rVco4Eol4AgSps1MtgU3drQTYD+rVZzE22HBvsxJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG7c0qjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG7c0qjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3654FC4CEF0;
	Tue, 30 Sep 2025 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246032;
	bh=67WgSn2xbZDCGkvt5BpBsbu1/pLsw0viTp2LMjvVz8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG7c0qjVs7StV09UsROL5Ek8SChwjypEJj2eVdnK56MpeBpUNT0fc5VFxZ9z600iS
	 0TGb4nmpBCkoVusmZzgc6kc/bhmHuF/bjvkWePjYw0KVyJsaLQHqZ4u8DlRDUnMS2L
	 FTm/a841tkFhdKL1LUrpaApIkQiS4M54sNz5RYNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 30/89] ARM: dts: kirkwood: Fix sound DAI cells for OpenRD clients
Date: Tue, 30 Sep 2025 16:47:44 +0200
Message-ID: <20250930143823.155547948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 29341c6c18b8ad2a9a4a68a61be7e1272d842f21 ]

A previous commit changed the '#sound-dai-cells' property for the
kirkwood audio controller from 1 to 0 in the kirkwood.dtsi file,
but did not update the corresponding 'sound-dai' property in the
kirkwood-openrd-client.dts file.

This created a mismatch, causing a dtbs_check validation error where
the dts provides one cell (<&audio0 0>) while the .dtsi expects zero.

Remove the extraneous cell from the 'sound-dai' property to fix the
schema validation warning and align with the updated binding.

Fixes: e662e70fa419 ("arm: dts: kirkwood: fix error in #sound-dai-cells size")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts b/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts
index d4e0b8150a84c..cf26e2ceaaa07 100644
--- a/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts
+++ b/arch/arm/boot/dts/marvell/kirkwood-openrd-client.dts
@@ -38,7 +38,7 @@
 		simple-audio-card,mclk-fs = <256>;
 
 		simple-audio-card,cpu {
-			sound-dai = <&audio0 0>;
+			sound-dai = <&audio0>;
 		};
 
 		simple-audio-card,codec {
-- 
2.51.0



