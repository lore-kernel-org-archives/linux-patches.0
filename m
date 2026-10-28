Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211686;
	b=HJm6VfxcZgEMsDlxrT9j4GHU4XDOhrH3b0ru3LpRQQ33q6shwpBpCCsl6ZA5d3743BqJ
	 7VBdJQscHCMavV5P+Vpbb1FJw/w94Ic1RGp6B85DEIg+2FexwNo0wmJPf/liZ3QSCrfTD
	 VLzktOAp72h3aHbPtg4T2E9941dAbG4Yb0bz2SMSzKwgk8uV30W68YGuUwgWFFNuZ8OU5
	 CCRtlTHCL8NAyRI9oEnz5bHoKBb3iyNk5RKcVo3mxZOlUcL2arcq5IdAKWcVKea0ASi1a
	 Iw0pJSQYvdh9mkLlMbwr3hGE7YlBmTK37vGInOnHey8qLVE24L3xNwN/YNeMIlGaXYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DYP84jO3f1841Y7kJlbcFxftokht4DEeXLJ/qbrxcdI=;
	b=1lKqphqv/6h7ik8lVsBxhtbTJaaqRsnyzw+lUY5gONPwhwSfzbtlLdfhy5sTQ+Db06nL
	 bez+/Fypa9IE6faloPccwTQJvGOd5lzuPjMEfYuIaR2iYUsafDffGjDkRHLzWXjbuWweW
	 4bGvtDErLJFvkdSzpwz5wKCAEBzviSTXOCIPhd8NMREKPxKgpSnbFgl5OsegNeT2X5YUE
	 md6BBNItU6xl0f9FG0lHy00h9XSF/UNGL6WXWIWAauG/U1UJFnJDVO6STZRdwGnRuNDBt
	 jg+GGEbq9whpS/IppDv+GIS8DtkjgX0LNgSHPQQH/UamTElu7Hhv6d7VhwQP/BYUXOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQPGUpRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D3F606A31A;
	Wed, 28 Oct 2026 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQPGUpRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38AE1F01825;
	Wed, 28 Oct 2026 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211686;
	bh=DYP84jO3f1841Y7kJlbcFxftokht4DEeXLJ/qbrxcdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQPGUpRG4eF4byVYC4b1VWNsCVJLMHGgmXKrGTlXBxhEb1I3wQXj1P/Iy1kFQKdXu
	 NDKCzdUTQkiSUEfdrc9zBc3iwq1PaFRIGES56GvR5mVdQGzO2dzKCxiTJq6KlS8fGO
	 BAq0+0pnf/PtjOWwJ8HJylqlRKZKHTrKSc9HmDMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/571] HID: hid-steam: Make client_opened a counter
Date: Wed, 28 Oct 2026 17:59:26 +0100
Message-ID: <20261028170017.953739240@linuxfoundation.org>
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



