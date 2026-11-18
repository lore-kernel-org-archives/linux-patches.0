Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060869;
	b=ZV4uEWsoC0MGhjp9k+COwJJ6b4O9xLXI4uYWqaGSOxqNTzJL9oXLVbVYYRvffzhM23rZ
	 r53Z8KBrOHggMaYS2cCa/Uo8DCJdA/pxfUqDaa6y0zoAdtMXaAcI5x/+VPjpMNpDaMuoL
	 IXArqR28tFlmzSIYhxKnhtEHaIG0zc+AbHRYTw3mhWna7TZr7+lMwgxMgwxsKJTRCDEWw
	 xOBJWxUQXXrhqWESHuJWR8esW5zYdrFbeRWyDG2ksHzLbWsArQE1NJgiLg6nlZtU5DaXd
	 beDBSrdLCRiLVCdMwM08O5yZVWzfgubtOGtbO9+Ef+8+GoeOA61LYbxIqh1y5zN/+oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvY4cHujTfA0SDluvh7JRMoQPGSIBe93/qBe8zW4P1k=;
	b=nsZ95Y/TTzOKBuBrF9g8tRWLUmmpV6PkU+rPlZH4jrVaKOwIfC3vZh/cErKe51wM4oMK
	 14frGzsQB/4WI+IDQSHeNxepDABfef2hVKXkwSV/MKItZs+zHHm+h0BM1yJgFWhDDgOG6
	 XWiblisQno8YK9qFyNjydcF3fbr7Fl1V9aaM56Fv3lRDRxRZk6nJj1ar0IA/R28kCZHgZ
	 3PpWinkg8iU9t8pHMY+rY7WFcm+uaysxuDiJCGXfPdiOvET99ZrvxIYnRgMG4Be2kmxPX
	 CRGl84KfdqgF0Rb9qKy0JpeCySzr9KLZKseFYZdJmcP2orI0oky7Rnk5HKU1CicGamw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhy09wzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA2606A32F;
	Thu, 19 Nov 2026 04:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhy09wzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BEB1F000C4;
	Thu, 19 Nov 2026 04:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060868;
	bh=rvY4cHujTfA0SDluvh7JRMoQPGSIBe93/qBe8zW4P1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhy09wzja34TI30sAUPAfPs2NdUAITWll9QMMj9C/Q7p78V349l9sKQTSRBG7afPF
	 9o1/4IZlTgp8xhRoue5HWiUTZciSDndEThPQz6ZfOvspawBJT+vbbuhBDnZwbJbrWN
	 KMnI18BeamUglIfF6uqP6cHr15F99TO/QBCJUsMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1353/1848] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150016.276809157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit cdc7d3dd101251a6373332726b8d6fad35e83b8a ]

The SPI driver advertises an ACPI match for BMA0220 but does not export
that table. A modular build therefore lacks the ACPI alias used to load
the driver when the device is enumerated through ACPI.

Export the ACPI table. Move the existing SPI export next to its SPI ID
table so each export is adjacent to the table it describes.

The issue was found by our static-analysis tool.

Fixes: bf2a5600a3eb ("iio: accel: Add support for Bosch BMA220")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma220_spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index e8a9db1a82ad8..4f16d1e96e7d8 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -312,12 +312,13 @@ static const struct spi_device_id bma220_spi_id[] = {
 	{"bma220", 0},
 	{}
 };
+MODULE_DEVICE_TABLE(spi, bma220_spi_id);
 
 static const struct acpi_device_id bma220_acpi_id[] = {
 	{"BMA0220", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(spi, bma220_spi_id);
+MODULE_DEVICE_TABLE(acpi, bma220_acpi_id);
 
 static struct spi_driver bma220_driver = {
 	.driver = {
-- 
2.53.0



