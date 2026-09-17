Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368B4E780E;
	Thu, 17 Sep 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660749; cv=none; b=iXLXlzn+CyfXtpfY2slFkOpILUxQ3RAMn7Ec4bQmYbDYh1ToUJFNa2TANNvq4tjdyd51DKU8RakLL5CEeguyM6bxAqiUCUgopIovVXB91tZpH9YEJP3JUl8wWtNUF5HxfIkDyefRp45h1LkTDqLqZz8goaXK7+EQaLmu1PMVwwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660749; c=relaxed/simple;
	bh=9yDEmoZvaSP1BEO+aa4ZYNxgyVoGZ66nzPe2vdy5hPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ8SPoeSP481sj1lgUB8CO+0PvQjiHbIgPZywgNbohRRA5o/mwrV5QW2GmmM6qsgIrHSXSmyLaSHmg4sWiTrRl75V3klAYAzhNFE7aQxrAR53mssZUWgK1dFiPrN1FPvS48GFzxSdzd8MyBnxETB0xMY8aYT4HDU5RTzdrg7EWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJiUG/37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJiUG/37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5991F000FF;
	Thu, 17 Sep 2026 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660748;
	bh=ooqMx/mIEW6UV6diLM3p/JUret4nzz6ScYPxq03hqog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJiUG/37qt37j16dASTSxCSJTOEElntqXR4rgfl7OYbjev4q6gRF3OAQWq+yiN7r0
	 8n4tYgD9llRkbo0aYNFkmbEhFhgJRkaJLBT7bZRN6WbPiLIdgRNGSJAMPcD7APOAjx
	 m4xNBGO+WBZrpqrL6k5TpZgR347TWDAGNeRvdlKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 695/733] usb: usbtmc: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:16:43 +0100
Message-ID: <20260917151410.147873875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index af9ae55dae14e..51cd9320a7366 100644
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
@@ -2394,7 +2393,6 @@ static int usbtmc_probe(struct usb_interface *intf,
 		return -ENOMEM;
 
 	data->intf = intf;
-	data->id = id;
 	data->usb_dev = usb_get_dev(interface_to_usbdev(intf));
 	usb_set_intfdata(intf, data);
 	kref_init(&data->kref);
-- 
2.53.0



