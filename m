Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062782;
	b=C7lcM9TTqcGvgTuWINCMecEtxg4GyKUqEppWcO6rhpWTxq6fF2Mw3KKnxeU4YKDLrEEf
	 S0dX8eUHb90h5BIjqLOyUdu9gUHwScxaofx2LCjXmzCS9jEeit6OdHSAV+nHUxXMmsDjC
	 3k0z/K66zFiTOA/obAVpNkVL8qgF9PrGLi+dwkkpsKdgVrycky8rvmLpxPguAXCzZ/sWl
	 ClgFoGHIu76E7J2EwpwRQcKPRIqtq+9zLjg3LzNsYV0+M8mx4bKT+yIC4fgBK3/DzAPWi
	 iV3gWCeO8vZSci3hPHCbIXk4Ze+T7D8h5sMBg+MN0AruZal/+xHnMbFMB6w+jM1j+Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WEl1Av/jc0hQtWhTXB24JQUkbD7z+WbtTrO0Fh3s5PE=;
	b=hHTjs//ymBDxhAh1qVVQNTSyJoeLJpRZ/lg8qLwMdfnVRMj4uHRgfpvj9qjWije4kHsX
	 3ye6QbSt4e8D1cJ/5mgkdtWVy3sClykRSFEsgoIMaf767OHp92ZtH/LFL6l+cp38TxXoI
	 ps6xlDIsOZh/pnXy+6/GOGpVEAEXAj4/a0u08vIMMawAFrXUX8CjVZSUjy0avYn7KScQK
	 4XRieJb6w19ZjFVZ6uuzg7FS3qPa1oJaxi4kQ+hOMeZzhHz9+Ng8UU6HTblxznXNSnO+t
	 sKDdXfyyUkAo7NOQM9+XRR2c8wJepcQY7TM14ogQd9gHwZkUX36OauR+UCeKb8d7qhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdrTF8bC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D18606A326;
	Sat,  7 Nov 2026 14:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdrTF8bC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C251F0089F;
	Sat,  7 Nov 2026 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062782;
	bh=WEl1Av/jc0hQtWhTXB24JQUkbD7z+WbtTrO0Fh3s5PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdrTF8bCTqvNciciKOKmNIPN4WcZPmjXSAEMtC9apVBRPRLBIqZvi9eT4TaBw8khB
	 UnOuQUKpE2BRuVkyjyS4DhcZjX9ku98c31UYkItBJYTxsu5tkz5CVa9nHV6+jwujL4
	 dKC1Inf06bvAQ+tJJAxrpGli1KUA5jr4dkfhqDmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/869] media: go7007: bound EZ-USB I2C transfers to the usb_buf size
Date: Sat,  7 Nov 2026 08:46:04 -0500
Message-ID: <20261107134855.486593416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 334cdde81a5c8..bf3cf320b2c9c 100644
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



