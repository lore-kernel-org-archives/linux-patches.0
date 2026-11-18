Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050053;
	b=PNhrzngLdK47JhIOhyrISRZC6WOmy8fbhwq9Dn1+a0Thm/I8Qc0DiWmFty53C9MrAX0P
	 BHxPIH7xL9f9R4PWsz/7fElwA2EpMTdtoPO4wH5gxiCCZgagFyvK+FJfLvVURy42mq8BR
	 TT3iXNiHtuFv7+j+JPj61IOQ0/nNewd97pUDRd9SxfJBhEA+CblrGSc5jpMIXHr5D7/ZU
	 i+9+UBilChXBLvoOMGygknDxLBNyQlXBQSA+eM6sPrOyJMdHWsf03TH1P/1TENJFiWvvl
	 YQzLYsZJCEsOSBEb/r0VIipkbkfZ+H+S8RrLTX/K3i7yhFXSLZImjTaqoInB9UtgTbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6bRrhhCvkvscg0NhFryDHOLe999nfTQrP11di1/aJP8=;
	b=3Eu3wquGY1yHaI9IuH55QXNfVS1XvMKv9xYd1RFZl8eK3o0gkTwn+saBjAmpg/JOr5fU
	 sVGCqP/LkODennFDv/2rxphbfEf9JEqXncJCSr7i8oPPDmsU5KeXwHgGyShLp1wByqCLj
	 6uLldiLXZHUpZF1j6GxS9urY1mITllwzDfjH+4yltCV0LdP29oHADQJLRoT008y3znBWJ
	 tXYLWzlbxy3Yp3oXYeV2h/lMF9DchhmtEBwClorM954WenA+pTxDrW+1VnCsH5kN+88yZ
	 CM4hhIW6ucoHdLjye7kQ5loWstY70Z868//0KdYHIrqGADGT97LzeS5z1gp20WOPXtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEBEessa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3088606A325;
	Thu, 19 Nov 2026 01:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEBEessa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E491F000C4;
	Thu, 19 Nov 2026 01:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050052;
	bh=6bRrhhCvkvscg0NhFryDHOLe999nfTQrP11di1/aJP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEBEessa7LOsaZ+Dhb0dI1f/XLSnLSuiiWTJ71dFGkx1PAlfeu1VgBE+JfC9N5XPy
	 mDaazj+I4KTkxkn0AiK4toQnd1fpkDT6Nx0CJpCYFXRyAmmQgb6EOnhrPMkb3XdsaT
	 MeA6rIrA41TrgyWGojkad9GDBWql57NAE2C42Xdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5a7cd83622c747977de@syzkaller.appspotmail.com,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2570/2857] HID: wacom: fix wacom_intuos_irq NULL pen_input deref
Date: Wed, 18 Nov 2026 16:00:04 +0100
Message-ID: <20261118150334.021013853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db3c0197b799b..ba17d3575434d 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1068,10 +1068,10 @@ static int wacom_intuos_general(struct wacom_wac *wacom)
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
@@ -1082,23 +1082,23 @@ static int wacom_intuos_irq(struct wacom_wac *wacom)
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



