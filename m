Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063890;
	b=wXWMQf370zBnnnbgoLgzfOAe0Bbue6Bn4gTAgrlnQX+SVtXeSbUHZ0qiwBWRzfys5Evx
	 0eNuZ2ylQwU9o69os/uN+F+j61UyocgUx2IOEUYG58928FGzAHkh9uPFMugpPLly65od+
	 4ZR3vCyyi0NdNSam52njLHgiiIuMXUPB0taEG9+TeOkDvQH+aUDxWE/9BWgoJ4DtEmNvZ
	 T2lOpNnRpQvIuCKS86RrPizvHcT5nIBWA72/ZNAEhslULdMK82kwpKIDn/mmO+GMqpgNg
	 oBzj70uzS1v8RTtn5vsHbLmPA3ZOo0X7lnWfgWM8UpEJzXfPaoLjIAJuZsSOBeekONQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=69LcYHT1BzqwLgMJx2j2ks3vAHllUvz7f6aGiskFrXA=;
	b=bFPhV3QKOqEb8bSLfT/CFw5sdJ55iLkVMjwSjBdi1a9qMGaf3pN+cnjYj0yUTKMe500m
	 fQGDenETa5/boFzzIehfwCdbjzMAB+ao/258cdWD6yfb1RDFuHWVj7s74utfCgqb/6IxU
	 xfCez2ON7tKDfh5M1xNfXlbpKthUUoyWuoSYJEiCUh2yk4QopYCIn66ZUcSlip0ynCntF
	 BG7cWh9Qd8ZJfmQ2/5kZb6llQrtkHXjTPgB2gToFcV6VCcfZ1VHgA91CimlvBD+chcQqq
	 jqjdOPhQng9IysDR7T/qC8ypd4sbEH7bmC5etnAd4/y3LQ9/qL67DRWyhe4zY/Td9WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKuyasNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C80606B8B4;
	Sat,  7 Nov 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKuyasNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CA11F0089F;
	Sat,  7 Nov 2026 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063889;
	bh=69LcYHT1BzqwLgMJx2j2ks3vAHllUvz7f6aGiskFrXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKuyasNHO+UYOqFZtYo1hA/V2rAJkZO3CMnSR50q0D3CMo+/8cfcvNbjwXvZjvPEz
	 3PuS9herd8U821s8Qwowv9bnU1TYHtGhIpM0bXm58NYFaUpBCuMJEF/xHledKpflPI
	 s7NrIUv7c4KXLycW900L3yBJiym8NATgA+7npZPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0093/1257] media: go7007: bound EZ-USB I2C transfers to the usb_buf size
Date: Sat,  7 Nov 2026 08:39:49 -0500
Message-ID: <20261107134941.934199734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c0cb92fa6ab94..867548d655b3f 100644
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



