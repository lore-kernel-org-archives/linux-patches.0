Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048728;
	b=SJN6l37LO+UvmHlemZJRw1jMQzoqDzbob+b6vxdMwG6k7Ne9Zwg0AFvHeYtuHhJNOqaN
	 QqPm/QtpmV5dGrIUMi0nBMKqhE7WGNenUebnVruyk7qzYxfX3hG9qlzHlKH+6es/IUQfi
	 +uGxtEwnz1clxt69svVqDSTplim4Np5R/G5+zpbGsQwOuxlfvisO4ZhjGqRZgv1g1NzfY
	 Q1iO8aeR+aYu8JTI3TtbDpG/yYs+3/cYkOxSra4n5LY9jSizSRdT/2NCCGdWcr2MaoOjr
	 /BnTs2aZ7+KrmOJYwIWgeEGzPGJMI7EmDM0GPfT3XB+UTvv1khFgXdiM2qWQZDY4Xlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=w3uOSVPldc6eKZQ+FqpvWKgpZ/6hUQHqLZx+IW1rMmI=;
	b=sj1K1E9Ymw+oXFsfc9As3X29tUtOBE6kU/lHo0YHYiEvAvU/j+ZpJua9Ao00NSdmgkVj
	 2rQk9iVGGJt1s5Z8HxcWDDv4b15boZcKw7LFJ/CPBt5QCtuMtlo62YAlGVLr/euX+oE+0
	 rsaT7baQ85B4Tik2iag4ajBNON/RNbAEghoPYXXCWnMKuaKOawqQZwReakrhWHRcV5yzp
	 ZD4KUSBtPm9nlsrx/JkV9V54oWRvJHlHj+B2ig8tBrJref/RIoZH/unix1hRtyWJ0kkRM
	 pA80sA7lVuA6go0fZ54TICbWHGSl/IWechy9lDqcK/x96jqzX+1aKHiu71cYVJTDP5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W65NVY9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5278606A31C;
	Thu, 19 Nov 2026 00:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W65NVY9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8C31F000C4;
	Thu, 19 Nov 2026 00:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048727;
	bh=w3uOSVPldc6eKZQ+FqpvWKgpZ/6hUQHqLZx+IW1rMmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W65NVY9IZUcYvCwin7GarEMy++HLRT609rpw9HtOIYIQsC5pm499xu3OGF3KMoIuB
	 Lh/lY3MUCfRDv18YOAr8fXDe6Xh1s/CSSHvbK+Ar+W4WBs3Qju+UMYOyE5mIX6azrY
	 n6bGMJw7HupMmMYY8t1LVsVO7354nNcGq42pkt4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2098/2857] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:52:12 +0100
Message-ID: <20261118150316.948677107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit ebc026be1b719e47bd7f2f1e72fabc875b590f87 ]

ad5758_write_raw() passes the value from userspace straight to
ad5758_spi_reg_write(), which keeps only the low 16 bits. Writing -1
to the raw attribute gives full-scale output, and 65536 gives code 0.

Return -EINVAL for values outside 0 to U16_MAX, as ad5755 does.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index d7fd2acd7dfee..19e8397b6ca05 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -557,6 +557,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		if (val < 0 || val > U16_MAX)
+			return -EINVAL;
+
 		mutex_lock(&st->lock);
 		ret = ad5758_spi_reg_write(st, AD5758_DAC_INPUT, val);
 		mutex_unlock(&st->lock);
-- 
2.53.0



