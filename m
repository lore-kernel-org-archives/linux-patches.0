Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFBA2EA15C;
	Tue, 22 Jul 2025 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192312; cv=none; b=ELoWJwIAizu4snwUbsDZXPJPY23c+BgxWWnUKkIqW1Svvhv/EghMXPH/Pb2+wtOLnzArhMD3udp/51vf+ZX5IaZPwOgQEIsrUPOrheE0kmMQv18Qu6CqPy7yPyiP6PjDl/fsTPqffKrm+bbF3hFSUPOQ5JGgctsFjhbPk25nZbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192312; c=relaxed/simple;
	bh=6dwpnIjraPtcfw0hKuNnjRkPHBFfVbs6zqbQGQSEK4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSFlf+otxgjJp31Yji9bGcXDRsAWwphFGF3bT5qQmy6ajvCj4WP4vxkBBDPbqRX6OrVwgsSCjTkVGpBnln8sxt0R93IK2u1emeFGqRN35YIG9Emheg4zDnHDJbOXoEhC7G1QbucuUA/gA5eEG7eH4nQ8KDqFC1cl1DmlU5hl7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=au70g8v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="au70g8v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F3DC4CEEB;
	Tue, 22 Jul 2025 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192312;
	bh=6dwpnIjraPtcfw0hKuNnjRkPHBFfVbs6zqbQGQSEK4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au70g8v3W6bDo2QmfZK0tleO16D1d8aK/0l7PRUmkyRvLtBByMppVAWKgFo7UdG52
	 hq2ayFr+u8OOwd+xg8r4g+iAMbiP1Cr/mHNuTctB4leXBlD4yPz7QvdrgiZeqWW2gi
	 KT1CYyaObgUTc+VLN8+WzcGrTiLIAxMezpn7+aLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 028/111] arm64: dts: imx8mp-venice-gw74xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:44:03 +0200
Message-ID: <20250722134334.443434968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

commit 0bdaca0922175478ddeadf8e515faa5269f6fae6 upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 531936b218d8 ("arm64: dts: imx8mp-venice-gw74xx: update to revB PCB")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -185,7 +185,7 @@
 		#address-cells = <0x1>;
 		#size-cells = <0x1>;
 		reg = <0x0>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


