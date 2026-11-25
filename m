Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620662;
	b=e1fdGMLtvKsExtwGmyzIKW/PuEehmJxiCl2dbrcm4kC5XU9LHP1EhDJlXQaLxwOWr2Jk
	 ltUmVBE/c6oiFE7pnHnyOrckLklrxpnPIBjZG5hZgpvZZIsfC/Bk2IP5y4B0DA+FBn+Q8
	 4E7LEL/kZt3/aTP5wZYbS3E1+LbMMMQ1fyjWboCOrIcY/UTyLRf7Tlk3V8KRkt3wIG0FJ
	 r2chCVNY8XbowBvkhE0dDrp5ZMqTNSMS2B7+1fObXTaJuGgcbGLLigeKU0XuE/zXaP2ER
	 j4k0wUHur4M2OCEQsouTx2DVFBwe95m8DdaQVqUV0Kn2jZ/GjpU2bhqpuhwo7bEdB/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8XB4ml3jvWes5HZk088OFFwDjnFfxTgUJ6WftHDIb8=;
	b=sRj0DL0Qklo7gsHDW4EhoKliH9TaNdSlvske1ZDPMre+Oy8wc6hJVwq5+fadsURQ7URS
	 CgBIsAEJrmTmmOVdE5ywpCVUmfQYgEsS0I4jf8m/Xjrbo9MPK2BlMASW1ciY/qM0ucRjf
	 tiReq1TYRM+id3PMNnupP8hTm5fsLjZJr/gKv4flEeL5f4ZDZVHwSHJCaLH0fkPsPsZjX
	 HhuxQlZdisWGxRNCeESV8o3MU9hWabHhhZrdoC043cz6N3og34wrdUvkZS2mn3Hy24Mzx
	 Oj27CoZ5GjXt/WxlDMLMlTWFNrQXmOgjW2IAp4PCL6zFIeJPjRw0Zo5m7NblghtmQgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnpdiiMX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D201606A327;
	Wed, 25 Nov 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnpdiiMX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328161F000C0;
	Wed, 25 Nov 2026 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620661;
	bh=w8XB4ml3jvWes5HZk088OFFwDjnFfxTgUJ6WftHDIb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnpdiiMXfMXNbB+mEl8r+d4zVyun+QyxPXrMbL0ILQuofPTXUVeJ3srMGlpD8nrRZ
	 7AfsSUTkn6D96gsNriaP+B/O0RPqgzGwxW+FtTExCG7DnOMzCncY+HAG+0hnATQ1lv
	 aaXHhu0wqprS8VqX/hyl6NP9nT+x5gXanuH7Z9SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0993/1005] iio: temperature: mlx90614: Fix dual channel probe condition check
Date: Wed, 25 Nov 2026 15:38:51 +0100
Message-ID: <20261125143844.915684522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit 4d4e75b3074bc29525c963a81c19471528f29a45 upstream.

In mlx90614_probe_num_ir_sensors(), the check on chip_info->dual_channel
is inverted.

Currently, if dual_channel is true (MLX90614), the function returns 0
immediately without checking op_eeprom_config1. This forces all MLX90614
devices to be registered as single sensor (num_channels = 2), making the
second object temperature channel inaccessible.

Conversely, if dual_channel is false (MLX90615), the function skips the
early return and performs an unnecessary SMBus read on EEPROM CONFIG1 even
though MLX90615 does not support dual channel operation.

Fix this by negating the condition so that single-channel chips return
early with 0, while dual-channel capable chips (MLX90614) proceed to read
the EEPROM configuration register to detect whether 1 or 2 object channels
are present.

Fixes: 3d5ead238bc8 ("iio: mlx90614: Factor our register IO and constants into model specific descriptor")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/mlx90614.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/mlx90614.c
+++ b/drivers/iio/temperature/mlx90614.c
@@ -565,7 +565,7 @@ static int mlx90614_probe_num_ir_sensors
 	const struct mlx_chip_info *chip_info = data->chip_info;
 	s32 ret;
 
-	if (chip_info->dual_channel)
+	if (!chip_info->dual_channel)
 		return 0;
 
 	ret = i2c_smbus_read_word_data(client, chip_info->op_eeprom_config1);


