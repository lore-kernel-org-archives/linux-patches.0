Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFDE2E091E;
	Tue,  8 Jul 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993852; cv=none; b=uwJEk3duwqB8IsmKQ5Y8/J7DAe32OlO0pHuTFb5sLJg1lfIZl/Rs3qH0C7A2R5DAyVM/AUgJd+T+BvtmmAdoBOOCInfPNaquwJUUIdr4UYe2rzakaNJBXCgXSFmDo72vh8ar2NPUapqOY6X9Mz0xj2CdejJT7oBozHpJnytAthw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993852; c=relaxed/simple;
	bh=jdX6NrJqbBmaMDRJ8P5/phzFz3N6Xl1hXUmOm5fGJTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnIMPZZ64hjffXdVuGg1CKFYJ2EeNtRDPpDU/Pfm+Lj9J1QD8ByYWxv5nsjwnrtajD3vzX0wglYsKbmaKPc3nyeRC/Ib2ZGW5h5HcjFe46g3DhltqK5BvuXV13bEJdX+g/QlUU9vzHWQXVwC89T69DZ3vS7MqECAOhFxFtwuBhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDk7Tap3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDk7Tap3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E03C4CEED;
	Tue,  8 Jul 2025 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993852;
	bh=jdX6NrJqbBmaMDRJ8P5/phzFz3N6Xl1hXUmOm5fGJTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDk7Tap3HvOF/+UTXzfWw8hgUnCcOdMqU9TFtSoENSX0TVi4GeGOTjfqOqpmFdn1s
	 d1lNvo3/wr3BAkfDXaKVJQi1nDWAZb9/HssEi1oELNDYUMjtu4xImfskX9OkUhLKm9
	 cmPpNPfXZ9A9cfo1HsWQIGAVB5dxBOIIF2Iiy4cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/160] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Tue,  8 Jul 2025 18:20:49 +0200
Message-ID: <20250708162231.847193238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 886a446b76afddfad307488e95e87f23a08ffd51 ]

On x86_32 s64 fields are only 32-bit aligned.  Hence force the alignment of
the field and padding in the structure by using aligned_s64 instead.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-19-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/zpa2326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index 50f3338778daf..741c95899e4ef 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -582,7 +582,7 @@ static int zpa2326_fill_sample_buffer(struct iio_dev               *indio_dev,
 	struct {
 		u32 pressure;
 		u16 temperature;
-		u64 timestamp;
+		aligned_s64 timestamp;
 	}   sample;
 	int err;
 
-- 
2.39.5



