Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3046AA0;
	Tue,  5 Dec 2023 03:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b3E7CVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D0C433C8;
	Tue,  5 Dec 2023 03:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746379;
	bh=9sOBd/gQ/X74ev521R4tmhCPizBjes2pGgn0fBBCqJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0b3E7CVl5QZYT/CMP/vLyknF6etE213rbFWO+3BcKrTotvYOOkPBd++jc6YrZnBc4
	 s5x0+2taCsJ6Yw84OvaRpxX3y+LFP/CKCsBZFnUbmYJolo4CUBYhz4nVShBz1nN3WO
	 K1AjMmsYaltOeIGD6+oAD+pw0qmNVBbQbXCNb4Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puliang Lu <puliang.lu@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 17/30] USB: serial: option: fix FM101R-GL defines
Date: Tue,  5 Dec 2023 12:16:24 +0900
Message-ID: <20231205031512.505269132@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>
References: <20231205031511.476698159@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puliang Lu <puliang.lu@fibocom.com>

commit a1092619dd28ac0fcf23016160a2fdccd98ef935 upstream.

Modify the definition of the two Fibocom FM101R-GL PID macros, which had
their PIDs switched.

The correct PIDs are:

- VID:PID 413C:8213, FM101R-GL ESIM are laptop M.2 cards (with
  MBIM interfaces for Linux)

- VID:PID 413C:8215, FM101R-GL are laptop M.2 cards (with
  MBIM interface for Linux)

0x8213: mbim, tty
0x8215: mbim, tty

Signed-off-by: Puliang Lu <puliang.lu@fibocom.com>
Fixes: 52480e1f1a25 ("USB: serial: option: add Fibocom to DELL custom modem FM101R-GL")
Link: https://lore.kernel.org/lkml/TYZPR02MB508845BAD7936A62A105CE5D89DFA@TYZPR02MB5088.apcprd02.prod.outlook.com/
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -206,8 +206,8 @@ static void option_instat_callback(struc
 #define DELL_PRODUCT_5829E_ESIM			0x81e4
 #define DELL_PRODUCT_5829E			0x81e6
 
-#define DELL_PRODUCT_FM101R			0x8213
-#define DELL_PRODUCT_FM101R_ESIM		0x8215
+#define DELL_PRODUCT_FM101R_ESIM		0x8213
+#define DELL_PRODUCT_FM101R			0x8215
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da


