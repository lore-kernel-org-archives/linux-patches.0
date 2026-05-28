Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEC1EA65;
	Thu, 28 May 2026 20:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000004; cv=none; b=r3KnPiggoqr8YgHG/Dm1Czmu5z/bHP9Xi1NYbA/SDpo5rIZWrKcZhrH5/fnDASGvGpSXlBX80/9KlA+zYCUoVblLAv7XPuvZLv8C2SXdzVFBPIS50j8/H8vyYGOBy/eRWHAu2QP59SkW2LaosaYwNoXmQvTc6gIBSmWglOu6WeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000004; c=relaxed/simple;
	bh=/Z7ElucwoCc2knVfTIzXqVVu/fcHUZI0mSymCEBNDbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Evvy3gDsuj0kScECNdtQfbrRxjMN2xUsEXepe/7FuAii6US/FV9m13ufNBaarvMnU0dRkkjOv7pQ5qVZdlQ4enNWwgo+78IOf0F6gkqYnC2O3LZ+YrbtAHhGN+Q1W7YBh9L1Q4imLlcFZbIIx7xeBzQE2edffCl5azHHwbbOzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eX7jTIOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eX7jTIOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6241E1F000E9;
	Thu, 28 May 2026 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000003;
	bh=RABn37J1janIqHZ8C/xO75nE/7WzceOc9tabD/3ZI3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eX7jTIOWjzfdnjBq23ZEjjst52zuBuy5P28idXDRFqW8EUcEsa8CpasQ2Iyo8skE8
	 R89MEpTCZ/GCvLBOukm1bTwQlUjo+quY/zVocR7qDgFaW7FWjYHWMOxYL38u4xXRu8
	 UhtZSYJ0LMpCKddvhEDbmA5LgYBjC9lPFKT5Oazc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/377] HID: quirks: really enable the intended work around for appledisplay
Date: Thu, 28 May 2026 21:48:25 +0200
Message-ID: <20260528194646.097419749@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

[ Upstream commit 5f90dcfa8dc32a488581b78e575cdd7808ba5c78 ]

Commit c7fabe4ad921 ("HID: quirks: work around VID/PID conflict for
appledisplay") intends to add a quirk for kernels built with Apple Cinema
Display support, but it refers to the non-existing config option
CONFIG_APPLEDISPLAY, whereas the config option for Apple Cinema Display
support is named CONFIG_USB_APPLEDISPLAY.

Refer to the intended config option CONFIG_USB_APPLEDISPLAY in the ifdef
directive.

Fixes: c7fabe4ad921 ("HID: quirks: work around VID/PID conflict for appledisplay")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index f6be3ffee0232..04d3ec360c1dc 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -234,7 +234,7 @@ static const struct hid_device_id hid_quirks[] = {
  * used as a driver. See hid_scan_report().
  */
 static const struct hid_device_id hid_have_special_driver[] = {
-#if IS_ENABLED(CONFIG_APPLEDISPLAY)
+#if IS_ENABLED(CONFIG_USB_APPLEDISPLAY)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9218) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9219) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x921c) },
-- 
2.53.0



