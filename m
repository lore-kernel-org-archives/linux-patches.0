Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212993;
	b=rmenAiylEZWuM7QBVA6bxlHREV0OCoaYmluqyyL1UrE3AbqcX8QgXHYzQ5gjjmB1AafH
	 vwAJcZNdl8QZP6m26bA0I+6kr01tIBpsmvMK5zrYiVj0E2qvvBU9bodISs0nHbFm+UokA
	 8P9vBDB2zKyV1nhj0v6hA0/p2MKCV/Gvl7T7c4gCKVmg+K9e3vJwmaaXT+Tb5fTAu+Fcn
	 Q2CC7oJOyz2PuOfll73vS+VsKeouiGMBO+qkoYRl2uGFChME5P9O7eCrIqkuLri+bJ0IO
	 jiBGwcHMKlpCbmSGpV8n8EqN+u4fYkGhQfavR12zDEb0ZNm9sy0COOrkhRsMElSuS4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eh6eedSbfbHqO2q+zU9CuKXIYydS4bxDM1YUBzbOrzU=;
	b=IMh2jrhiREK+kXPB/EZADAa946nkRZWoORejEu0QR2BkuNw/7NSU4L28DobDgS8poc8t
	 8sfLEmy95XwGKgIbic5W7EoIcNE3a1XeypSKQVGcj9U9xUtI5IxgetOPkOnR+sDJ6cGgQ
	 9V+91KdGMOtAjM159GV1bw532ewDYeX+mzHV7NZ6PGpi5xLJhJWT77B2S4tM86dAU0V6F
	 hQM8qrUxe76OFA+A3fO4tC3H6kxT3P3URCATtn1SU+lZrNj48WG8UjBWlvvrpd0NlcHr5
	 +LuBKkz1DcYnvagndJuihCIylOYLIrf92NPL4NFa5NK1Aq/ePdu2Uxoj9fV0kH5Ybbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxnrWUTZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE94606A31A;
	Wed, 28 Oct 2026 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxnrWUTZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D021F01825;
	Wed, 28 Oct 2026 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212993;
	bh=Eh6eedSbfbHqO2q+zU9CuKXIYydS4bxDM1YUBzbOrzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxnrWUTZoqjnhtYG1wWesMq6LXPVIv2bHCFqzXLIjZbkjK0H6mKoU7FT4tQLEDqpD
	 Bvc9SEGNhwliSOyu++/HEgxXv+OmJ6Xjfyd+uCog7qCKgkepKfvTgFbEdkwOofOqpd
	 QJVcsNe0rQfI+1+fJzHyD1pLzinD4DfIlNrOLkY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0342/1887] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Wed, 28 Oct 2026 17:40:38 +0100
Message-ID: <20261028170507.009488611@linuxfoundation.org>
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
@@ -1565,6 +1565,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1587,6 +1588,7 @@ static void gp2ap020a00f_remove(struct i
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 }


