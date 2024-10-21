Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1616B1E570D;
	Mon, 21 Oct 2024 10:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506852; cv=none; b=KEIWC/21DorJ+HtDYzxwBpYo/Rz/zp9+7PLQGJjZxZSCiaXD7TVzNlrks7ddLWBGbUe4YbLNaqCkygh4A0/ySj+c7+dh0W9mxY+cNJ2geK6ZJaXOJceuxVId0gpFqG4n20qUJaNwBmNlSK+7ibAQBGjOkIVpyS3bxWY4ScqrQ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506852; c=relaxed/simple;
	bh=Bvu3CGnwkSsOOM+sJBQGFwsjQCOFsux6k++5fesv+Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dS3P2ifWS/pqdtLUJpOxjAMJuW86V8KFVCfh/tp4/SeyDZqF7uc6aFXPAzDiS+WTQmZnutY9OlGXjKdNF0p0arEETn3AwspLE8yvMjmH119ETvUudjP8b7yBRjCqRU765y2yEpiYp5gzNuvv0Az0F2OazDkcdRBM8xCRB7C2VBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUzVoFc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUzVoFc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A35DC4CEC3;
	Mon, 21 Oct 2024 10:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506851;
	bh=Bvu3CGnwkSsOOM+sJBQGFwsjQCOFsux6k++5fesv+Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUzVoFc+B9q8R3mKAqd3+AY1Z9dSGheND9EVgq/J6lygouXs0MM9E1lUiO/M4MSHs
	 q15WTOOO6pQ5WNbO0iVkc+/RF+bMwMsnmbr2IoKfdYC6z+rHEbNjG4dZbJtOygwHj5
	 MkLqEcoQFqTeF+h/uimmr9WH7P7jQJRR1HRWvSNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Thiery <heiko.thiery@gmail.com>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 6.11 111/135] misc: microchip: pci1xxxx: add support for NVMEM_DEVID_AUTO for OTP device
Date: Mon, 21 Oct 2024 12:24:27 +0200
Message-ID: <20241021102303.668190851@linuxfoundation.org>
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

From: Heiko Thiery <heiko.thiery@gmail.com>

commit 2471787c1f0dae6721f60ab44be37460635d3732 upstream.

By using NVMEM_DEVID_AUTO we support more than 1 device and
automatically enumerate.

Fixes: 0969001569e4 ("misc: microchip: pci1xxxx: Add support to read and write into PCI1XXXX OTP via NVMEM sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20241007071120.9522-2-heiko.thiery@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
@@ -384,6 +384,7 @@ static int pci1xxxx_otp_eeprom_probe(str
 
 	priv->nvmem_config_otp.type = NVMEM_TYPE_OTP;
 	priv->nvmem_config_otp.name = OTP_NAME;
+	priv->nvmem_config_otp.id = NVMEM_DEVID_AUTO;
 	priv->nvmem_config_otp.dev = &aux_dev->dev;
 	priv->nvmem_config_otp.owner = THIS_MODULE;
 	priv->nvmem_config_otp.reg_read = pci1xxxx_otp_read;


