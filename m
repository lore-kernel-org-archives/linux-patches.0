Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058102;
	b=a8ZCs0dc17pamW+vaUhR+ApBVOrqZXZV8OUogCFM8cEjCJMiwdavqUesF4Di/LR/o7Yv
	 LEZLE5cubK98vjWx1gvhTlQ7FK6zCzcLzHtdlxugOEP1iNmCptwiLWpK256zJ2qTnH/+4
	 yY7IEZzu3cnU2Ppq/Kwo6PGj61fu5HIqdHVL5ZbfA3LfD6aCr1n/iGlD9FwCtN0obV2lP
	 oQqrR2yFQFTNiRcShUEZezgTm+erp+0VugH7J5JEgTdj5bxSdPIjx6abAW6WxoFUco0g3
	 Kweqw6DzCSL4w9/XIcWcBtsXtr62jjDNk4D4Mc3pGfubndKTAF7pzhc9W7ILEh44Irg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1WES4n7Ae5pC4dttidqS2ZdY/EQR+GuXwbm0MSwqeE4=;
	b=twbcZD8zPatdVzxRQJb4CojgE0/BsY82dMjtYURZBfLG+AUj3r7Qj/bSPv/XgCUbPr90
	 uOucXpSr0YMFl6iZlo9lgeiJHqOLfgGWs22Uzo7NwKNepmBFsOWMk5Gy5D++r+9eyW8m2
	 pCVmJbo1FepRCEZ238Kbx1C5aCuJlgH9BTRMhYxq0zgpITC0nsiuaT/mUF9EMF3Vk1Ymo
	 qGA8SzMgATDyC8vMbqvdet0JVqx4wUm84rz+8lmHk8meOOAxNuG9zv4zDBKGcIDBNoFQc
	 enuBVeLNWcuTrKglMnM9y4+w5zquf85LtqiDyBBKXUBvey399g72z1MR5dWnZcMrK5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YU8PPphX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A5E606A330;
	Thu, 19 Nov 2026 03:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YU8PPphX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2E41F000C5;
	Thu, 19 Nov 2026 03:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058102;
	bh=1WES4n7Ae5pC4dttidqS2ZdY/EQR+GuXwbm0MSwqeE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YU8PPphXnCzVyXBQ6CIzY8y80LV1Td9TMYC/FD9OM5yNbMtqAfa2cWFi6VDKlqiKF
	 eZ+SPfuskgqjYiWBJ2jy6XOd+gHbIbr5nmYukmJzUWtoalnIh8aWTFMkEwAnXyfGaJ
	 jZ5QWR05n7TG49zH644JUBNXy4X1x+EfL7TI0sJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0367/1848] media: go7007: bound EZ-USB I2C transfers to the usb_buf size
Date: Wed, 18 Nov 2026 15:40:05 +0100
Message-ID: <20261118145928.681932838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhuo Wei <me@cherr.cc>

[ Upstream commit 816c4628b23e8c3d925978433f4dd1a13620c01b ]

go7007_usb_i2c_master_xfer() copies msgs[i].len bytes into go->usb_buf,
a 16-byte buffer embedded in struct go7007, without any length check.
The adapter declares no transfer limits, so an SMBus block transfer
issued through /dev/i2c-N can write up to 34 bytes into it and corrupt
the struct fields that follow the buffer.

Bound the transfer size with i2c_adapter_quirks so the I2C core
rejects oversized messages before they reach the driver.

Fixes: 7955f03d18d1 ("[media] go7007: move out of staging into drivers/media/usb.")
Cc: stable@vger.kernel.org
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Assisted-by: GLM:5.3
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 762c13e49bfa5..6a0733c5925fc 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1029,10 +1029,16 @@ static const struct i2c_algorithm go7007_usb_algo = {
 	.functionality	= go7007_usb_functionality,
 };
 
+static const struct i2c_adapter_quirks go7007_usb_quirks = {
+	.max_write_len	= 12,
+	.max_read_len	= 15,
+};
+
 static struct i2c_adapter go7007_usb_adap_templ = {
 	.owner			= THIS_MODULE,
 	.name			= "WIS GO7007SB EZ-USB",
 	.algo			= &go7007_usb_algo,
+	.quirks			= &go7007_usb_quirks,
 };
 
 /********************* USB add/remove functions *********************/
-- 
2.53.0



