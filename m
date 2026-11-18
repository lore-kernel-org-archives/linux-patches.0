Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052086;
	b=iOCyOBqrEkddWS9qDkddG8I60aWz90XyH24SFKWS1q0MMCLYMgBz5CMmG/JxQ0EQRaMB
	 mDTl7bba/TAgKedy52uwO9PM1rgOtES7cV3YMAGesHb5ERC9i+CmTs/eHBZ8CkPqMz2gB
	 u32SmKBwM9ZoY3lzEWMeGiJBlBqFW6vrk03NtNlE/AwdG3lCIbe8mGh4ddcxOsoFRGsmW
	 t52J6d7ztvNXU7XTZVFgnPexDzzKjkWj2klPcKH7hRNMRha8URwRPEYq/ce+VYznF+ySm
	 pNGGWclg7KuLWIOu3SD5myeuEQA5jGB/gWD9Zj8+QQQQHLc31pwnD+YpZEcxSihTnjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1T1cfDXinR44JbyMjDh6PJxsw/9f3XdJhLeJ1wwRCS4=;
	b=mxr1hM1f9t33XkCguTObt6oIvGxkizXme5SCArYAH8lXlCRVFV9fJDIAtHZCbf1Eg+qb
	 3QlqSWvd/vc+CLX1VevW6+z3fuIf2iovbb6O2voTTKI2L8UWX2clkXBZ0xkJUP2ezU7+f
	 RfRSdaTYID4uDu8xVj3P4aBsc+CeWhwnwxr1AUGxa8N7D9Ot9ver0JjkX6I0lUIAr4x5Z
	 +8uFDQ837mIQzneZYjIehaWrdk8UBsTuMZUkmih/LseJlK7YEQ6NjO3gQdBnqk4zHoFYx
	 vHuqtAaTrqyo3b5p+bm4sm2AG3lJ+avup+GvcmPj8Yq4xT+Kqy54U7s3yyFio8w0zLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdK6lBp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF4E606A32A;
	Thu, 19 Nov 2026 01:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdK6lBp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375BD1F000C4;
	Thu, 19 Nov 2026 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052086;
	bh=1T1cfDXinR44JbyMjDh6PJxsw/9f3XdJhLeJ1wwRCS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdK6lBp85i4ETAqgUcrUWuT2nN96AEIN1GhcT5d58nrI8xTy1XrCVYqQbbZSZ7CUK
	 CD6RqMHKW/J0OM7Va3X3opX2955aTDquR8QvtF5/yB9twLocaP9Y+LvL9j/B5oAj74
	 adqbSPU+geGwRkRngXtyraLCuGBpx4vqlbBOQpsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0439/2214] media: redrat3: Ensure all urbs are suspended
Date: Wed, 18 Nov 2026 15:35:15 +0100
Message-ID: <20261118150028.653305718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1582f545273f2aa4eb4ee6f3a89b433f5c85c68f ]

Ensure that the learn urb is stopped before suspend.

Fixes: c49fcdde38cb ("[media] redrat3: enable carrier reports using wideband receiver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 52b85a1898bfa..e0a59a2b0f995 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1168,6 +1168,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



