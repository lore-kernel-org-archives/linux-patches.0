Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2925869D29;
	Wed, 21 Feb 2024 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523610; cv=none; b=f+TE7w5jbRMjJ9ysJhzfc4eZDKxK7BSqEIbpe7yfW2yDj21sbmKGzFqWMs9lhkzcomzfWHvOyHcBjxEvKEPhjpnEUPjaU17gkp197uHYj96M5aHG8iL391NPbQA4N2HcgT5N5NVJVLguDq1NeY+ewzH1R5/nCvitg1W/dRpDYyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523610; c=relaxed/simple;
	bh=Lxm0poAaUf6+mInwasvx/+nEyInXVe0j7n1Nmb+/lJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcY7VEqQ9kStU0xdu7xmaQelzwAoVybu8kdWyBJawLmYSDk8SHJ+cTF2XKFPz1L+amawpQajtVEXHye2sq7Tw074uPlKtV2iXhU177a/6OfBoCNv5hVH+TmQHHORcqNNYFpd74Jsssjk52mYkD/GjDdRAcN0Je04ANN4txl82ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJEzsqPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJEzsqPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842F1C433F1;
	Wed, 21 Feb 2024 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523610;
	bh=Lxm0poAaUf6+mInwasvx/+nEyInXVe0j7n1Nmb+/lJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJEzsqPHCTbCI2JGJZB2cYQS5P+VgwB7lgvyBSlx0d5q9NpcxAciK3e+GXxIR7vc8
	 6dBhZ6QNpXqlu1heZX4q2q/dzARnj5XFn2kexas2IocKSTcaRYv8XaEbTmQHS+f7E7
	 RLifsaVByVk8QkoVBwzd9i0LuRObXdQ7MfONBaUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/379] usb: cdns3: Fixes for sparse warnings
Date: Wed, 21 Feb 2024 14:03:00 +0100
Message-ID: <20240221125954.966035072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit fba8701baed76eac00b84b59f09f6a077f24c534 ]

Patch fixes the following warnings:
cdns3-gadget.c:1203: sparse: warning: incorrect type
                     in assignment (different base types)
cdns3-gadget.c:1203: sparse:  expected restricted __le32 [usertype] length
cdns3-gadget.c:1203: sparse:  got unsigned long
cdns3-gadget.c:1250: sparse: warning: invalid assignment: |=
cdns3-gadget.c:1250: sparse:  left side has type restricted __le32
cdns3-gadget.c:1250: sparse:  right side has type unsigned long
cdns3-gadget.c:1253: sparse: warning: invalid assignment: |=
cdns3-gadget.c:1253: sparse:  left side has type restricted __le32
cdns3-gadget.c:1253: sparse:  right side has type unsigned long
cdns3-ep0.c:367: sparse: warning: restricted __le16 degrades to integer
cdns3-ep0.c:792: sparse: warning: symbol 'cdns3_gadget_ep0_ops' was not
                                  declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Stable-dep-of: 1b8be5ecff26 ("usb: cdns3: fix uvc failure work since sg support enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/ep0.c    | 4 ++--
 drivers/usb/cdns3/gadget.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 30d3516c7f98..4241c513b9f6 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -364,7 +364,7 @@ static int cdns3_ep0_feature_handle_endpoint(struct cdns3_device *priv_dev,
 	if (le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT)
 		return -EINVAL;
 
-	if (!(ctrl->wIndex & ~USB_DIR_IN))
+	if (!(le16_to_cpu(ctrl->wIndex) & ~USB_DIR_IN))
 		return 0;
 
 	index = cdns3_ep_addr_to_index(le16_to_cpu(ctrl->wIndex));
@@ -790,7 +790,7 @@ int cdns3_gadget_ep_set_wedge(struct usb_ep *ep)
 	return 0;
 }
 
-const struct usb_ep_ops cdns3_gadget_ep0_ops = {
+static const struct usb_ep_ops cdns3_gadget_ep0_ops = {
 	.enable = cdns3_gadget_ep0_enable,
 	.disable = cdns3_gadget_ep0_disable,
 	.alloc_request = cdns3_gadget_ep_alloc_request,
diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 210c1d615082..82b6fd2bc890 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1200,7 +1200,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		td_size = DIV_ROUND_UP(request->length,
 				       priv_ep->endpoint.maxpacket);
 		if (priv_dev->gadget.speed == USB_SPEED_SUPER)
-			trb->length = TRB_TDL_SS_SIZE(td_size);
+			trb->length = cpu_to_le32(TRB_TDL_SS_SIZE(td_size));
 		else
 			control |= TRB_TDL_HS_SIZE(td_size);
 	}
@@ -1247,10 +1247,10 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 			priv_req->trb->control = cpu_to_le32(control);
 
 		if (sg_supported) {
-			trb->control |= TRB_ISP;
+			trb->control |= cpu_to_le32(TRB_ISP);
 			/* Don't set chain bit for last TRB */
 			if (sg_iter < num_trb - 1)
-				trb->control |= TRB_CHAIN;
+				trb->control |= cpu_to_le32(TRB_CHAIN);
 
 			s = sg_next(s);
 		}
-- 
2.43.0



