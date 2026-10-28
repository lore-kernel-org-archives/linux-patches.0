Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212968;
	b=VMenkwXqVIxYMU3JKAXg9U8ZvSki8ppeXIx6j9zyCIy8EWrVVyP8uGf7UCVja3wn/vZh
	 btb6qhMBDZCS6fZEM+U6S5I0tJ/ZV/XClN8+Hw5wt2rC+Uqp8ht9dkNyFWAHnzWPdJL8m
	 MJY6I3vno+qTAUg7UEWsj+aGrYzNEQa2mKhK3P6AIkG1HTK/+ALGnLliKTfiL8ryJ3dBH
	 gqq1QjET3dsWqvYA9fgX5ZD0ki/F+T9LJ2NdGJuoYbbn4F4htidg0YbLjYb+eCW2AM/Dg
	 Z+lcxWnFWzey/0SFD3axmRkbwGCQyIWek4RkYEC9WOjiD62ukZHjRmpGWG4YTbd0hSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z5/8dQ0vE9PrNrxK485FB6RlyH8JiOEZ08yv/8cEC2k=;
	b=GYuvAjmJesjacDZ7ShgrjS7OApG5S8tkU1Tdcb2BZ7f68k1RIqXstlgQQd+B3fsjB7/g
	 t2txfa+ikUB2tnuDEFtVcJKi8+WFCd/DRKgFbQlPo1Mu0aMTfAt3wWNDQebAnm8+dVZS3
	 MRgyLyl+ghZeTyXAN0yerby5G2j8iDoafAN2LaW05SBPR6kUfeDpuRXEhrdkKMTOnXeMX
	 TmTFwfK8yh7xn8sQHmBCT77nd2lNe6t0Mw1m0VEyYmeIKUu+LVGK6c0e6qAJSBBnvXbEC
	 IUP+bkes27ZJDf49XzsUQpM/fGj8c/tLJTDpMYWBG/HQHmNZkOGSnjeFu38P0prfZPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W80iYFIo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5A8606A320;
	Wed, 28 Oct 2026 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W80iYFIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374DB1F01825;
	Wed, 28 Oct 2026 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212967;
	bh=Z5/8dQ0vE9PrNrxK485FB6RlyH8JiOEZ08yv/8cEC2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W80iYFIofIG8nLVNjY2YjM+bQWQLDQtGbAa5De1ZRZafBEjvLnWzxHgmbSEAo5ghk
	 1EWFpFJoHRnUOUyhxQINEt7RAZwELs31td8sbkDQv+vBFNwpcLhmWiUB+B+UYyo2aD
	 hs6/GWnjEd+ZjZqrrmV2ppACOGz1dZvEe3+QZQy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0338/1887] iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()
Date: Wed, 28 Oct 2026 17:40:34 +0100
Message-ID: <20261028170506.919444912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 2093236e886ad9446ec3285ba520e024dd1464e1 upstream.

admv1013_read_raw() switches on chan->channel instead of
chan->channel2 when handling IIO_CHAN_INFO_CALIBBIAS. The channel
field only ever holds 0 or 1 (see ADMV1013_CHAN_CALIB()), while the
IIO_MOD_I / IIO_MOD_Q modifiers are stored in channel2. As a result,
the switch always falls through to the default case and calibbias
reads always fail with -EINVAL, even though the corresponding
admv1013_write_raw() path correctly uses channel2 and works as
expected.

Fix the read path to switch on chan->channel2, matching the write
path and the actual channel_spec definition.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -197,7 +197,7 @@ static int admv1013_read_raw(struct iio_
 
 	switch (info) {
 	case IIO_CHAN_INFO_CALIBBIAS:
-		switch (chan->channel) {
+		switch (chan->channel2) {
 		case IIO_MOD_I:
 			addr = ADMV1013_REG_OFFSET_ADJUST_I;
 			break;


