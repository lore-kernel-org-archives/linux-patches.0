Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC544AB91;
	Tue, 21 Jul 2026 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670286; cv=none; b=i+DGU6Y4EGeK67bGgtXiQrGWdNqW4pADJ30HMDER7uahOn7De/TjpmKt32sjSABJ33Gb3X855B44Rjs6oQaY9fpuatHIdBCOQGC2wbx7LablLC70SZeF+lQUGHQ6gDtu7Gvzw9Jq/x1wRML1M90aiHWq3GI1N3Bqojc9U85sLpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670286; c=relaxed/simple;
	bh=JMbZmDNEE8F3/RUsSXBR7NxHU4mf/ZTyUcgjX8clAOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZSu6Mbw4oRD9dB3bqErOHN/zdfaqh6cUE1xRSY1P0PJHKTQfEd4FtQtDi/5/2ZsQkaPIIgIJTFNfJP7X8cfv8yleEcqhDLTh7uphTXIFe1WhqMghneO5SbwC+BJ5L+nAsIJPlogcd3jGLHaAHa2JapTpW/8EWryUxKs31pB0Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdGNwvyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdGNwvyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1436A1F000E9;
	Tue, 21 Jul 2026 21:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670285;
	bh=DQRY0MlWGt8HLkH1qIvV3ccUOYJIm7UDbmmhc1rISPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdGNwvyTlns2ntHed1JtY3+8EkY7IYputQ+PlsoRVZi9BKqZ6dxJfXksvg0QuYYUG
	 uVPfvz/wZskVzCoBAJKplAk60/2tDhva2tICPc7hB238TIO2fB5+tEb+McB9FXTzB7
	 VVX8KeTPu/kA9WsSrkjFK96VyjUBZa8mGgLxvlwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 0874/1067] gpio-f7188x: Add support for NCT6126D version B
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152444.084863060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -559,7 +560,8 @@ static int __init f7188x_find(int addr,
 	case SIO_F81865_ID:
 		sio->type = f81865;
 		break;
-	case SIO_NCT6126D_ID:
+	case SIO_NCT6126D_VER_A_ID:
+	case SIO_NCT6126D_VER_B_ID:
 		sio->device = SIO_LD_GPIO_NUVOTON;
 		sio->type = nct6126d;
 		break;


