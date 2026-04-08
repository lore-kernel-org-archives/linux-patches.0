Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46393B19A3;
	Wed,  8 Apr 2026 19:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674801; cv=none; b=r1QfTSRdcWcyPFnnY+T1aioU+x7W/2gMCIcx0n6yEDgSk85BjTFP7wXg0pIk/3y1et/TVuUlEfnc6ZwLNk/0jNim7jBrhCN4azCzsrrV7IqTHrjdxJxtWucwyBqhh1VLLhOKzfdEyqYHtEbRAMsXCZSjNgXYksu0G7UGK1PjZ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674801; c=relaxed/simple;
	bh=ZSsbgmTE4ASjbI6DX6YNtNameNCw31Fm7P/Xd8TlwzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVEOPXPxGEGAn9bqRl/CbdFdd8Q7bITjC9Wgt3jTyKcXOUF83HUCijss6trw+6rISJznEvwnnTOjM2pWvhsJ7owqHzMTl82yRr5WkA7awiDpISI/l8ncGFvwvPwSl7qxnd5EIHBmETjdRKqTGuHlFZNIrDhXZfP43RpilPVogi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlxHFyL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlxHFyL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49988C2BC87;
	Wed,  8 Apr 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674801;
	bh=ZSsbgmTE4ASjbI6DX6YNtNameNCw31Fm7P/Xd8TlwzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlxHFyL+qMDri+Jq+TceCpWH069s/f7M9D/xyadBR7FCUG6Kp3mK/88GW6seEYnnp
	 M/eySPL+MSJ16XaAjJ3yLi61OnUFQAbeMkZmFNadNPiNE/507OuH2qOqxBWWfN5MVB
	 5C3VWP/c9a2irSq2RYB25hrWTy4y81euHnFrWKNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 237/311] usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive
Date: Wed,  8 Apr 2026 20:03:57 +0200
Message-ID: <20260408175948.245878302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit dd36014ec6042f424ef51b923e607772f7502ee7 upstream.

Another Silicon Motion flash drive also randomly work incorrectly
(lsusb does not list the device) on Huawei hisi platforms during
500 reboot cycles, and the DELAY_INIT quirk fixes this issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260319053927.264840-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -402,6 +402,7 @@ static const struct usb_device_id usb_qu
 
 	/* Silicon Motion Flash Drive */
 	{ USB_DEVICE(0x090c, 0x1000), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x090c, 0x2000), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* Sound Devices USBPre2 */
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =


