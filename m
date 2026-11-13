Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591472;
	b=Doe1Xa0vszjuy5zU/B2rDVlyqBa0QPTkODy+aP+cQTjCv4hfChuULxkqdRxy8vv8jC/e
	 89lOX+oeWw6lqUmnJO/vRUKOF7RAPgd8ANxM/ib4k5XKjWIA4XIXW8HOkn9EKaS46fokc
	 nTDCCTm4Cf4kZhNLPk0onLvPY1IdGrCbIuvRIQ49wqk7i51HA3w/D3rJPG5l/3wTxUiyb
	 VG2fBxbPghrxXG6mKGMzHwVyWL4HI6FtIkVL21R95kB46R4nXeSqcMuhgGh8E/pCkwhmU
	 yVmPWiTBojFPLKecsRMLAe8a8/anB80QGfpAryfmyH8aTwDxDUF+QZjxWhOd0rdYRrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29SEUTKuPmPl0k19Jkhug/1XkvRmPYtp2Za/uSSpPn8=;
	b=avBADc9tPs2NdQfiF1dPZoWsrUc+e0qqKqyn8YyYOOD3ML4iMR7VipYoYeh+cDZKT/Yc
	 VXe6ja0nmcLHS7u/DgYY9lhViCzF+eq8CMWQUEM7bKF2gQUR7bVHHNdUcTRP6x7M0HD6a
	 l04ZZFHrKKCvbm+51RyO6CAWE5hwBfXOhfvdqTx7/4MSgc1QuzxzHD3AjkM2Fjcb2wxRD
	 p0sTZXdvXqju/S7cYf95n4WHY+JfAC4x9dBcHnvwkebzoGUys2VveiW3BnJccGbUjZunH
	 39d6IAg/DlVxiWFEoprSrTlA/IfZBPdw6YIp7PORJfNfw48Clp/2hwyuwyvWv61n1Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ohl6Tkbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6782F606A88E;
	Fri, 13 Nov 2026 17:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ohl6Tkbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68E11F000C4;
	Fri, 13 Nov 2026 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591472;
	bh=29SEUTKuPmPl0k19Jkhug/1XkvRmPYtp2Za/uSSpPn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ohl6Tkbr/5tuVemg3qp1n2tRdnzSnhK6VT52hxoSxw5AuKgnXopzmz3FAPIrpcbTn
	 WMj8l9RO/MOqVZMK7vtahR9N/bJpqcdiq6W8BxuFCCKPerA9U+o2qopAhqbxD85nUj
	 0+eBBPedii4lBej4/jO19jVX0EkCuArJAUxX5guE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 519/670] ata: libata-eh: Rename and make ata_set_mode() static
Date: Fri, 13 Nov 2026 10:51:23 -0500
Message-ID: <20261113153829.521148831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 6ba4d05c1425fe220d95395b4485443ce895bb95 ]

The function ata_set_mode() is defined and used only in libata-eh.c.
Make this function static and rename it ata_eh_set_mode() to make it
clear where its definition is.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250703103622.291272-4-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 96fdeb7e3fd8 ("ata: sata_inic162x: remove dangerous broken driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c | 9 +++++----
 drivers/ata/libata.h    | 1 -
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 32ec1cfd648e3..1cf737f17d0a3 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3248,12 +3248,12 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 }
 
 /**
- *	ata_set_mode - Program timings and issue SET FEATURES - XFER
+ *	ata_eh_set_mode - Program timings and issue SET FEATURES - XFER
  *	@link: link on which timings will be programmed
  *	@r_failed_dev: out parameter for failed device
  *
  *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
- *	ata_set_mode() fails, pointer to the failing device is
+ *	ata_eh_set_mode() fails, pointer to the failing device is
  *	returned in @r_failed_dev.
  *
  *	LOCKING:
@@ -3262,7 +3262,8 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
  *	RETURNS:
  *	0 on success, negative errno otherwise
  */
-int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
+static int ata_eh_set_mode(struct ata_link *link,
+			   struct ata_device **r_failed_dev)
 {
 	struct ata_port *ap = link->ap;
 	struct ata_device *dev;
@@ -3900,7 +3901,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
 		/* configure transfer mode if necessary */
 		if (ehc->i.flags & ATA_EHI_SETMODE) {
-			rc = ata_set_mode(link, &dev);
+			rc = ata_eh_set_mode(link, &dev);
 			if (rc)
 				goto rest_fail;
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 4b3e246227e68..898d5b368d82f 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -199,7 +199,6 @@ extern void ata_eh_report(struct ata_port *ap);
 extern int ata_eh_reset(struct ata_link *link, int classify,
 			ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
 			ata_reset_fn_t hardreset, ata_postreset_fn_t postreset);
-extern int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			  ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
 			  ata_postreset_fn_t postreset,
-- 
2.53.0



