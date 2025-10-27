Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5CD31E0F2;
	Mon, 27 Oct 2025 19:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591695; cv=none; b=p3ODYwl3gPdsBIX98JO0e9Mq9gGCVHEdc4oCcv426azVE26SmNNu9L0Wu3EiVoyuleOQ8KzVdliIBAsmgommNfIrNzw2zQj9Ylnd0H04Ktfyg+QAeOUWGz/Bc0FMXeiHXOfWHxcjksOLk5zILqQQUbvs0q+RkOolSfVdB3IsX9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591695; c=relaxed/simple;
	bh=jc8TUUfRd4wRYRx/GrypAxwQYiYqnBYplYgJw+vGf8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTRqUcW7rKZWYkhG1MwT3Md2OpGmSG7XtvL+JlFuiaKVSjTpcYm8MjPTeQT+H/XV9ruW95SyM0x5fNH8aS9i2d/cAMeFm0ToqRrvLyB5rASvMfwhI21rFE8qPdLylriAd0nkh/DNh6tp2083DtSuhapNIU9MItexVRPBKjSfeN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jliGsGJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jliGsGJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0B7C4CEF1;
	Mon, 27 Oct 2025 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591694;
	bh=jc8TUUfRd4wRYRx/GrypAxwQYiYqnBYplYgJw+vGf8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jliGsGJNgQDQy0DluQtXl+qM7uFZWXcQoITXPKr9aOb6qbSIg8HGxdS7PRPRHTxEl
	 LoywemjL3yuv58mTNpsjsDfmiHnzRJPs9Btbkk2ljfJGgxvF7aZW+Y+Qn5cc3usfzU
	 1UzzB0emAVUWTRoDx73JgAvph38HOdYKBpwS1nD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 5.10 294/332] usb/core/quirks: Add Huawei ME906S to wakeup quirk
Date: Mon, 27 Oct 2025 19:35:47 +0100
Message-ID: <20251027183532.616721575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

commit dfc2cf4dcaa03601cd4ca0f7def88b2630fca6ab upstream.

The list of Huawei LTE modules needing the quirk fixing spurious wakeups
was missing the IDs of the Huawei ME906S module, therefore suspend did not
work.

Cc: stable <stable@kernel.org>
Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20251020134304.35079-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -462,6 +462,8 @@ static const struct usb_device_id usb_qu
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
+	{ USB_DEVICE(0x12d1, 0x15c1), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
 	{ USB_DEVICE(0x12d1, 0x15c3), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 


