Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46FD13F452;
	Thu, 11 Apr 2024 10:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830554; cv=none; b=D1iF73oKSE5WNBTtT4pKY1/74b3AHEPq2JepPAiKbRWIav3bBmsvGDBH1DuIX0HRCDJ6lfgw83XVDS/7lQRwVmMUSdKgTvpK8hYwgbfXSGg6fwx42l9nbZSAW7Jl5rR7pTZSF4Ar3oUBlol9UUa5AZqMKGFP//815hKC7GtKks4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830554; c=relaxed/simple;
	bh=unEQYijzmM5PCgZcQepmRjZrG1Yq3emQ0x7pMDoqyAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hspt0aIT4Dxwt9FZJI6C34S/z5swslG+QMxc+xQkSJVGgKjqkNjuOuj//sWjSHBlQn0ByCxknq3vf5JqvW3rtf63RmFELwK78rCu1jzxcTaM1kY8ySG5t6dLgoT681iWkO9uLhAUTx29QSXP7U3/CaDG4vTmKLYNLlceA1uD8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtJaQR+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtJaQR+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE31C433C7;
	Thu, 11 Apr 2024 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830554;
	bh=unEQYijzmM5PCgZcQepmRjZrG1Yq3emQ0x7pMDoqyAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtJaQR+j0Cu3HwYIRXjXsPraqkpuaolrFQi5+u/R9wjG8+j98RmkTPXZSCflDamYN
	 QELg82D3+JNFdAUsWZOWm3B3R/9psB07zisZjLLIT6qOyqAkammXIW3i6O8RZgEf6L
	 szpNFZi6PYDbQ0uSOMUBa/AQjJntkFJ0+fvMGk7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20H=C3=A4ggstr=C3=B6m?= <christian.haggstrom@orexplore.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/215] USB: serial: cp210x: add ID for MGP Instruments PDS100
Date: Thu, 11 Apr 2024 11:54:09 +0200
Message-ID: <20240411095426.100613042@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Häggström <christian.haggstrom@orexplore.com>

[ Upstream commit a0d9d868491a362d421521499d98308c8e3a0398 ]

The radiation meter has the text MGP Instruments PDS-100G or PDS-100GN
produced by Mirion Technologies. Tested by forcing the driver
association with

  echo 10c4 863c > /sys/bus/usb-serial/drivers/cp210x/new_id

and then setting the serial port in 115200 8N1 mode. The device
announces ID_USB_VENDOR_ENC=Silicon\x20Labs and ID_USB_MODEL_ENC=PDS100

Signed-off-by: Christian Häggström <christian.haggstrom@orexplore.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 015dcaf58047c..88659a75f30f9 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -145,6 +145,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85EA) }, /* AC-Services IBUS-IF */
 	{ USB_DEVICE(0x10C4, 0x85EB) }, /* AC-Services CIS-IBUS */
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
+	{ USB_DEVICE(0x10C4, 0x863C) }, /* MGP Instruments PDS100 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
-- 
2.43.0



