Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020675;
	b=FhN0iAMi465HEhBF32bQEUaz061+xl6I+Z2VzA+BhNaWD3qfPuVL+U65KMo0+VZcJBnK
	 xvZ1qloR1fMmf5Rk8NY+FlpukFEhxpADcDnN6V6QRhLiXFy8kofqwNpEwysgOM0OGLqjZ
	 JEgR1sQeSYsDyy+R32b4wxTp+pSsz3ZPQfPd5Y3JMn3h2F44DQnp8CRmTmWdK7ZNK3Mc1
	 svoTNI4omBhGVtqVDtd5nPlS1g9hODiOo2Xrh5FKW2tnnK9Jx1rJtVF+GprAhmKBDXv6r
	 6f7mYXCCPAHGYI5z9TlUrdPYDZ/87EBGP6Pxe/sSCQEsHYLlgOy3/ru5QlotyBIEhsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yw67btF4F0FTGz5I13hYNFBSaFqIX3hnG1zyjhw8vRs=;
	b=iUHd2DmYH3qI2mM369vePc5Mf7jmUy+0BRY9RjUjOJ7txgdfpjrFCULLOpdeLPO5bZmy
	 a3dhpZmarJp9JxLmoqDpM/Nw6nMH8yDZQbqwKDidCIOuIOU+4H46ZjjZM+zFYFLJpYS/i
	 ZfftWnR/T+oeoKfZcMSCV6Gmlz9IKcLwVh9lcLmXUQAqMUx3+qlFUvFI1g23bm0nu66vG
	 6SIrz4JMf9fxferShHIPUhhJ0Ejy4PpTyi5pwPjUkmiZI7m+JVA0DHFGyB4GQ08F77S1n
	 8FRTCGmuQRV921nclZJ3b9f5CWD9CM65kmMrE0o1DI+oaoIJu8Y85Lys+o9Ea2v4RLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJUC+ja+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF180606A31C;
	Wed, 18 Nov 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJUC+ja+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E551F000C8;
	Wed, 18 Nov 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020675;
	bh=Yw67btF4F0FTGz5I13hYNFBSaFqIX3hnG1zyjhw8vRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJUC+ja+2g3RER61ZziJ7dCj9Jv4Mw/fYPS/V+l57bPuFSXSXQg6vmESwPB37T5aM
	 EQBET3PDd0otJn1n2Nd6jw42n+/ETSmPphNrZ8XFdGdchV1+WvfAmvesBAgDzZ7dpt
	 PfwgeRooNvP0D0OuVzPDWnm+2RdUy6pKBd0+dm/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5a7cd83622c747977de@syzkaller.appspotmail.com,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2036/2651] HID: wacom: fix wacom_intuos_irq NULL pen_input deref
Date: Wed, 18 Nov 2026 15:54:36 +0100
Message-ID: <20261118150359.417067351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index cf459c16b39a9..361738bb87253 100644
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



