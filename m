Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208903;
	b=PDX6KNkmUMBOJae1ICIgAmKTOKEWNVGHuVnEfd2XtpAgDlfRaHtXoXj4mLM1ZH2KPXnO
	 4cwk4aZQBih+1LFzlPd/y/zCPXmgImAxRez/NwwLVho8gW2MVaJHWrfe4o/ByTS0sfvwb
	 sCgwLttUzKvRv7xwf6uzqOjLfXc4H/KS2DjrV1auIkIERpDw6RAw/3mioq87Cz9jCzOys
	 FNcDm4cz1tCMvPEOAxohkRvWQeKGwDdXvtnOC4EgKo4oCnlwO2Y2qpO4s9QHmVSwZJ2Rd
	 s1poiLfZDSGFP+GkqFuIVEg624/EsKNuRli6BveH5WQ3SfjgVZd13zEao5qDUfRD/Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXFTXcudzWpuiJo1HI5e5r7RuTdkLcsjIdiM14nMhjU=;
	b=IOaE4pEo5aU8ijOJV1l2yfx67Ytq88t72mZc9DFTnyS2IB8/n7NcL234puK6T3zj+qBV
	 pMLNnkQfKNGI++V99nXxhFHXLHQpKpz1hZx75vTrKeera3B8DNMGlEaiC+Qjq7WAphsky
	 +xNFcnJk27en1kzvSzmw4gFZotuIRVfjTYM17LGE5u+UT/92DzpkCMJUmCoS6jVJV89ui
	 qOKHf094wDQ0b6ssCUCYJArFG11bWGaRhqT6UVmPdvoNr8bUU/XTYHsLFCfsCPklG2o4U
	 XafL9XWVI5ozErOu9I3HbNPkCBdQQ3RnBhkYhvcXzqBY1HphdKqf+fXbJgMKv9LGscA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAMu0y6n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6800B606A31A;
	Wed, 28 Oct 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAMu0y6n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF21F01825;
	Wed, 28 Oct 2026 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208903;
	bh=VXFTXcudzWpuiJo1HI5e5r7RuTdkLcsjIdiM14nMhjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAMu0y6nksI1r5/TEKDvdiO492EIR0Wk8Xr7vCeZ3lDeMRCVamMaC9lsee3QwGe3k
	 GzvwkZNmek+uFxRiG1QcE5JXnyhqTB1DGxOWFAbpI6MtCK6cFd3ul87sTTXWu0Kbsc
	 vQdRFVccKRgYkx72yvLTb+ATvfV+gEECAx72sGRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 240/516] iio: light: gp2ap020a00f: drain irq_work after free_irq
Date: Wed, 28 Oct 2026 17:56:32 +0100
Message-ID: <20261028170009.187809022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -1571,6 +1571,7 @@ error_trigger_unregister:
 	iio_trigger_unregister(data->trig);
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 error_uninit_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_regulator_disable:
@@ -1593,6 +1594,7 @@ static int gp2ap020a00f_remove(struct i2
 	iio_device_unregister(indio_dev);
 	iio_trigger_unregister(data->trig);
 	free_irq(client->irq, indio_dev);
+	irq_work_sync(&data->work);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(data->vled_reg);
 


