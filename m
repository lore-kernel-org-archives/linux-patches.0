Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704819;
	b=4WNvrqOFeqah2VFeuPt9r01LBdyzlUnTZW9zxMZdtcdwLcPerUIzE91CElZzv0Cco+iD
	 jhvY9/qGEKxY5NwLlPp+c0RPD/k9ZULvOrO2IR/RgYXR5wvyOX6EnOmk2rw+2p6fFQ/AZ
	 Go81MsebgkYh9erGj5szEVA6GIvmn4P62IEKA0rN7Hx2pYUZZSRBo5OqhbpH/IZ8c+gmi
	 Taq5klrPJweowD6kg2+Kj4r9RYE+mOVXK9E85gGYCVre803miGoLbd0U6u/luxbA+vxwP
	 mk4ra/f574P9ggul+KFSpqghVe57b5YikQcM5eGa/odzSkd4yCPSZg7RTN8VfUySuRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSh93P6dbCYUUIgnlTg9Vzcz1FYm+F0s7Na8ZcULtxI=;
	b=a8+QRysZf96kmGFAV6lCBWvD+rjA5Q9vInCh1Sh3vleuFT0h89eXw0zcEpP7RfhHHLR/
	 W1cF0JUVSoLe+P8OIgmGmQw/gGr32AgjiLw/dIiXa6OogphqPb6CmmGSjP28BZuyz3WYO
	 DBv0ghcDJ2dS2vpGkNrCU3Q4JK6tXJCw6KTtqq0XvzyEnD9gDEHawCCgqZsBtNE6m9URi
	 72/bCZU9su6OOPvOUaXQzbejmvxDJ5De6ztnoeZiWFrwmWWr1RW1aJAmC6tM5W3zhcU+0
	 7NJq7e4P9Mrr1V9YXZTCS0POEGn2x3QNuUKkXHFVIrqdDUlQgJ7o5P/JaNsk0WmJYzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQRo3MHJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D87606A31E;
	Thu, 26 Nov 2026 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQRo3MHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C741F000D4;
	Thu, 26 Nov 2026 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704819;
	bh=QSh93P6dbCYUUIgnlTg9Vzcz1FYm+F0s7Na8ZcULtxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQRo3MHJ2bjk43nCFNMCpC0gHBTsrVMwjKcKBI19YcZVHks84bIODlsd4XJyDJMpl
	 Pz3+4iaKQL5p7LOdrrkX1iSOBNy9J0JBtIAwoVumFFZPlqPZDE1WC4ilsiob5+fNhs
	 TJnMXMbGI30laeBjOE97h6FAZVBuOkmE8zAnPrQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 254/265] iio: trigger: Return an error when the trigger has no free irq
Date: Thu, 26 Nov 2026 15:39:44 +0100
Message-ID: <20261126143623.031218034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit dff701806ab6252f6a0fccba880c47cd09602625 upstream.

iio_trigger_attach_poll_func() prints an error when all
CONFIG_IIO_CONSUMERS_PER_TRIGGER irqs of the trigger are in use, but
returns 0. The buffer of the extra consumer is enabled without a poll
function.

Disabling that buffer calls clear_bit() with a negative bit number and
drops a module reference for the second time. On arm and arm64 the
clear_bit() goes about 512 MB past the pool bitmap. That is an oops if
the address is not mapped, and a bit cleared in unrelated memory if it
is.

Return the error from iio_trigger_get_irq().

Fixes: 995438233579 ("iio: Fix error handling in iio_trigger_attach_poll_func")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -254,6 +254,7 @@ int iio_trigger_attach_poll_func(struct
 	if (pf->irq < 0) {
 		pr_err("Could not find an available irq for trigger %s, CONFIG_IIO_CONSUMERS_PER_TRIGGER=%d limit might be exceeded\n",
 			trig->name, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+		ret = pf->irq;
 		goto out_put_module;
 	}
 


