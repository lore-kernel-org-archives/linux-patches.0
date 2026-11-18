Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027106;
	b=M7SEJ+0Bb8jdnU/dR1ppkIQKT+zY8+emFZzbfI8/x230nooaOakD2P7sB9SwiMDm+Coe
	 vRoSelZIyfPvGWmx+bHzZQeLwpkSCTcYKfA3JIvhgcmAtGyFhj59uiA2wmX/EAqph2cv4
	 MSpMmfKWMv9R0k1BlUcRVrYPFHcIjACbbviqi55GLARYle4HPE/HWGHVMUiws0MF9fFj3
	 h7GmkKQglbvIN+mno94Thd7s/ZGxx2k60EsQGYSOYglJEK5Tq2bNlvZcC+xARYmPc/m4u
	 YqwgzfOFWDXH0MU0tT9B5wPJSmiRrC3qv6y478jcE0BTO+Py0i4J+EJDsNqgfOtIPDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=si6/1z3j52Q3C5Kl9UjfE4v3uVJHkM21xb18bu3wNMU=;
	b=5tXokdaTEyhoUB2rOivl/MSzdpjKKpl/Gnp9gIFiDmDUZQ3qrQWarftfAfDo/IqJ2LIQ
	 oKPwJyaATmqQadeOztcHrcO83KpCU5HkgysADsYVib6O7i3OizJpGzQCrJ4glver66KOq
	 gQ+H/85EvcdMzDw1mBhnHUz7q3CVhZdbVS57saCoom9hgr4s/2IqLMiG5y+FljEGUZZ89
	 u3yXw4xytX1V/oVPDB+d+bj0TNeifAaMYrKRxLVUx/whkC4gMksPIQUrzwrtdOmZNhQNJ
	 pIwsYTyCctkyonAIYYJz0Ym5/s0EnuCkk2F+CTfJNWe/zdvVyFDiGEFTOvgL75byVyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2ZQLpKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B676260A2600;
	Wed, 18 Nov 2026 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2ZQLpKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FBB1F000C7;
	Wed, 18 Nov 2026 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027106;
	bh=si6/1z3j52Q3C5Kl9UjfE4v3uVJHkM21xb18bu3wNMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2ZQLpKY01h5EaY9+c8HmYvUptY+Pbuf0Tgsth9opHzgq2MZMCUiIffbo10S8GPUo
	 secwm8Ms0HZFCfzJKhtYdfHeciQvtqHoDjVLU+Eb0NsuwZHfix2fXN7EmIr9//LqdG
	 eOA65ZAjE7uLERCyiPKVE8hybmrzW2LPIT/n1/XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5ad4fc9c8360b68e353f@syzkaller.appspotmail.com,
	Nehuen Lian Bova <nehuenlian.kernel@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1672/2151] HID: magicmouse: fix null pointer dereference in magicmouse_event()
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150222.740631408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nehuen Lian Bova <nehuenlian.kernel@gmail.com>

[ Upstream commit 5b66b65cfd6f697b1addb6159cbece53d20db2fc ]

Add a guard clause to check if 'msc' and 'msc->input' is NULL
before attempting to access its fields, preventing a general
protection fault.

Fixes: b8d56ef91cc3 ("HID: magicmouse: Apple Magic Mouse 2 USB-C support")
Reported-by: syzbot+5ad4fc9c8360b68e353f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ad4fc9c8360b68e353f
Signed-off-by: Nehuen Lian Bova <nehuenlian.kernel@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 0480e7d216bc4..cf92c9c9ab2df 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -553,6 +553,10 @@ static int magicmouse_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
+
+	if (!msc || !msc->input)
+		return 0;
+
 	if ((msc->input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE2 ||
 	     msc->input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE2_USBC) &&
 	    field->report->id == MOUSE2_REPORT_ID) {
-- 
2.53.0



