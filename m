Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0881A434E2C;
	Tue, 21 Jul 2026 20:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664436; cv=none; b=MBRrt5WuV33/OJUyuQ+mXgyyy9SvmX3lh5lvFmCo1FzAEdGUlMesZDCz1OBP6nSKPFVv9qn/GXKzH2snHpmRaoxXXyAL+B7DveeAzzsZyeHX0ze6YcV1o3G49BllgmE2D0EY5hmqEIkbQls9bk0Aq47z1wqpqU62Km+y4wcfsGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664436; c=relaxed/simple;
	bh=Uccwq1vkoaf1zb63KKC/BuTH3rtobdOdaB/T+Qr7Wng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QePtm/WqYEmUcmh0XI402d6VIYALybV4SMR6uft+wGInboP++p08xXxdKQCMRwiEEE/mYnHFZtMeBvaWooC7IsV6KZj6PS00iH7oxw0fSX2KLb8BXIp3GX5UfAl9DYBL5HYyTeEGSabMu9GqiSDLGkjIzkYRD2bdHlDKdFsby8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odx1XLSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odx1XLSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D96E1F000E9;
	Tue, 21 Jul 2026 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664434;
	bh=FFvk7ut2eKGY5iA7ytZcUi4xX9xU8OUvUCTijy26RIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odx1XLSrVL2zUbo8Dy47VChmhr0cv2JyzdBeCf41+Z4bIpS9dOypyM3QEPeQGJDyc
	 E9DpCHzC8XzpW1Qte8/Y+X5b+DK/ZV//HeKN8iYTkFEVVMsLY3A3GR//x9oWNGCTV4
	 DGjFF33K3bGTu9wtRPG+yniA9Cwt5cUfx38wHTLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1197/1276] HID: pidff: Add missing spaces
Date: Tue, 21 Jul 2026 17:27:20 +0200
Message-ID: <20260721152512.844045590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 61ea33ded9327a07d9ef85a6933cb6316e2f185f ]

Fixes checkpatch.pl errors

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: b251598b8bf3 ("HID: pidff: Use correct effect type in effect update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -251,9 +251,9 @@ static u32 pidff_rescale_time(u16 time,
 	int exponent = field->unit_exponent;
 
 	pr_debug("time field exponent: %d\n", exponent);
-	for (;exponent < FF_TIME_EXPONENT; exponent++)
+	for (; exponent < FF_TIME_EXPONENT; exponent++)
 		scaled_time *= 10;
-	for (;exponent > FF_TIME_EXPONENT; exponent--)
+	for (; exponent > FF_TIME_EXPONENT; exponent--)
 		scaled_time /= 10;
 
 	pr_debug("time calculated from %d to %d\n", time, scaled_time);
@@ -587,7 +587,7 @@ static void pidff_set_device_control(str
 		hid_dbg(pidff->hid, "DEVICE_CONTROL is a bitmask\n");
 
 		/* Clear current bitmask */
-		for(i = 0; i < sizeof(pidff_device_control); i++) {
+		for (i = 0; i < sizeof(pidff_device_control); i++) {
 			index = pidff->control_id[i];
 			if (index < 1)
 				continue;
@@ -638,7 +638,7 @@ static void pidff_fetch_pool(struct pidf
 	struct hid_device *hid = pidff->hid;
 
 	/* Repeat if PID_SIMULTANEOUS_MAX < 2 to make sure it's correct */
-	for(i = 0; i < 20; i++) {
+	for (i = 0; i < 20; i++) {
 		hid_hw_request(hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
 		hid_hw_wait(hid);
 
@@ -869,7 +869,7 @@ static int pidff_upload_effect(struct in
 	case FF_INERTIA:
 	case FF_FRICTION:
 		if (!old) {
-			switch(effect->type) {
+			switch (effect->type) {
 			case FF_SPRING:
 				type_id = PID_SPRING;
 				break;


