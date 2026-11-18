Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035882;
	b=jqIEEkLb4fS44yXZAotLoDDE7ctyZUZTlUK1qeEb3rmYrP8KPHoYDAWn+qulfsZenVUm
	 0O+35jHNDrxiPI7uavOgrl27Aeag7/mzk6aaB99ccpcNeOZEFqKB1bDUHbuGrX1N4SWXa
	 8YmcSvH3fY7k0nIRMgqxBBCuhpsOGABUIlCWUwcffx7+DlLB5TOfQr+VXvRADYTfsNWb2
	 1iaDz7x9+AS3XgvLqO2s57Qat0urbyQfOzgadRbY9k6Z0zfRg57IVgqwPspmskgiS+OtG
	 RdygZndBMF4alduLQS+noTsUDQtqpxabyhaHxFC15T782btHGJtoP5JHkf/gNL5WIKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1RIWzDnxNc9Qv1o9Z6Pyn5+vkH5s0jve785uwXMwF6U=;
	b=LZ1oqJ6UbcI6U7R+PR0XKUBXJ95rVMBe20vq5H/0GBsWLxc0ACwMPsqaR3jBfAZgUkTZ
	 s0al3EM6yrt3d7xtJaSYBGXVxo0fP+m5dEvOzZzuR+xRscjgwF8LwfE3ThWKm5aRpfOE3
	 aFv/oEWG4X6RmgN9lXYDBTIIGlXc5kpVUr0vdwRq3RbQdumgdAjbNM9BFrC5OIOPs34Fr
	 qZlb7lGAKXJqf2g0iHjYkIEGBje2QI0g40IxeZwbpHfTJ6m95C94s/KVjlrzrPMmORe7g
	 xtgrndpAoanYY6ZphJo+Gu/wylfVC5OjzRITwUT5KKmpRMMaJGwCcMaTf9jUprBXe5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K611pS9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544F360A2609;
	Wed, 18 Nov 2026 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K611pS9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92091F000C5;
	Wed, 18 Nov 2026 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035882;
	bh=1RIWzDnxNc9Qv1o9Z6Pyn5+vkH5s0jve785uwXMwF6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K611pS9tMa9FJAQwVmEjaCIobxd755qfTSyGnb4fNavvMfefshgKauaUSLfDkZ//M
	 WBMgPIBcyLIGVcG2UBXFRRDAKjfwDAI3qMb2Eb/FpxkKfjqhqnWOIg8wGIY1zWPNbd
	 j+Khqi/mHp40xvUa+vpiBOnYs2hYY9x35a0aCElA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0834/3318] media: go7007: bound EZ-USB I2C transfers to the usb_buf size
Date: Wed, 18 Nov 2026 15:24:16 +0100
Message-ID: <20261118150344.163212799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



