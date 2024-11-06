Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FE71DF24B;
	Wed,  6 Nov 2024 12:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894867; cv=none; b=ORGWlrYE6T28PRXIqAyHtb5E7Ik8PgA35YONAUePZJn4/4z6A5pFXG+IDRUfEp9U8dn2Syzh+NUgMJCZ8ok40oZMtc0EtzZcfQfA8IjGDAN2eIdMr9EL7U+q3T+Kmw2sogRiXiwtJc4jMYYnMogEXqmb+ujcNmH1nPGCMuCO4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894867; c=relaxed/simple;
	bh=Vhr/rbecO1zjpzQP2XevugyrtrI0SJ0k00PPjKuf4/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6PzxIQ+uHxjo4qhxyCDdef/S0QWgQ6ho+3tG1LB36W2zu6Fjikidi332H45mxO8whXkFs3Dd43nm51AWmej1Trlsf8Jfg23MjU3B9WYCr/ewmQnZ2vs/Or7OCJxv0CHxLmaw6hghVwL0Yt8ie3EoKP4lvEjSEoVNfbZlGiPY2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tZpJTRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tZpJTRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF0BC4CECD;
	Wed,  6 Nov 2024 12:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894866;
	bh=Vhr/rbecO1zjpzQP2XevugyrtrI0SJ0k00PPjKuf4/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tZpJTRPTLKteGDUqpQWwyEMg71lVYSSl3FrM7P2QirgHbtk2RW6xtTLnbF9pGFg2
	 9ghXDRlFQbRqrGV1w53B0pICFJvDXjZRFjhW/laCQdzRb4XbTZAE4+xQxWTk1jpRnf
	 aAx6et4nOJU9zBqUegVEz3qkEZfWDNcoOJn8fMzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 027/350] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Wed,  6 Nov 2024 12:59:15 +0100
Message-ID: <20241106120321.546867430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao Xie <bigfoot@classfun.cn>

commit 7d47d22444bb7dc1b6d768904a22070ef35e1fc0 upstream.

Add the device id for the Macrosilicon MS3020 which is a
PL2303HXN based device.

Signed-off-by: Junhao Xie <bigfoot@classfun.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -112,6 +112,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_PRODUCT_ID) },
+	{ USB_DEVICE(MACROSILICON_VENDOR_ID, MACROSILICON_MS3020_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -165,3 +165,7 @@
 /* Allied Telesis VT-Kit3 */
 #define AT_VENDOR_ID		0x0caa
 #define AT_VTKIT3_PRODUCT_ID	0x3001
+
+/* Macrosilicon MS3020 */
+#define MACROSILICON_VENDOR_ID		0x345f
+#define MACROSILICON_MS3020_PRODUCT_ID	0x3020


