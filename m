Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017322;
	b=ZDhd9UxjyFNlTQInMBsGNyP+OzaThDm1ABuwycU0GVTE/cECnvY5ckjffgTgJ27fD6HD
	 swQoajlje7a7VNv8sJg0ieQ88lXCf097TD0GQm6yJH28QtVPl0ytmezs4is9wsb+RMD2y
	 VyxPF8nX5zlEMW8pPJgvMgzvsthOVWgm66DzVydassc2U+bFKTB3x4CAvbaCs514k1AGI
	 ngOB4Z+rFA+Z50xMWRxw5W+ZDarAExHtf8wnMNKPASLNoyAe0EKzLgWVgpqyPhG7cF6GG
	 +NXE4OLy7sKSjRAc81u32ni7NvZLyOaBDoC7P9kg7vLe4eVhKNdauZwZd8lEyu7BRiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jQeX5BdE97YxwBvfcFfnONGHfQDKqTNg17CiGMue5VY=;
	b=bqBkpx8oVrYntuKEz8GtansN0jbHEXBxrGouZulz8NHkVZ44PsKQPL7hcx0+htQeMyoi
	 i+OpddirfC/iHME+Kf9/ZJ4uyDfSzRyWzx1DIUXjGRurBYJRusTlNFfNLky4IrvY977/Q
	 p+4OevVSYkBe81OlqeN8vQOOwLkkuQEa71FtwVtkOCC8lY/lQ8Y5Ci6xKi8UeD/b1/5vu
	 ZzD0UVq4Gqhdxhg3M3PlKQHDYalKbF1UZEarqGt8qp4TS4GDXIhGdaavqRDsM9EArIC8e
	 +s/bR8Vbgg6uN6h8mHR6rOcFZaRj9OUwuiQW78T3bqEPAt6DESTWZ2YnxIk6ID1ipZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cXLwjsn/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65152606A330;
	Wed, 18 Nov 2026 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXLwjsn/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B552D1F000C4;
	Wed, 18 Nov 2026 15:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017322;
	bh=jQeX5BdE97YxwBvfcFfnONGHfQDKqTNg17CiGMue5VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXLwjsn/GRtmYW2sjBy3EfUrtAoii9QaxHKtsb6r812JKCjNgAh71g0edMEPydOEp
	 P5iClex5tkYlcironizPEPgjva6/aP2AhhBXugBphOHy7MIosf8awNBgsS5fqzkAbP
	 Ysn+9ZZmXdw4rim3AiHhvYPwv3vXVAptXVuaEDQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0843/2651] arm64: dts: qcom: x1-hp-omnibook-x14: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:43 +0100
Message-ID: <20261118150318.226056602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 4ea8c5b790dd884bb5118336dfcb2c648cb40b2d ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 6f18b8d4142c ("arm64: dts: qcom: x1e80100-hp-x14: dt for HP Omnibook X Laptop 14")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-12-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi b/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
index dba8cee43e294..bcd85cbdcb93a 100644
--- a/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
@@ -1287,6 +1287,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <72 2>, /* Secure EC I2C connection (?) */
 			       <238 1>; /* UFS Reset */
 
-- 
2.53.0



