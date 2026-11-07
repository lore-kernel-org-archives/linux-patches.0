Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061883;
	b=uYsqWvRYVrIZzS1zd0L65rJgJHIERL0Z8z9aYS7l6h+FKN/WaMwZD4EItfSwbG5Wp6aB
	 pBF5HI88IqsWaDZ0CmqJA8lpmUWdZAxlV96QsIUfQA4q/X/evNLCbRSnnzpevJ23Dwh9i
	 yikaUJ3MJklOgENIjUHOBeZXWOIBb0LgC1geWkZEo/+zRpF/RaQxIbAjj7ogGUrcnjZ3C
	 Aj1nGlhNDQnLcXvsU556nMHLjlirJMxmcO803QEG/Y0p4sV8gtZrWRa/4TCvopPxcIAel
	 VlBM40u7QNIwq0/kJ0cHUGpiVit5A8x+B1peVEvYj3fy6G6aCjX37n4mlrzqjM2i1Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QqvXoqV6/2vooffGFf1jSTq1bUQUyLLq3Ti9ToLS/EY=;
	b=ryYr1VA4ELrenWT3R7uhcEKACpT9EsSQzNafqd5U4O17g49mG1Dp9FZXtipMAiXF+kkj
	 lH09jQHG96Y+L+kcYpMPF8VMeitr1Nurh3rLMmkKI1TCRMVrHtnwGB9sXE0HXFfVP8fBS
	 g1UXBMU3CHX5jMHhSXsndz8PV6lf10Je69je3PaKrZQi26ojTwtb28vZNfHBD4Y+YXeHt
	 MLyz/zvOUY2lqohkrMcIEfzgr5VmknrVp2Qv3cE/K+CZVxM8a4rtjU4tWKwgYWATheCZ+
	 4jVtuGMZHcvFaCTFf8J+1oaoJS7FqrEsC+Wu5lJSR8OrNMLpzm0QCm2OKqdoiq5P+Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlILXqwR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C8B606A326;
	Sat,  7 Nov 2026 14:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlILXqwR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6031F0089F;
	Sat,  7 Nov 2026 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061883;
	bh=QqvXoqV6/2vooffGFf1jSTq1bUQUyLLq3Ti9ToLS/EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlILXqwR3TCsV0U7+W4vTFGnF5drmrYpkpe1X693C59IWUr8HG46DwX6I2mf2XnpA
	 Fbdr5rHhUJdd5JNoo9yK1BVOAcuZh/JjAEeuWL/igRGUUigb2hapL4+cu/+ziLhTlu
	 5lNFDcsBuS/fh55VSHvWqTZRypToRm61zM3V7m+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0895/1536] media: redrat3: Ensure all urbs are suspended
Date: Sat,  7 Nov 2026 08:48:31 -0500
Message-ID: <20261107135022.769019190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 4cbbe16a8ac47..c9a5c030f7726 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1170,6 +1170,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



