Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030264;
	b=AlKMnUZZzE6lSKzdmscwkpmiRT3fSDYx2RYK+49EujXmNt8uip+Os72+qnyOeB46hdPP
	 o0qJ7W7hW6UpQvnX3aS8zJ5Rlzqg/kzjQ+EWV2tf4Ab3vCrldYdF4d53/vdm6qO/w0x6v
	 G3oYy+GOd9+r7SrfQLlLoHkSSP2Ze4N06aWVUBnYdEmxnXKriZ8VLKBjyMYIpA9cUWt/r
	 qWmJihlFcVmKawh5DFLh0/anto8bT0bTNhZi5qQfOYOrPd+muLjsZkErAOR+kGjCjvhXC
	 xSnQ2N1aW5LA4ZUDeZsnTss5sBrEo+bePjy5nlboYFebg1+Jct9SbOdWCjg7AwshQfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ouZDug8l746/NEGWIX1sOcmM7ZnRgpp8GWSOmUn/iwk=;
	b=3eS0vMwsCmdbk0ELk5BUTT9McfR3vwS/s3lrw0X1b1ygD40NeY0DjP8okzbRO6NGsSnQ
	 g+yRMOjs0pjC2FvMr8a5HgM040amfrraP919UR3QpVIdWqtJvToa6ndcjUJZ8gt4kDCmt
	 h/Al8r2L+sZcwIPIuAJ7HkW2EfqKMP+2mXj1IyDZaQx5t8VgBvXLMOCLT041ElMHYgWya
	 qlpiFGP1NllngZ9PC4Q9dbTJgGGCWhjRVHQ502fnfUwrHumaCmuAx6SgsLnHU3qjNSag3
	 BIjQ02/o03KRWNlsjZc2/e3dwrNcYqBruVpQCOFe92egPL/joiMktRVxm3HLNT2JguQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwvnPSPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E63606E7C8;
	Wed, 18 Nov 2026 19:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwvnPSPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9A91F000C4;
	Wed, 18 Nov 2026 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030264;
	bh=ouZDug8l746/NEGWIX1sOcmM7ZnRgpp8GWSOmUn/iwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwvnPSPfN03G+78tEFdpFAqtvKDKTO8ZuJMlvglZeXqyMm6uWoQiTihx6Ty/nWnkl
	 +v3AFF7irGwE3CyMTjRCE7U1cbRIsw3m8Qz/yQE+yd0PYNkg6tmM7SfoC+o9NU4G1I
	 MSvrBJY3h6tmaPCWj2J2yyKOKLVLy/mFb26zH9vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0641/1756] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:46:08 +0100
Message-ID: <20261118150034.367348764@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit a3b3580713f3ac5a32dc2874ee546828977a1d68 ]

The offset is a count of DAC codes, so the microamp or microvolt units
of min and max cancel out and the final division by 1000 is wrong. For
the +-20 mA range the driver reports -32 instead of -32768. For the
+-5 V and +-10 V ranges min * (1 << 16) also overflows int, and the
reported offset is 0.

Drop the division and do the multiplication in 64 bits.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index 19e8397b6ca05..b444c21719853 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -9,6 +9,7 @@
 #include <linux/bsearch.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/property.h>
@@ -541,7 +542,7 @@ static int ad5758_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_OFFSET:
 		min = st->out_range.min;
 		max = st->out_range.max;
-		*val = ((min * (1 << 16)) / (max - min)) / 1000;
+		*val = div_s64((s64)min * (1 << 16), max - min);
 		return IIO_VAL_INT;
 	default:
 		return -EINVAL;
-- 
2.53.0



