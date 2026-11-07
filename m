Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061519;
	b=Yh6144f2QBb3/d1UVvgYqYX9ZxF10Jr2h2xuqQZ1W9nGT3LJ+aRwinq4Jf4/dubjsOzz
	 x9Faa6NjLGY8vpE2YqAPJSlH8DPmwvWsHh14OQIA5BtIQtNYkZuR0ZeGoFQBqo/YUXQOq
	 JpZTbScpifmVlQsrcv5BbB0zwZruW6sR8ZEbLazW2gxrE1UOZPNtrCA6qBBPx09JJcPJ4
	 9o3Py/XLHqHTh2G6S1XAA4tcSsWGiZttWYHl8HhmCVsb8qvFSLuKsDiDl47ymyJJGVCzz
	 dGbqVJCaAKxiC8ptXEv/6EfW8miQ7sBuh+zuD2mZYyiUYR6lRyuxtv1p+BjsBNfkS9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIaZEVOniRCb/pjUzSAZblfTMQMzSgQsGLXYjrW5hAs=;
	b=Uvx/zX30YJfPJ999pRb1dETQfFLlA2laMwg72REy1pY1okO84xjZdo4Rblu21BHJpmHE
	 bY/lK93ROzHEF157Yxoj7S3iwLbIJ+RSbUv3LHWFY3WPlG7AGnkchyN8vEbN4srggMck5
	 2Sd9pF7DhsMLzAFXLtgecnjBY5JkOgji0RS519R6bMXoNILziwYN/gNIzBzvChjAfwXQA
	 NIQpqCSOEHTWv2qD2kVng1+zoTHfTCQ3uyRpbX2lP0SU4WjfkhIUdvzKUg4wN/MVIBKWh
	 J0MWG/ydLlXwfASJg1mYoiLI9yzrQMAPif8fCgUuu+HIEQk0WY6anON0eM08Kepo8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKh7HKR7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C68606A32C;
	Sat,  7 Nov 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKh7HKR7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E751F0089F;
	Sat,  7 Nov 2026 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061518;
	bh=tIaZEVOniRCb/pjUzSAZblfTMQMzSgQsGLXYjrW5hAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKh7HKR7jZ7QHz6rt8kEyx++tIcAFIn0nE3PKCUzPfgnBRWZze+tfelEMnHaHKazm
	 rEC4OWW0o8Q+8+Rsan3L91S/zdiAo09l3n4gSMzbbX4PAAxY+exg4cCxXae7ID3xNP
	 cVVIONxr5S+sCZkw+blVViMNoJswPLCrrpfjvn0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 0581/1536] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Sat,  7 Nov 2026 08:43:17 -0500
Message-ID: <20261107135013.868516609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

commit e60dc9c05e0f415ef8bc63b3179abdd49830a619 upstream.

WLED3 has a 16-bit brightness register pair per string, at 0x40 + 2*n,
which is what the pm8941-wled driver wrote to:

	rc = regmap_bulk_write(wled->regmap,
			wled->addr + WLED3_CTRL_REG_VAL_BASE + 2 * i,
			v, 2);

The restructuring for WLED3 turned that into WLED3_SINK_REG_BRIGHT(n),
defined as 0x40 + n, so the two byte writes for consecutive strings
overlap: string 1 overwrites the MSB of string 0 with its own LSB, and
with the default three strings only string 1 ends up with the requested
value.

Use the 2 byte stride.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-2-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -59,7 +59,7 @@
 #define  WLED3_SINK_REG_CURR_SINK_SHFT			5
 
 /* WLED3 specific per-'string' registers below */
-#define WLED3_SINK_REG_BRIGHT(n)			(0x40 + n)
+#define WLED3_SINK_REG_BRIGHT(n)			(0x40 + (n * 0x2))
 
 #define WLED3_SINK_REG_STR_MOD_EN(n)			(0x60 + (n * 0x10))
 #define  WLED3_SINK_REG_STR_MOD_MASK			BIT(7)


