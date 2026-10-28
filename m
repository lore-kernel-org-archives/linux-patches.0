Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209145;
	b=CulPhigV4ikd8T3+PMC7SExI1DVEnpTBckef3QrDicbqetrqLp5rIq92ccNXHyBLwp1B
	 azNzkb0lSwFM3Eby5OrdJ+6Ta3nl8t+/gIKXUkF+pMaeltisJC6qIhbYquHTY0EHHqGpq
	 e+9/cASQtsJXHdc/wiPabaLjARBZP1z0BCLj0NlUHDf6GFFFwH9nbntdA040Z1DUmqY3S
	 gmg2aQ+Yw7Qo0+tt7Y9rw7PqSLFEGFmC+taCVgrHD4y2PKFzEl7ZLheN+iBs2FsWdmkOu
	 hWD6nsreyPPXc/c7QCu1VtiEQJ/lxyKVWV2DMCy4Z1vuu51F/R4EdUL0RDCcRyAXOuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OtjbnAr2L651HsgUZ0BWekHDtVDYSQ3BwG2Iy7cW+Eo=;
	b=NBfDJ/1htuKAsQOHS/1/QxCShZPOjeW0y7pjHcRoSaD3oYEHs6qFL/f13e1RJeBWY04c
	 KoNULWhZrTarOhLjeqU+0kO9uyjWlADUWa0oXmpdd67GWdRKz+TZRR1rRh2Br86IiZM8i
	 3Y1Fn7Uf1ZP5HaJUx+rr3umu5OMQKIjgNKrkfx1oCiKhrCjeYZaZKO0cfSDTzhlNL4veK
	 oNQqLN1vxS8GrK5wMZe63STi6RS8nEL+/0vlER6PRlMkJ6MkEgVOLlGPEV02k3P7br8fw
	 vdwvtOquvbbtvwqcVpFevWPuxMei4wmFSeZn9e9/qxUwDwsZGSBpT0GC1Aei+FGqi6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g1ntWX/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E19A606A31A;
	Wed, 28 Oct 2026 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1ntWX/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8CE1F01825;
	Wed, 28 Oct 2026 17:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209145;
	bh=OtjbnAr2L651HsgUZ0BWekHDtVDYSQ3BwG2Iy7cW+Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1ntWX/J0SPckN09T36qFW3Z8Vbh3EtkrEoF2zsOxOwagi9dJeBybphnuZhEiMzsP
	 /CJS2J8WBsUSWMqZ0/buJPP1CE8z8ohCWRsr3CzEEbYtFlx3P+q5IXzfEYSbgT6I3q
	 yr30DOnPhIhgrV8IVNvWnmhuKmDPd5TD6gTY59hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/516] HID: hid-steam: Make client_opened a counter
Date: Wed, 28 Oct 2026 17:58:38 +0100
Message-ID: <20261028170012.156878501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 555b818adb97eca70210a49ba3f1d27882dde092 ]

The client_opened variable was used to track if the hidraw was opened by any
clients to silence keyboard/mouse events while opened. However, there was no
counting of how many clients were opened, so opening two at the same time and
then closing one would fool the driver into thinking it had no remaining opened
clients.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Adapt steam_client_ll_open() and steam_client_ll_close() as
      691ead124a0c and e1147961b214 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 8832f7987006c..159b55dff799f 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -114,7 +114,7 @@ struct steam_device {
 	spinlock_t lock;
 	struct hid_device *hdev, *client_hdev;
 	struct mutex mutex;
-	bool client_opened;
+	unsigned long client_opened;
 	struct input_dev __rcu *input;
 	unsigned long quirks;
 	struct work_struct work_connect;
@@ -509,7 +509,7 @@ static void steam_battery_unregister(struct steam_device *steam)
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
-	bool client_opened;
+	unsigned long client_opened;
 
 	/*
 	 * This function can be called several times in a row with the
@@ -634,7 +634,7 @@ static int steam_client_ll_open(struct hid_device *hdev)
 	struct steam_device *steam = hdev->driver_data;
 
 	mutex_lock(&steam->mutex);
-	steam->client_opened = true;
+	steam->client_opened++;
 	mutex_unlock(&steam->mutex);
 
 	steam_input_unregister(steam);
@@ -654,12 +654,12 @@ static void steam_client_ll_close(struct hid_device *hdev)
 	spin_unlock_irqrestore(&steam->lock, flags);
 
 	mutex_lock(&steam->mutex);
-	steam->client_opened = false;
-	if (connected)
+	steam->client_opened--;
+	if (connected && !steam->client_opened)
 		steam_set_lizard_mode(steam, lizard_mode);
 	mutex_unlock(&steam->mutex);
 
-	if (connected)
+	if (connected && !steam->client_opened)
 		steam_input_register(steam);
 }
 
@@ -824,7 +824,7 @@ static void steam_remove(struct hid_device *hdev)
 	}
 
 	hid_destroy_device(steam->client_hdev);
-	steam->client_opened = false;
+	steam->client_opened = 0;
 	cancel_work_sync(&steam->work_connect);
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver disconnected");
-- 
2.53.0



