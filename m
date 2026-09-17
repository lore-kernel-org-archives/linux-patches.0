Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1ED518142;
	Thu, 17 Sep 2026 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666978; cv=none; b=LryNwBkdj2n/AXBcKeOQ4qo3ZIsaA+ipkY8riGbA3c0jvteZ7OcPYxksknGm81lfX/kg44IqgIrnXMgJOd1El32t/J8/ydQl2n3dwxwYkoN7LBtxoot7iEA3Ft5Ev3m2dgktm81Betds0/BKB96r/Y89prQA2LScx4wqgWKHSQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666978; c=relaxed/simple;
	bh=Wna0/cOo7Er2H+/+pF+IPFbN6px5UBap2gOkzwmsV5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgDHJkNegWsIoHY5adERFCmgxmJxnXOlJ4RyW9m3owsxZgv+/mjj0xqjJY+wUMoDEJmAKZ6fkXYS1pv0KE/OZoKZXGe4J3S7jcVDPjBBJG5/VjiXFZRxUZoHfA/zWH1MNZqxvMEsPBY2SZXQPNorWRU4xY73Gk7mLygVa9KdsGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYnfNigY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYnfNigY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA271F000FF;
	Thu, 17 Sep 2026 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666976;
	bh=/oSNkaSNsPmkvW/CeZ80Bw7YhO3qfNRE5a3KQu45jX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kYnfNigY9cWPEYzku+lIPv842Hr1TWQxfagL+84driDXAsHLMIURDlYjvdUGt7hgJ
	 1v+73vFvjYnPhoXgimr0nyFNFcmIeNPjMsJHBBKWYtykaQ7XUb+WS++rZF5gOVEcQ+
	 zb2iPsBw1GARO6hzElARieGG3wK1e7rQ/3jUo1Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1149/1250] usb: usbtmc: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:15:44 +0100
Message-ID: <20260917151623.408081568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



