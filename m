Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212962;
	b=3DMQVhtMxLeKc7mYKVyrmZEC8yF5LGRY3UcphY4exOmuwfwlvDiLKGXYFsYzigV/kdSX
	 qyfEwkWF7/tEcEK4whAkJy/NHWwKke0oNoeVQ1AN1F7Je0paxE0TXsJ4pGhLdrwwrJV6U
	 MgvbULa6diha1wFX8/9YX/2STDG7XHcHwDQlom/9OA0uKJhQK0koRMIk/1wtFl6bxCa8J
	 vIlBIFOdVUUSW0awihVotP+kMDSxIoiKCxrpHJeXQvxM6d4rVyByk6l9yEqMclH/SSWfX
	 W/70PGqR7L81KMtp5ilodO54a8hsrmD2Q89qdCwytv3a5qPRRxXXByBMz0092xKQBag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ar6VOtduIbMS/WduYQ131MsySdC59ySu/8OQQjbrr+g=;
	b=uW5/B9R7a08F0VbrouK23WXQLOWaHw+bpNVvJfmFjl/E+ENMV/A0lPjXRR5edF0x8q5p
	 4zjQWSUehlELYyDjOvEDR9acQsB43aO/pF6hKRRFjDcFW3TC6JMcddRZNPs5QjwstWZ0y
	 HZF3wG0Vu09tZQzCtS43f/IM3yAGBJAyxL8RzhtUg37PjKlFHBkErefLVlFe5m/XJH2Sr
	 W2BBZQjYXjvvP+P69VNefNKkf33Ege/LWREnT0V5ZJg1yY7Atfab5zoFeLZz9T5Kk6e3m
	 fh4kiRM5bLtTy00onoabVJDbeT+jm9DpKnaVenQCdODjaIwR1gFn/Ok+Ah6s8kZcAWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYkHWbX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B33E606A31A;
	Wed, 28 Oct 2026 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYkHWbX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEAD1F01825;
	Wed, 28 Oct 2026 18:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212962;
	bh=ar6VOtduIbMS/WduYQ131MsySdC59ySu/8OQQjbrr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYkHWbX6V/DpuAwdTHCxkgJOu9kp2TLevHOU7/xMtKacbiKQZ0AzxGaJgYYQJk7Ao
	 X0h4KQm+yMK8wu5aq221ra+hC4zer98qwTnxHthAc5cLOvVQb8M4paESoCpAhCFkvW
	 kMKDDOJ8KuKTMpvF8Ycff/n0pXLxaWul/gwTNypk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0336/1887] iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind
Date: Wed, 28 Oct 2026 17:40:32 +0100
Message-ID: <20261028170506.874502587@linuxfoundation.org>
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

commit 0f3f427076240e75ff265e61645627a71ca4918c upstream.

The ZYNQ XADC alarm IRQ handler queues zynq_unmask_work via
schedule_delayed_work(); that work is cleared by a devm callback.
Register the devm callback before devm_request_irq() so the devres LIFO
teardown frees the IRQ first, ensuring the handler can no longer queue
work by the time the workqueue is cleared. Otherwise the handler could
re-arm the work and run it after the xadc structure has been freed.

This issue was found by an in-house static analysis tool.

Fixes: 2a9685d1a3b7 ("iio: adc: xilinx: use more devres helpers and remove remove()")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-xadc-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1406,13 +1406,14 @@ static int xadc_probe(struct platform_de
 	}
 
 	if (irq > 0) {
-		ret = devm_request_irq(dev, irq, xadc->ops->interrupt_handler,
-				       0, dev_name(dev), indio_dev);
+		/* Clear out any work queued by the interrupt */
+		ret = devm_add_action_or_reset(dev, xadc_cancel_delayed_work,
+					       &xadc->zynq_unmask_work);
 		if (ret)
 			return ret;
 
-		ret = devm_add_action_or_reset(dev, xadc_cancel_delayed_work,
-					       &xadc->zynq_unmask_work);
+		ret = devm_request_irq(dev, irq, xadc->ops->interrupt_handler,
+				       0, dev_name(dev), indio_dev);
 		if (ret)
 			return ret;
 	}


