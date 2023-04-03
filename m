Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B45683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D41C433EF;
	Mon,  3 Apr 2023 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531341;
	bh=yo/GowJspS9xIPJZdpuPQJlHVyI1uHUr04sRIKrsvcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N486humoEjpBtVjTGE+GXOO9DQ/uAoy/pSa72orHfrnLrYDJCpKAF0M1eFfSvsth7
	 xrdFTg2D6zvFbtehzPd+/8nYnZihZxApVQs/cgazKt2Na9SE3eJXSouGsiyU4IvzKe
	 /s6LZEEOzxYd1yHKGHBUndJ+qIoJ2F5Q2J84/W7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Furman <yaro330@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 26/84] uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2
Date: Mon,  3 Apr 2023 16:08:27 +0200
Message-Id: <20230403140354.259723481@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yaroslav Furman <yaro330@gmail.com>

commit a37eb61b6ec064ac794b8a1e89fd33eb582fe51d upstream.

Just like other JMicron JMS5xx enclosures, it chokes on report-opcodes,
let's avoid them.

Signed-off-by: Yaroslav Furman <yaro330@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230312090745.47962-1-yaro330@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -111,6 +111,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported by: Yaroslav Furman <yaro330@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0583, 0x0000, 0x9999,
+		"JMicron",
+		"JMS583Gen 2",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
 		"PNY",


