Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5634CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B136C433D2;
	Wed,  7 Jun 2023 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170697;
	bh=mztivEPOQeLmOj6B3dXfjhhzjSa0YErj1r36X1VdstI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo54QuAnUnQPeRrxeohrpG5L+30+Kifk44NGTVGRM7v9cYyD7vF084opLTzAipOuv
	 1mu7WdW08UvyVxt3A2AQA8KXwcc5jzs2sTjgBtutR+9Gy19LYa4PejJGLwoKxE4Epi
	 /kw5nQX1PDyeyDlbGMCE6m7awIr1DMGk6Ihaq2iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 155/225] net: usb: qmi_wwan: Set DTR quirk for BroadMobi BM818
Date: Wed,  7 Jun 2023 22:15:48 +0200
Message-ID: <20230607200919.478084316@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

commit 36936a56e1814f6c526fe71fbf980beab4f5577a upstream.

BM818 is based on Qualcomm MDM9607 chipset.

Fixes: 9a07406b00cd ("net: usb: qmi_wwan: Add the BroadMobi BM818 card")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20230526-bm818-dtr-v1-1-64bbfa6ba8af@puri.sm
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1324,7 +1324,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x2001, 0x7e3d, 4)},	/* D-Link DWM-222 A2 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
 	{QMI_FIXED_INTF(0x2020, 0x2033, 4)},	/* BroadMobi BM806U */
-	{QMI_FIXED_INTF(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
+	{QMI_QUIRK_SET_DTR(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
 	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
 	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 8)},	/* Sierra Wireless MC7710 in QMI mode */


