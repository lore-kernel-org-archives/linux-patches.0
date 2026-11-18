Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029356;
	b=r8zAEQeda5+GEE7+quuF+9NvReo5PKwSUpThjLUj8tkL2lQpV86+ix3liPzQMnW/1mEF
	 hmBEq2fadB4zzfK2i0QyD11eBB1wUwVnH+w3Xvh+lzSImGKMlw5ayldNwat7PVkQKiqyM
	 0K8atfrMcUmGmkr1QQJsiwP3nWn4BAjMSqiUEi5pKEgRTmNK8QToUGqONSBx+uA9vPjQN
	 m4h62RLwwpmYSa2ucoE3wsv9KjpLZo7PjgktJCTHVAa712C1E+tGIsAodW+x0cV2G+mZd
	 GGsCpKuGD9AxIPACcKDDktiRh3uB/mYaKWavj2DCiezr4tMKjnN9YwMAts9DnPJASZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IC46mGxnSsNH1kjk1j+4ME0xrhhV+Nhw3miEx9zzz6s=;
	b=3fZO5Cf8WwpEnWqk/k2jb6mtc1WqMTomH9qIynmzwKC9gMGsBQpgFJoiBtlIyT1hQRkX
	 rc72bLp6nwakhUvunVhwWUuDDuFlup+eD5NDXi5VU6lmbvXUnXTJkLwq8kZVM+p3hTwOJ
	 rdD50q0Ru/ToDJSA8AY1VVgC4/r4zlcQBjv/8iQ57UqECjRlcNWNqRNCjSLkvoqhdj/t0
	 0lfaKa9+XZbptrIlSJf1SiRJTilOBDVaxFUySfnloVGnUJ4gVXTHHwGWV0T6ovJv27ml0
	 0qasIVos5niA3jGI1Vt8fkmSvtXz6mFTS+JdmilPJl7RM4UQgUbLUT84Vyw+LdBsf2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZfAY7J+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6537A606A31C;
	Wed, 18 Nov 2026 19:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZfAY7J+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F441F000C4;
	Wed, 18 Nov 2026 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029356;
	bh=IC46mGxnSsNH1kjk1j+4ME0xrhhV+Nhw3miEx9zzz6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZfAY7J+t1VaJFg3qEGQ2OwSf99/m4dK9A5Y5rbawwNpYJaoARuRV7T6iYmYb9xQg
	 NZaZeGyP7I6tRDqd8c7R4lPFmL7hPtyiMRCwCb4BQ4cuJaCk/3dHvlvbj8ipi2aNvw
	 JzMZDhqRB90ikcjA5lIAtloADiUUwNVqkst9QOrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0318/1756] iio: accel: kionix-kx022a: Fix IPOL macro name
Date: Wed, 18 Nov 2026 15:40:45 +0100
Message-ID: <20261118150020.972124001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 7060438ad88c8..95df968d341f1 100644
--- a/drivers/iio/accel/kionix-kx022a.h
+++ b/drivers/iio/accel/kionix-kx022a.h
@@ -64,7 +64,7 @@
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



