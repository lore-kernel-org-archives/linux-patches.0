Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC426BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239D9C433D2;
	Tue,  7 Mar 2023 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215613;
	bh=DMHfgvn16lsUelSb+tjsuqRW5hv8aZv8AokspayJkVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4IEcbXLRbhXSNRHcgxo8lnKfUUNDL7oqz1xOfDNd/J1bUjTjLVtGoupan9G7aY0O
	 cARX1dXCKutyAnP8e6qRNhJcLL9PDDPOFVfRv8udIFHffemTUfqpFbg0Ms1L0A717c
	 gOjMhxnzxYFKQEDNc5OWfcVctXtT2TtUqmndPfe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Pham <quic_jackp@quicinc.com>,
	Linyu Yuan <quic_linyyuan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/567] usb: gadget: configfs: use to_config_usb_cfg() in os_desc_link()
Date: Tue,  7 Mar 2023 18:00:54 +0100
Message-Id: <20230307165919.653061942@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linyu Yuan <quic_linyyuan@quicinc.com>

[ Upstream commit 5d143ec451429891385a21617b292f2ceaa684ea ]

replace open-coded container_of() with to_config_usb_cfg() helper.

Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1637211213-16400-4-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 89e7252d6c7e ("usb: gadget: configfs: Restrict symlink creation is UDC already binded")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 5ade844db4046..7d3b93dc154fe 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -890,9 +890,7 @@ static int os_desc_link(struct config_item *os_desc_ci,
 	struct gadget_info *gi = container_of(to_config_group(os_desc_ci),
 					struct gadget_info, os_desc_group);
 	struct usb_composite_dev *cdev = &gi->cdev;
-	struct config_usb_cfg *c_target =
-		container_of(to_config_group(usb_cfg_ci),
-			     struct config_usb_cfg, group);
+	struct config_usb_cfg *c_target = to_config_usb_cfg(usb_cfg_ci);
 	struct usb_configuration *c;
 	int ret;
 
-- 
2.39.2



