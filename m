Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829283;
	b=TuA256IuasibSYMMdvwwKKMN9m3Gd3OJI3mUB4bpuCvck0kTgOY0akxr/MQoHd32JyyX
	 lesWawrdWZilot+P9FQX0ADxA/InjzEYcVFS5o5WU+H7LWr72dKQVvI51zZtBPurooGBg
	 gE8sO4OE4d20I4xGeLMY7hBMX469dwX0N4E204lPp1iT/wRG3n3j1y+g5mFyyjNOT5QbX
	 73P4HLPrQdr9Xw/pX5b7F6MFMd/Wb5ef4drTkc0m/AzxXmgS7d0Q9joM1mChCoBnlgoT6
	 5t37VxdYcppAfZXhzi6EXgNt7LlMuWNbYJ925ahXOSjMlnQ7uHg9UqReFOV0f02VtzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4p6L31TN8lrrldsNMV/TKmCaQn+U5uM0T25wAvd5KcQ=;
	b=Nqn9M2trLZC5bpgPdRgGLXBgW85NGdi9E5W4HFixQw1hZ51XL/gET64A7CNCJ54TD8jw
	 RI/dPfuWwSvYQ2RJ/Q//qFEXRHLntwG9ghaCsl+FyNTxi9K9rH4N4JSHXgMEM1UwVVC8y
	 qOC18Yd01YOw9V5yedIneWERY2X/JgZJV3SO0yZ8qgeuB8UfOw4sPizCj0cyS0YeO9Txk
	 0hq9pR8yfc65h7rMTNsNAVL0u17JZ4Ekz7ner8/NrnrjKO4N7AylbA+hAAMpmHooYXaIm
	 b8BajKuRAumlFF+KN0kvq7t/A/k1vsCYVfdqCPQ+nmVfw68th0yI84IcU0EB4gXYKgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOGQBtSu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88260745A8;
	Wed,  4 Nov 2026 21:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOGQBtSu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA491F000C1;
	Wed,  4 Nov 2026 21:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829282;
	bh=4p6L31TN8lrrldsNMV/TKmCaQn+U5uM0T25wAvd5KcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOGQBtSuKGUVsMtaMqXg+NFPdv62SfYQXaZH5P1xbeR/m+t+0TMAGD41SnpT0Adn5
	 G6hlWDFDaLU6ugfiXdtGMC6i00W4vqlMgeULzicwxSYPePuhnavJdHcYfMXj1Q3b0Y
	 q6PgfxIUtsPKuHH+TUdt+DlW/M4/201H6P9RSa4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0027/1005] HID: wacom: avoid copying Bluetooth input reports
Date: Wed,  4 Nov 2026 15:56:00 -0500
Message-ID: <20261104211044.320310024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 8310cdeefc8a14d2093c3234b570c7805c20bcbf ]

wacom_intuos_bt_irq() duplicates the received Bluetooth report with
kmemdup() so that it can pass 10-byte input report payloads to the
common Intuos parser. The helper then copies each payload back into
wacom->data before calling wacom_intuos_irq().

Avoid the allocation and copy by temporarily pointing wacom->data at the
current 10-byte payload while the common parser runs, then restoring the
original report pointer. The Bluetooth report parser keeps using the
original report buffer for dispatch and battery parsing, while the common
parser sees the same payload bytes as before.

This also removes the unchecked kmemdup() result from the Bluetooth IRQ
path.

Suggested-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index af76e49fd0f25..8feb8027be95e 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1192,8 +1192,11 @@ static int int_dist(int x1, int y1, int x2, int y2)
 static void wacom_intuos_bt_process_data(struct wacom_wac *wacom,
 		unsigned char *data)
 {
-	memcpy(wacom->data, data, 10);
+	u8 *saved_data = wacom->data;
+
+	wacom->data = data;
 	wacom_intuos_irq(wacom);
+	wacom->data = saved_data;
 
 	input_sync(wacom->pen_input);
 	if (wacom->pad_input)
@@ -1202,7 +1205,7 @@ static void wacom_intuos_bt_process_data(struct wacom_wac *wacom,
 
 static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 {
-	u8 *data = kmemdup(wacom->data, len, GFP_KERNEL);
+	u8 *data = wacom->data;
 	int i = 1;
 	unsigned power_raw, battery_capacity, bat_charging, ps_connected;
 
@@ -1242,7 +1245,6 @@ static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 		break;
 	}
 
-	kfree(data);
 	return 0;
 }
 
-- 
2.53.0



