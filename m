Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015924;
	b=UkoUJypaFAkNd2NAFtJSY7oK3WomQTQzH4dmgCypEaKYzwTV1KNbpXPPL6/VJmQZLKMS
	 cyuh7I9yX57/Ld9uX1ibOyWRYh2eQ+uKYuM0a/R+iMnX6oJBkcVYcZh4bej4S0/n+YX/R
	 nFYEBlWQG6qFZGgHjyD8P3qQLJV6+lvY4vBwINUWhDT7pkQAlDZeAOr8/55y2lGgv2SHV
	 x6L2x+IknWo2Lv0rIuSDgEEkB7O77O8RlHe9EdEvgNknSPTGICOHu0qmZF+Uz6XS/XaU0
	 buaN7rJPq5AwRAKJUMfEpMDJp1vZq3A7lDesGPLbHJtRfY85DbacUX+MkgFAlfA3nrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2RpRUZkfaIqPIQRndUGz4c2x9kMKpu2JI4uoctNrpRQ=;
	b=huTFXJzeww8ePXhCtSelAi9wTMqSlTW0VQiEvGOsNzMKINdALQrGZDlK+tb7bk2cfDpL
	 BbjBbhMslwdTLZsfyTV5WiCFrDTkhE7vKCL7WaLaWPW4KqaXyMPMPrxtvc92gMW1g9tbI
	 ZTrNjZIzsLnAhlxMe+UtU8qxcLIPu+y2bQeTImIGaZu7U7r4ufoXx7UN+usZIwVRKaJvV
	 WlI8K4TUGpnBgeGTly7ZkRE8QQEFoJyDOGmiMHvhRgUZjRzNJ9RMmPWFbaBc4ybWs5jBL
	 MJP2PCjES7KYgjqfW6VZuIS74m4BsbYCTs1wimUS8efHxcBlsUqiqb1cS+pFxYrTkfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8geRAap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D38606A31C;
	Wed, 18 Nov 2026 15:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8geRAap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B41F000C4;
	Wed, 18 Nov 2026 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015924;
	bh=2RpRUZkfaIqPIQRndUGz4c2x9kMKpu2JI4uoctNrpRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8geRAapJRDOXFsmdWqhOAYqXMuaDMA/OBKlKZTxc55xTDCVH6SG2VV7WND2Z2WV7
	 vWM5f7ec6YgEBrAr9iZBiCWuTT+z/iMpiei3xdrkgwkoIldlLJjZyecR9aUip8/FKX
	 BM8AIRKvWnm/uXyXh/uBEDhFqknUjBQGKHbF8qB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0347/2651] iio: accel: kionix-kx022a: Fix IPOL macro name
Date: Wed, 18 Nov 2026 15:26:27 +0100
Message-ID: <20261118150300.332185927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 0ed54f5842235..a2d122c1e2347 100644
--- a/drivers/iio/accel/kionix-kx022a.h
+++ b/drivers/iio/accel/kionix-kx022a.h
@@ -65,7 +65,7 @@
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



