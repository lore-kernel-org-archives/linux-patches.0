Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705000;
	b=odp1Pca3WAeLgDdBAllZIu/dH4Bd4b9x7TPxTXqrJQZTZUBYd36BlE4FbLJ4RyYzN2Kg
	 jNx76vQ+vKSxHnIa/ALJd6Gb/aEFosZgsW5gjWZVfT4CtlHjnAKgwOYHdhCgJzytbP8yE
	 DE1XRjcEk8d1nP6FbTilg/OGCkc86lJacYNKdBbq5d3AYCOZc03A+Qc1sbT6yp8dB6Y9t
	 ylY3RXjANLNh/lFlOhDEdOiqcrNzIUetp57k7yrE4zweYn0bbEcH++GNcJ2LDS85ENKJ5
	 GByfinicb9fGq1PEgiBtWcBg4unafor4HytFo9Y1HVD+87x1z7yfZeys4CKTNByKimQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7hqtrm3MuV33QK/rDsdntADYDEQM1URpeSV742FV0uM=;
	b=kG1dVR8/mqj48dRX/StExrESMHf8JbCKAM1EgArZ7pgdhCMDV4BTo+FtJY7FqZkM4mKo
	 /YIUHq3LWLgsF8umwijNlJ6nbHH8F4M19Gll1PW9hFQf9bqGxZKjnPF4TiOEflRXP4USq
	 RRIVGLLv+DtVWxzp7otVBjzenR6ZGkqwaNVNL16dMRrYtsd7c2hRZ2Z3Sgu79zlCZQC1b
	 foBT92G958IdPSm4xHM5PJs/mgeiBSE9TnG9scX41b3LYU8NmmFobygS3zqLH/5/GWkwS
	 XF9MDi07Yh5fMG9LeKYTGzSWGjkxFp1JE2Hp8anY0iyAX6doFro0VHG9Gq3C87n5ZTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEOOjK5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC1C606A323;
	Thu, 26 Nov 2026 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEOOjK5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9021A1F000C4;
	Thu, 26 Nov 2026 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705000;
	bh=7hqtrm3MuV33QK/rDsdntADYDEQM1URpeSV742FV0uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEOOjK5w0IHC1dMKZs5oa33Rvx6/nennOPo9uGd8TzNQpOxN5MGNXALJASR1+p97l
	 sVndYq7ljMaagoGZcFNEb0J3KCYpVls/zaqiOOk37JjaR5McfaHF9tTVbZfde6FxLT
	 zNtgAry82RhccJ+3w9DxXOEPC3Ak8X+smosM5FOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/319] spi: Fix ACPI SPI resources using relative path
Date: Thu, 26 Nov 2026 15:36:56 +0100
Message-ID: <20261126144007.820187662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index b662a9a3961ab..56505af80ba80 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2272,6 +2272,7 @@ EXPORT_SYMBOL_GPL(spi_new_ancillary_device);
 #ifdef CONFIG_ACPI
 struct acpi_spi_lookup {
 	struct spi_controller 	*ctlr;
+	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
 	int			irq;
@@ -2328,7 +2329,7 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (lookup->index != -1 && lookup->n++ != lookup->index)
 				return 1;
 
-			status = acpi_get_handle(NULL,
+			status = acpi_get_handle(lookup->device_handle,
 						 sb->resource_source.string_ptr,
 						 &parent_handle);
 
@@ -2419,6 +2420,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 		return ERR_PTR(-EINVAL);
 
 	lookup.ctlr		= ctlr;
+	lookup.device_handle	= acpi_device_handle(adev);
 	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
-- 
2.53.0



