Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0765920316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUInBIiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F6EC433C8;
	Mon,  6 Nov 2023 13:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276449;
	bh=Qf/dQwJPGTDMWgqZJ4X+xQRVVLCWfzfqbEST6cLXTBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUInBIiuA66+3q5bZi0eMzpxsd8JmhRKAdd1Cb5tbma2ZIE+Cmff5FXYPS0yUfZfB
	 OZX7Dcr2vxuTcH8Fk068Ikj6eXKtxJt17dPw7PU2oH8qsbQ7mRRN31yKwMxk6RNeRc
	 cXnpeIYE9Ywgck16FwGuAncTvJkOyvwiQoShKDlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liha Sikanen <lihasika@gmail.com>
Subject: [PATCH 6.1 47/62] usb: storage: set 1.50 as the lower bcdDevice for older "Super Top" compatibility
Date: Mon,  6 Nov 2023 14:03:53 +0100
Message-ID: <20231106130303.479978026@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LihaSika <lihasika@gmail.com>

commit 0e3139e6543b241b3e65956a55c712333bef48ac upstream.

Change lower bcdDevice value for "Super Top USB 2.0  SATA BRIDGE" to match
1.50. I have such an older device with bcdDevice=1.50 and it will not work
otherwise.

Cc: stable@vger.kernel.org
Signed-off-by: Liha Sikanen <lihasika@gmail.com>
Link: https://lore.kernel.org/r/ccf7d12a-8362-4916-b3e0-f4150f54affd@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_cypress.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -19,7 +19,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0160, 0x0160,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0150, 0x0160,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),


