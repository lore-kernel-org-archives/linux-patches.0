Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624189;
	b=tkhjo6NWsbWervNS++IrSJSgUbaosftDjgawpXJaC/zCyg7ZrNhFHpU4IqJxVPJP0m5j
	 KBcjsIuRo7XLp3FFrZyxc2u1Ff/VWcC1Qez3wh59TZF4/1xXkRhUlM0hWs8q8wzYFIWhg
	 O/Na16g3K+QveJFixV0TUO/fQk4+RXpetupcdwTdiAhWO9vy5uKnamjcrDMD7alyLX5Fn
	 nTamyf52t4rIzuGnNi6YNQeHDCqAzgv3AJDQ/R8y9UlX1yWMBVpWxK4s7bhPcTkjF35/o
	 PBwgg7tpANtkP2iWEy+SSUVnWNl3I4jHCwGKHhfYj0z4A3o2PPonswwNlGF0OeaKRdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmovbdqi1SZNWfHZsGDlxzMs7tAqKfsLc3Ja43cXmJA=;
	b=i3hYpnn1D1+aQac1KLiTz+XjkSus0v9ntzv5NxmQZbpfBiNTbdnD8zGU6vMIsOpLVG2X
	 NPSOa91jnWMm6+B5aFXSFwL/Kmiw4VgZUKSDTqEGV+1ngz9dtO+H47vIOLyYH0m5LuW3B
	 5Bh2VgoQTfK9MROZBK80uH2+1+K2GlU0oYIy6esdDZNe+ypi/ym85zg2sLlMtgRc/xsCw
	 asPvu7AKnFKHVcohcnvskz7ttKvY23zICVqGK/ejRCNmd5FIDUI4O1QoxBh4jyzkm7+iT
	 Fd21a29QaKptPN10t93xlVER8I2XQy/LanhRSxx9xWMX1UNvNYC7La4WdFPnQa4Bvpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N776oFTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD820606A326;
	Wed, 25 Nov 2026 16:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N776oFTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6F91F000C6;
	Wed, 25 Nov 2026 16:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624188;
	bh=kmovbdqi1SZNWfHZsGDlxzMs7tAqKfsLc3Ja43cXmJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N776oFToDjXkMBTifhtAifALh41vU7aa+Cs9oqLClF86WXnCbB48G18x81CsgpWX0
	 ZtVFkbGIocGcecFF9geLNBF8kpFk4SL9PTMZRJAfMtR8aDucyxD4JHxnDSvLY1IXmf
	 FDb0O6Zxgj2QwhAZ1NqAdoaztXyp64QyRyMmb7us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/816] spi: Fix ACPI SPI resources using relative path
Date: Wed, 25 Nov 2026 15:27:40 +0100
Message-ID: <20261125143851.804078858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit 4825287f6d2346e9273f35a928d1ef40e68bc58b ]

ACPI resources can use relative path when pointing to other
resources. This didn't work with SPISerialBus resources because the
device defining the resource was not passed to acpi_get_handle().

Pass the ACPI device handle through the lookup context to also allow
for relative paths.

Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Link: https://patch.msgid.link/20261001153507.2011806-1-alban.bedel@lht.dlh.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2d0953ab69d3 ("spi: acpi: only look up the IRQ of confirmed SPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c5cd38e295f56..5f58df273dc7b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2628,6 +2628,7 @@ EXPORT_SYMBOL_GPL(spi_new_ancillary_device);
 #ifdef CONFIG_ACPI
 struct acpi_spi_lookup {
 	struct spi_controller 	*ctlr;
+	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
 	int			irq;
@@ -2722,7 +2723,7 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (lookup->index != -1 && lookup->n++ != lookup->index)
 				return 1;
 
-			status = acpi_get_handle(NULL,
+			status = acpi_get_handle(lookup->device_handle,
 						 sb->resource_source.string_ptr,
 						 &parent_handle);
 
@@ -2814,6 +2815,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 		return ERR_PTR(-EINVAL);
 
 	lookup.ctlr		= ctlr;
+	lookup.device_handle	= acpi_device_handle(adev);
 	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
-- 
2.53.0



