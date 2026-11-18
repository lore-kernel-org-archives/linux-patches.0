Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023482;
	b=TwU1Ixh/JFn051606UyAItAgiXy0vb5dkoiPHgFTDtxgLJ1cCnBycTkk1em6Tg+AZYfb
	 tGGmHRvxgHAPGWLtPDv8IPjw49vivmPFtr8Qg60sngvpmLKZzhH0YGouYzIckeCWNNnZT
	 yQnEB/D01YH8jDebl7+ec7tepJ/dKV4VY2tRfoz8HldAso7ivMfdUa7xUQSXHOm72ECI3
	 po3LWaMSSClNQWAZoYtfceCIKUth/b7bKFHz5+IRxcE29aA1g+6/3pQJJhRg8YOm9G1ie
	 7/vT4lvs1cdg+q0hQUHcOO6fwYYdvZOSn90vCbAv7T7JwzmfIGkeIisc4Q3uv+9DMOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yulO3x+YdBZlL//rQZ2lpAw0a6teblBupJwPJHwZHk=;
	b=GsA1QBBy59nKEKoZQ7SpI0DlvpPBqUFX3xW129vCSAZl+3TIQJ3OMdT3n2rwkJWaxjHi
	 +JAhq3fJ9SitWBWQLapW9gCKTSEuJ/WTNwqkDFONHGjSx08FnYiuNka+LX/MpYBeR4EI3
	 5tpU2/2QDMiVuuYiActvdv1iVo5c2A8pJomXZbqlG7fhwC6rXBwg10L6JBnGQbFPq9uYv
	 udKZSQbttB+pmS73c9xWIB66sr9Z5jf7Gy9FnIpIKrwNi3InOkK+EkKnbcjxpa/vXlEJx
	 JNzoaTTS1RG8+rosXqbhivaedDc+vCohl3b3ygZifTgy7n2loUTRpMJn+8NEIjr9vWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="stk9CpJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31697606A330;
	Wed, 18 Nov 2026 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stk9CpJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D081F000C4;
	Wed, 18 Nov 2026 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023481;
	bh=3yulO3x+YdBZlL//rQZ2lpAw0a6teblBupJwPJHwZHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stk9CpJ/1pGRWhwsZfyWtXy+z9fQ6HZLhafvTe6v3qQnllfg74OhrshQkMRQPbNeU
	 IytByznNHUIawQ+MD7JvdcJcJmyUqTXvwcQXwz3tI8wJxEKBCCivhUwjNkiW8lbycc
	 17ouGwYlKVdTvNBKk9qNiDDNHixrSlTQBd+ISsvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0344/2151] iio: accel: kionix-kx022a: Fix IPOL macro name
Date: Wed, 18 Nov 2026 15:34:39 +0100
Message-ID: <20261118150134.634722194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



