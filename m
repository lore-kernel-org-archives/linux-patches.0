Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4C7E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE88C433EF;
	Sun, 22 Jan 2023 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400042;
	bh=14cn/NlF5MWK9KYQH14Rd2ZbJ657MG0mzFh629Cckc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzmarzLNQwBy/wvrX2gv819319+fb5izUji49yF+ynWFjeQ3ajoKgq4RrlD+GMHgN
	 3H/OTZmzDsvqmzMbwFdLgRGyFNrJFq2llLHBHpoGJONxRAkyQ5yrZVMfABWhcYSUhj
	 bqXPvcJYYAAMXF3Z1pgkCuBK3/NJbzpoE7AaPUDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoph Jung <jung@codemercs.com>
Subject: [PATCH 4.19 18/37] USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
Date: Sun, 22 Jan 2023 16:04:15 +0100
Message-Id: <20230122150220.321860427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
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
@@ -832,7 +832,7 @@ static int iowarrior_probe(struct usb_in
 			break;
 
 		case USB_DEVICE_ID_CODEMERCS_IOW100:
-			dev->report_size = 13;
+			dev->report_size = 12;
 			break;
 		}
 	}


