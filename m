Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617781;
	b=KluJXlPKvmMFYtxLTcDG824FhBqsE6ZUu6rqPmSjEn+kM2h4iOXZN0BrCJvYPYrD9WxX
	 518/kBz7HBi5655Oaht6lBVFP9CeC45B3Svy3nl9tVhZFvb6CGxjGHbdGcejlsIRiEDlB
	 RXsF7s4wFAS8XnhyWbHkCJSuMx05Oo11ZhQcJkiUvrxqW/oDm7xwDizDQXmOCy1P5zRQK
	 2O7td0jgyS/sok7ACre1fCWHpgwWdDJ7h04rMkkmP2S1tsJ84kdUOryQK0vvxCuN7HQw/
	 0I1IjtLo4ou/ajvMHU1ozI3tUlHeLgADiG3ksAzjOkrPSR23L2ZRIRNsIlBWKByk1Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=taoJsBv8D7UPSUvfVWeWA6TaQbzKiCZPGnDRrmpE8/k=;
	b=tsGceKmXuNFuQTTqUvEm9i9IlvlWz0BP+jfhM+nExLw+B0TNR44vdvwQe2nl3+fBVnjT
	 2iZO7B3HQzsGUui9DMFRM/eBvW1saCjQaCk0J+sA/RUukqhtXG1IzLPJ8QLs5bRgtJ4Fy
	 tFfhiADiwfnK0W77VejNkIwUk6Xg1G34QtmU9liAStv0oKIHv5oZEiZxjSVsTxdQPxlNB
	 dtgJYx1EMY4FRdi96QLXxOEt1pToXbdugS/vHGEYoekjrEw8grJuy+r0EUVqIVLYo8SsR
	 5p4RpnLV4buqYduLayvD/AIcL9Ro8NELo6HRb37PrrvztJPFFEId5we2d0Xx/1luy8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SYJwej+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D38606A31E;
	Wed, 25 Nov 2026 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SYJwej+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C711F000D0;
	Wed, 25 Nov 2026 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617780;
	bh=taoJsBv8D7UPSUvfVWeWA6TaQbzKiCZPGnDRrmpE8/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SYJwej+ZTW7qrL33IxCUrrzSK/2YvK4HScvLflx7ZiNiy39rtCwfYM4CG068gNV1
	 gHd/ax3oT190R1c48FQSKEoCDzw5P99sZAarovxx7+MrhAoiQJbCfo6emWCsTtKHr8
	 YqNQkabtocDeGBDrMPq+1YfkVEsRl13rXgA3fGMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Nick Venenga <nick@venenga.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0027/1005] wifi: rtw89: 8922au: add ASUS BE93
Date: Wed, 25 Nov 2026 15:22:45 +0100
Message-ID: <20261125143822.372657697@linuxfoundation.org>
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

From: Nick Venenga <nick@venenga.com>

[ Upstream commit 475539db19530b7e134f58555e1afcae21d419f3 ]

ASUS USB-BE93 Mini USB-C adapter
Originally added and tested here https://github.com/morrownr/rtw89/pull/121

Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Nick Venenga <nick@venenga.com>
Link: https://patch.msgid.link/010f01a05fa084ba-80349068-cd1f-4e4e-99f5-8cf6f4c03216-000000@us-east-2.amazonses.com
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 7854e6aca749d..b146bd79c675e 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -52,6 +52,8 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x1bd2, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x1d84, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0bda, 0x8912, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0db0, 0xda0e, 0xff, 0xff, 0xff),
-- 
2.53.0



