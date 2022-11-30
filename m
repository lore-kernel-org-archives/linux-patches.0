Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84D479C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1058C433C1;
	Wed, 30 Nov 2022 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833588;
	bh=WYsHhZJLiCJ6nU8qI57VyDOomQC5/9dowr7LoimCVrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9/UKLv8i783hR+tBTq+ueK0eWMfJww77OuEgSti4TxMGEloZnqzPufCI5lx3iyGf
	 7zTmYWLYucxbvwQ7cpE9Br+n+UBxNmjxruoOH9ls1awnWCtLQYpibkjX1gYah04OBP
	 EjRDMS6PviolqNgas7iIuJf/mpGhHu5OqPmFD8SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/206] usb: dwc3: gadget: Return -ESHUTDOWN on ep disable
Date: Wed, 30 Nov 2022 19:23:23 +0100
Message-Id: <20221130180536.876380329@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit ffb9da4a04c69567bad717707b6fdfbc4c216ef4 ]

The usb_request API clearly noted that removed requests due to disabled
endpoint should have -ESHUTDOWN status returned. Don't change this
behavior.

Fixes: b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3421859485cb32d77e2068549679a6c07a7797bc.1667875427.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f90f5afd5083 ("usb: dwc3: gadget: Clear ep descriptor last")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d735a713e0e1..515ace4c85cf 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1008,7 +1008,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep, -ECONNRESET);
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
 	dep->type = 0;
-- 
2.35.1



