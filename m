Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2211465A4;
	Thu, 13 Jun 2024 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280192; cv=none; b=TU+iY/jIQZx+R4ZB8yXC2/Xmi+3p3uclf97QwwRARdOLmwTd59nsnkEj2yGXltRk6raFsIS/4LPYaiqxKD7wCAE8r5bawKL02iOqDfzqbiy+kjxnd5uDj+s7K804J8pj3HTC/UNhsJg7cezYqYdaYp3pJnEhOaPMadMzoyyaj0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280192; c=relaxed/simple;
	bh=fQnmABLythWs9w2vbhLfkqcF0ZmhCMzu93P8JAEnckQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAU9vzjYGHdZM8GLLKZIKI5mIh+fRl6Mzr6dhhZhJzURLMPDnfv/nLtYVpAoPz5EykziGvlfiIt8et4lLVUMQK5BMDEa1i0Yl5zNmcW6ZmW7y2fiE/lyHUIrDBAJWZL/TU/7upLc937MUXPK8E4s9VNFt5BGxRViDWEgv6GgacA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrqLgJNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrqLgJNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78B1C2BBFC;
	Thu, 13 Jun 2024 12:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280192;
	bh=fQnmABLythWs9w2vbhLfkqcF0ZmhCMzu93P8JAEnckQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrqLgJNxekJcfKfvIS+l47jI3bE9pLWyI9/4pFYcfYeNy87Y8ZLzXfRyG70FP6aqh
	 vKYnUpYybz3CTNG0jLAbNNtjMxeLJDzIRcq54WrqqxZvI9terBB4dwo7jaiiYMhawj
	 M2iHT0qNR/KGfW8tcZUueVbf55EuqeJzQKrmqAi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheyu Ma <zheyuma97@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 173/202] media: lgdt3306a: Add a check against null-pointer-def
Date: Thu, 13 Jun 2024 13:34:31 +0200
Message-ID: <20240613113234.418705832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2199,6 +2199,11 @@ static int lgdt3306a_probe(struct i2c_cl
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


