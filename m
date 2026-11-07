Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064301;
	b=ZOoS/1ip+67ZD+oAaU9dDPb5w/fCpugc8wGlw6y2hF/GtOm0L5vOYnyHZpWeOx7wpdCS
	 E1NbdhqpYD7JJkOvVFjxoO1/JYJcmKnmyQKIOTWEE7vJt+J3ehef9gqwmO3mjWjc1wsCR
	 nBhK5+LtLeRCSpI36XMN0G811o2MDPC21PlSUjJ4rTLoduvnSmVj4FC8+tK/jlbxxzy71
	 TBbumQz4CAcixDtRbz5ZTp7uP6gXHcN2jdLtZRRb1IQ4E6Xf/Ir1hN6YZ+qnUB9Lrr3wf
	 zHs3ZUW5UKlU5N0UjSaRkptqcJ1VF0mgMs8GHOfqhOJFotK3eb0c7KNSKzsBQqFJaKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n3PXHhYJ9Y4W/1VZcoc8i0lTjBw92Yr7cytKGvTzwdc=;
	b=ciFSijDWljYN/kkyanik55CaCZzhJppwNHrBMncsFryjM+QcvjqBH0r42sRBcHa8UiJZ
	 HddOhguZgLY0eayYDdynML4G/QTsKTLSPELjMzsDXMcVGA2V7bg/PnUYIlM5Nv97q9V+R
	 ZUovVxLMGmAWOtlPyYI2iSd1rxSiC+arx9b35k8FlIj+jYlBb8kKgWDMZvGkXipb0E889
	 WXYwH3ItAKpvvzmKHuwsE4aOAgovhD+Ldig4Gn+Ylvh2Ukjk+XzTckR6kNZchPLhRpc6q
	 Rk8dBrfZlVi2Svank/Ty8pw11agV7OmeBYXaUUUdwoCjI1sx4mI0duaY8acNhc0Gjig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hdh8U2n0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A08B606A9CC;
	Sat,  7 Nov 2026 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hdh8U2n0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4CF1F0089F;
	Sat,  7 Nov 2026 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064300;
	bh=n3PXHhYJ9Y4W/1VZcoc8i0lTjBw92Yr7cytKGvTzwdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hdh8U2n0TXMSzvxbyv7Rk3jUDWztth+lzFCq/krDikHK9doCMBLl1jLDoZNcQqw6n
	 Ubl8yBYGldO06/NCl+VVix/9+5tDdeXJRHUTJBmFPmy5P5lGdtuVYFT8OItdTqcRN4
	 oHp+1UkY7ZlCfIOvDjMo7na+LEZUpni4A6A1H5U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0394/1257] arm64: dts: freescale: imx95-aquila: Enable I2C_3_DSI1 on Clover board
Date: Sat,  7 Nov 2026 08:44:50 -0500
Message-ID: <20261107134950.427314464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Franz Schnyder <franz.schnyder@toradex.com>

[ Upstream commit cffbc25c212bd41885094648918a935da0115a0e ]

Enable lpi2c8, which is used for the I2C_3_DSI1 signals on the Clover
carrier board. It was left disabled by mistake in the initial commit.

Fixes: 3f519121e120 ("arm64: dts: freescale: imx95-aquila: Add Clover carrier board")
Cc: stable@vger.kernel.org
Signed-off-by: Franz Schnyder <franz.schnyder@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-aquila-clover.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx95-aquila-clover.dts b/arch/arm64/boot/dts/freescale/imx95-aquila-clover.dts
index fd93043314466..435567b257087 100644
--- a/arch/arm64/boot/dts/freescale/imx95-aquila-clover.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-aquila-clover.dts
@@ -188,6 +188,11 @@ &lpi2c5 {
 	status = "okay";
 };
 
+/* Aquila I2C_3_DSI1 */
+&lpi2c8 {
+	status = "okay";
+};
+
 /* Aquila SPI_1 */
 &lpspi6 {
 	pinctrl-names = "default";
-- 
2.53.0



