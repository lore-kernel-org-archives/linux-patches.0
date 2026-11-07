Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063924;
	b=Td81P3Zq2aEmVkHl/rQLp+LqAIBJQmwptdkJ0oUp7yBltjCl07PBiQ+JHH8bRmwKX/aS
	 lZ2w17QGpQcgC/d/5Qiw0Zk372UI61EJ7/F+egUDXdu+wDqsnfdsczLrmgSp/UyuFu8P7
	 RmN0uy++ixmplpc291L5/w0xjErmxiRdRheSo2BVIGB5NgkRQI82ZwGLje3n1/SqDrEZs
	 F68eOy4UUqk5LVP4xii4g8KrsoGs06LQRfWxs8gDFlNf94XqnYREtqIkYuCwziHPV3vZV
	 6bnbnxte8JXTRy65w33IBlrtjuOnfiMWf5RAWS3V9oCLNgMk6ZyElETgovs1ucWpRuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TO+dySuTu4uG1yBA2I8vs1dIxAg/WHK3qT+L/7zeMUM=;
	b=bviOnY4Q/LtKEvOdNPk0I/qu0lsBrI/3kmWlfuvdwCzwgBreh4Ng5wP1oZHAoo6DUt8y
	 TegLch5Hl/Bitx8u2DjOZR9qj/lROlz7VGgoDm1OaYQrjBw1/OrSmMWE1Mc2x0ZMxYKjW
	 p07MmWZ3MM5i5Qeii/7GYxHkkBi1uv8WALf2NG+kJijqymANJgIVcILSKATKwg60fUH6x
	 2XhO7FMq1NxqCIwc9o59kN2OSUS/VZ+zlFIduGHucYrTwRbuUO87/hKtg6ldlrP3pmdRF
	 t+h4vA1F6FEpYyRAw+LP/O9dHh1SNyHLYI74feL9EsQvqY8dE+ERRnoiNkOumit1v+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9bj2Q6V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537D2606E8E9;
	Sat,  7 Nov 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9bj2Q6V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026851F0089F;
	Sat,  7 Nov 2026 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063924;
	bh=TO+dySuTu4uG1yBA2I8vs1dIxAg/WHK3qT+L/7zeMUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9bj2Q6V2mZk7Y4gL6tfORxvSgGvSuGUAL9qy81IFTODxEzNmCJiN4ZtZMeQhhq6z
	 4QasbApQmmbSfWbFmyTe2dEoXA8qRAdMxbUBWwwDaPWDAyBqi8Dlcb+sGLPcjDzuvM
	 lA1eQ8cdZAXSykYSu5p+eGlMJt8zDHcy+4Qzr4tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0119/1257] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Sat,  7 Nov 2026 08:40:15 -0500
Message-ID: <20261107134942.623698509@linuxfoundation.org>
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
index ac9c69ce438f1..231edd3797abe 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2641,8 +2641,9 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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



