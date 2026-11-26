Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704813;
	b=vx2K4ESWNzlTIwstO2Cb3LRlZ6kDkaNe1uGMwUIheLwQHgwubZewziVfzjUIzGumUSPZ
	 QpPFHOawIUGD9a2zhzdCTm/9sfXeTyzImru7scg2XT8LrC+EavhdELSMY2xKOX14KLanE
	 YTYbz+WeWgTQpXUfyGKSEdxdhm0ZgoP1lSQkeAFzZ1gUmn/Nl9YzuM7tmz64Zuq2q+dzj
	 igvn8GcA9ukKMJ21bhLF7v2o8R4XFoiSiksDJ3F8JmA6MqpKFzTgzM3nVVR+6NRjIbNyx
	 aQGf1Cg8wB0kVewoxt9PTtGqJ7l5bDTASIyVVpPMqSRoHYJJcLZvTrxozedqNvLx2sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PC0M9dx9yhImFZye3DZ/Q36zh6whlsYRJjYWHhtZ89s=;
	b=rcDdYwmmxh6njeToDvCYLxwxjs+WeHhrDTQk0c+/3lDz+CyATfTQBw3IrFI3PTO/tF0m
	 EoP4RAgQuWeMsDuNVE/yGeDvgm6gnyboGPUdk+hgNS6GJ94A0/ZOMs6e+sxs6P1n4DQoo
	 zW3ZrC3tailIIPqYaHV/oEoPOQPF39tQ9ktkJ6IcU2RlC9V1AmKIPBB3D5eku/XnZk/l0
	 lAizh79GbogilcuzS0Im9NsrS8fgt2XrOoT5R57Nrgeg+RbNLRwknQUL+UGxNFA2Zc9b0
	 QQrHVtCNk9uV1yHHdv0/9fSYJ8Ozm3Gp+tYz0nMttL70m68YmYmx+dBZxS5ezheL05g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGNtFjs2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCC606A32A;
	Thu, 26 Nov 2026 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGNtFjs2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E511F00A36;
	Thu, 26 Nov 2026 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704812;
	bh=PC0M9dx9yhImFZye3DZ/Q36zh6whlsYRJjYWHhtZ89s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGNtFjs2LHtQxLBJB+xsKWEFBuPxpfPGtKZHodNMZgNh2YWaXdih+FF8TMyL8dcTh
	 77bP355r1wRLL1yJ6MYfoaD+JF4PQRNzTI75FoQPc4Tn7MQdumO1N1tLgFNT9qKmFW
	 I9yenIOYIBHzhxsWKvdHzKIZUuqnlUR3rS7UJyvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sarmanow <as@discnull.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 252/265] iio: light: vcnl4035: Fix reversed ALS mode bit
Date: Thu, 26 Nov 2026 15:39:42 +0100
Message-ID: <20261126143622.867231738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sarmanow <as@discnull.de>

commit 6bcabc30b89f31e2925647d1ffa5a0e4b7919829 upstream.

According to the datasheet (table 2) the ALS_SD bit behaves the opposite
way the current ALS mode defines are set, writing 0 powers the sensor
and writing 1 shuts it down.

The current driver thinks the ALS is up while it's actually shut down
and it's down when the systems powers it up.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sarmanow <as@discnull.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -46,8 +46,8 @@
 #define VCNL4035_DEV_ID_MASK		GENMASK(7, 0)
 
 /* Default values */
-#define VCNL4035_MODE_ALS_ENABLE	BIT(0)
-#define VCNL4035_MODE_ALS_DISABLE	0x00
+#define VCNL4035_MODE_ALS_ENABLE	0x00
+#define VCNL4035_MODE_ALS_DISABLE	BIT(0)
 #define VCNL4035_MODE_ALS_INT_ENABLE	BIT(1)
 #define VCNL4035_MODE_ALS_INT_DISABLE	0
 #define VCNL4035_DEV_ID_VAL		0x80


