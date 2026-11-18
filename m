Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046852;
	b=iWR8l7cunZOi51NYPGwgNcgoW/eqNtlPKsPBgqXKgXTl1VaXFbTgo+AYpuhasFG8TmFo
	 c7a5GHxxg+hy5qWhYAeKQQmaIwbojf+jsViHK9LbtpU23N0RPGKCLaIFEXDbEiygK6xqc
	 loPiywtcLabVZgJoiULltK9E/grPdWp7tZ+8D/2nzSrv72npQ6ccGmEsM7mN57DN9qubL
	 ZzXWinmK8mlHt1wJJ7n/nfiOXqZOqdSNrfhI5sgaow6MAl2OoGvWF0SQgeR/W7qbAK+QC
	 JdRKZ5XIgtm1dAeDzUBxfhkkFMIne/5+gBsGotkAR/pYRaMC6pM1st8FmTHsvDamhMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QcodqjM5VgQmIH4d6FuvuE4IbfdrrWlJlDdk8IP1tOY=;
	b=mqbiOQKfPExnbimBTB5is5y/kyBwHWTpKkCRJdgq52Mr3KRBC0ZersdNJ6hCthN6+vNc
	 0x0UYJlai36T3gQfknUGL1j5UOtqIRl3UC5m9v6Jd1XrYsREGzGbOHzmjwQnNxpwh5OjB
	 3S0E36tqfB3SvL0+MameaWiJxxsljFabdd60WcsO/VNIANmLf2Zui8FkiLOvW+3Q3AlgN
	 LKbXyMVnKO3DH7z0nOTBVUttsHdcOioAHt6hrQsBYyh2wQOpdfRDKALFjSMK/QlxaD4IJ
	 mYSNxuAWAs6ABA67ZcBwl+2w0sjd1VH7BCwaFRjcQKWnYL+ciDLf0PTY3UEvIsUQNQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GhVzeFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6C5606A31C;
	Thu, 19 Nov 2026 00:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GhVzeFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D1A1F000C4;
	Thu, 19 Nov 2026 00:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046852;
	bh=QcodqjM5VgQmIH4d6FuvuE4IbfdrrWlJlDdk8IP1tOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GhVzeFcWlJothoULIVzMiJ7iR8O4/bUrXAW/cVslRHq1z5mS/I2zvx8/Hu/BJVOW
	 jwzzL6QnqMiSO/nY0tsVvIFw7VOgp/UwdJE3PaZi7hjK65ROcOuFLkEa84y8zjk6P3
	 7XyYAZNwOkn+Cbe8/ZxNsvXXJFKI06kqQs4uXct4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Aishwarya Kothari <aishwarya.kothari@toradex.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 6.1 1430/2857] media: davinci: Init async notifier after registering V4L2 device
Date: Wed, 18 Nov 2026 15:41:04 +0100
Message-ID: <20261118150252.801516849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2c62a9b8e4d5515638dc2f5e31969675b98c3de0 ]

Initialise the V4L2 async notifier after registering the V4L2 device, just
before parsing DT for async sub-devices. This way the device can be made
available to the V4L2 async framework from the notifier init time onwards.
A subsequent patch will add struct v4l2_device as an argument to
v4l2_async_nf_init().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # imx6qp
Tested-by: Niklas Söderlund <niklas.soderlund@ragnatech.se> # rcar + adv746x
Tested-by: Aishwarya Kothari <aishwarya.kothari@toradex.com> # Apalis i.MX6Q with TC358743
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> # Renesas RZ/G2L SMARC
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: b00fbdad64d4 ("media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/ti/davinci/vpif_capture.c  | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/ti/davinci/vpif_capture.c b/drivers/media/platform/ti/davinci/vpif_capture.c
index ced6392c46d2e..7592216177b50 100644
--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1609,18 +1609,12 @@ static int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
-	pdev->dev.platform_data = vpif_capture_get_pdata(pdev);
-	if (!pdev->dev.platform_data) {
-		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
-		return -EINVAL;
-	}
-
 	vpif_dev = &pdev->dev;
 
 	err = initialize_vpif();
 	if (err) {
 		v4l2_err(vpif_dev->driver, "Error initializing vpif\n");
-		goto cleanup;
+		return err;
 	}
 
 	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
@@ -1647,13 +1641,19 @@ static int vpif_probe(struct platform_device *pdev)
 			goto vpif_unregister;
 	} while (++res_idx);
 
+	pdev->dev.platform_data = vpif_capture_get_pdata(pdev);
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data. Giving up.\n");
+		goto vpif_unregister;
+	}
+
 	vpif_obj.config = pdev->dev.platform_data;
 
 	subdev_count = vpif_obj.config->subdev_count;
 	vpif_obj.sd = kcalloc(subdev_count, sizeof(*vpif_obj.sd), GFP_KERNEL);
 	if (!vpif_obj.sd) {
 		err = -ENOMEM;
-		goto vpif_unregister;
+		goto probe_subdev_out;
 	}
 
 	if (!vpif_obj.config->asd_sizes[0]) {
@@ -1696,14 +1696,13 @@ static int vpif_probe(struct platform_device *pdev)
 	return 0;
 
 probe_subdev_out:
+	v4l2_async_nf_cleanup(&vpif_obj.notifier);
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 vpif_free:
 	free_vpif_objs();
-cleanup:
-	v4l2_async_nf_cleanup(&vpif_obj.notifier);
 
 	return err;
 }
-- 
2.53.0



