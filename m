Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1B2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C93C433EF;
	Mon, 24 Apr 2023 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343201;
	bh=av5o3vC55bbMILVskKfeoTt01agSyBcf5512qMmSJbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFGAicJ3rCLduLsOoqBTVpD1yjqmb+QpIIV8Tq12eXW035cdSYUL7AVti5933dqEO
	 gNmZ0lVchrTmNjG90IAxV2Leiwrfh6JRDPPBuQ/MjQNQL+L70tnL50XPuy0FsFWsmN
	 J43GpvrX7AEuvhv0IuJgvzVeKU7J6rPVzeSOnsCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hrdl <git@hrdl.eu>,
	Alistair Francis <alistair@alistair23.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.2 102/110] Input: cyttsp5 - fix sensing configuration data structure
Date: Mon, 24 Apr 2023 15:18:04 +0200
Message-Id: <20230424131140.400353698@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: hrdl <git@hrdl.eu>

commit 5dc63e56a9cf8df0b59c234a505a1653f1bdf885 upstream.

Prior to this patch, the sensing configuration data was not parsed
correctly, breaking detection of max_tch. The vendor driver includes
this field. This change informs the driver about the correct maximum
number of simultaneous touch inputs.

Tested on a Pine64 PineNote with a modified touch screen controller
firmware.

Signed-off-by: hrdl <git@hrdl.eu>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Link: https://lore.kernel.org/r/20230411211651.3791304-1-git@hrdl.eu
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -111,6 +111,7 @@ struct cyttsp5_sensing_conf_data_dev {
 	__le16 max_z;
 	u8 origin_x;
 	u8 origin_y;
+	u8 panel_id;
 	u8 btn;
 	u8 scan_mode;
 	u8 max_num_of_tch_per_refresh_cycle;


