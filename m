Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019688;
	b=1/beu4dUtLLRnSa/9Fi03VITwIB3Is1pAkuWqMA04oAfXjZDero2TkPNxQTQCknQvRHf
	 Mre0e07cFnrQLQHkXcl+o0EsRRx0Wv/fGVjtg7RZAHtxUrOodSRUC+9jFH/JI/YTPQKtX
	 jGEnxAly0XH36aCnHJ4HVUDQu7Hb4R/POx1XvwMchlLq+DGRPEXZekWy8oBBHLCog+znC
	 K/yfLToyvnWKp+UySji46mklSn/Uol4oRFxuH0i0yQevgDOTZmjJA+Bw95r3hDTnIumrP
	 enBxgcxwl2GLowl9ErQwEhsiW2T+l8EFDWnILbCt4heZUEBn2lVdR+TGfIDntYh0mDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ngeo5AlL7vfDta2IRXIJ4vIvJzUArdJbznlhIQ/vNMs=;
	b=vPlyUX63jnnIB67dv9OYtFRGlCPRsExExBAks9zAjB033u50FozAXXsq5dSXAyzJwGHX
	 GAfP7vGVBJFaDRcH2PGQfxW0SVZaLnEAvjomaWMD1YBtLGweZrLtab75eiREsDbwwx5zU
	 J/Yo+lTOIdYJ6zRKkIoUBDgFADkHgJbuM5hCxwCUftOHSXUquX8Yv2I2WBKa/Pwf40pLo
	 RUDE090ZKCW2xaDsRPeGGmdShB0rTPj85VyGFkDPYpjZ88/BhC7a/LjEUXPRfyYP1CJ4z
	 k0zvja/miu6Mxnb2FGYLNq5q9o26YwQuKrg4QE2EutTFXRAu5F5SKNEQRZVCPOTJnow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mXa9SfOF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BD9606A32F;
	Wed, 18 Nov 2026 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mXa9SfOF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EFE1F000C4;
	Wed, 18 Nov 2026 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019688;
	bh=Ngeo5AlL7vfDta2IRXIJ4vIvJzUArdJbznlhIQ/vNMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXa9SfOFbjOtcYoJQjdA03siltNqoTvznd53J07FUHdVm6xTtWjvu+SadEPl/2/2I
	 L9CPvdOm3moYMr3tQ2rir4FQ9n5LoCXwVNiLYCxZYzEZjgWXQ3bK6FbmC8IpX1jcZb
	 1ec02dZfsI7gXuENN45Am7noIEuefJ5qejmRHfDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dale Whinham <daleyo@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1685/2651] platform/surface: aggregator_registry: Remove sensors device for Surface Pro 11
Date: Wed, 18 Nov 2026 15:48:45 +0100
Message-ID: <20261118150348.342606477@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dale Whinham <daleyo@gmail.com>

[ Upstream commit f1db1b80190b6a9f96e1171e2d7eac51ed4e28ca ]

Remove ssam_node_hid_sam_sensors as this device is not present on
Surface Pro 11. This fixes a probe failure in dmesg:

surface_hid 01:15:01:06:00: unexpected descriptor length: got 0, expected 9
surface_hid 01:15:01:06:00: probe with driver surface_hid failed with error -71

Fixes: c4a069095395 ("platform/surface: aggregator_registry: Add Surface Pro 11 (QCOM)")
Signed-off-by: Dale Whinham <daleyo@gmail.com>
Link: https://patch.msgid.link/20260918-surface-pro-11-aggregator-registry-fixes-v2-1-c4ed9335814a@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index d37a7e4c6b02a..82c2144e10ec7 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -415,7 +415,6 @@ static const struct software_node *ssam_node_group_sp11[] = {
 	&ssam_node_hid_kip_penstash,
 	&ssam_node_hid_kip_touchpad,
 	&ssam_node_hid_kip_fwupd,
-	&ssam_node_hid_sam_sensors,
 	&ssam_node_kip_tablet_switch,
 	NULL,
 };
-- 
2.53.0



