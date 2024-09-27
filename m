Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DA918BC0D;
	Fri, 27 Sep 2024 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440000; cv=none; b=PoUOswfRMhwH5Oq13/qI1JlJlmQMFnTJ2cRAurqXXxDz6+95tQa+EmgqzB9z+V4TTjrPvM32BiDGNTUE//eN1Dh7Tf7VhOhNN7+tdxf2zKhBpDPPpt8UDGblPaCLl3Rr+6LlIjZFTCqTjRxDbRicX/ely3Yf7Hbq6vx4Rw+EfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440000; c=relaxed/simple;
	bh=zMKR21tESs86fv01IB6D7EcMIcyMAqv5QXycgHRlQAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5zJmShvrup0g6+H8to1+ohnx6kIV5ULLMRoJP0ihpt8MzzKPEDa3gO4o3sMq5CsE7amLcaWibhUJUmbsZrUxy4cr553FGhKk3ArSNh7+p4kYGVLGZ0d8L5qIgLEwKlyMmO1Z5tcNFCqqB3GJOND/6MzNCPxfCfKlBmCBFnt7Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJqLO2dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJqLO2dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B82C4CEC4;
	Fri, 27 Sep 2024 12:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440000;
	bh=zMKR21tESs86fv01IB6D7EcMIcyMAqv5QXycgHRlQAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJqLO2dXV4sJn2Gwmt0I2hbYd65gLhLnNnPTQ5REihb3KB9P2QJuKw4Oasj8Wxioe
	 rAuVNjnni0S7D/9usxaGXQQ6XGC3P6wKEg9E2zKY5ewf+ZVew81m2p0gX8/2EyQGRu
	 BkQN65+hk49WAcp6X2cy5958YSySU+j0WKhJ5iaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 51/54] can: mcp251xfd: properly indent labels
Date: Fri, 27 Sep 2024 14:23:43 +0200
Message-ID: <20240927121721.859685040@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 51b2a721612236335ddec4f3fb5f59e72a204f3a upstream.

To fix the coding style, remove the whitespace in front of labels.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c   |   34 +++++++++++------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c   |    2 -
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c |    2 -
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c    |    2 -
 4 files changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -791,7 +791,7 @@ static int mcp251xfd_chip_start(struct m
 
 	return 0;
 
- out_chip_stop:
+out_chip_stop:
 	mcp251xfd_dump(priv);
 	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 
@@ -1576,7 +1576,7 @@ static irqreturn_t mcp251xfd_irq(int irq
 		handled = IRQ_HANDLED;
 	} while (1);
 
- out_fail:
+out_fail:
 	can_rx_offload_threaded_irq_finish(&priv->offload);
 
 	netdev_err(priv->ndev, "IRQ handler returned %d (intf=0x%08x).\n",
@@ -1641,22 +1641,22 @@ static int mcp251xfd_open(struct net_dev
 
 	return 0;
 
- out_free_irq:
+out_free_irq:
 	free_irq(spi->irq, priv);
- out_destroy_workqueue:
+out_destroy_workqueue:
 	destroy_workqueue(priv->wq);
- out_can_rx_offload_disable:
+out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
 	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	mcp251xfd_timestamp_stop(priv);
- out_transceiver_disable:
+out_transceiver_disable:
 	mcp251xfd_transceiver_disable(priv);
- out_mcp251xfd_ring_free:
+out_mcp251xfd_ring_free:
 	mcp251xfd_ring_free(priv);
- out_pm_runtime_put:
+out_pm_runtime_put:
 	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 	pm_runtime_put(ndev->dev.parent);
- out_close_candev:
+out_close_candev:
 	close_candev(ndev);
 
 	return err;
@@ -1820,9 +1820,9 @@ mcp251xfd_register_get_dev_id(const stru
 	*effective_speed_hz_slow = xfer[0].effective_speed_hz;
 	*effective_speed_hz_fast = xfer[1].effective_speed_hz;
 
- out_kfree_buf_tx:
+out_kfree_buf_tx:
 	kfree(buf_tx);
- out_kfree_buf_rx:
+out_kfree_buf_rx:
 	kfree(buf_rx);
 
 	return err;
@@ -1936,13 +1936,13 @@ static int mcp251xfd_register(struct mcp
 
 	return 0;
 
- out_unregister_candev:
+out_unregister_candev:
 	unregister_candev(ndev);
- out_chip_sleep:
+out_chip_sleep:
 	mcp251xfd_chip_sleep(priv);
- out_runtime_disable:
+out_runtime_disable:
 	pm_runtime_disable(ndev->dev.parent);
- out_runtime_put_noidle:
+out_runtime_put_noidle:
 	pm_runtime_put_noidle(ndev->dev.parent);
 	mcp251xfd_clks_and_vdd_disable(priv);
 
@@ -2162,9 +2162,9 @@ static int mcp251xfd_probe(struct spi_de
 
 	return 0;
 
- out_can_rx_offload_del:
+out_can_rx_offload_del:
 	can_rx_offload_del(&priv->offload);
- out_free_candev:
+out_free_candev:
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 
 	free_candev(ndev);
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
@@ -94,7 +94,7 @@ static void mcp251xfd_dump_registers(con
 		kfree(buf);
 	}
 
- out:
+out:
 	mcp251xfd_dump_header(iter, MCP251XFD_DUMP_OBJECT_TYPE_REG, reg);
 }
 
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -397,7 +397,7 @@ mcp251xfd_regmap_crc_read(void *context,
 
 		return err;
 	}
- out:
+out:
 	memcpy(val_buf, buf_rx->data, val_len);
 
 	return 0;
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
@@ -219,7 +219,7 @@ int mcp251xfd_handle_tefif(struct mcp251
 		total_frame_len += frame_len;
 	}
 
- out_netif_wake_queue:
+out_netif_wake_queue:
 	len = i;	/* number of handled goods TEFs */
 	if (len) {
 		struct mcp251xfd_tef_ring *ring = priv->tef;


