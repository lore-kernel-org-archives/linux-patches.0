Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E571C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADA9C433C1;
	Wed, 23 Nov 2022 09:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196194;
	bh=VXRv0y6xY0jPwHcNM1H07341PsyTBnUYhW9WJTx/3uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsTstYCmVbg6nbLE4NlY7aSmGInsYe1urJ+/ZO6UERmflAHgZmsHkqqxf8qUm6ppS
	 HfWxodWQW815FsCjpCevJcaS1yxCE87vZMeHEeFxTApiEIbGtb9VCk9Ti0C3bv+0/C
	 fMn8w4UQZhhT3/nkN/6w3Mdn7AZJHeEmN5+C1Y6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Tronchin <davide.tronchin.94@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 128/181] USB: serial: option: add u-blox LARA-R6 00B modem
Date: Wed, 23 Nov 2022 09:51:31 +0100
Message-Id: <20221123084607.898092851@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Davide Tronchin <davide.tronchin.94@gmail.com>

commit d9e37a5c4d80ea25a7171ab8557a449115554e76 upstream.

The official LARA-R6 (00B) modem uses 0x908b PID. LARA-R6 00B does not
implement a QMI interface on port 4, the reservation (RSVD(4)) has been
added to meet other companies that implement QMI on that interface.

LARA-R6 00B USB composition exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parser/alternative functions

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1126,6 +1126,8 @@ static const struct usb_device_id option
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x908b),	/* u-blox LARA-R6 00B */
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */


