Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF12E1DDCE;
	Tue, 16 Jul 2024 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146281; cv=none; b=kQ4T+FEldqu4ptzmISbPQUrZsTJ9+3KZ+3DJ8ySR55A7jp5DEs8axtbaPWB8d6H/taa0tgR5j/bjkA5koy4d9bTsIo1hCPmwaW3g7sjT4Fqq5qPTUSMrG68CvwTTKxgaeS50y/jXRXbdLusZ3O+qaEdyjUC+TiN8Bq+SJaoGKpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146281; c=relaxed/simple;
	bh=HpQZNm5PaXNPTHaKEgdtYHumxpqcXJu3rbbtSLCwajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1xw2jsvUZMdDcnYQX1uen4J7pc54+mm/1MYfRK0nkniZJSoO2P5BG3UYTLfhIqp9eEowoLQpssZ5i6KkkPE/afgAYOJsxI6HGdBhc3nCbSH1En/YDm3q1wo6d7RM+Wx7HptSLV3iC42yLAa3B6VwSQuyxZANWFcKwxGMg0NYYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PB4Wg4bV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PB4Wg4bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4615AC4AF0D;
	Tue, 16 Jul 2024 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146281;
	bh=HpQZNm5PaXNPTHaKEgdtYHumxpqcXJu3rbbtSLCwajk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PB4Wg4bVMBF9xEcvFgV2RKMc6l7BZ5ER83bUiUTbpupzUhDHmguQ4shdzF+O+EJ6Y
	 /xjtWJsnaFrG5IvheoMTwL4+b+zN2RQMY2v4y9AXt7wj+CDEGixO/9GreMMXTUedEW
	 UD3Gv4+wR4NDTxaGq400QhVSLst0krtl4KH2eoLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	jinxiaobo <jinxiaobo@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 5.15 114/144] USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k
Date: Tue, 16 Jul 2024 17:33:03 +0200
Message-ID: <20240716152756.911915532@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: WangYuli <wangyuli@uniontech.com>

commit 3859e85de30815a20bce7db712ce3d94d40a682d upstream.

START BP-850K is a dot matrix printer that crashes when
it receives a Set-Interface request and needs USB_QUIRK_NO_SET_INTF
to work properly.

Cc: stable <stable@kernel.org>
Signed-off-by: jinxiaobo <jinxiaobo@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/202E4B2BD0F0FEA4+20240702154408.631201-1-wangyuli@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -503,6 +503,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1b1c, 0x1b38), .driver_info = USB_QUIRK_DELAY_INIT |
 	  USB_QUIRK_DELAY_CTRL_MSG },
 
+	/* START BP-850k Printer */
+	{ USB_DEVICE(0x1bc3, 0x0003), .driver_info = USB_QUIRK_NO_SET_INTF },
+
 	/* MIDI keyboard WORLDE MINI */
 	{ USB_DEVICE(0x1c75, 0x0204), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


