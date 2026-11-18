Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017717;
	b=KnUlc0doqwhQS/1iSxahqawM5+u/T9tLDWeDUeHZpZO+k191S8XzYLGRexW9cMp1x6IS
	 CFg5SNo4AyZVk+j9Iws6e/jAx/08K8varE3fBP57JnA10yFZxVEiDDtcrleCSM8HB45tA
	 61CNh+qFwkDBMYPIF5CtB7HuTfQRMOUgCVB6xg4/8F8EvarMu/0TzSbHcEu6Wqb+kTtFt
	 aBMQO6w763aBAE+Hh7r4L6/BFLevnVNR4mF6PNg+j1nJl0KsuNaSGAvGYivz7Kxsv5mhT
	 tvdOYMQgmyyEWVut90w2XfompFo39A0630JCaGn/+sZD3LwUTBJnSLnZngaBbHJAP9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CYppjbzQJbmanKImHlupVJ/GGzIDVyNIeXZ6RhAAaLM=;
	b=h/a7C+7LVrJTC7rr8unGSQu3owfQQ4sI4Jm3r8CJzk4qMHb+sDfPzEIOOaTv8FWah6oW
	 LF0vr8RsLw+5VAJQwVCogXACEwTDmSQmC4hAzEWYzsFTdxAaA4V1TW8iLT4MlJv2KwnaI
	 EE5t7XT5oMBAR1/Oi86T7BkI+fs0K5Xj2KafJuxdGCiB0ACEkUpf7i1n/kW0E7F3Uz0kK
	 XEMwRcQE4iHym853BPmAkHkrEG+/e1zD1+F2ON1HNGlYKPsksrXsI7vNqBTjWKKMFajm+
	 z0Vr5jRIxyhHGoPSsm0Yql8o84GctiJOCElO84LUYS55nQQ35br0OtuB8n8aooL3Dtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+4qp9mn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA225606A31C;
	Wed, 18 Nov 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+4qp9mn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054B41F000C5;
	Wed, 18 Nov 2026 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017717;
	bh=CYppjbzQJbmanKImHlupVJ/GGzIDVyNIeXZ6RhAAaLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+4qp9mn29Hb6uVPKwKjri7s+dDUZozZm91IBr3wcPOtODElIR7gLp1K0UHVsLXJU
	 l6CNg+Z+0CoUzfIokGhvQmMGMIfQa1MhLLqMuiMbamgljZd+ec9Nh5/n0PdzAv18vw
	 otBk3WYx/KZdby7nhsJShYDuSzj+ap1fdWhsPNdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0957/2651] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:36:37 +0100
Message-ID: <20261118150322.352986223@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2a9e907b5eb8c..1e21ad2a050db 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -9,6 +9,7 @@
 #include <linux/bsearch.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/spi/spi.h>
@@ -540,7 +541,7 @@ static int ad5758_read_raw(struct iio_dev *indio_dev,
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



