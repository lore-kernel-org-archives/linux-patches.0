Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BC6143878;
	Thu, 13 Jun 2024 12:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281498; cv=none; b=u15ktLcbWoiCtoJ8ExeFlEKcxeZ/myqiD1hH8jtVBILRszoSUhyXRANQLMiYs/nLWtSmSY9GaGd498OeJCW+XAY/4AuBkL8gUZeHUsC7q/+3IWayAXzGAnWc3M4y/PyAdP8sH8y7zmMAbIx5gOaXjcuBGP+PcpMpFZVpJRGW9uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281498; c=relaxed/simple;
	bh=5FZ1wdKSzBEcwa4120FtmfMzrS9t5YboVwFVLLjg59A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0CnraLp9No16sHTBXyVW+DPciYd2icNTfhGooUWCqpUD+jtoNwfLRWWYuVPzLlIwigFUDQXykAjgKdbftnjdPfwWuekMr5hBnL+EdwNhr1o/JjCRJDuRgixtJwIeJzg1nPgw3+EaEcwXD5/N3SaCG+soeHcRwsP5JfvFWZnu/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye5/u8iG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye5/u8iG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84ECC2BBFC;
	Thu, 13 Jun 2024 12:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281498;
	bh=5FZ1wdKSzBEcwa4120FtmfMzrS9t5YboVwFVLLjg59A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye5/u8iGetQTZPGDG1SM1SKQyc2r0CKHjiRz1EUJxC29C2sO+CvfcfJRFbzLVLa+w
	 +hMOv9nD4+xir6Q/ZgdpIXv0DbewSTL6IswPFotZJJ2gicGta48SYm80nJNaPfFOkQ
	 7Xp6F8qz7M8QHree/IOBSYqg0H1ZZVuY4VcnLnOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheyu Ma <zheyuma97@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 276/317] media: lgdt3306a: Add a check against null-pointer-def
Date: Thu, 13 Jun 2024 13:34:54 +0200
Message-ID: <20240613113258.229010631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2213,6 +2213,11 @@ static int lgdt3306a_probe(struct i2c_cl
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


