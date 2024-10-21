Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918581E47A6;
	Mon, 21 Oct 2024 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506719; cv=none; b=VAzvrHtkad/8E8GTR+t5IGv/wYXR4Rb8p9imxRny5MAfktaCCH2q411gHq9/dMAlKUCHNfBP8uXX61SRDW4Qy0E1IefVkeN8A/nyln0eall7VH25SK+ck2WSgKeUk2obcxuDRkDLqCiIP6WR7h8jhrxetVJxsmS7Cwx4lnBZC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506719; c=relaxed/simple;
	bh=Mxm5sz/9AG1BdCBsMcS31zaCSdZResGK+tgID/8Pbzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTyx4mdZ97vLZw68yFSjTWx1OIajD1JoJmU7ZScBpD2XyPPmlN+Lku94N0rRgVhWMszhPpVcnf1xqP4jisFntF48smLGDWdycjuJ+cOe2rooLS1coFxWs6rOWwhbKYjnIae1ytvKbK9/eWz8JkjOHPixsqTyBrJOuOaGE5gt/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya4OjBze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya4OjBze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA7FC4CEE5;
	Mon, 21 Oct 2024 10:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506719;
	bh=Mxm5sz/9AG1BdCBsMcS31zaCSdZResGK+tgID/8Pbzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya4OjBzepk7ATFdgX9yPQdH+bNmtZ5Q/2qtBbibPBmvEX6v7Vv1kLvZMTogoIFQrT
	 V3nj2Gyqthye4G+dE+I5zfs4jzfjA6YK1gpSv8cHSYLTRr94no5tfIhFAiGujBsVaF
	 G1RgNcFPX1zi1T233L+5obrGbsRwXrLyXKVYcu9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 071/135] iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:23:47 +0200
Message-ID: <20241021102302.108683558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 252ff06a4cb4e572cb3c7fcfa697db96b08a7781 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: 8316cebd1e59 ("iio: dac: add support for ltc1660")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-7-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -354,6 +354,7 @@ config LPC18XX_DAC
 config LTC1660
 	tristate "Linear Technology LTC1660/LTC1665 DAC SPI driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Linear Technology
 	  LTC1660 and LTC1665 Digital to Analog Converters.


