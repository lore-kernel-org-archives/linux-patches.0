Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211128;
	b=Rrz9VVfmWDUhv0LAsxe93pGMtMYoKcjKm/E/0P+1Gdt9d3gi6/p7IZPf2rOfXnYGJ9uI
	 3e5hwTiEbX31N7XEUW4TjTU00s7BXdkj/UHPWYsg0hyTniJN0vZ/itM+P3kIjoBMTOu7V
	 0n7Y7yKQ9ChHW3+PzVZ2nuCorsFLzlDsCBtQwoetlC3sq8CoCDpvjMx755Rcwj4GC2rBt
	 iVJCrZKDCIJpngQpj3qPswKZsljopQLiUsxd3ytEalK5QqVy4btfeoz4ncb+UuGRUqES0
	 hBdvZ2TxrRt9mGf8nXgTUXWw6+0ZvnV05i8POBl+g14sLBf0tWVDQ0/lfZmXfah8rGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/HqnJ/uS3HQHN0TAYNEVwfpQj2W5QRLjK2xIcCopSGg=;
	b=j005KAwhfy+SEnYg7IG6axO3HNfJAQeGG/xJTRi9wW8UJx8vygofiKg4UDkRrIyt6VUE
	 O5/tWFMoVx3hhxXM4ueuBucO7YJUwhLKYSs8dBnIW1R8UV3OUWvXCVRXA4MmGjlpoB1Bu
	 CdRk6h9VuPuNPefuN1RMil/R+4Hu8IpG5wjwBPdtGr6vv2MUOpq1Sz9VyOKSlFj05/RsH
	 1Q+PZCa4P83lhXBEsInASF6MITKkl1c1wrxB1pGO9mp5SjUfj8yYubcJPKv6Bn2hl4jJo
	 TuenifbtrthYJ4CKRW7qqIOFUXPPg5v19Jrm9LSQHQDG7fxIwfrwusUHCRapV9h/c9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uN5HbhH3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8DB60A6F5E;
	Wed, 28 Oct 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uN5HbhH3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9211F01825;
	Wed, 28 Oct 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211123;
	bh=/HqnJ/uS3HQHN0TAYNEVwfpQj2W5QRLjK2xIcCopSGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uN5HbhH3vSCKdZkt4X5QfN2MLHgCOATVpim1vQCkPXsqY0SPs/xi+U3JZ+d8sk+5R
	 AH/thMNIFMPZYGzYCYs3C097r3xQRCmdd6UYq6SRj5tZ+hERkfa1uSabeUOSjzO0Ge
	 vc6FzyErCVcuL+7TReqr24wJA9TsoT6HcPYVG7AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stahl, Michael" <mstahl@moba.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/571] Input: exc3000 - properly stop timer on shutdown
Date: Wed, 28 Oct 2026 17:56:52 +0100
Message-ID: <20261028170014.291046167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 79c81d137d36f9635bbcbc3916c0cccb418a61dd ]

We need to stop the timer on driver unbind or probe failures, otherwise
we get UAF/Oops.

Fixes: 7e577a17f2ee ("Input: add I2C attached EETI EXC3000 multi touch driver")
Reported-by: "Stahl, Michael" <mstahl@moba.de>
Link: https://lore.kernel.org/r/Y9dK57BFqtlf8NmN@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/exc3000.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/input/touchscreen/exc3000.c b/drivers/input/touchscreen/exc3000.c
index 4b7eee01c6aad..69eae79e2087c 100644
--- a/drivers/input/touchscreen/exc3000.c
+++ b/drivers/input/touchscreen/exc3000.c
@@ -109,6 +109,11 @@ static inline void exc3000_schedule_timer(struct exc3000_data *data)
 	mod_timer(&data->timer, jiffies + msecs_to_jiffies(EXC3000_TIMEOUT_MS));
 }
 
+static void exc3000_shutdown_timer(void *timer)
+{
+	timer_shutdown_sync(timer);
+}
+
 static int exc3000_read_frame(struct exc3000_data *data, u8 *buf)
 {
 	struct i2c_client *client = data->client;
@@ -386,6 +391,11 @@ static int exc3000_probe(struct i2c_client *client)
 	if (error)
 		return error;
 
+	error = devm_add_action_or_reset(&client->dev, exc3000_shutdown_timer,
+					 &data->timer);
+	if (error)
+		return error;
+
 	error = devm_request_threaded_irq(&client->dev, client->irq,
 					  NULL, exc3000_interrupt, IRQF_ONESHOT,
 					  client->name, data);
-- 
2.53.0



