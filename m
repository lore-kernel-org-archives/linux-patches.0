Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E113CBE6E;
	Wed, 30 Sep 2026 19:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795817; cv=none; b=k9INydXeYt22wqoW8QLaleOTKjabrVp1MpqZtt4Qh7ODOVRm1vXR3yf5roocTHkHcbahPPxGdSmvIhfOR9FuHSXSUkfnyCYSuoS8QiIdR8BlBVtrrcSfNSI0btw52foooYU176l1xvWg+g95AWruatMe43hS82ViFcbP9KtCYK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795817; c=relaxed/simple;
	bh=2ZPZdMNRnYEQ8QBBNW5CVgcjtT2ltEp/AuK6pZ99nwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkaqZJM3+Wv3wR/C1+tl3i9VjoKPWWHYkICQJOmGcfRM4zgDrHFLIt78rdcc3BqEYHoNExUX2482VGiLgtK0LFQh7yK6d8MzIjmw+I4zjujg8ai0CZtxLz+9tDD+toKaBtTtAH/RCHylqdgXhDCopExoNAh81CIcJTXHQI3Wfrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k75vtU8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k75vtU8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE9B1F000FF;
	Wed, 30 Sep 2026 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795816;
	bh=7p1b3oZU1v2MSMm7u3WRQFLoTnfuJs6PkdJwHQCsscw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k75vtU8V/ANZ0XjkZmxDeXrwAz5IqRS7A7+XMYG56DKEcnwd/4evuB5OzIESsxrs4
	 lMfCamU8Jo1oDIiFveDWkfhrktyR5gWLpiM7ofWjkD2bHh93sI+kEuS+eQyjEv9DJQ
	 tEMlfD9CbPBkPBcy+RiscExmL7u32PWja8Cp2j7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0693/1193] usb: usbtmc: dont store usb_device_id
Date: Wed, 30 Sep 2026 17:22:57 +0200
Message-ID: <20260930152449.645320816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit fc045acec1a501c97f84ae184aadce9dae4ba9b2 ]

usb_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. This stored ID is unused so remove it.

Reviewed-by: Manuel Ebner <manuelebner@mailbox.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-2-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usbtmc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 593db4491ff72..ac2683a976fa6 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -71,7 +71,6 @@ struct usbtmc_dev_capabilities {
  * allocated for each USBTMC device in the driver's probe function.
  */
 struct usbtmc_device_data {
-	const struct usb_device_id *id;
 	struct usb_device *usb_dev;
 	struct usb_interface *intf;
 	struct list_head file_list;
@@ -2398,7 +2397,6 @@ static int usbtmc_probe(struct usb_interface *intf,
 		return -ENOMEM;
 
 	data->intf = intf;
-	data->id = id;
 	data->usb_dev = usb_get_dev(interface_to_usbdev(intf));
 	usb_set_intfdata(intf, data);
 	kref_init(&data->kref);
-- 
2.53.0



