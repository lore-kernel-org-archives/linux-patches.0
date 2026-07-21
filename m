Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D642315D53;
	Tue, 21 Jul 2026 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659222; cv=none; b=sOWSTW/7ABZhsRQ+dAU+du1jrUxIXGfxewRQD7pX75FkVQTznMTqOciCVAdRSI4sAYZUm1HvO2ZfcxNU4NyXSoFSZ1QGQbU6yHGCVvQSSWh2uhhK5LYD0U2S26Pzten04Z7bysX+HzxA+9RgY91dhOYvEW38KL6IwP7+3nKvppI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659222; c=relaxed/simple;
	bh=eycF48HdWzCAapykaVItEu4t1H7lKbHg23auBjZ8iFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABqo6/83sUnxugb8qQbluP8ktuezqu5yG1OCqkE8TroDtjfDcB0xTG9zKgxmD8psvfxiwYFGWk2bERSUc9RCVDkeRlHHX/nRSKep4awN1l+ocB8zv4dSw2d1fs0LY2p8bfVaArEZSeod8rvtH7GRuFEZvYh95g0DeoboO3i3ob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8zMAE+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8zMAE+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42C81F000E9;
	Tue, 21 Jul 2026 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659221;
	bh=90v+S5fgTbDy5nQGmtwqhdZBeTq43c/TcXhNH7Q63I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8zMAE+H8FAoUM3hAqxye6vTHvhtRV3fey7/izBiwLD51SvqDbBY1NBlduJhRKfY1
	 kdXOaxkv8aQJDyvWC3NOFr7iWnW4I5yuLGJQpIpuylSYaj8ZBQE3nLwAX6kIsrr9c8
	 WfKSCTOgdjSnOAJ3QQ84zUjiJny0JrWd9hd8h4Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 1396/1611] gpio-f7188x: Add support for NCT6126D version B
Date: Tue, 21 Jul 2026 17:25:12 +0200
Message-ID: <20260721152546.842500615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit 9a6c0b6ea12746d50cf53d59a7e05fd83f974bda upstream.

The Nuvoton NCT6126D Super-I/O is available in two hardware revisions.
According to the manufacturer datasheet revision 2.4, version A reports
chip ID 0xD283, while version B reports chip ID 0xD284.

The driver currently only recognizes only the version A ID. Version B
only contains hardware fixes unrelated to the GPIO functionality, so it
can be supported by simply adding its chip ID without any other driver
changes.

Fixes: 3002b8642f01 ("gpio-f7188x: fix chip name and pin count on Nuvoton chip")
Cc: stable@vger.kernel.org

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Link: https://patch.msgid.link/20260629-gpio-f7188x-nct6126d-version-b-v1-1-a06226c02a2d@bootlin.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-f7188x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-f7188x.c
+++ b/drivers/gpio/gpio-f7188x.c
@@ -48,7 +48,8 @@
 /*
  * Nuvoton devices.
  */
-#define SIO_NCT6126D_ID		0xD283  /* NCT6126D chipset ID */
+#define SIO_NCT6126D_VER_A_ID		0xD283  /* NCT6126D version A chipset ID */
+#define SIO_NCT6126D_VER_B_ID		0xD284  /* NCT6126D version B chipset ID */
 
 #define SIO_LD_GPIO_NUVOTON	0x07	/* GPIO logical device */
 
@@ -564,7 +565,8 @@ static int __init f7188x_find(int addr,
 	case SIO_F81865_ID:
 		sio->type = f81865;
 		break;
-	case SIO_NCT6126D_ID:
+	case SIO_NCT6126D_VER_A_ID:
+	case SIO_NCT6126D_VER_B_ID:
 		sio->device = SIO_LD_GPIO_NUVOTON;
 		sio->type = nct6126d;
 		break;


