Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212820;
	b=LHF0ZbtgjFzBhTfWofb+t/b7WRl+N6i478k7dz9m189yklzbxMlU3BQE3y1lEoU3y7ar
	 lmxXMFCslQFIH1F/6tX9bxx9DN1pad0NdH5zxm8/qYH4T/RVaTrttPtcYFVTCBdX1dsDl
	 c2mHnLuogLBoLOFVMtXzeBX7x3e5mFoF2ruIcdsv2DRxeR7D3jfROUzVbCIIWO0KmVo33
	 08Hp/NuW7mhdCc80sG2XAsbtF8bXnW01ddZtrzZGOLDoKmD4KAX5iG0/4lH7pHHfkdj+U
	 lmwT18yTqMsLrJCKTQwXfBq/3S1K2N2TGOZzoTJyxSYmKtRc9LSuwa8E7vf20GKKZdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SocmZwR/Y5mv+S8MutxT5rOSsD7H7SNut2EIgm1ER5w=;
	b=03k+9IzadBMnzz95yY4JD6xEEUPfoIl7XpjIwLPJ837n/qTd8onFBL5H+8ulSm/L5ZTd
	 DBi9dYYoKIg4Gp0A2PQUf21LzIwD02WI8Dpmb0paRvZ/WpcIhpV41RDkkKZ75PgAwMCX+
	 0PSWQdeiYQd7OikVbf47Fgg3sH2sgOgNDDPww0cHtF0HfVHmfFg71x0xdBd5GWrhRjP4r
	 9F7Px2LyaL/U4Qvf+G7aSeEVaoxSncCCOyCL4+vFsn4jb2klJDXvgPscxRGl42SzkFBOM
	 mNxVrDbb4IZjGYKVERQwdyYOpTbNh4hUs3Wcm9NHRzlEo1twLQZOH3QKszd5aXwBZhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgtGBPmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0F606A321;
	Wed, 28 Oct 2026 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgtGBPmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5601F01828;
	Wed, 28 Oct 2026 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212820;
	bh=SocmZwR/Y5mv+S8MutxT5rOSsD7H7SNut2EIgm1ER5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgtGBPmI2S8A99wK3LRCKq9HkHFtuEDfVA5nL86EGAQQPKm8FHm62VmICuLhx6U9L
	 GMNpm2K1zKtyb/hNHEZ8tXlqaLWVZTy+sCQQnwCy8CEvEeIqxkI1hapUWlSStjZ6Se
	 qwLmtN1p2J/fxcu7p0Pc1Vf8L1yzRYrvYncXsjv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sicong Huang <congei42@163.com>,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 0287/1887] usb: cdns3: fix use-after-free in cdns3_gadget_exit()
Date: Wed, 28 Oct 2026 17:39:43 +0100
Message-ID: <20261028170505.760297291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit ebe9b68c396792c15d0ac690d592e449e74ed804 upstream.

cdns3_gadget_start() arms two works on system_freezable_wq:
pending_status_wq for the deferred ep0 status stage and aligned_buf_wq
for realigned request buffers. Both handlers use the cdns3_device the
works are embedded in, and cdns3_pending_setup_status_handler() also
calls the ep0 request completion.

cdns3_gadget_exit() does not wait for these works. It frees all
endpoints and aligned buffers and drops the last reference to the
gadget device, which frees priv_dev, so a work queued before the exit
can run after the free.

Fix this by waiting for both works after the gadget driver is unbound
and the IRQ is freed, when no new work can be queued, and before the
endpoints and buffers are released.

This issue was found by an in-house static analysis tool.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Reported-by: Sicong Huang <congei42@163.com>
Closes: https://lore.kernel.org/linux-usb/7f5719b.8700.18f67b324d3.Coremail.congei42@163.com/
Suggested-by: Sicong Huang <congei42@163.com>
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260909095655.694527-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3265,6 +3265,10 @@ static void cdns3_gadget_exit(struct cdn
 	usb_del_gadget(&priv_dev->gadget);
 	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
+	/* The works can still be queued until the IRQ is freed. */
+	cancel_work_sync(&priv_dev->pending_status_wq);
+	cancel_work_sync(&priv_dev->aligned_buf_wq);
+
 	cdns3_free_all_eps(priv_dev);
 
 	while (!list_empty(&priv_dev->aligned_buf_list)) {


