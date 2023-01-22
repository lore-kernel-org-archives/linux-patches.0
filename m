Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85482590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0CEC433EF;
	Sun, 22 Jan 2023 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400450;
	bh=Abx/xixK3TRoFNk9y2qH71j+LuCtxV2AOJFGdA40zuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBt2CqnceLW/kITKKWaq49C5AUSi3baZQBzGm8jW6txaDSQGUf7x1KZycl2zbyj2a
	 ECjAPK4I+9H9OM6O/5gzT9OgIzq0uTs9gAre+YkEVNvNcQLoAwzC4fZrDFtF9C7W7t
	 lHIP9WwNfhaFpakle/9/gfbEeFV9LYNU8M0RmYRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoph Jung <jung@codemercs.com>
Subject: [PATCH 5.10 50/98] USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
Date: Sun, 22 Jan 2023 16:04:06 +0100
Message-Id: <20230122150231.622657563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 14ff7460bb58662d86aa50298943cc7d25532e28 upstream.

The USB_DEVICE_ID_CODEMERCS_IOW100 header size was incorrect, it should
be 12, not 13.

Cc: stable <stable@kernel.org>
Fixes: 17a82716587e ("USB: iowarrior: fix up report size handling for some devices")
Reported-by: Christoph Jung <jung@codemercs.com>
Link: https://lore.kernel.org/r/20230120135330.3842518-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -817,7 +817,7 @@ static int iowarrior_probe(struct usb_in
 			break;
 
 		case USB_DEVICE_ID_CODEMERCS_IOW100:
-			dev->report_size = 13;
+			dev->report_size = 12;
 			break;
 		}
 	}


