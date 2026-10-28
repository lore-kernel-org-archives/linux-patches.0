Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213439;
	b=2hJh1J2AcNmygmAF9bdhxejkjjzyWtxScIdWRPKtXY3sWodKSHuPkqU8582Dw3oaCvYf
	 6klGAMbO3uUv7T+ZIixuRfUmuygcjmWFaBpKasZSxYj11naGTkf3iGSCMBkJk3oKur73b
	 KkF/vzblxLSq67rtsxG6i3Du6jwkwZyGwmX5KJhFxWGPll4IRP8FIup4br0jPm+3AskL2
	 uZhU9cNAhd4xutMk1Ge5ZEXvoYliqgwtJa734vOPsykD2xqXcIXW1b294YHHsEgpKBgpH
	 nLEO9wBET82w3WI7kdvVQvb2RF6EVGATAsx+1/S0metA97a4ypJPtJVFxynq8idC3CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pgiyFdu0IIhkZ1PXv+u/JyZ7j2TWAe+Bfondd0XqWlM=;
	b=Z9j1Y30+nKoi8G2KqAjskVnJEAG3sw3D0L6R7pp/YoFj30dCe9UW/Go4SG8imFiGDILV
	 701QsBirgwai0m0lSmfOH6ojr+rC3wSPeZinnMifR0Y0p108MdziR91WEkZ9gAcjjc822
	 hOTS0If442jGSXgMMC2QApEUa0jI8QhMtvbikXKN9Wf5OM/kCjIl6/1fHjpd1Py1nctYH
	 Oj/oikN0QP2KZgDP/I9DAH/4XqdjrW6hd7VVW2ASXCmmiLro/iKt7OS/Eaoq1Lco36p6d
	 UiVGWfE1fjFdIXWfym/WfcuxQdSxm2qzvBJ5kJDb2don1Gey8PzblckEJWc4q+ktwLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1zEyvba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B24D606A31C;
	Wed, 28 Oct 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1zEyvba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8A01F01828;
	Wed, 28 Oct 2026 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213439;
	bh=pgiyFdu0IIhkZ1PXv+u/JyZ7j2TWAe+Bfondd0XqWlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1zEyvbaD2aiO+2rR5UIGvYYojSSuXmgO4gyZMkfIhia8S4BbtrG7uPPXMlmXc5L8
	 mF0o1gXgu+E1/UyZsXZdFBonBu7gt5rLO6u7WGZfW56fnvX9bxrDNMdxGxuvXaS0QL
	 +PEjOLO8EFNEVDmM420X4PRHWlJwGcAvK2Axz0b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0506/1887] HID: hid-steam: Make client_opened a counter
Date: Wed, 28 Oct 2026 17:43:22 +0100
Message-ID: <20261028170510.818048636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index 2f5e9d3e64991..4a0a13b0ae62f 100644
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



