Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7A435C694;
	Tue, 21 Jul 2026 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672910; cv=none; b=Ak/4f9pdOZbF+d6gNh1hG0Z7PGLAm3tKmfC3qul45v+cJKjsNYa7SCMfC9Tkk5KmGvpLmI45UvrqxQe6gIjPNF1XCj5WfXBOzUh64B+kCVlwmFA+SMKrkFu7Bg0fjnz9q9MsC/CTPtELt67Yjcuvyprz7b7Jp9hc9LieYYYhDxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672910; c=relaxed/simple;
	bh=36eiHvAhi3wM+ktdooO68KYE5PwogdYtIWRRkmggXMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFvJCE6/BMcNEpzSvC0ethQ7sscWJYp0T+53zUdXSX0+acMrQJXZri4Jz6gdgKRmqRu21PwWkw6a4VKBVJ3mLVwRxGdHXIpMAx5pbDqRiLjqG+nQmwXGotQN+0ei+rg2esVnTbN2K00MLdEFFxTYKNAjFJJYoR41JYkp8cHaR+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aY6kSWgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aY6kSWgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA6E1F00A3A;
	Tue, 21 Jul 2026 22:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672901;
	bh=Rt5AHgVZlP1vkXVmJaZr2EnipR1Bc6SYEwxUvEVW1x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aY6kSWgcvcCRES3jAhwtOKWz6YWRzZqFfn156hG6XvrZ+0y36+xLtg/3ELSiGmJaw
	 gmWNy9ETQ7NDqMYQhmWlmPNIDTyXro8o8GsBFUuq7h3009wHhqi2RKpSVAbl+Q8PHR
	 0Cq+33lwi/cVBlnSccDx48PW30mjoVttpRdFQurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 799/843] treewide: Switch/rename to timer_delete[_sync]()
Date: Tue, 21 Jul 2026 17:27:14 +0200
Message-ID: <20260721152424.040719126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8fa7292fee5c5240402371ea89ab285ec856c916 ]

timer_delete[_sync]() replaces del_timer[_sync](). Convert the whole tree
over and remove the historical wrapper inlines.

Conversion was done with coccinelle plus manual fixups where necessary.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: 75fe87e19d8a ("HID: appleir: fix UAF on pending key_up_timer in remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appleir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -319,7 +319,7 @@ static void appleir_remove(struct hid_de
 {
 	struct appleir *appleir = hid_get_drvdata(hid);
 	hid_hw_stop(hid);
-	del_timer_sync(&appleir->key_up_timer);
+	timer_delete_sync(&appleir->key_up_timer);
 }
 
 static const struct hid_device_id appleir_devices[] = {


