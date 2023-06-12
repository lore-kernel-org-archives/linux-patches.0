Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC9D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6319DC4339C;
	Mon, 12 Jun 2023 10:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566895;
	bh=tBAm1pdF+MbLEALDIee0j9nu1ry5/x2Bf4519oKv0Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AYqdZvBJnio80aCTismj/ruQrT4x3ip5pgDPSWzGFVwpVAqnmbQYEKzTynmRP60B
	 2iUOXd5sAnM/pxoi1vY+lQQbwM6C1WU3KnhbB1Q//RX3AzQ9QvbTkPvYKGJgkUjxPv
	 hgPrJyOurgRBKU79QcVC74OvCa+MczOQQtyvOTpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Weigand <mweigand@mweigand.net>,
	Alistair Francis <alistair@alistair23.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.3 072/160] Input: cyttsp5 - fix array length
Date: Mon, 12 Jun 2023 12:26:44 +0200
Message-ID: <20230612101718.310655587@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Weigand <mweigand@mweigand.net>

commit 529de2f1ca3f0898c0d905b7d355a43dce1de7dc upstream.

The cmd array should be initialized with the proper command size and not
with the actual command value that is sent to the touchscreen.

Signed-off-by: Maximilian Weigand <mweigand@mweigand.net>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Link: https://lore.kernel.org/r/20230501113010.891786-2-mweigand@mweigand.net
Fixes: 5b0c03e24a06 ("Input: Add driver for Cypress Generation 5 touchscreen")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/cyttsp5.c b/drivers/input/touchscreen/cyttsp5.c
index 30102cb80fac..3c9d07218f48 100644
--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -560,7 +560,7 @@ static int cyttsp5_hid_output_get_sysinfo(struct cyttsp5 *ts)
 static int cyttsp5_hid_output_bl_launch_app(struct cyttsp5 *ts)
 {
 	int rc;
-	u8 cmd[HID_OUTPUT_BL_LAUNCH_APP];
+	u8 cmd[HID_OUTPUT_BL_LAUNCH_APP_SIZE];
 	u16 crc;
 
 	put_unaligned_le16(HID_OUTPUT_BL_LAUNCH_APP_SIZE, cmd);
-- 
2.41.0



