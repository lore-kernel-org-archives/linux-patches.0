Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055675;
	b=oIMC4dPM86K56tLZmNRCqwRdt/wXf618xtSbTQd+XZKnuqXnM4L4etwhGdOccSlSqN4e
	 Fk+BNa+JYvtk6G6i+zcGlwTfXnJaCqtYklnde2+BKDIRnejV28exzI988PmeQSyN6Ea9i
	 cIWx0zqpkFslTMZppL4PUXu7a1jTlWjTprUrDCHk0X0CfQTyYYrzgB4dxVkbYVuiIid4v
	 0c7X7YFMHHJM926HBgbmzEdMHSQcB7qaWnljiAapHKoiftik37REyOHypafrwb8VYxIwt
	 dOvLbVl0vNDVxN87IWLOWhtJ2NKj34dDnTXM4uJtoZUx5Gftu2Kak4VC9LHls/Pm/Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IxyST8eN3vVoa6fYtCIWrQGm7hkzraUmcvcwHrB7NWg=;
	b=h3UViOgn+wvCLnhzCvcDYHst69/+HBBRte4a7bjDq/XZF/pCDE/p3kvgoZdLj/Ho3NJn
	 s9W1K9EPJ7Ee1G9RDw7cNZc2pmEqTvRaH27ebFubLehEYKHXD6CMOwPej7cVvBGk2+Mls
	 yVUb/Cwx/G/rAXr204SI47kfLpw8C8dCJzQCpbCxCLdqHI2GEcKgskWgWKCF+l0WS9zLz
	 QaLD75KxvGk/2y6rDPn3sa3BPk0cp3tVuNjiz0UbAkS7pIqVjUF19H9XvR3f138uIW3RT
	 e91fiyQyB0TA66n5S6/lcIAHjnwU7PbH41G+GwtqIG7/FLErowPZFaYZsFo2qY79xsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5LUmdCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568E7606A325;
	Thu, 19 Nov 2026 02:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5LUmdCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05891F000C5;
	Thu, 19 Nov 2026 02:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055675;
	bh=IxyST8eN3vVoa6fYtCIWrQGm7hkzraUmcvcwHrB7NWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5LUmdCOBEjEyAcwqqFzk1243RjPeaUdehDcXhC/fRQJHnLUa6IeWkpjXMtyl+KBr
	 Ob0DVNNm0qZ5Zr2yPfwbEd5InQh1c7TjzGVjn1aPfqXS3Mv6qEVOp7HtuQO0X+4/04
	 guthoambnj4UCSIwCUWt2GU1oiMQ1GGnJwrRTlZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1715/2214] arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150120.355705735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

[ Upstream commit b44e2be772f866985cafdf90355285069ea68495 ]

At 104 MHz, reads return corrupted data: bit 0 of the first byte of a
transfer flips from 0 to 1 part of the time. The same byte read as the
second byte of a transfer was correct in all 100 reads. One 4 KiB block
read 200 times came back wrong 157 times. Writes are unaffected.

flashcp verifies while it writes, so a bootloader update erases blocks
it should skip and can abort halfway, with the flash half written.

The Hardkernel vendor device tree for this board uses 40 MHz. At 40 MHz
the same tests pass: 200 block reads with no mismatch, and 14 flashcp
runs with no block erased.

Tested on ODROID-HC4 with an XT25F128B.

Fixes: 7178f340e929 ("arm64: dts: meson-sm1-odroid-hc4: add spifc node to ODROID-HC4")
Assisted-by: LLM
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Igor Velkov <iav@iav.lv>
Link: https://patch.msgid.link/20261002-hc4-spi-nor-v2-2-8366a4f91049@iav.lv
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
index ef45ed4113110..c055bf0e843af 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -134,7 +134,7 @@ spi-flash@0 {
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <104000000>;
+		spi-max-frequency = <40000000>;
 	};
 };
 
-- 
2.53.0



