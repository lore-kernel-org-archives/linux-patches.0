Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D48EBA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A9AC433D2;
	Tue,  7 Mar 2023 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215616;
	bh=GfMeHo2tdByvPHzFaze2f+E9pHV/MJzkRbMmfvlrEtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFCeSsXwfXmlcAl7lG49x+G3qIC4QT8+WPOM63pEzp37XdqNbfL4wMwxjZ2r61kJM
	 Aq6XoNj9ot6yjlXR9qMCgEk1YH8+UBFSjWqZhCeHlhet9IJAFEHlGuyGtMeuZEAxDA
	 FOQMEaWburkkQgxBQgl3h3d735bM/AYEED8p7vRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Pham <quic_jackp@quicinc.com>,
	Linyu Yuan <quic_linyyuan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/567] usb: gadget: configfs: use to_usb_function_instance() in cfg (un)link func
Date: Tue,  7 Mar 2023 18:00:55 +0100
Message-Id: <20230307165919.701444047@linuxfoundation.org>
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

[ Upstream commit 5284acccc4a501f38dbeceabaa0340401c107654 ]

replace open-coded container_of() with to_usb_function_instance() helper.

Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1637211213-16400-5-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 89e7252d6c7e ("usb: gadget: configfs: Restrict symlink creation is UDC already binded")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 7d3b93dc154fe..8166e771e8663 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -416,9 +416,8 @@ static int config_usb_cfg_link(
 	struct usb_composite_dev *cdev = cfg->c.cdev;
 	struct gadget_info *gi = container_of(cdev, struct gadget_info, cdev);
 
-	struct config_group *group = to_config_group(usb_func_ci);
-	struct usb_function_instance *fi = container_of(group,
-			struct usb_function_instance, group);
+	struct usb_function_instance *fi =
+			to_usb_function_instance(usb_func_ci);
 	struct usb_function_instance *a_fi;
 	struct usb_function *f;
 	int ret;
@@ -467,9 +466,8 @@ static void config_usb_cfg_unlink(
 	struct usb_composite_dev *cdev = cfg->c.cdev;
 	struct gadget_info *gi = container_of(cdev, struct gadget_info, cdev);
 
-	struct config_group *group = to_config_group(usb_func_ci);
-	struct usb_function_instance *fi = container_of(group,
-			struct usb_function_instance, group);
+	struct usb_function_instance *fi =
+			to_usb_function_instance(usb_func_ci);
 	struct usb_function *f;
 
 	/*
-- 
2.39.2



