Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CBF13C816;
	Thu, 25 Jul 2024 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919333; cv=none; b=Sjf0xu6gvQ73C547HhnYQmqMXiwBTQQLFeoM5xr6MzXWmWhRkeuXMizijaE5A1DIRkfMWFAISMuUMrGRWNrrB/4/wEvNOwQdQghN3FhenRGtTjDHoHQTIoy0P80hz9+xcxvsb6d6eGfG4nljUWNvv9F6wyn+TY6x8Eijb38eF/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919333; c=relaxed/simple;
	bh=Ny/IpOF3V75070+A5Cn4CEFNBYh/UGYBoQi3yERo8t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyoIepGe0d9TGXj8aFeJwnWtxCN9xF4/3lnaMacifsqdiQjuYO94Pw03c588QalbHJgTtWjXeKaeyGVM5DnfkP718XfmKFaA4CN+8v4IKYK+Wc4gGDBxCGjha1w7gQGDuk23PTP3JTc5SMcp65U0k5USItVxAVvT93+YKVBWZzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+mboQpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+mboQpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5333C116B1;
	Thu, 25 Jul 2024 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919333;
	bh=Ny/IpOF3V75070+A5Cn4CEFNBYh/UGYBoQi3yERo8t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+mboQpPrbHec8UC6gUv8vbeUWnbunhKBcoAo7SiJ6YYsiB7O7HoOTcdqEkoKJhGO
	 lYKYs3jA6AD++myY8vaKpG+mJlUIveWF3P0oNbHEQZ16wtXdGqohldLuepLbqnO9/6
	 5NkpgB7V1XnCpEZz/zyYbZS2d2dXc56fuzmYlRc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/87] spi: mux: set ctlr->bits_per_word_mask
Date: Thu, 25 Jul 2024 16:37:36 +0200
Message-ID: <20240725142740.808248798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit c8bd922d924bb4ab6c6c488310157d1a27996f31 ]

Like other SPI controller flags, bits_per_word_mask may be used by a
peripheral driver, so it needs to reflect the capabilities of the
underlying controller.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20240708-spi-mux-fix-v1-3-6c8845193128@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index f5d32ec4634e3..e1af2d8ed51a6 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -156,6 +156,7 @@ static int spi_mux_probe(struct spi_device *spi)
 	/* supported modes are the same as our parent's */
 	ctlr->mode_bits = spi->controller->mode_bits;
 	ctlr->flags = spi->controller->flags;
+	ctlr->bits_per_word_mask = spi->controller->bits_per_word_mask;
 	ctlr->transfer_one_message = spi_mux_transfer_one_message;
 	ctlr->setup = spi_mux_setup;
 	ctlr->num_chipselect = mux_control_states(priv->mux);
-- 
2.43.0



