Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EC539734B;
	Fri, 15 May 2026 16:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862149; cv=none; b=cIFPLV629b1QzZ9jHgvXVKhJA6T7oKQTTPdvST9K7VORnF1VNaQ87TEzayaj2uf7SephaZsDbjgWYYu40rWvsQ9fMyaK5HLKIvZ3IPM8oArCPkeDyhjZw5tNzh+1cxtUZu27ywZ9A6ESgSj8HEqVG4OgJVt/lw3bphnBvQiKu/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862149; c=relaxed/simple;
	bh=msmO4KXhcpCuQKvAdu0xpVFp1pRqbxZrxgNorRtr9UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVaGerh11aI1X1K1Ev7n5rMP0cdvKlKkm6jVv2jrLZ4L3JlrjbNlkoV8nQ7/F0QVfP1fuw0bHCLitIJHWawJc+4D9JguiCQHjLg+4N8bhg7PgLglEAtQOv0+wvC6FWBPAQSph1I9m9KsXNk4HQyOzF6J34L9nnHy2vi4mhR/X4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeZFU0Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeZFU0Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD68C2BCB0;
	Fri, 15 May 2026 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862149;
	bh=msmO4KXhcpCuQKvAdu0xpVFp1pRqbxZrxgNorRtr9UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeZFU0OkGp6YGIfiMQGSmtLjY6x6tBE3lnz8zT8qK/652MMGv12a/mp1T8IIr7O3C
	 yOZW+PR/EpSqOXiUDaMN2GZ7TgDwxXOOQkh560n6r8ligwvoGfhrJYRescYu6kvdlU
	 Zmxw3CYgVpM4g8WrJ6jEX4gJZKPGEvR8UWaVhbfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kory Maincent (TI)" <kory.maincent@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 127/188] drm/bridge: tda998x: Use __be32 for audio port OF property pointer
Date: Fri, 15 May 2026 17:49:04 +0200
Message-ID: <20260515154700.083522006@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent (TI) <kory.maincent@bootlin.com>

commit 2a46a9356ba7b1bdd741c8b41e5374edcd960557 upstream.

of_get_property() returns a pointer to big-endian (__be32) data, but
port_data in tda998x_get_audio_ports() was declared as const u32 *,
causing a sparse endianness type mismatch warning. Fix the declaration
to use const __be32 *.

Fixes: 7e567624dc5a4 ("drm/i2c: tda998x: Register ASoC hdmi-codec and add audio DT binding")
Cc: stable@vger.kernel.org
Signed-off-by: Kory Maincent (TI) <kory.maincent@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260428090457.121894-1-kory.maincent@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/tda998x_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/tda998x_drv.c
+++ b/drivers/gpu/drm/bridge/tda998x_drv.c
@@ -1697,7 +1697,7 @@ static const struct drm_bridge_funcs tda
 static int tda998x_get_audio_ports(struct tda998x_priv *priv,
 				   struct device_node *np)
 {
-	const u32 *port_data;
+	const __be32 *port_data;
 	u32 size;
 	int i;
 


