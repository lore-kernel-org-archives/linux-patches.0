Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041716;
	b=1O+fvlD9v4ilWeyj+SV7dxpxOoGg+1Oc2fpSJwHUzIZQddmHzhayaPqW2Z3X3WwXm0uu
	 6rpDIxCVxoVX+zj8YslxsNBQTaB7/IK6WruPh0APmDC74bulwsRhUHigwSpUiikYutvst
	 dB1ppzYyQo8WvFVJYXN1t3zcv1MFyNNLkjO0jYy6nV5XLVfom/8/s1MpW5ovruq01TX7n
	 zrdvuPjWNr+yqHtSowEGlNb266SrweWcmUUa1VUSx5Uhw5AkzkAICQKQ2R/nPe3XkDeq8
	 OZIP7haRj3S+rM0acMSj3JTsPBKZpO6Y3EDA5HR3d8vZpVg8F7lMBCQx9u9+SQSI7bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ozs886vxazTo7cAI1GONQrm7zSX0yzsvWzJjXjSwuBU=;
	b=AxG4SFTdxsIrjaQD6s3KVzjWQpaRT0pq64utG6YS8mCokv2Ql7fGUi4tRBGHYf26LAr0
	 kJSH8tJoMFW+9H9/QL5UjvMyOy8chBuBrT2aLDVFzJoXOlMbr4aOQRQRnF1cNdLR4fC9h
	 oujHc4ieXfWwZjyR+eNkECa0tuJ4BL2ut8Cq3Q3jKpC0rYpY6Yoce8sTzXU5DFadBmzrA
	 7WtNzc0wG/z6o5VUQQbQW/GuQ0X0XWvjBp38YmWHXIUHaZRsz/RWmpi8x8touXCMRxTPR
	 Qw9dECn55ddX4rHFaY1CKp5JfaFx3eCOg6ILBs/3DzSY3ODY+uhC3/E01Q3rcevFRcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aB0wRSPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C71606A320;
	Wed, 18 Nov 2026 22:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aB0wRSPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BA21F000C4;
	Wed, 18 Nov 2026 22:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041716;
	bh=Ozs886vxazTo7cAI1GONQrm7zSX0yzsvWzJjXjSwuBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aB0wRSPvv9GtaNHQ8aYzwfA5FCK9ArdE3msU+nNGWP84OiTGMnNteeDT8O199XmjE
	 VcEgVr2bnFAD4/aKlXc3M5yAQx/soS+G6Pjf3FAIvsbn8RnwP0lbOKvnHC2Gc4K7wR
	 2jlM9tMRMgW5mKUfUSKrgr/okht0aBwfSMRXz6x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 2913/3318] spi: Introduce internal spi_xfer_is_dma_mapped() helper
Date: Wed, 18 Nov 2026 15:58:55 +0100
Message-ID: <20261118150447.834378051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0535cf64e4b1ead224fbbe1c25c81221a298c5e4 ]

There are few drivers that use the same pattern to check if the transfer
is DMA mapped or not. Provide a helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Link: https://lore.kernel.org/r/20240531194723.1761567-2-andriy.shevchenko@linux.intel.com
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c126e07bde21 ("spi: omap2-mcspi: handle DMA setup failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/internals.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/internals.h b/drivers/spi/internals.h
index 4a28a8395552d..47a87c2a69796 100644
--- a/drivers/spi/internals.h
+++ b/drivers/spi/internals.h
@@ -40,4 +40,12 @@ static inline void spi_unmap_buf(struct spi_controller *ctlr,
 }
 #endif /* CONFIG_HAS_DMA */
 
+static inline bool spi_xfer_is_dma_mapped(struct spi_controller *ctlr,
+					  struct spi_device *spi,
+					  struct spi_transfer *xfer)
+{
+	return ctlr->can_dma && ctlr->can_dma(ctlr, spi, xfer) &&
+	       ctlr->cur_msg_mapped;
+}
+
 #endif /* __LINUX_SPI_INTERNALS_H */
-- 
2.53.0



