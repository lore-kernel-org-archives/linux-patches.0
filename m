Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052317;
	b=n/22i/iidV24hn+LnV6QTFjrdSzC6JXRZM+yBQ7qibk16gxJpXWuc8RcCoxHIQIZZZkk
	 3pAiPC83qW7jgJKPI+LfAHMaWiin8iY6tKkOdc+Dae7jVSxcksjTObkYWG7x8Fz03XKd9
	 Su9GJZo97xsdZuuFdS2+oYVe1SVeWp/EZfgAziuVpAhRbc853hDeSOErEPGEpo+ZdsHhj
	 PX+oTdqKHDtAZgfAE0Isd7ntyi5otDH5pcqq7EqNIT9zoI1AO/HISRQoOq8S8Y7PMlUFd
	 eju6SgyezZBxmqs1mImrDqLt98gDRip1EUMgKBk+cPhjb47TYJhzwSwbq4/snyKBogg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pDtjlVYaBSdXIXOacnpVaOFLDzWxTqQgG09gYDxcYrQ=;
	b=E99afL2sxwZjTguAfilZeNqw86xBX1JeNneBnFQ5tFRE4p5jTH9LbjCxyBqXXRd+ZMAC
	 oArvtV+ppMIoIBvtHEQrAVXcclOsRVS08GdWbgtHzds6MUhsAWm77hI8ajXn1yg7i1biB
	 I9Nqo3Dk0P8Ur4ik4Qj0y/t3SVRp8yLLjw+2rtbGjeLRnsxrHrOw8nAikC5v30ZDCfUzo
	 HWsn5Ksqt6O0npfWCnWpORFYrGitltbY58oj1AkynWBL73ElOKOHBmXTI/INu7k4wQ2PJ
	 72oLTw6xwPGaJLYBfQ0dZO+jInOBQKsqT6j6xdjtXCiPEFkE6edMhoVRGa2BVA8WeWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfOvbsBM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F86606A320;
	Thu, 19 Nov 2026 01:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfOvbsBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E561F000C4;
	Thu, 19 Nov 2026 01:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052316;
	bh=pDtjlVYaBSdXIXOacnpVaOFLDzWxTqQgG09gYDxcYrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfOvbsBM30d5UsrJvDO3xsyOom7vK+p3BRrVn5DzqNFRuWAvSa0sk1m1GVdb2tqsl
	 9si1sAMxf4inxXWH4uwLxDs93F7rUHTrEfXsWly+ZcS22SJSbqNmF0qZJ8vSCzzvOr
	 +7nD9Wq5fePHvHNDpN5MK1jU7Qpgv7zb4nd5POvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0473/2214] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Wed, 18 Nov 2026 15:35:49 +0100
Message-ID: <20261118150030.107638218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 10d8dfda1c08f6788049aa100685e223d857f901 ]

cp_read() returns the negative errno from regmap_read() on I2C failure.
adv76xx_log_status() shifts the result right by 4 and uses it directly
to index csc_coeff_sel_rb[16] causing the right shift of a negative
number to result in -1, reading a negative place in the array.

Commit 8163419e3e05 ("media: adv7842: Avoid possible out-of-bounds
array accesses in adv7842_cp_log_status()") fixed the identical pattern
in the adv7842, so do the same thing here.

Fixes: 54450f591c99 ("[media] adv7604: driver for the Analog Devices ADV7604 video decoder")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 482e5234fc389..a1bd5ff8ec92b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2635,8 +2635,9 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 					"(16-235)" : "(0-255)",
 				(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	}
+	ret = cp_read(sd, info->cp_csc) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
+			ret < 0 ? "" : csc_coeff_sel_rb[ret]);
 
 	if (!is_digital_input(sd))
 		return 0;
-- 
2.53.0



