Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705776;
	b=Rrr0DhuabdWNp8SQLWi9D1g5hUHuUg/pbXv2DWbnO8FUl9X3X3jwl6VQidR/Qolz7ELH
	 ne9GpCkFpScVyjejoFUSHBUPA7zvkPwm3q48dsDWfzHjsqGUT/gHGDgBfXGPC2cTWL6mu
	 Uv9HW6w1OpO68Sb/Vijj7W0qqtG9JDfYCiCMxfG3JM6nQB2MvQKttmno8envXWHNC3u/Q
	 3Ljsw9Mfh5KJ/L7h8/eAfujixbiduzDCxdL0xWA+tIlDvpYKPVh7Xz/6k4sg28pEbEQ39
	 VEhRy4CRSdkYk0gP8ASMlxTJJ77ANq3fGJicH8JZC1lDmuaXAfW5QFboT5J0wx6N7Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9hh1L3jbJbCixeSCmUUo5dMz+TZtj/CK1CXWjqmqi0=;
	b=gJ4VDvuVfKWak7eaF+K2qbIsFZij2hRYw8anubEnYpb9gmN7SJpMxrB6RiWVvLXIzQBd
	 V/uDyWrMyEz9SVhXsKWuMoUegx44MRVMoiFz0xU6XQRL7RBBoNWkWEE4z8/DnD8YVCUHK
	 vlH8Xn6V9ZNCC3kG2CoDEJ17tFvTsip30bysN5yNuJdN/D4WWX1r+fAeqb4monhD3pCHC
	 eZCzBLQpjwlw7ZAVKxwJf6M+Rn6aKJHmh+1lBjAYXZvMCy8cW6IdQTA1Ucy03Jcf6zV35
	 1HeX6JGKrwptvaYsF6GHLpMhQdIu35I4Yk3qzmBVVdb1gU5FNGNlvQFjuCukR2LI6DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TI9Tk0Il;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200EB606A331;
	Thu, 26 Nov 2026 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TI9Tk0Il
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029C1F000CF;
	Thu, 26 Nov 2026 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705775;
	bh=s9hh1L3jbJbCixeSCmUUo5dMz+TZtj/CK1CXWjqmqi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TI9Tk0IlpSaKr99yCf7rLv+Ftkz6gu5oiORPtU2Cfq6VFvuY/OKRVZpPtT2kmd2l4
	 2Y1/FOa4KMTAWkTU1Xdt2lefhsqKJKzk5c9s+yQnfTIMJcigFpiD8BFZPxFymgQc03
	 x+stEk+X/pti/PgkDwQrD3hb0iN2uT8M0v5S4xjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 309/319] iio: trigger: Return an error when the trigger has no free irq
Date: Thu, 26 Nov 2026 15:41:17 +0100
Message-ID: <20261126144013.731989223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -290,6 +290,7 @@ int iio_trigger_attach_poll_func(struct
 	if (pf->irq < 0) {
 		pr_err("Could not find an available irq for trigger %s, CONFIG_IIO_CONSUMERS_PER_TRIGGER=%d limit might be exceeded\n",
 			trig->name, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+		ret = pf->irq;
 		goto out_put_module;
 	}
 


