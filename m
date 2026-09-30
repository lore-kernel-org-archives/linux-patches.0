Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6150C2B9;
	Wed, 30 Sep 2026 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785596; cv=none; b=tqO2H7bI1ytrx0rbP4xAyGqrTY93BkOJrpTApx5GDKLoeeF/kDNEsE6PH9DPzU/2mkGlP2Z/9itOt8+Tkv6vPZ62R5mEl+Z1rSPwO/1uce3uWkUlMc7yui3QCgN+bj4RvNo1LiTevu/04rKz8KFlJ2uerRZPBmVLwC0Z3asBQCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785596; c=relaxed/simple;
	bh=Xp9+wlw5N32BbT7IHs2OHjviikqVwEkUrzkeaN+q8Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awGaNWQ4B0Q2SrOEhLci5ES16K2uoZj9Hl59NFuebjOYaTH+6xV8htVWWRLYJmoD4IHkm6xpM2KODi1pB0nYip5wMldCx8WqgPe++n9e0GIpFKo8dNLQBt9DU0xfK11Ggl5inCLWM/zO/skZg+XX5EeQwSjSIgASufPNzrxmbV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTFWVcD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTFWVcD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4321F00893;
	Wed, 30 Sep 2026 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785591;
	bh=oWwqhqEsgjKRz1pPB0TgqXxZogbYQzeu+3N9ieiwKjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTFWVcD0OpYfw/GdJdTmOgnnVyfNV2Q4CUQAgOHTpM5shLH9XVO9U5sncxD3jQY/m
	 Nu1NX8putwZJ3ZQOuuqxGudrqG4uPlZbCb86RYDc5seKA+9FTJ/Y84LX4mr7AE83rj
	 rFeLKR6MIqz0C2LLfOv9vXSKiKowaUEiNG0HX9eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 563/982] usb: usbtmc: dont store usb_device_id
Date: Wed, 30 Sep 2026 17:21:39 +0200
Message-ID: <20260930152428.864686710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



