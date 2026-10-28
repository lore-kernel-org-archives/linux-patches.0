Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212965;
	b=OjiZzhSK2SFTB0SNTXZCwGt90+GVJzn438OA4hZ3I2rQ34YajypLQslKUcWVRmG0Q+QN
	 ivo/8cFhQY0tvXziHulkKMwssy3DVyeld/Vq6CAlD5/mueVAV59Z65BQlYputeYU+tXzy
	 rspfmPnJh9iQA+8clS1ILvakmytXn5y6+Tt58mWmHnVVfWqWQyvalcoICYf8NzuOmMK3l
	 ZgsaPkoaAbjLM8p56BZkEJpTPHtKtPM6UwFfpvhJvFm8p0MtpdM6bcAtRrlADwgtpINsm
	 bpE5+g4iTyoFZBXTzAGj6OSDao5Gva4Cuo/+EPJtDcWoZp/pCWFHWIHsffu9WIYwiPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GQjzgTiEOibl7vHBiMNHW/z5AY9k7Uf1EYY21AyDgFY=;
	b=kXiKXpqHBo/0EIlJVog76WlkH5C5roUcWC0EMpvibagl1V3pHsFYFlcOk8Y9cwuPAPj0
	 xZLOlYtgKXN7sPTEVEYigRGzBXWFPOqB20yXTO8mV8LjtLF4+nt8dEuYxxhwTWINjQ8Jx
	 THcGAQhaP77sVzY8h4RLLbBRkWZB7lMcm6DV7J/zBgwf7PyiblUpZXPURkp4vqLNKZmgN
	 W0fWtc9a+VJ2H8olOZ8DE4bJ3h8CyOpxoC2AKqrPIrryiedvZ+bXn02IP9RblV84PAFq+
	 kWRuofx8XHOKBma6JC0l6ZGyF9NkRdWS2qgt/01zJROojIJkoMFZ5WzTjVyfMaoA8/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnn2fJ0c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31184606A31A;
	Wed, 28 Oct 2026 18:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnn2fJ0c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D051F01825;
	Wed, 28 Oct 2026 18:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212964;
	bh=GQjzgTiEOibl7vHBiMNHW/z5AY9k7Uf1EYY21AyDgFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnn2fJ0cPT5YEiIFqZ5zHiLZoV25XhAj5FHzXpXjZU4xzg2d5HRDhzeJaY6NRsvy0
	 1PR8zxaGTbJ+iQAw9JHjzsPpKZXtKPFGyuTZvvhFU0dkUvQ+SkYs3R3Dy6aah+Ta0M
	 yTTDwQCoCTZ7XiFuzMzvegwAwPZ16GzzEtKYWiqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0337/1887] iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.
Date: Wed, 28 Oct 2026 17:40:33 +0100
Message-ID: <20261028170506.897338372@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

commit 5330036bc68d23672bfcc16c60c54701ae123083 upstream.

iio_push_to_buffers_with_ts_unaligned() leaks uninitialized heap memory
to userspace if the data passed in is not a multiple of 8 bytes and the
timestamp is enabled. Specify __GFP_ZERO for the devm_krealloc()
to ensure any extra space is cleared.

Fixes: 95ec3fdf2b79 ("iio: core: Introduce iio_push_to_buffers_with_ts_unaligned()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260529121005.1470-1-kimjinseob88%40gmail.com
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1905,7 +1905,8 @@ int iio_push_to_buffers_with_ts_unaligne
 
 		bb = devm_krealloc(&indio_dev->dev,
 				   iio_dev_opaque->bounce_buffer,
-				   indio_dev->scan_bytes, GFP_KERNEL);
+				   indio_dev->scan_bytes,
+				   GFP_KERNEL | __GFP_ZERO);
 		if (!bb)
 			return -ENOMEM;
 		iio_dev_opaque->bounce_buffer = bb;


