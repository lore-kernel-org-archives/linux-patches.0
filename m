Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032334;
	b=clgT5X7LWx69WkHwMG1Sh4HSFFbcDvDa6Miz1/V/sIBO7Osc21Hhrg0PvrBQg+/4xSYY
	 AZH/WOlmlfavHO8SWslUzxP21kE/aCqyW6QD//Kln8qzqiE+9Qy6A1JCBHNyaeZLkfaBM
	 VPuO6CZNR5IswI9os/QrRtWCGkN9hR6Zi/X1V/NckbZBGPECkVBydilq+2I+dfyEZKCR3
	 fhTh/y/R+dQl9OkUGSg2LoSKd9tvwgRL5/RoA9Qg8Epd0VLLo9re2ranccPC4rycMJj6y
	 yUq/is4Ui/yGk9KV7egFnmvwbpNmZJ5Ums00erPalhEznYxJ+0aS5NkhsMvGxB8rW+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I8LeeXhtpv6oBs+iavPL4yqYwrpEIrzgV+n5f2BfUwg=;
	b=TFF3V5wm2OCUoqXxpJ0mMA1hIRbO7t+HZyy2kauQeZGGYdjuBsAJGHtwLOE4RPf8aDRj
	 WYbE2rLN49d0l2PCeQ7x/lQBiFloKWtWEz12lRzkCgt+3LzrYEkUfQMO0tkGbswE9w5rw
	 efciQoH8kFh8l5PwRyBI8OJZWhirknzDXT8h51yM9TQk+Yk5z67+EvNdQTXJVTjKpLeJV
	 TOjyAGPWU+OQptJ+xNP8xqmfi+QDqqUpoHcPyBrIlB9mXYPe4auJcg4ldyV+j3EWwvzqM
	 DIoSPnJgLq4HqkZlOv+BStE6AHxh0UKsd7pte/u8Zl1F05H1jO1DEf/bPPTyIS5XaEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aPl/5X2D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34237606A330;
	Wed, 18 Nov 2026 20:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPl/5X2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3101B1F000C5;
	Wed, 18 Nov 2026 20:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032333;
	bh=I8LeeXhtpv6oBs+iavPL4yqYwrpEIrzgV+n5f2BfUwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPl/5X2D1BUJKymZ7GhNt9LKH7jFt+yVaQUBJoxp59sHaMa+ETNWA7TKQWgi4yIl2
	 CiGTtLqIZlp7eqRqotnGQwFvI0L52mqhLhmkY2iiLXU1Wnc+Q1VOfXnzLVsDL5U2D0
	 QnRNNDtRxd4D6RFmJi5nW99g6V9DQwpJlQxqhI3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5a7cd83622c747977de@syzkaller.appspotmail.com,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1333/1756] HID: wacom: fix wacom_intuos_irq NULL pen_input deref
Date: Wed, 18 Nov 2026 15:57:40 +0100
Message-ID: <20261118150102.442095266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>

[ Upstream commit 2f985de0afbe9366af9d322ea20589712c1dc8fe ]

Currently, wacom_intuos_irq() passes the parent of wacom_wac's
pen_input to the dev_dbg() in the unknown report path. However,
pen_input can be NULL on interfaces without a pen, causing a
NULL pointer dereference.

Get the HID device from the enclosing struct wacom and use hid_dbg()
instead.

Fixes: eb71d1bb270e ("Input: wacom - use dev_xxx() instead of naked printk()s and dbg()s")
Reported-by: syzbot+b5a7cd83622c747977de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b5a7cd83622c747977de
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 8574dd843d0d5..207a25e82c494 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1027,10 +1027,10 @@ static int wacom_intuos_general(struct wacom_wac *wacom)
 	return 2;
 }
 
-static int wacom_intuos_irq(struct wacom_wac *wacom)
+static int wacom_intuos_irq(struct wacom_wac *wacom_wac)
 {
-	unsigned char *data = wacom->data;
-	struct input_dev *input = wacom->pen_input;
+	unsigned char *data = wacom_wac->data;
+	struct wacom *wacom = container_of(wacom_wac, struct wacom, wacom_wac);
 	int result;
 
 	if (data[0] != WACOM_REPORT_PENABLED &&
@@ -1041,23 +1041,23 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
 	    data[0] != WACOM_REPORT_CINTIQ &&
 	    data[0] != WACOM_REPORT_CINTIQPAD &&
 	    data[0] != WACOM_REPORT_INTUOS5PAD) {
-		dev_dbg(input->dev.parent,
+		hid_dbg(wacom->hdev,
 			"%s: received unknown report #%d\n", __func__, data[0]);
                 return 0;
 	}
 
 	/* process pad events */
-	result = wacom_intuos_pad(wacom);
+	result = wacom_intuos_pad(wacom_wac);
 	if (result)
 		return result;
 
 	/* process in/out prox events */
-	result = wacom_intuos_inout(wacom);
+	result = wacom_intuos_inout(wacom_wac);
 	if (result)
 		return result - 1;
 
 	/* process general packets */
-	result = wacom_intuos_general(wacom);
+	result = wacom_intuos_general(wacom_wac);
 	if (result)
 		return result - 1;
 
-- 
2.53.0



