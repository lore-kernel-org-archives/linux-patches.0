Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212951;
	b=0dT3kQRDdrDvQJJFNNg2nG/zViQaZPtZOvB3yJ0UGXuJ0Xx0qQAGYInOLs5y9upVQWEs
	 QjBfy2G0Er1w4j2f4gnLE1dvzPImgciiOR3CXN/UJnTodK39HQ7b0j+0Y6Diw+Hns7tvV
	 iSL5XoN9UIvywAHOKc2Eu+EEknnwp5COGjJs4rTRF6I39LZy2aKzB2sSzNZAbJzIURow1
	 rgjlA/55f8stZ+UjYu7MH/abwuZFupGwuFT1rlsbIlzDkRzXtoBNPQTrsvENzO9QxMuKd
	 TAk463Q2Oj4k+yBKTRh4z+oye3jf5UjtH9QvZlS+q7lMNkLiBtbMfmnsa+nzo1U7k7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ZleuBzCOuBGqNx24nl3eBk7yrucLALwAsJc/4kHDkw=;
	b=lrpm+nLQEI8zqb9F6UzMex7KBSUtrfNI0pClBPQUZLkuIM5RqDy9VcM9nV9rTPe8lINu
	 s2Pi89KWWjMyrFCc9L1HqWj4oq0t17xLZQnqs7qIMoOJfLaHAE33CPUFAV2HxVLk/co8e
	 IbdbhEeaiVduYWbdohQbYdQDT5FRPf0xq0RYCIxbQ3PDgxk2Nlqh5WGEzMJsTVzoUIKZY
	 dYS0oSuim5QcJoces7R5Y1V1wYYkOssvi4Ojt5/MzxnH1kyR5OwTMpKy6RY9h++uzE0L1
	 ZK4IBQmEoGdmuOIPVAeYGIJcp303RFN8jbqgaUHUP+GinhFPchVNrgZZDlu0AKGIRig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0ECtcIu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC071606A329;
	Wed, 28 Oct 2026 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0ECtcIu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236E81F01829;
	Wed, 28 Oct 2026 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212950;
	bh=+ZleuBzCOuBGqNx24nl3eBk7yrucLALwAsJc/4kHDkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0ECtcIuVDGVCobIX3TsDl5N8qrJUKpfCO5UY1COdV/n9mdyxKw1BsSJFv2IAXEFZ
	 AlqXKfgwkMIdPm2xGThArQ9wdI7lnkMgAEvnM1bQBFdhgBEY9Hg7aliY1d/MmFUsNd
	 qDLpFM9h78mVj9afxLa3N1Gh+KTJUc08sBY4mLPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0333/1887] iio: accel: sca3000: fix frequency divider condition check
Date: Wed, 28 Oct 2026 17:40:29 +0100
Message-ID: <20261028170506.806354983@linuxfoundation.org>
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

commit d380bf5f94a892e546d9a94e8557ad866b043a2a upstream.

When setting the sampling frequency, the check for `base_freq / 2` is
followed by an independent `if` statement for `base_freq / 4`. If `val`
equals `base_freq / 2`, the second check fails and falls through to the
`else if (val != base_freq)` branch, returning `-EINVAL` erroneously.

Fix this by chaining the checks with `else if`.

Fixes: e0f3fc9b47e6 ("iio: accel: sca3000_core: implemented IIO_CHAN_INFO_SAMP_FREQ")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -652,7 +652,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


