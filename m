Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE971386DF;
	Thu, 13 Jun 2024 11:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279295; cv=none; b=QH+dwYLEJvDuVOKea/PWcQB8i3ITJW4UMPpaH4NyN8f/z1DmFgnXX5PMwJ7/ztrQc7V0W4cY0KcTKAgAJCSEF1TfNQWll6rUVuQnQrk7Xz2K2kVr2YCT8ULWLhNt/+ue+CnabAieyuw8e7Im5Ye236ddsCR9Ay+AfCbzS4P+P9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279295; c=relaxed/simple;
	bh=dB36BTEh36BJmXU+LGExqPXY1E9lUYNNTpdGEf0p/nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxEEWDSpyWZuu1ejIuPoUQQr1faP/W1iwpDlbhOAkI7ZZ4dMsAjPjY4eGIWOtG6s82fmeK5G9vTAYM8XanDjkSgWDi9ueS0Diu+WglN+xt270tyrk+j0PBLeCiglUtTdl+NO+8aRn/Scr0zptJsz4fadeRrr1NUhClLf1m4RSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3cEW5ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3cEW5ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DF4C2BBFC;
	Thu, 13 Jun 2024 11:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279295;
	bh=dB36BTEh36BJmXU+LGExqPXY1E9lUYNNTpdGEf0p/nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3cEW5ipNoYpka9O3vb8Y4+YraDdINSPEazFzDOHOepYIojexamxSm5mF9R9swzdp
	 0CA/YsXduomcPR2bgqtHVx8bRj8gnGq4oBMeRtqMOaBjvRSJLLUtG2wimFjDbLA3ld
	 AjNMnb7qN+ZwmvkPxqN6Kkv0Leu+dOPROPNT76sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheyu Ma <zheyuma97@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.9 008/157] media: lgdt3306a: Add a check against null-pointer-def
Date: Thu, 13 Jun 2024 13:32:13 +0200
Message-ID: <20240613113227.724450994@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheyu Ma <zheyuma97@gmail.com>

commit c1115ddbda9c930fba0fdd062e7a8873ebaf898d upstream.

The driver should check whether the client provides the platform_data.

The following log reveals it:

[   29.610324] BUG: KASAN: null-ptr-deref in kmemdup+0x30/0x40
[   29.610730] Read of size 40 at addr 0000000000000000 by task bash/414
[   29.612820] Call Trace:
[   29.613030]  <TASK>
[   29.613201]  dump_stack_lvl+0x56/0x6f
[   29.613496]  ? kmemdup+0x30/0x40
[   29.613754]  print_report.cold+0x494/0x6b7
[   29.614082]  ? kmemdup+0x30/0x40
[   29.614340]  kasan_report+0x8a/0x190
[   29.614628]  ? kmemdup+0x30/0x40
[   29.614888]  kasan_check_range+0x14d/0x1d0
[   29.615213]  memcpy+0x20/0x60
[   29.615454]  kmemdup+0x30/0x40
[   29.615700]  lgdt3306a_probe+0x52/0x310
[   29.616339]  i2c_device_probe+0x951/0xa90

Link: https://lore.kernel.org/linux-media/20220405095018.3993578-1-zheyuma97@gmail.com
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/lgdt3306a.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2176,6 +2176,11 @@ static int lgdt3306a_probe(struct i2c_cl
 	struct dvb_frontend *fe;
 	int ret;
 
+	if (!client->dev.platform_data) {
+		dev_err(&client->dev, "platform data is mandatory\n");
+		return -EINVAL;
+	}
+
 	config = kmemdup(client->dev.platform_data,
 			 sizeof(struct lgdt3306a_config), GFP_KERNEL);
 	if (config == NULL) {


