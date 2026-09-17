Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC05A4AD4D4;
	Thu, 17 Sep 2026 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671345; cv=none; b=WeSYZuNDVfcCqXgW9zVpAX8nD7JVxi4+YYPZ7Q2WnHSRPLLsl27gDlPI/yu4+60tC9qXtSF0/mCBn/psXXMbT/wk2Zq56uXocKIka0O7gP5dn6CfjRQwImy3CFQyh7wxOQidoJqzHzX9PMtSJmOsTEDD6SyM2b9TEeUpUSxNrks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671345; c=relaxed/simple;
	bh=HQTWi9zkirAiNiRwzcGlJO2e+/gUpuupX9LQjnWOo0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEHhDgf2OxaEjWftlxItoJnaDJx3aCDB7C4nA+geWfeYYkieMZn1n1VxPx7hCH1FGhwsgaKsI0B/lFZCIdOH2GC/n9nK52MRchXMgWWl04GMLLDIwz5qdqC1uq6y/8KOWXmt7Pc5rX2BYZzut0IqwCRPd3uJVIrHI3pcI5Nz+Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu7jDt0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu7jDt0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5AB1F000FF;
	Thu, 17 Sep 2026 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671343;
	bh=YGQB3lV7iObIGe9Opk8HsrW3+PFl8P5u1DI1xmNEUlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mu7jDt0pIBOpia1+HMEoUTdFSLxDnn/A4SAOCqWHIG8DNRGXyy193sC5RpDDawgjI
	 Oll3NLx5YyWMvIiNeA8uD7ece5ko9t77wdwv2V1zw6u5hLdIPhs3fKXZdw5Tj7UVRh
	 2DIwXGytOy193V/dHtbjOg8/8fU7+6bF1n1KyQV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0945/1102] usb: usbtmc: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:14:48 +0100
Message-ID: <20260917151604.374259097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fe88d555142ad..5bfbf801f9c4f 100644
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



