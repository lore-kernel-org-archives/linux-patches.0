Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055535;
	b=GXHWaUoUVfOKshmi7sLqtBqr1eubu+X7G5Wo95w3tq8ABkwhd/SciAtS9w4D8aaF0SRG
	 tb/WD9cJInbvksrYk7I2tN+Q5HW/OyhrioGP8gNui3QAnxdzrqziWI9eGY+HK34K+bSyh
	 X82QhXMMuFSSIabW6iXHE10G/clSWCIIWrVPCUvW5OsEBQJWshKQqiyghA9AlBeOeih45
	 dFmuSh1aPUJLfmhw3Tyq03UQvgVzeF12lN9Da/gYxyWMeE/zM9cc2VhUAqq0M9b7F7/Jn
	 idDTSgoqzygId0kKIyGnvyi4gb7oNjuluGW0jQJkMxi1hxiZ+nDvB2S1StXf+EVZizg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QKPwJhhlZ3Nc+6nvStzuq0YQjyytddC0rvgz+HOTNrE=;
	b=4FuglPvrB9eeqDi1ZvvizYfA+HXdak3iOhNpVZtJhB7J2cBy7FYgYHmwYAAeImbBb9QN
	 XP8+6hzliyR5wNWg4tKcEd17MleOYX0h/lSJkDI9E5LjBe9BdwSqQYIrscOledso5TTDe
	 Mw8e02iw/hxH28kEl5WlkRlrnwn15pd08dRQrdlTuU0wV1XtFaxJDCXEcKnvWHPH32sqJ
	 FpQNCeCJnx4WBJYk/bcp6l4mxRYGqBCQChL7ru2oWZsA9NfOvISV8vG016JMdJ2y4tdX1
	 aWHEya2jq6Z4iwO9tBHx5gbMtJbTVE4qc3XH2XzKVEBuDy2PTtaza3+Pn07NGsO2x9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y9HejSI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19090606A332;
	Thu, 19 Nov 2026 02:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9HejSI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AB81F000C4;
	Thu, 19 Nov 2026 02:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055534;
	bh=QKPwJhhlZ3Nc+6nvStzuq0YQjyytddC0rvgz+HOTNrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9HejSI/At3y+iBBhvz+U7EugoVWo/8nhKlOdqQv3ILPVr2qHqA8UJrB0ShK53yti
	 C632X52EFgw14WNh9rbjv6zzLfthSD6f2txjLEQl16xooQja2i3qNGzwxMfX+0Kg/Q
	 WJV5MvSHEPgFxl6hFfG7++E8ESjKC5KSMvAoSrdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1639/2214] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:55:15 +0100
Message-ID: <20261118150117.498789145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a8ede7d6e640..12756f9134526 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -9,6 +9,7 @@
 #include <linux/bsearch.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/of.h>
@@ -542,7 +543,7 @@ static int ad5758_read_raw(struct iio_dev *indio_dev,
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



