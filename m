Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEA4145359;
	Thu, 13 Jun 2024 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280333; cv=none; b=gqlO8+Q3uPZngXWb9ObuBPk8M7OcXowBy/VtgKzq83dQK5IowqZan1PxNbA8uY5oB4c8cl5Hc97f1RMMX8co3kbcwKTUnKw/+51GrISSoTmhoE00lysUFu6Zy6IbQufXbF91WGZV5z+K2FMUxr3DlsaxzS7g7ohhL80SLd7c6Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280333; c=relaxed/simple;
	bh=5NFFBSQNtCzslocE2/8CsAt30RQRYshd+1uFV9Z7Eyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbYSCk26TQwn/plF7u6JL38SLS6tNDPSbYFf8ZLYRdmNjGF5+f50msdKr18r6hSku1+PqX8xn0Vo3VNAsMzx4Y8XYAr6psghf0k8NWN8ZeYDROWCCwiH2SgVX8JqrIuyst7o3xLs7Wti1x4oyDAbHkrh+8ynlB6vTFgwgBfb85g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6MraaKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6MraaKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A3BC2BBFC;
	Thu, 13 Jun 2024 12:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280332;
	bh=5NFFBSQNtCzslocE2/8CsAt30RQRYshd+1uFV9Z7Eyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6MraaKia3Yd9bJd/zKl3OAAlc2SrdQZ//N8v6hSLTLAG31UjVhRzDodl+73a0aQ8
	 3dlph2kE4HisTbstbZ1tZkA3rvzolVdtWjB/wunGOw+Iob43i11gwTEjNuBiIoD3Vt
	 YM1PC7zcRq9nl9T9+VXGsnkzNLZaoNNTzNRq1vYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheyu Ma <zheyuma97@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.6 018/137] media: lgdt3306a: Add a check against null-pointer-def
Date: Thu, 13 Jun 2024 13:33:18 +0200
Message-ID: <20240613113223.997615869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


