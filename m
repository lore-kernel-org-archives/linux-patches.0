Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437517263D;
	Tue, 22 Jul 2025 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192745; cv=none; b=XbxhTMJzGCeulFIOTVFqh4RD83s0c7ApG0HVk6SX4yP3I0pjdQCExfGxhRr19HIqVHjjZwrI38m6lNjLX72dQO0vixsW1/rhLsMjgMw0FZfJR5mr/UA+VgFk619NOQakTQcwfSPP8ABmvw7+SiZskm15DQLqoqSELCSb0+CsOds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192745; c=relaxed/simple;
	bh=yGVwN5u1vthZIyH0jcXomsOxbRD0oYbs637tnT/hDE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUJksL4NorFs0uDdQCzvsCj1U6w1BZzn5b72RxkhKV4geMtNQjeljVvatrnHQeYSK+jxY65FLbmDrZqQviRyF+yowtI+wjdqM2YeWlSWNexrU4V9dF8yuEr/vNOAUBqquDeZAoJ4Jld1UTmUteoJ5J2FrjaY/uK9U5uH0YpUNy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvU8kI4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvU8kI4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D3DC4CEEB;
	Tue, 22 Jul 2025 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192745;
	bh=yGVwN5u1vthZIyH0jcXomsOxbRD0oYbs637tnT/hDE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvU8kI4pioE4y+iKmQFvNBrpX+/KMFgYVxtVnLQkaENGKg81ayMInEPE2yTB/4/io
	 eFbKIWJcdz2hXp8dBIuHF+Pnm+yapzBkTXkjoCvNPd2BqdCKmE7YtC2wWsxkNnUlRy
	 L2E2W4MxIefcBJb7kNk41ncOO/fVFYmDfyT00qWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 045/158] arm64: dts: imx8mp-venice-gw72xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:49 +0200
Message-ID: <20250722134342.420808506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

commit b25344753c53a5524ba80280ce68f2046e559ce0 upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 5016f22028e4 ("arm64: dts: imx8mp-venice-gw72xx: add TPM device")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
@@ -110,7 +110,7 @@
 	tpm@1 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x1>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


