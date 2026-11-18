Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045058;
	b=a4DJ5YCyvyhdGw5h6OZZYBeWpbrU5ik98QHsvnrA7c7sBq/81IzrQLh1P8OiLeFE6nSy
	 C4N9CzVW6hHr1upRz8Ox5aEr32kiwUjdvPIyPy88TA0EFk+tiUpTzS3hIAZW8izu7J3ur
	 eyx5Iyd8Y33+XeumexKAfLKDeIerteXpuA0F9nb2kcR3bkbugygeGey/9ipVWQen1fKzU
	 HenoQDP/pnOpNQWnexsXRtmJfWOZy71y1iCmAz/93ZVF3/rhqKxawWDZfV5N6TmxJuxIR
	 ciAXUN29os3Ji9QEfqDsyZQoi3p8+SqOKR7MV0vIXITGUz2XpwbjX79wE/4JXvZE3tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBj/45N7+PRmxlBKZZBch2Cr98OCfBFBFAfnYflv/Vk=;
	b=OhLFd2EDtEUjd+q9tnHmEamGHrUXJO1x7TssdBUvzmFftJAsRxAVbh1L4RM8OWV6TbhW
	 cLdHCfe39R6vkSJaYwKHenniWXZnuke72hKApl4vuZ1MrKcMbUuhFXKqRHB/swKiF3h61
	 NdRYJ5YpkLF4Tepij/kIfKXssa/5WHrrsWBS3lenT8RS+Qtk8VHX17EVH1yc1VvUE6Bul
	 Y8wj+01BCypB9S723c34wEPqlFPrivsJg2auufgdpzijuGA8vARYChIei+S04Fm/iZuts
	 uwQ2UVwC0ID3xEYY80ufFVUmoey9Bq3pQl2/yK80XJ62bzS+cEOrnD1IePD7AfmRO8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbwO5sAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE3E606A320;
	Wed, 18 Nov 2026 23:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbwO5sAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259731F000C4;
	Wed, 18 Nov 2026 23:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045057;
	bh=vBj/45N7+PRmxlBKZZBch2Cr98OCfBFBFAfnYflv/Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbwO5sAjCp4E/vIrnO0Pq9o0SmkeCAbVty/i4YuxS2SBK+bmxkCeasan1CjNKRzY6
	 yJC4m/q9LviXP+kxlq5Q94ok7g2CNnoYXitz+ymJfxCD8S8Abk1iAjLJfg/7HVJNQJ
	 qYQQAhuJSdoSUMMhWc5g1NO632Xx/Sl/hdO1jCSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0738/2857] media: go7007: bound EZ-USB I2C transfers to the usb_buf size
Date: Wed, 18 Nov 2026 15:29:32 +0100
Message-ID: <20261118150228.123677615@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



