Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039544;
	b=ZQA2NxEiHaeqYqPXmOg05whcWoD7OOtqGaUwe57ojqtfW94jfJdBXppMpmJeFGyt4gPq
	 ta0FzWaVGSqdsm2jMlebsmvcKQAzfFGDj+nUYFFAlqcr7Od7u4TpBw33MmTpfyQ/tel/l
	 WASgMYkZwz7t4vzPpNgw/NEN6+ICmS3rM+MWws4n7JNBcXmhDacimRsh8STWCsLYyZfHN
	 LH/311SBZXI33qCwO4X7jkelvDmeb++lIT0ZjwT/GC9MyZ7uKQhptJBMx1fzqLiSdtTWN
	 h3omBkgGKwWGA1tDt91mkmYXNGU9gcOrjomrVZV/aWP7fAJKYwV4BgrUnuw3iOgRo7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nf8xD4tT42SdPu+WP20ZVmpJJmLTA3XXBYCO9zuUhGQ=;
	b=5LfMdG0yhY/3ek+kwNJEzkWAi/4/9aaOOO8sPY7QzAsVztMmOH4p4zo/UZqTRL87gj6v
	 mZC2m5TAqHgda6/r3ComqKYo9ACV+wZbTND5V+tV8BLjheoUl/PzmGKO6gC0PmOy9Ljhe
	 Q6fAenkYJGEH73dSdHacSCDmEDe25/ebFpx1Ho5A8/Ob7PFqeMipakxJyTMM1tFlau8tJ
	 oJcgOk+4sk+CPwqqpzjMmPcKOhkjs9oiqahuFYLvt0faVqSQWAHxeGpmhcUbu3mYl3XYY
	 fkfrbsA9XzH8NTLqpsfRoaYpKemowmTbjSHA0ZGP2+Pzi2BVttCujtrQGbkEvKjKsjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CaRNzNhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03347606A31C;
	Wed, 18 Nov 2026 22:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CaRNzNhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542291F000C4;
	Wed, 18 Nov 2026 22:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039543;
	bh=Nf8xD4tT42SdPu+WP20ZVmpJJmLTA3XXBYCO9zuUhGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CaRNzNhiynUULdnWvnwYLl4FzktVN9XqcjubFJq/Ke1vUqQnjK+0lTBd1ntSWtzrH
	 QYVU97r1+L4YliUmGP+qrDPMpjuEz2Lpa1DZF/aFGgAVtw11zXt3Yn1Ng8/yX5wB99
	 e1dTEBa1+1Trwjm8HpwAkeSaG+6SitEf1u5XNT6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2136/3318] iio: accel: kionix-kx022a: Fix IPOL macro name
Date: Wed, 18 Nov 2026 15:45:58 +0100
Message-ID: <20261118150426.145786601@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 4a4b0d75622f7d911c96045b328fe2e88be05072 ]

The "interrupt polarity high"-macro for KX022A variant is defined as:
"#define KX022A_MASK_IPOL KX022A_MASK_IPOL1"

However, the KX022A_MASK_IPOL1 is not defined anywhere, so actually
using the KX022A_IPOL_HIGH would produce a compile error.

Fix the define by using correct mask.

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.h b/drivers/iio/accel/kionix-kx022a.h
index 12424649d438b..4e21c91611eb1 100644
--- a/drivers/iio/accel/kionix-kx022a.h
+++ b/drivers/iio/accel/kionix-kx022a.h
@@ -63,7 +63,7 @@
 #define KX022A_MASK_IEN		BIT(5)
 #define KX022A_MASK_IPOL	BIT(4)
 #define KX022A_IPOL_LOW		0
-#define KX022A_IPOL_HIGH	KX022A_MASK_IPOL1
+#define KX022A_IPOL_HIGH	KX022A_MASK_IPOL
 #define KX022A_MASK_ITYP	BIT(3)
 #define KX022A_ITYP_PULSE	KX022A_MASK_ITYP
 #define KX022A_ITYP_LEVEL	0
-- 
2.53.0



