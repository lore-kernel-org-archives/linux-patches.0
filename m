Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626314;
	b=K9egI/X9TaFfljNr7jy2i+Y5MseARKZBmPfR5JETrsNFdwGXIUZi8NQe+5oQcjCePS9r
	 L5zTnUtOVS4Gqua82w+rocLeoIL6VdTkcBE6C4Q5b9v4QWDu4+0WJ6bNW0jAiYPB1LMNv
	 Gr9Gg7wZV2vyBWvzx3gaVT5DixYyTRN2GQSSAUenIoN2FsXdPCYY0KyeWL6DCCdQ9GfGk
	 ZJtBulFklxFS04vOYqWcUlq5oDvZvQSDGpGZI36Se6iy90DCBA1XXLkPFJkzKz3SjLtjE
	 GquHffKB4+hGNIB4z5bk/sCd6UYrAXVE16dMl2IUn3W1JjjK9plVBJ9X8RghNYTzXmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=no6H7VMk1wME4d67DmrB3tRK6qv96HwXkYH40+I5M1s=;
	b=MAUcmA8idzUQxHku8u9XIdu1vJcI4kX8wG+8X9PQac92x2EkWj4wO97s7dvCq12TmjbF
	 7RaRyOgAzmjWCJNqYoSNsyKVd+bYgVx/l+gVjYgoBYCEqL4jdqaSOPCoj30XWo4PEH+FE
	 e+OPfke9wCMKqkOZ1WabIhRLCDSvf0ocGrKsjOrXjwyjvW9NGOLbFfZx3z+kudu/vDYzZ
	 wK5fc69rjJ/PL4kGfKcB9jKfZCWLcxL5/nxyzNKocc1zmqXNxGd8ZmSvh/DSNMc+SWFOq
	 CeDk1UfArianUT+EdF1fd9DdMSCqAhmjRWm30mRtEoCaXz6eVSDzFOWqIdAN2ERQCNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUeAAW5T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA76606A321;
	Wed, 25 Nov 2026 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUeAAW5T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7051F000ED;
	Wed, 25 Nov 2026 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626314;
	bh=no6H7VMk1wME4d67DmrB3tRK6qv96HwXkYH40+I5M1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUeAAW5Tt8Lk1/QXaHCuabn359mMVCbz5o3sDCSBvC6v5v4+Keuq7yQmq5cdeM2l5
	 I4TiWgOEeoLhZl20EEvRiwpaT82BCVd32whmnFM6zWUZAXJKVpyraQP3uhs1JtLhmS
	 7882xb9qAX7LY1oNa5GoP1G+kLoETO4mHGlfxVI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 757/816] usb: dwc3: gadget: Track a timed out End Transfer
Date: Wed, 25 Nov 2026 15:38:25 +0100
Message-ID: <20261125143906.695611236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit af91c6322e633504aa45de278f5d520f39d127be upstream.

If an End Transfer command with CMDIOC times out, the driver clears the
resource index but keeps DWC3_EP_TRANSFER_STARTED without setting
DWC3_EP_END_TRANSFER_PENDING. The command is still outstanding, but a
later stop issues another End Transfer with resource index 0, and the
next Start Transfer fails with "No Resource".

Mark the timed out End Transfer as pending so that no other command is
issued to the endpoint until it completes. For any other failure, there
is no outstanding command, so clear DWC3_EP_TRANSFER_STARTED.

Fixes: e192cc7b5239 ("usb: dwc3: gadget: move cmd_endtransfer to extra function")
Cc: stable <stable@kernel.org>
Reported-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Closes: https://lore.kernel.org/linux-usb/3fdda532-8181-48e9-b58d-cad7289408e7@samsung.com/
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/5815c41a7e7923edb114741f29697cf0161f523c.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1795,9 +1795,9 @@ static int __dwc3_stop_active_transfer(s
 
 	dep->resource_index = 0;
 
-	if (!interrupt)
+	if (!interrupt || (ret && ret != -ETIMEDOUT))
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else if (!ret)
+	else
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 
 	dep->flags &= ~DWC3_EP_DELAY_STOP;


