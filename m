Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229C42056;
	Mon, 23 Jun 2025 21:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715188; cv=none; b=FRM6slSCznVWTK1sbQ7u/oYuUJwMXBfN+fPfD4Pevgwj+PiBDQJAG5TMjXr0dnxJ+fEyyG9yAn4chhRh9uK26/fN7ygcxdxjZnYhDCx1+t8fMduY6M8l9DUyBqs2rWCxsKz1jUTvKDG2gXOxq+2Gywpklxbn2Y1mZT5va6KiRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715188; c=relaxed/simple;
	bh=TVw0Tj1ksQt/NsqhWmbRo9BjEvUSotE8+hxBmgRoPy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK856ctl2LzlLsHQfwzu4WvJZcBYU7nz6g2jtkY7pCwvTN6oTKSCdMLlsasKTkgG8FiwRF12UIIZFsQk53Y750CCttnr1cgkjSQkZFVFxDnYLKODz8yqjZiKRAX9eTkrKI/HH8/D6LMPEwOCRAwyaKZnCYKU2rXmq+uHFBpAQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKjlDiGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKjlDiGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F3BC4CEEA;
	Mon, 23 Jun 2025 21:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715188;
	bh=TVw0Tj1ksQt/NsqhWmbRo9BjEvUSotE8+hxBmgRoPy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKjlDiGJDtTrOOiiPmYfiJmR2vphF/ITjuGSojxGwnJIVEsiRaizQAu2xi/BXATOE
	 yrzRzXNDE43OKOoZh3uyhJ12QAZG0TPQrOJPhGIfU2yjs6FngmqlL2JUHd4auYFhbd
	 rCdD9ynIp+0q88E/UyBSjbB2UN5sd2RKlLUBlnVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 258/411] iio: accel: fxls8962af: Fix temperature scan element sign
Date: Mon, 23 Jun 2025 15:06:42 +0200
Message-ID: <20250623130640.142479960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Sean Nyekjaer <sean@geanix.com>

commit 9c78317b42e7c32523c91099859bc4721e9f75dd upstream.

Mark the temperature element signed, data read from the TEMP_OUT register
is in two's complement format.
This will avoid the temperature being mishandled and miss displayed.

Fixes: a3e0b51884ee ("iio: accel: add support for FXLS8962AF/FXLS8964AF accelerometers")
Suggested-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250505-fxls-v4-2-a38652e21738@geanix.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -497,6 +497,7 @@ static int fxls8962af_set_watermark(stru
 			      BIT(IIO_CHAN_INFO_OFFSET),\
 	.scan_index = -1, \
 	.scan_type = { \
+		.sign = 's', \
 		.realbits = 8, \
 		.storagebits = 8, \
 	}, \


