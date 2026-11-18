Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056485;
	b=W0zngxJPv3LC/v5yawTFJ4MV5bL8gFDvfrd0inl/WIILFd1ptzMmozdjzG7sBN3NncLW
	 zaqFSMfZIWE7wxxCo3HxoeD4oBvJDTvkZECzlYnMjANM5oxfFQ/AFqXYFlrUmX+QEKfSt
	 RlqWZtK0YxqOazRWqHWPyuK1JWK9qMvnGnmhbGSaV2k3+UpUMWxwk/UVDko6hmPN41AhY
	 hO0Br4fkF5ZdVGaQ2xE66EC8Xe1GI6coLGq9p1fa38at5mWWNG2wQ6sk2S6Ctiu0xXbwb
	 8QoA3rM+pglKYgjWyWQHJrglDoTEaJ3lwtRbkZJVo8H5GhUIUzgWT32lclKCRFHmTAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V3SRrKZs+Yusa6WKwPPuPwDFVXxr8ToNQJk+0kOFVds=;
	b=iytQ4jmp+XXAftxRLoy4QOXg1+VcA+02fd9FfaOUAKuKhcQ7s44BP3wxElyb5RNs4poq
	 iE6lVVJA0r9niJpyP+sAUlcKMVS5I8OqcMnqYoydLwPxgSeijBnAy0Ca7bAHPUxNrdQdr
	 Ohx58/WBTY3emCfqWXzldurg/Ot3Xg8PE1GZw6Q148CDWnwPYuJDx1xXTBSKdSHSCKfXJ
	 jnCvQz+KYdZ9HdHxPvHn2Z3Us9A2S1VgZNVA0WXp9kkWkgdsoEcdvFqjr6RvBrU+t8MHv
	 2xkw6Mmyjkeb7XeUNJxV14BpYXDF/hQ8y623xQPhhW453mRq0dJKLltNFTQZg77Qc/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxTGP0S4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9891C606A330;
	Thu, 19 Nov 2026 02:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxTGP0S4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECF11F000C4;
	Thu, 19 Nov 2026 02:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056485;
	bh=V3SRrKZs+Yusa6WKwPPuPwDFVXxr8ToNQJk+0kOFVds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxTGP0S47ocA4l7Bw3eGMo/MqsyOIbG+riLZoduHoLO/JxY3hvmdOIp4Hr48oWrHJ
	 BiLtleRfAH8kV6qdUpzoHNZt9oJSiYN7RBc1yi0UjS3cIxOyGtdLu2kZiW6SHypPmF
	 aLm39/1DEg8dStBDYiBPGnXxU8qW6TAux4JAvyoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5a7cd83622c747977de@syzkaller.appspotmail.com,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2006/2214] HID: wacom: fix wacom_intuos_irq NULL pen_input deref
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150131.015075194@linuxfoundation.org>
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
index 965f9fdc140a6..84e5227793a89 100644
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



