Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211103;
	b=IRGVvEAfaWII8S/EccCjGzsy+tAYWd8YhpKMvmkD71S+uwhDucntUDu0zRenJObdZn2v
	 qwaqAPY0IYkjBubZwCTpuVZ996Z7Kqc9ajOd8VAwDde4Y0HovFiqEL2+vSYkIsQ0H1tpE
	 Aft5wFCh/ejY0bfMc1ALU/4lFh76QctV3A56jp4tgvASPoPUZUwDVDmokkgRwBVl3wbyD
	 R3OU9PsjkHi6b0Fvv/M78WTIhLoXwxXaNzUnEH/+Lby776ytODHQjvcs8CEWMlBMUxsxX
	 6TXAlcIBaamquiZgtyBCEkZxwe3Wk8OSaNAPL+JXgbXgItNvmLmZ5CuABbue2Irj9fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YIQV9DVuSp/fWBgUHN+nB1Nufs4Ds2/7n3rFYXzBG6Q=;
	b=CTR1PxSALBxl/fX7oloRjUlATO5DvKgSny77PK9X6G9MmDsxtq/80LEXCC7pMXWkNYvt
	 z94AUhIVUvpKPEwU+a3xBJjqIhz7ekgXuty1bJWNOqsXyN702QGI5NYRzHxWBEn/El9Ha
	 plNX/xM2LnzYdKhgMPU3o9Dg8huVoPNMlz1qpHmhNjJbERVFjtfsX2K57CdrH1ct2PAYP
	 jNHg3d3122GmehWt6R137LkVdbApR1L6brNmhdgCuBeX/G3lOSftUYYPtZHB7pRaOrKrV
	 +dW64rOnLhBYPpRbHTpmHyO475XoHVIVX34HkYR/c/V+Ky9+9fHuYldAoYN5vnr4XGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnA+zYwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C74560A5BD2;
	Wed, 28 Oct 2026 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnA+zYwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1271F01825;
	Wed, 28 Oct 2026 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211103;
	bh=YIQV9DVuSp/fWBgUHN+nB1Nufs4Ds2/7n3rFYXzBG6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnA+zYwUwTh25T3mIiyNOUU92zdfzchd2tQoE+C5hz+N6tJ+TukhC6NO9w1iSoySn
	 +Isuw7Q3/H+8dagi9AbTiLy+kstaQRFK+4DT7RhtVZQK6brXNsqN/GmyIU6SYRivoX
	 ujG54Z+U2VfaJ0TUT71WMGjXW1bj8/4l6kwVthpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 259/571] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Wed, 28 Oct 2026 17:56:46 +0100
Message-ID: <20261028170014.152195417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit e8dd273d199f5bbe295a8e3d8b777c5505b6b2e1 upstream.

isl29501_register_write() was returning a u32 instead of an int.
Since the function returns negative error codes (such as -ERANGE or
return values from i2c_smbus_write_byte_data()), returning an unsigned
integer type prevents callers from correctly checking for negative error
conditions.

Fix this by changing the function return type from u32 to int.

This was found through manual code review.

Fixes: 1c28799257bc ("iio: light: isl29501: Add support for the ISL29501 ToF sensor.")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/isl29501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/isl29501.c
+++ b/drivers/iio/proximity/isl29501.c
@@ -227,7 +227,7 @@ err:
 	return ret;
 }
 
-static u32 isl29501_register_write(struct isl29501_private *isl29501,
+static int isl29501_register_write(struct isl29501_private *isl29501,
 				   enum isl29501_register_name name,
 				   u32 value)
 {


