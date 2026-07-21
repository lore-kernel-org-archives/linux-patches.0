Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD99401A18;
	Tue, 21 Jul 2026 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654967; cv=none; b=n9QR2qmNPZlgFyY+glLspSiBWvakC38uWln94bWEhGiX6t2I16d/wOKVCOSfu5fzKhrtzrFoOji5zKNcgUQDewWwBmyDs6N8QKjxGDXoFK4oyk0uqMid8ZtbB+LUZRjOkishOobnS8bb1CbPEi2XG9cURc5XA0QeQgoASPOlmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654967; c=relaxed/simple;
	bh=6WZjWikrdKcmCyT/gvftNH3VyysXzM9JbFXblRGb7wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpdPwIzOAeTSTT0KUrukmWWakC0nqYwTxP8Rj2xzAcrqKzqmgVtNa1BJKFzCW+ZYNjRD+Zm0JGmmwcqjs0l0iy/kRS8R51/XZRziww+i9BFhDEVNvdF4gZcuiBRfZK0jJ4XopJw3Ejv36DMD9tauLu+sSc7Ncg2j9gU//JFhQ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXBBNxKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXBBNxKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC931F000E9;
	Tue, 21 Jul 2026 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654965;
	bh=V1oeOs/OIsDqvvNj5RUU03YlHJUj8mOrzukIAMRra2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXBBNxKr7uo3rN3C+6JQzv0QewpUT+9G6y1Z7gjBAcPoSY7EkX7GcSMPWe+uLhyG9
	 0WXbJq9YmrSLzBmNVmRJnYSBOdLR4WGQGIVjaSwgJEU3QWROxLHxzqI3HXyF3xjLFF
	 qvI8Smjw0JNUwdNQdO+h41RSJjPcYWqxx5S1FAdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.1 1906/2077] gpio-f7188x: Add support for NCT6126D version B
Date: Tue, 21 Jul 2026 17:26:19 +0200
Message-ID: <20260721152637.677576011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


