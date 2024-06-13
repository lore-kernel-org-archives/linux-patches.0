Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696E413C691;
	Thu, 13 Jun 2024 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281304; cv=none; b=tCSP4dag1+uUcH1+W4oZ3i7YULn0+Yqn98/PhtObihZBtW7qbEKbmklms8/0y0B6F0a1F1ZqReI3hPhumj4AM7REmSIT4YkLgWlet9HStnpznqU/CBxFaWGwp44KAbuDgNTF90YF87ztWMKbGDGzTN6Zn7kJ23zG6jOitafNqFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281304; c=relaxed/simple;
	bh=kkMyl2dDmqxv40AHFyMZjyo36XtzoVdHwhTzCOatQ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M12NRFoUWvnaqYdta7KnXnbS4fyuHXfRGXsh//vWG/x4GJWhjh2ksGcKrhHwxLOujgB3+/sKNdL+3rzRWrnf5a4ULXfw2ykCg8Kx8lZax0N/PkSqMiPdTe0J0tuYmxrWdY0Ve4Z6tXxgpw5PCbRDAHc4NqvjiWh/jxBz5mv4PBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlHIAZFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlHIAZFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44AEC32786;
	Thu, 13 Jun 2024 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281304;
	bh=kkMyl2dDmqxv40AHFyMZjyo36XtzoVdHwhTzCOatQ0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlHIAZFs30+ImmhR8myoH+tGvr0VRqZYUjnKki6V36YzKYFhGJv1vB65udmfrwPus
	 aZtU0JbyKMrB5qr1EWP4Hz3eDj+TEVRXTzwpbpqTG/giz6DTEWxO2Xn3siha+b5Fbs
	 eknpmg+sLmrew2nErXuWf2RG2Dj6OJp+YDEGgkWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/317] media: flexcop-usb: clean up endpoint sanity checks
Date: Thu, 13 Jun 2024 13:33:48 +0200
Message-ID: <20240613113255.680981717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 3de50478b5cc2e0c2479a5f2b967f331f7597d23 ]

Add a temporary variable to make the endpoint sanity checks a bit more
readable.

While at it, fix a typo in the usb_set_interface() comment.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20220822151456.27178-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f62dc8f6bf82 ("media: flexcop-usb: fix sanity check of bNumEndpoints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 2299d5cca8ffb..6d199b32e3170 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -502,17 +502,21 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 
 static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 {
-	/* use the alternate setting with the larges buffer */
-	int ret = usb_set_interface(fc_usb->udev, 0, 1);
+	struct usb_host_interface *alt;
+	int ret;
 
+	/* use the alternate setting with the largest buffer */
+	ret = usb_set_interface(fc_usb->udev, 0, 1);
 	if (ret) {
 		err("set interface failed.");
 		return ret;
 	}
 
-	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
+	alt = fc_usb->uintf->cur_altsetting;
+
+	if (alt->desc.bNumEndpoints < 1)
 		return -ENODEV;
-	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
+	if (!usb_endpoint_is_isoc_in(&alt->endpoint[0].desc))
 		return -ENODEV;
 
 	switch (fc_usb->udev->speed) {
-- 
2.43.0



