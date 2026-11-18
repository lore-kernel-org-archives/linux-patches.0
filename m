Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041902;
	b=3+hJZ2ElndkRAh2zVtW8FNxhyq7qU+ID0C/3gDinFJ+OyHQIKLieKur2oH7mPS2xNwoQ
	 TkXMfvhzdHYDuIIA5SOUyWt7KhBHkx/MiL/+PMnYGr5MHc3p002AhV44g+RrznP+uTlvp
	 LkOMIYgdsfsIqMG4cWnX16A85EKURF5ZEsERqcvQqgxS2FVvoSjdIsOfMA+vTu5XstEsb
	 bZllY6BwiLZVFSrDVuBh0yqCwFDUbtJ4Oiv5WoSDgi5aCWIkZb9l1l8hatoLNe4u/ithI
	 63SlaSmipKaCliTtT6yE75PzYv/BgXzay/XX6ppTXWV0ezYTCeg9rF6batH9bw1XqPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EH4+c9bMpkIdVRiBVl0tsPaxrLTeQyoCb2AhcjLFufg=;
	b=TUY5xzAa7JMajlMape5ENqax1oQRm7fVKW3k+ITJlma6Cb3HNHW4Yir3YbvkW/VEeDS3
	 tmvDaFKqS6gBs6xyP6GvyQPFJgTPHhhyaoAwHJ5aUhg7fx9RKYDFl+es+OdKORolO/GTi
	 eGJu4UZ9O72G0TTYZ9zqRBTPdE3IVzdsX7ct9BlUzHgcyIN6dAZcj2atk0f9XsBI8lHv+
	 Kt6+yIX3VZgqhhmq4JX0KbippLU3Xifc5Q+7NJ62maFlkVNKFE6v7I8yKIPABADl3oVlO
	 f7dWQzwNsB5pfxrImKEqdMfzhFR1xRCdg1m9pUMgn6MMyQ76q6EsAzS1CKgRmikbMuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioAbJkbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620DB606A32A;
	Wed, 18 Nov 2026 22:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioAbJkbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6EA1F000C4;
	Wed, 18 Nov 2026 22:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041902;
	bh=EH4+c9bMpkIdVRiBVl0tsPaxrLTeQyoCb2AhcjLFufg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioAbJkbrJ0I7moDOXA/fdpXHxOiPl0n/kyWWtdzznyqpymi7bHpVwHsxOGH7sgzKX
	 87BuGL9N0NJ36PTrslL7Cho7DzFfbCIMDz7FFp3qaZiNRDpK4WQIV181UUhHT5kdI6
	 wJjTyMb9sNoupcQrjdcVxCovlbnWkACgD9TEMpG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5a7cd83622c747977de@syzkaller.appspotmail.com,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2977/3318] HID: wacom: fix wacom_intuos_irq NULL pen_input deref
Date: Wed, 18 Nov 2026 15:59:59 +0100
Message-ID: <20261118150449.589796194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d7aabed4b555a..8b34ec796b9fb 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1073,10 +1073,10 @@ static int wacom_intuos_general(struct wacom_wac *wacom)
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
@@ -1087,23 +1087,23 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
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



