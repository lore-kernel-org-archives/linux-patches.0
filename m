Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618052;
	b=Mz3nwguRqOn5pVm9FU4xw5CzdlG/Zw6hPXtLZFZ0lx9Jx3VpfrYHUvtgEMDEIxIk3Aue
	 67VY85RwSDtdLwJtQqOkVK7UfZDAfnbmsbkSl+nqkPjYO1WO0uMmkTlX246HugknwM9rM
	 AhD0NS42d7mGp4swPVo1AAsUz5/e5tC5LspOnVTLKY1tccB51AjSFZzdTRJIjQRkZ6V2g
	 yVcgiBdw6YmHXctSbcafo7X3sGd/mJmlyXrgHpya3H+uHYcHcNuIU+6xrbecIbR098K2w
	 R6AMT2DymH/o5lfLErwF4D79i2PTMHQbsaWTQ2M8bx+Wn7NBcUiywOvdTGD3PNw61NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aSwOgYDBL6eN3iOm0IeuoCFODMXxf5AGA+SRyUlnXkw=;
	b=RHn1CPTFpCTXZj7s0i7BncLX+QnfELAt0RadFCxLQv0l3ITUP5y8zM4qS+O+8DBz79Co
	 nZ8sNAn4vm67/8vJL6yZJmkSwvI0IDgmncPp1efchS8zdJWC8gWn9/WsGxQhOA9f9xSKz
	 Yqo+qfmi1YcZbu4eqrCdvdXR5pizrbDC1p3XyOLzoLNjdvq9X9habnmG6DcY18P67+rRt
	 3Tq5VVA6s+XZu+Pbc9dRl/c8UBBUdGSXmgZwH+eMZinUUTtfsqeOWoGkYibbMjxlei234
	 uA5TH1H55akmOrL+GR7+DjQy0QgLpjqdq8+bfZ6Y7+JBUwqH/x/h/wwfafocHCsZz6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkLFGwnX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62684606A321;
	Wed, 25 Nov 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkLFGwnX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07FF1F000C0;
	Wed, 25 Nov 2026 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618051;
	bh=aSwOgYDBL6eN3iOm0IeuoCFODMXxf5AGA+SRyUlnXkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkLFGwnXzv+2Z3F6QlkK19VJ33J+YYqXiO/rLfUleDZQaHXtJsDXjPAdFr1bXw8dX
	 c7USpIT2KtXiikaBhavsPVdxqNJePYTY+RA9BS0Oc0bEDCf/1OBJxqlJsbJBjx+cqR
	 +v+0Hhy1ndRu1idl7Ctf9gYkNi9groyuTJ9m9UJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0120/1005] spi: Fix ACPI SPI resources using relative path
Date: Wed, 25 Nov 2026 15:24:18 +0100
Message-ID: <20261125143824.552999745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 172141650b648..e5ef3ca769d53 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2983,6 +2983,7 @@ EXPORT_SYMBOL_GPL(devm_spi_new_ancillary_device);
 #ifdef CONFIG_ACPI
 struct acpi_spi_lookup {
 	struct spi_controller 	*ctlr;
+	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
 	int			irq;
@@ -3077,7 +3078,7 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (lookup->index != -1 && lookup->n++ != lookup->index)
 				return 1;
 
-			status = acpi_get_handle(NULL,
+			status = acpi_get_handle(lookup->device_handle,
 						 sb->resource_source.string_ptr,
 						 &parent_handle);
 
@@ -3169,6 +3170,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 		return ERR_PTR(-EINVAL);
 
 	lookup.ctlr		= ctlr;
+	lookup.device_handle	= acpi_device_handle(adev);
 	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
-- 
2.53.0



