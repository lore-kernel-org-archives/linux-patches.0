Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626379;
	b=gYKUMXdjQHorTB3YH9zUGHRshsl9TPo4buNannuOURGVvOIK8qAZhCuiezcCL2eD1CBm
	 oS4qhxhYg+jHzxuHv9+fLZPDB5e+oMJfv6C4ZRDhqCFJSgx+sUr1TxHu1oVQyky+bQTxq
	 oVRH2MD5VsMPq+Hl07GKSo97uMnFn9JcD6T5rOACiCRJlTj4avz3UygqX+ENcXpJg7Mbq
	 e0sX8611M64QeyfQ3hfVeVQCX9cWJ5aa/dqEIkKeFLLkM8lJCCfk+R1Ffs802X5lW8bZl
	 s2UKXkw9K+F9eAUau4musoz40EQpbH3NUndrgoHrlogiRaO1CEda3UDKMTJahxsG+Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CShp1yipgGG2IlA5x6oIwsNQlfND9Vdb+MoLnHG12Xs=;
	b=noIJ9zD0pCZuEv5dpiE2qPJl2k6/qetgb1rEsgPYnuJX+BagZzMSwOiSAg12GU0HBrTL
	 KVyWysBdqwhZ+Bhp+o9FuqFWBj9W7cj2NOTISuz7lt9rF5pX44/DJfdllYf3wcVNpFWug
	 e6dRMdVwuXLCpkqUUfc0N6osaiaXPA9pNhC1n6DvdfkK0X9KlOkaBF9cRER7PMYJ0SJ5v
	 tEtbB9GtMXktO7nqra12ikLU+epyI6feSTqcBbYrnK1pSO+khXrccjM3J/WUoRWdxhcmM
	 V8/s8DzR0BmnUwDGlOvt37X/22F0i7z4OomqqSQK8X6vscEXY+l0RpeZ+0YMVLcQ4Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rVfFn/UQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE30D606A31E;
	Wed, 25 Nov 2026 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVfFn/UQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98021F000C6;
	Wed, 25 Nov 2026 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626379;
	bh=CShp1yipgGG2IlA5x6oIwsNQlfND9Vdb+MoLnHG12Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVfFn/UQGEO9YNOFLFZ1viHcdsvaa1bvAreKtBdnYStz+kMn07U7kVB0PR7E8YTbh
	 pVsI7rE4kUchginlm6gyT6EjYGqEhg4sukADV5pti0vUxJcbNklHeeLOYeAR6qdpTm
	 T9PZmUXnsxwA5Qcc4maUr5V7fpRPp6KvHWDoAtS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 799/816] iio: trigger: Return an error when the trigger has no free irq
Date: Wed, 25 Nov 2026 15:39:07 +0100
Message-ID: <20261125143907.666260195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -292,6 +292,7 @@ int iio_trigger_attach_poll_func(struct
 	if (pf->irq < 0) {
 		pr_err("Could not find an available irq for trigger %s, CONFIG_IIO_CONSUMERS_PER_TRIGGER=%d limit might be exceeded\n",
 			trig->name, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+		ret = pf->irq;
 		goto out_put_module;
 	}
 


