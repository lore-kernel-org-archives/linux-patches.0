Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4B211710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D4CC433C9;
	Mon, 11 Sep 2023 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445824;
	bh=hEoeITLNXjZrPo4pm5l7HV3VCI2oGe252ASmTe0uQDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWiGwN8iL6uuNIaYKxVq/e2h+X+P93TRzKIsHOzEVwnaC46qlC7wjEXT98VehSGCY
	 EfKFLwJ1UPUlNTwp6JzcOU/z41yXhZ4EV6J9rsEQGvC4LQzGpHoF8CKwdjWd2jcklV
	 wqwIWnW8CiYN7T51cRh7ryBjf/w6aCbZBVr2xgF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 458/600] USB: gadget: core: Add missing kerneldoc for vbus_work
Date: Mon, 11 Sep 2023 15:48:11 +0200
Message-ID: <20230911134647.174502823@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 159a98afc88e88f588077afe818081d67f50a5e0 ]

Add a missing kerneldoc description of the vbus_work field in struct usb_udc.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 50966da807c8 ("usb: gadget: udc: core: Offload usb_udc_vbus_handler processing")
Link: https://lore.kernel.org/r/1e5e7cda-b2c8-4917-9952-4354f365ede0@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 316e9cc3987be..1c0c61e8ba696 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -40,6 +40,7 @@ static struct bus_type gadget_bus_type;
  * @allow_connect: Indicates whether UDC is allowed to be pulled up.
  * Set/cleared by gadget_(un)bind_driver() after gadget driver is bound or
  * unbound.
+ * @vbus_work: work routine to handle VBUS status change notifications.
  * @connect_lock: protects udc->started, gadget->connect,
  * gadget->allow_connect and gadget->deactivate. The routines
  * usb_gadget_connect_locked(), usb_gadget_disconnect_locked(),
-- 
2.40.1



