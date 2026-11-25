Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626301;
	b=xJ7mHwAJBk34j1NPBNbFumhxXAx3D0ES8og+BiSJsnOMbsZeGYq7kT0tF0mhGXllYbj5
	 iOL8rLhA2jaXA+59/JoWgsj1Id8akiAVuvdd5kcDrklgQlUiuKzAcDFmjVV2f7i+NtP+V
	 FCH1wNw1rPTmMOzWWrbCnfQ89XdCHx06xKxnFmjaoPmU4gPm7z6BA39rqP2DYHv4Wv/qM
	 kG/1vH+McedFgcmqS92hWE0PEHMiv7Fa2rj8QDPd9kzKL1TyhjYQSgysAr6osTB+hgQmH
	 Y2q3iY/xtaIdySgOJnQG+fLrv2gH+CLLf00kT5a6j2Z4kYOt7RwcIOu0ruBp4k5NHLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HE9pm/A9RH3OC0vZdlOtD3h2fzhS2Ztj0gHguNVoIYI=;
	b=c/KW1j1Az3+D1uhu3DXX/Cm9Q2AuY/zqvdQ9uDX4SLeiUkIINzoEyYlhlv0vD/whUQqg
	 JtSajjvL+WphZL6CXJUJtCUYkmvO1o+9lkDzELyDSXCaVGMZk8IJC9m4jhCdi80TB83RB
	 Ej8s1uw+W6I3ZAWA8jNG8bqAJiLi3uWhiGUGUcgxKKSr3nfE/BbOOkHcGkoroUOSlWTwb
	 5w6fOfIKN4wt8gLFyq7ZnT8Pg6m+DbMjtaLcpSlwPA2JMxQ0oH84OY+T26s7dvti5CsXw
	 iLL+KOfMPhrqZtH2Hfq18xSSqW/fZBuFM6Hsr57VHiK/2Bsy8nAjEUZh4DR24Y+imng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzVMl7Ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D6B606A685;
	Wed, 25 Nov 2026 17:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzVMl7Ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A911E1F000EC;
	Wed, 25 Nov 2026 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626301;
	bh=HE9pm/A9RH3OC0vZdlOtD3h2fzhS2Ztj0gHguNVoIYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzVMl7KsQcSJByoAqB86xzEgPg4mrlOaHfURvtNLX3VIK69Ci045dzX4HHN4JOkOU
	 /aL23L6SipZ1sssWj/U7N+sT2YR7AJRjb7jgAEyG4p0hx26rpg5Trw2z+ssSsKIWtF
	 zXTy2trxt1WMwId7or182vY+zB4NFKjTSDWI1NMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 797/816] iio: temperature: mlx90614: Fix dual channel probe condition check
Date: Wed, 25 Nov 2026 15:39:05 +0100
Message-ID: <20261125143907.619702159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -570,7 +570,7 @@ static int mlx90614_probe_num_ir_sensors
 	const struct mlx_chip_info *chip_info = data->chip_info;
 	s32 ret;
 
-	if (chip_info->dual_channel)
+	if (!chip_info->dual_channel)
 		return 0;
 
 	ret = i2c_smbus_read_word_data(client, chip_info->op_eeprom_config1);


