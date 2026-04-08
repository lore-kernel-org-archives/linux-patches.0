Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A53ACEFB;
	Wed,  8 Apr 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672773; cv=none; b=YUfvnt4Foe1QsanG3xbaQ6yK5lUzz1ozmFh5AKeUFJbHDYW8I6fbXLQVMXgZgxq9d8w4g9UzlqBb2Ce/xdFcImMjxTLYAjZWGK9IL4dDMx988bXl/jXaCNxe4Bcn0vVIqHJ65Coa2EAF8xlDAxg6LAkFemZZAC+Xt1Ap/jbV9S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672773; c=relaxed/simple;
	bh=N3uxZeYvsDZR3Ar1SRAEZMWUZMYEvO07IXbAEx4d/HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKjAGeTfE7Abfkwb9Z+KxfYBc0qj4LKa1GpYCj1XWTWFI+vcDWu3sNRlHU0uKBetE5efhwQVjB5rEmQ6qBn5X/vhbIB50Bn699A/RayIp4qqOpTLK5wsi/SkDXV9F9yOhbE4WmrCCVuCYPzBog9FKtGHM2Hc58o7P7uwZ+lweUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aC3xuODe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aC3xuODe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8309BC19421;
	Wed,  8 Apr 2026 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672773;
	bh=N3uxZeYvsDZR3Ar1SRAEZMWUZMYEvO07IXbAEx4d/HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC3xuODeqlr18QJ9tsGmzc36vb8zN5qf2fWU8zFntb6SmtbOXa3oTE+P1IlfXGPs8
	 atAh9dBkMWaoJ2aymiHAnrKg+XM6xU7BzB22BGEjkvyCibKc520dfWzRAOARr26/s7
	 jNijsUEUhNcKG77wn6MUkyrIoeWwuY+g93LZmK5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 104/160] usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive
Date: Wed,  8 Apr 2026 20:03:11 +0200
Message-ID: <20260408175917.066980598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


