Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029652;
	b=FH5dIYYJ7+r6SGglN/XwTA3bcaln50F+ecFZRVVxb9e2Kd2juM/Gn5hdrMSOq0KLb0RX
	 rmDolORh7qVcNc2zGq5rwyStUEyTb6S0sK2OW+7v3CRxSFn1Avlhcpw/Ljhn0/EAguBBG
	 2oLMwJ+56gHRywUxsag9l7eAP1RsO0kh5/7LiONfLe+iFzJA0o5kmLw7gwdoL3rFA0qfD
	 uRKXb+l8zEMrBQZoNK0RFcIMyv2wKHx+/gkTRU6TS30b6XXTGBFPXOox4qRenU4pdwGAQ
	 BW5VtF+fm5CQDrpSFDOtnWFLnZjLCYnLxza2kHqHchKIbDShqAMU23As1OTPD8P6n8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EBkKDbp5VBf0LzQr/eN52+QxHLeniH5obpv2frr3h0c=;
	b=304GHMlXC8HE4Npt3N/FlQ6iCCdtC1udvRsrrj6VujM2sA9d2DBRNvZDEbUS7b1qYivi
	 ymsuG5BgLwBYOBnubtVPpyaLj41xZBwIe7XtXJJ3ueeGXhVCMLRAoFKQqOkHgIsIcE7Mo
	 sMoR8b4AFsHZY/xfoamYEGozbJ6LOB9LHnNUFDZbcY2HN2rjNKZUzhMYgKQyOfHYi5UG6
	 i2dpybOA1BQOUSSxmBYmKM2xTEkGev5K2LenPOKoTNw348q6G4u87ZPoqP0PEPEyPWJLz
	 N6BOpccyoeiB3mTJ6vm7T7/ZuFZm2AcXA96+47rzOVAC3O3rZG7rOtpzkw1iE9kjCqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iH6GFGw3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566B6606A32F;
	Wed, 18 Nov 2026 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iH6GFGw3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6051F000C4;
	Wed, 18 Nov 2026 19:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029652;
	bh=EBkKDbp5VBf0LzQr/eN52+QxHLeniH5obpv2frr3h0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iH6GFGw3mA6Gfje4e4KVDF1EJDoapzbWR5mT4WGP1VKvPQK/Wyk/ESVCnuPsdM0rC
	 oVVb/iylRyj9nV+NqAgPAHmPcTvQRFcqgQrofEsLi67J3bniJW2cmudyH55LQHBipx
	 DUyCn+NyvTw78HCOql+9+W+nZdlDj2ffhwSXFW2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0381/1756] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:41:48 +0100
Message-ID: <20261118150023.781413906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5915ab523e33057224a0240e27b88c6c2798b919 ]

The ata_scsi_remove_dev() comment misspells its caller as
ata_eh_scsi_hotplug(). The caller is ata_scsi_hotplug(). Correct the
reference, which predates libata's move from drivers/scsi to
drivers/ata.

Fixes: 580b2102327a ("[PATCH] libata-hp: implement SCSI part of hotplug")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260912101215.86413-1-kmehltretter@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0e309707f8828..9419df80f39b4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4932,7 +4932,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
  *	ata_scsi_remove_dev - remove attached SCSI device
  *	@dev: ATA device to remove attached SCSI device for
  *
- *	This function is called from ata_eh_scsi_hotplug() and
+ *	This function is called from ata_scsi_hotplug() and
  *	responsible for removing the SCSI device attached to @dev.
  *
  *	LOCKING:
-- 
2.53.0



