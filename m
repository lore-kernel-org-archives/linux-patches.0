Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621117;
	b=MJgL5wGtAUApz/k4uw+ZN5nKnv4rckwToQxsAA90fTAMgX2QUa1Xj5ywUtpPaTKo8t/2
	 N06tL4Ckw+ty3shUciaz+BMxz6oUGcgFDKexzio9gwoI93p3iss1jtEaJMC+DY9Ghp515
	 pz7eF0BfvhtK/fsMTgDeEuVC95dwFUkWP5RpUfnntFJjaI36s8vo4MnRqgS2IfhGaberP
	 p1PHi/m+LMmtBolmy3gSjmnvM6axX42IarGgW/lHyK4Lw4wFdjO+dzixyHWpdi0+bDvU6
	 HK8dBRZHLqpZ7udz/cJjBLbuvb0QdqYZijqFkS1qTrqdjBWZVKqCuaOG1kEGpETG9nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LTRUqdq8Ls4idjpZkuwbTg5J1QDbme+YRa36g3Xq7kQ=;
	b=ri0OYDsPKgMyTwj5DvRxPeEftkRDkQwbzDznOhUUjZ/FK9h89Q2IE3D/RaUTr+rapdIA
	 HE6ybqwRPUxYHVFNpBiZUP79lkDxXq+s5PxIDeOgLfj9hnMcDhJseIx+JI911+Q0/s6Ec
	 npJUXcEFdsHgojHRfk+t9S7AnU3oMQGUyVzb3XZcF2THdbF635DFx/8Rhn+hrJu/jt292
	 DXTJYIyzF9j/2cq+1o1XphGcKRyOxBdhrz4iCQ9tdMP0j5MExAJtPinVevAeA2VFXr6k3
	 5S4DQlibqeKk22aop83gPknWRdvBJ/NSZCfRLktddmQdMg7ioXepySd2DIB33bhtk6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0sHJ8NX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947EC606A326;
	Wed, 25 Nov 2026 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0sHJ8NX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60501F000C6;
	Wed, 25 Nov 2026 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621117;
	bh=LTRUqdq8Ls4idjpZkuwbTg5J1QDbme+YRa36g3Xq7kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0sHJ8NXW6opHvRPttGVD8XrNLj+AFLPqK2lY2/KrMeRGXX7cDpp4nfzwpjWyiYhl
	 1gXUPTQ1nNi1YPRfu3FEzQw91mUQuaFAOrxUtCUQo5ime2KPiNa488V8/l5yxBM8iD
	 RzlVWuG4l07vPIS+bzBf8saM9Dl6OJ6v7Jc6O2ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/990] spi: Fix ACPI SPI resources using relative path
Date: Wed, 25 Nov 2026 15:24:55 +0100
Message-ID: <20261125143825.085409065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b8db8f5fd285d..b447907fba508 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2601,6 +2601,7 @@ EXPORT_SYMBOL_GPL(spi_new_ancillary_device);
 #ifdef CONFIG_ACPI
 struct acpi_spi_lookup {
 	struct spi_controller 	*ctlr;
+	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
 	int			irq;
@@ -2695,7 +2696,7 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (lookup->index != -1 && lookup->n++ != lookup->index)
 				return 1;
 
-			status = acpi_get_handle(NULL,
+			status = acpi_get_handle(lookup->device_handle,
 						 sb->resource_source.string_ptr,
 						 &parent_handle);
 
@@ -2787,6 +2788,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 		return ERR_PTR(-EINVAL);
 
 	lookup.ctlr		= ctlr;
+	lookup.device_handle	= acpi_device_handle(adev);
 	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
-- 
2.53.0



