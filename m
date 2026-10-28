Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211101;
	b=NvOICvgIVBasq5aJmiaiPiRNU6DVe9qqfeMshvLbXufimTzQe7ipZ6kBiA8BCzC6nc/I
	 7Ix4qzAfQ9bTivqCe3WfTst859oYAsR6yqW+uDr8/fJJ5yhQkK2N00KQvGBKEA8zUGLYI
	 K/GxX8d+0GmkT6Rp17EfUfJVMckLzmIgTlDo0ubOxYHYHfHUEurDxwFwPIArO+x2QRYL8
	 1HhC2s5KOhxXQv5ZMQAgQrEZn+SZk1UnbEh2uFaBclGTS5EFeTqa+os+8u2j5fc/mdbHJ
	 32gNIeqCZVza2iba8bYDptCjxHhxthE9r3qR0OrMeAnNptRCmbdnOlPK6CIrqPlP1Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cn1gDMOiDiQUJWM2VlxIMgL58vnA05XYw+JqdbOiOLY=;
	b=wi7CaBiF2Igy7qAkKn/1S1Wp8NukHIS9vhyN45I8INGKPF2T/ZmcqM5t1JUXhPl+aShv
	 Yg1yI9yZj3ltYgW4MKvM/NFgdozFnecUBhH330tpiauMeu8TvILrg6ZScj+NWgbXicgWE
	 AnVMhx37FhrLrV1u2kbB2cw7kM5s2Iylxs6epNPnRowGDYMcYACNN7qVlOMD7satVaheV
	 D7z+GsCK8DZcx1mn47ud6yVRM1dGHb8F27gM5+BkVKuV54G3QMyq6J2Gro6NjN2FRU7wA
	 466fdq03J2W3gfgaP51wZGI5SA8wOo483RYuwlMkVTXqDg9NUsFw4GX0AZYuNrFWAZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXqU0Bei;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E060A5BC1;
	Wed, 28 Oct 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXqU0Bei
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8A61F01829;
	Wed, 28 Oct 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211100;
	bh=Cn1gDMOiDiQUJWM2VlxIMgL58vnA05XYw+JqdbOiOLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXqU0BeiF6RyQpu/u/KtEgRq84NMB3xsPhCNo0BWce/rjrGflmRJa/v25i4hhZ7QI
	 PHbgCO0OwGLR0LK4eXd1a5bRoa9zI1vRo93g462v2dRF8RA2ZHZodnhY04pW9vu6G2
	 79bwwxdHVZAGOkRq1AC9xk5x+J9QKSYRUxQtQ67o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 258/571] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Wed, 28 Oct 2026 17:56:45 +0100
Message-ID: <20261028170014.128685401@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 63213927b141085b6c8719b8037dab3074b7e0fe upstream.

The threaded IRQ handler queues data->work through irq_work_queue() so
the trigger is polled from a per-CPU context.  free_irq() does not flush
an irq_work the handler already queued, so after gp2ap020a00f_remove()
returns that work may still run and call iio_trigger_poll() on data->trig,
which the devm cleanup has already freed, causing a use-after-free.

Add irq_work_sync(&data->work) after free_irq() in remove() and in the
probe error path, mirroring commit 78601726d4a5 ("iio: trigger: sysfs:
fix use-after-free on remove").

Found by an in-house static analysis tool, confirmed by manual review.

Fixes: bf29fbeaa13d ("iio: gp2ap020a00f: Add a driver for the device")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap020a00f.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/light/gp2ap020a00f.c
+++ b/drivers/iio/light/gp2ap020a00f.c
@@ -1570,6 +1570,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1592,6 +1593,7 @@ static int gp2ap020a00f_remove(struct i2
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 


