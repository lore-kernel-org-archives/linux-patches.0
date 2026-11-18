Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048730;
	b=j5WbJJWKUfdZgWuOisVkbLDAJwvQ3ZP7TN0N0PqQLDGbnVMeFF6eKbZMc/8puNNMGJ3a
	 PpLNFzJ9bun73fCiNYtc0r418HSdsERYQJCI4UfRsMdiNoaepUJ1fVKuXGfOdN4Ig18V0
	 RtEvJp9HkN4Ev2WtBpKXHs82JXhllPZFgfdfcSruzHYpC91wgR3cINY8hsG2pkoMmSbhs
	 zCFXlQesqVZvaXRB31/3rdFxozYknM9/opYgVeotZQ8lIPlQ4fYrrcJvoS3TbMVs+bIRt
	 BatZcxiyF7aKNH2eHWRCWvJ3DpQHMrplOli/h/CpHf+19zi6wr02RqoOODHqbI0GZ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=98JnmH5rXGZFp+hVnnvI/xRizYQ4Kn4knzma8KYidIw=;
	b=pjcodIwHtaMv8Brfor02E4/BVFauUGOZf1JGp/pN2qP6iwxFmTcZX3IPgC/REe3wvHIK
	 FLVJ7FPUsqFP6Ayzq0rswtiC99Q2FDl7ZXRI8lMWcG5LWsWN2K08j0inQJo/I1s9CcCIq
	 bunGXc2qM6I4cz8lkebWUu2fG65cnnmrGsU/iC2hTAZW0Y85W2lWA/iwJ796ESDMPXgty
	 /kE7ES/FfjNWGdRWVeJKwdp7rTuKzzVtCYMdfcV4QqkHesrcgzhm+XqXZj7rC2v/Z3oKy
	 MoryBZqhDQfqqV83A4NGwOFnHGgd/97VDc9WvdhQajy+L61zWtR28lp5SUU5xflyahw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SWqAoU78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A920D606A320;
	Thu, 19 Nov 2026 00:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SWqAoU78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DC41F000C4;
	Thu, 19 Nov 2026 00:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048730;
	bh=98JnmH5rXGZFp+hVnnvI/xRizYQ4Kn4knzma8KYidIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWqAoU78Sop15NomxvH5CSp/qUmzDNRreB8kNEB/AORpzAx7ORS6OSoHECV4E5PA6
	 l8azI4SK7MYaDajMrlfSOhwOyLYrjEGvt69iUnqdl3yIni4Lgepn29h3NbLGofrOP9
	 ExC0Sa3JJyWNDZEIbdFgOrDZEIs5VP9Dv8ZzffqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2099/2857] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:52:13 +0100
Message-ID: <20261118150316.987729049@linuxfoundation.org>
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



